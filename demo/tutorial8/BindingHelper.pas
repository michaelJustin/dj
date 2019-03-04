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

unit BindingHelper;

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

  // Before you can integrate Google Sign-In into your website, you must create 
  // a client ID, which you need to call the sign-in API. For details 
  // see "Integrating Google Sign-In into your web app" 
  // https://developers.google.com/identity/sign-in/web/sign-in

function Bind(Context, FileName: string; SessionParams: TStrings): string;

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

function Bind(Context, FileName: string; SessionParams: TStrings): string;
var
  SL : TStrings;
  Folder: string;
begin
  if MY_GOOGLE_SIGNIN_CLIENT_ID = DEFAULT_GOOGLE_SIGNIN_CLIENT_ID then
    raise Exception.Create('Please configure the Google Sign-In client ID in BindingHelper.pas');

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
      '</header>'
      ,
      [rfReplaceAll]);

  if SessionParams.Values['name'] <> '' then
  begin
    Result := StringReplace(Result,
        '<dj:footer/>',
        '<footer>' +
        '<p>Logged in as <strong>#{email}</strong></p>' +
        '</footer>'
        ,
        [rfReplaceAll]);
  end else begin
    Result := StringReplace(Result,
        '<dj:footer/>',
        '<footer>' +
        '<p>Not logged in</p>' +
        '</footer>'
        ,
        [rfReplaceAll]);

  end;

  (* Result := StringReplace(Result,
      '#{name}',
      SessionParams.Values['name'],
      [rfReplaceAll]); *)
end;

end.
