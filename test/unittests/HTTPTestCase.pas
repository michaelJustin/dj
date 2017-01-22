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

unit HTTPTestCase;

interface

uses
  {$IFDEF FPC}fpcunit,testregistry{$ELSE}TestFramework{$ENDIF},
  IdHTTP;

type
  THTTPTestCase = class(TTestCase)
  private
    IdHTTP: TIdHTTP;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure CheckGETResponseEquals(Expected: string; URL: string = ''; msg: string = '');

    procedure CheckGETResponseContains(Expected: string; URL: string = ''; msg: string = '');

    procedure CheckGETResponse404(URL: string = ''; msg: string = '');

    procedure CheckPOSTResponseEquals(Expected: string; URL: string = ''; msg: string = '');

  end;

implementation

uses
  Classes;

{ THTTPTestCase }

procedure THTTPTestCase.CheckGETResponseEquals(Expected: string; URL: string = ''; msg: string = '');
var
  Actual: string;
begin
  if Pos('http', URL) <> 1 then URL := 'http://127.0.0.1' + URL;

  Actual := IdHTTP.Get(URL);

  CheckEquals(Expected, Actual, msg);
end;

procedure THTTPTestCase.CheckGETResponse404(URL, msg: string);
begin
  if Pos('http', URL) <> 1 then URL := 'http://127.0.0.1' + URL;

  IdHTTP.Get(URL, [404]);
  CheckEquals(404, IdHTTP.ResponseCode);
end;

procedure THTTPTestCase.CheckGETResponseContains(Expected: string; URL: string = ''; msg: string = '');
var
  Actual: string;
begin
  if Pos('http', URL) <> 1 then URL := 'http://127.0.0.1' + URL;

  Actual := IdHTTP.Get(URL);

  CheckTrue(Pos(Expected, Actual) > 0, msg);
end;

procedure THTTPTestCase.CheckPOSTResponseEquals(Expected, URL, msg: string);
var
  Strings: TStrings;
begin
  if Pos('http', URL) <> 1 then URL := 'http://127.0.0.1' + URL;

  Strings := TStringList.Create;
  try
    Strings.Add('send=send');
    CheckEquals(Expected, IdHTTP.Post(URL, Strings), msg);
  finally
    Strings.Free;
  end;
end;

procedure THTTPTestCase.SetUp;
begin
  inherited;

  IdHTTP := TIdHTTP.Create;
end;

procedure THTTPTestCase.TearDown;
begin
  IdHTTP.Free;

  inherited;
end;

end.
