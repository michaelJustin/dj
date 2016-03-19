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

unit rsRouteMappings;

{$i IdCompilerDefines.inc}

interface

uses
  rsRoute, rsRouteCriteria,
  {$IFDEF DARAJA_LOGGING}
  djLogAPI, djLoggerFactory,
  {$ENDIF DARAJA_LOGGING}
  {$IFDEF FPC}fgl{$ELSE}Generics.Collections{$ENDIF},
  SysUtils;

type
  (**
   * Route mappings.
   *)
  TrsRouteMappings = class(TObjectDictionary<TrsRouteCriteria, TrsRoute>)
  public
    constructor Create; overload;

    function FindMatch(C: TrsRouteCriteria; var Route: TrsRoute): TrsRouteCriteria;
  end;

  TrsMethodMappings = TObjectDictionary<string, TrsRouteMappings>;

implementation

{ TrsRouteMappings }

constructor TrsRouteMappings.Create;
begin
  inherited Create([doOwnsKeys, doOwnsValues], TrsCriteriaComparer.Create);
end;

function TrsRouteMappings.FindMatch(C: TrsRouteCriteria;
  var Route: TrsRoute): TrsRouteCriteria;
var
  MatchingRC: TrsRouteCriteria;
begin
  Route := nil;
  Result := nil;
  for MatchingRC in Keys do
  begin
    // Log(Format('Comparing %s %s', [C.Path + C.Produces, MatchingRC.Path + MatchingRC.Produces]));
    if TrsRouteCriteria.Matches(MatchingRC, C) then
    begin
      Route := Self[MatchingRC];
      Result := MatchingRC;
      Break;
    end;
  end;
end;

end.
