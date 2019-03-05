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

unit OpenIDHelper;

// note: this is unsupported example code

interface

{$i IdCompilerDefines.inc}

uses
  Classes;

const
  MY_HOST = 'http://localhost';
  MY_CALLBACK_URL = '/openidcallback';

procedure LoadClientSecrets(Filename: string);

type
  TOpenIDParams = record
    client_id: string; // Google
    // appid: string; // PayPal
    returnurl: string;
  end;

var
  OpenIDParams: TOpenIDParams;

implementation

uses
  SysUtils,
  {$IFDEF FPC}
  fpjson, jsonparser;
  {$ELSE}
  superobject;
  {$ENDIF}

{$IFDEF FPC}
procedure LoadClientSecrets(Filename: string);
var
  S: TStream;
  Data: TJSONData;
  C : TJSONObject;
begin
  S := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    Data := GetJSON(S);
    C := TJSONObject(Data);

    OpenIDParams.client_id := C.Get('client_id');
    // OpenIDParams.appid := C.Get('appid');
    OpenIDParams.returnurl := MY_HOST + MY_CALLBACK_URL;

  finally
    S.Free;
  end;
end;

{$ELSE}

procedure LoadClientSecrets(Filename: string);
var
  C: ISuperObject;
  web: ISuperObject;
begin
  C := TSuperObject.ParseFile(FileName, False);

  web := C.O['web'];

  client_id := web.S['client_id'];
  client_secret := web.S['client_secret'];
  auth_uri := web.S['auth_uri'];
  token_uri := web.S['token_uri'];

  redirect_uri := web.A['redirect_uris'].S[0];

  if redirect_uri <> MY_HOST + MY_CALLBACK_URL then
    raise Exception
      .CreateFmt('Please enter the redirect URI %s in the API console!',
        [MY_HOST + MY_CALLBACK_URL]);
end;

function ToCredentials(const JSON: string): TCredentials;
var
  C: ISuperObject;
begin
  C := SO(JSON);

  Result.access_token := C.S['access_token'];
  Result.expires_in := C.I['expires_in'];
end;
{$ENDIF}

end.
