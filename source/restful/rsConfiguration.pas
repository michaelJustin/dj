(*

    Daraja Framework
    Copyright (C) 2016  Michael Justin

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


    You can be released from the requirements of the license by purchasing
    a commercial license. Buying such a license is mandatory as soon as you
    develop commercial activities involving the Daraja framework without
    disclosing the source code of your own applications. These activities
    include: offering paid services to customers as an ASP, shipping Daraja 
    with a closed source product.

*)

// this is unsupported demonstration code

unit rsConfiguration;

{$i IdCompilerDefines.inc}

interface

uses
  rsRoute, rsRouteMappings, rsRouteCriteria,
  {$IFDEF DARAJA_LOGGING}
  djLogAPI, djLoggerFactory,
  {$ENDIF DARAJA_LOGGING}
  {$IFDEF FPC}fgl{$ELSE}Generics.Collections, Generics.Defaults{$ENDIF},
  SysUtils;

type
  DuplicateMappingException = class(Exception);

  (**
   * Context configuration.
   *)
  TrsConfiguration = class(TInterfacedObject)
  private
    {$IFDEF DARAJA_LOGGING}
    Logger: ILogger;
    {$ENDIF DARAJA_LOGGING}

    // True if at least one mapping exists
    FHasMappings: Boolean;

    // set with &Path('/basepath');
    BasePath: string;

    // set with &Path('subpath');
    NextPath: string;

    FNextProduces: string;
    FNextConsumes: string;

    procedure Trace(const S: string);

    function GetCurrentPath: string;

  public
    Mappings: TrsMethodMappings;

    constructor Create;

    destructor Destroy; override;

    procedure AddMapping(Method: string; Criteria: TrsRouteCriteria; Route: TrsRoute); overload;

    procedure AddMapping(Method: string; Route: TrsRoute); overload;

    function MethodMappings(Method: string): TrsRouteMappings;

    function HasMatch(Criteria: TrsRouteCriteria): Boolean;

    procedure ClearNextPath;

    procedure ClearProducesConsumes;

    procedure SetPath(const APath: string);

    // properties ------------------------------------------------------------

    property HasMappings: Boolean read FHasMappings;

    property CurrentPath: string read GetCurrentPath;

    property NextConsumes: string read FNextConsumes write FNextConsumes;
    property NextProduces: string read FNextProduces write FNextProduces;

  end;


implementation

procedure Log(Msg: string);
begin
  {$IFNDEF DARAJA_LOGGING}
  if IsConsole then
    WriteLn(Msg);
  {$ENDIF DARAJA_LOGGING}
end;

{ TrsConfiguration }

constructor TrsConfiguration.Create;
begin
  inherited Create;

  // logging -----------------------------------------------------------------
  {$IFDEF DARAJA_LOGGING}
  Logger := TdjLoggerFactory.GetLogger(TrsConfiguration.ClassName);
  {$ENDIF DARAJA_LOGGING}

  Trace('Initializing');

  Mappings := TrsMethodMappings.Create([doOwnsValues]);

  Mappings.Add('GET', TrsRouteMappings.Create);
  Mappings.Add('POST', TrsRouteMappings.Create);
  Mappings.Add('PUT', TrsRouteMappings.Create);
  Mappings.Add('HEAD', TrsRouteMappings.Create);
  Mappings.Add('DELETE', TrsRouteMappings.Create);
  Mappings.Add('PATCH', TrsRouteMappings.Create);
  Mappings.Add('OPTIONS', TrsRouteMappings.Create);
end;

destructor TrsConfiguration.Destroy;
begin
  Mappings.Free;

  inherited;
end;

// Setter / Getter -----------------------------------------------------------

function TrsConfiguration.GetCurrentPath: string;
begin
   // Returns <BasePath>/<NextPath>
   Result := BasePath;
   if (Result <> '') and (NextPath <> '') then
   begin
     Result := Result + '/';
   end;
   Result := Result + NextPath;
end;

// clear properties

procedure TrsConfiguration.ClearNextPath;
begin
  NextPath := '';
end;

procedure TrsConfiguration.ClearProducesConsumes;
begin
  FNextProduces := '';
  FNextConsumes := '';
end;

// Logging -------------------------------------------------------------------
procedure TrsConfiguration.Trace(const S: string);
begin
  {$IFDEF DARAJA_LOGGING}
  Logger.Trace(ClassName + ': ' + S);
  {$ENDIF DARAJA_LOGGING}
end;

function TrsConfiguration.HasMatch(Criteria: TrsRouteCriteria): Boolean;
var
  RM: TrsRouteMappings;
  R: TrsRoute;
begin
  for RM in Mappings.Values do
  begin
    RM.FindMatch(Criteria, R);
    if Assigned(R) then
    begin
      Trace('Found a handler for ' + Criteria.Path);  // TODO log handler method
      Exit(True)
    end;
  end;
  Result := False;
end;

function TrsConfiguration.MethodMappings(Method: string): TrsRouteMappings;
begin
  if not Mappings.ContainsKey(Method) then
  begin
    raise Exception.CreateFmt('Unknown method "%s"', [Method]);
  end;

  Result := Mappings[Method];
end;

procedure TrsConfiguration.SetPath(const APath: string);
begin
  Assert(APath <> '', 'Path must not be empty');

  if Pos('/', APath) = 1 then
  begin
    BasePath := Copy(APath, 2);
  end
  else
  begin
    NextPath := APath;
  end;
end;

procedure TrsConfiguration.AddMapping(Method: string; Route: TrsRoute);
var
  C: TrsRouteCriteria;
begin
  C := TrsRouteCriteria.Create(Route.Path);
  C.Produces := NextProduces;
  C.Consumes := NextConsumes;

  AddMapping(Method, C, Route);

  {$IFDEF DARAJA_LOGGING}
  Logger.Info(
    Format('Added HTTP "%s" mapping for path %s', [Method, CurrentPath]));
  {$ENDIF DARAJA_LOGGING}
end;

procedure TrsConfiguration.AddMapping(Method: string;
  Criteria: TrsRouteCriteria; Route: TrsRoute);
begin
  if MethodMappings(Method).ContainsKey(Criteria) then
  begin
    Criteria.Free;
    Route.Free;
    raise DuplicateMappingException.CreateFmt('Duplicate mapping for %s',
      [Route.Path]);
  end;

  MethodMappings(Method).Add(Criteria, Route);

  ClearProducesConsumes;

  FHasMappings := True; // ready to run when at least one mapping is active
end;


end.

