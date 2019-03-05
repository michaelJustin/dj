(*

    Daraja Framework
    Copyright (C) Michael Justin

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

unit BindingHelper;

// note: this is unsupported example code

interface

{$i IdCompilerDefines.inc}

uses
  OpenIDHelper, Classes;

function Bind(Context, FileName: string; OpenIDParams: TOpenIDParams): string;

implementation

uses
  SysUtils;

function Bind(Context, FileName: string; OpenIDParams: TOpenIDParams): string;
var
  SL : TStrings;
  Folder: string;
begin
  if Context = '' then Folder := 'ROOT' else Folder := Context;

  SL := TStringList.Create;
    try
      SL.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'webapps/'
       + Folder + '/' + FileName);
      Result := SL.Text;
    finally
      SL.Free;
    end;

  Result := StringReplace(Result,
      '<dj:header/>',
      '<header>' +
      '<p>Navigation</p>' +
      '</header>',
      [rfReplaceAll]);

  (*
  PayPal Result := StringReplace(Result,
      '#{appid}',
      OpenIDParams.appid,
      [rfReplaceAll]);
  *)

  // Google
  Result := StringReplace(Result,
      '#{client_id}',
      OpenIDParams.client_id,
      [rfReplaceAll]);

  Result := StringReplace(Result,
      '#{returnurl}',
      OpenIDParams.returnurl,
      [rfReplaceAll]);
end;

end.
