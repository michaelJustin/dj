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

unit OAuthHelper;

// note: this is unsupported example code

interface

{$i IdCompilerDefines.inc}

uses
  Classes;

const
  MY_HOST = 'http://localhost';
  MY_CALLBACK_URL = '/oauth2callback';

  SCOPE = 'https://www.googleapis.com/auth/drive.metadata.readonly';

  DEFAULT_GOOGLE_SIGNIN_CLIENT_ID = 'YOUR_CLIENT_ID.apps.googleusercontent.com';
  MY_GOOGLE_SIGNIN_CLIENT_ID = '235205874120-57lktp5qfr899u57jnepagcsnilbbdlo.apps.googleusercontent.com';

  CLIENT_SECRET = 'rAB5hhgkeO_o09e-PKiZz480';

type
  TCredentials = record
    access_token: string;
    expires_in: Integer;
  end;

function ToCredentials(const JSON: string): TCredentials;

implementation

uses
  SysUtils,
  {$IFDEF FPC}
  fpjson, jsonparser;
  {$ELSE}
  superobject;
  {$ENDIF}

{$IFDEF FPC}
function ToCredentials(const JSON: string): TCredentials;
var
  Data: TJSONData;
  C : TJSONObject;
begin
  Data := GetJSON(JSON);
  C := TJSONObject(Data);

  Result.access_token := C.Get('access_token');
  Result.expires_in := C.Get('expires_in');
end;
{$ELSE}
function ToCredentials(const JSON: string): TCredentials;
var
  Claims: ISuperObject;
begin
  Claims := SO(JSON);

  Result.aud := Claims.S['aud'];
  Result.name := Claims.S['name'];
  Result.email := Claims.S['email'];
  Result.email_verified := Claims.S['email_verified'];
  Result.picture := Claims.S['picture'];
end;
{$ENDIF}

end.
