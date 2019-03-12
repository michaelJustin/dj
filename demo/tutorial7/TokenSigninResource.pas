(*

    Daraja HTTP Framework
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

unit TokenSigninResource;

interface

uses
  djWebComponent, djTypes;

type
  TTokenSigninResource = class(TdjWebComponent)
  public
    procedure OnPost(Request: TdjRequest; Response: TdjResponse); override;
  end;

implementation

uses
  BindingHelper,
  IdHTTP, SysUtils,
  {$IFDEF FPC}
  fpjson, jsonparser;
  {$ELSE}
  superobject;
  {$ENDIF}

type
  TClaims = record
    aud: string;
    name: string;
    email: string;
    email_verified: string;
    picture: string;
  end;

{$IFDEF FPC}
function ToClaims(const JSON: string): TClaims;
var
  Data: TJSONData;
  Claims : TJSONObject;
begin
  Data := GetJSON(JSON);
  Claims := TJSONObject(Data);

  Result.aud := Claims.Get('aud');
  Result.name := Claims.Get('name');
  Result.email := Claims.Get('email');
  Result.email_verified := Claims.Get('email_verified');
  Result.picture := Claims.Get('picture');
end;
{$ELSE}
function ToClaims(const JSON: string): TClaims;
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

{ TTokenSigninResource }

// see https://developers.google.com/identity/sign-in/web/backend-auth
// requires OpenSSL libraries in application folder (32 bit or 64 bit!)

procedure TTokenSigninResource.OnPost(Request: TdjRequest; Response: TdjResponse);
const
  VALIDATION_URL = 'https://oauth2.googleapis.com/tokeninfo';
var
  IdToken: string;
  IdHTTP: TIdHTTP;
  ValidationResponse: string;
  Claims: TClaims;
begin
  Response.ResponseNo := 500; // 'pessimistic'

  IdToken := Request.Params.Values['idtoken']; // sent via XMLHttpRequest from script

  IdHTTP := TIdHTTP.Create;
  try
    try
      ValidationResponse := IdHTTP.Get(VALIDATION_URL + '?id_token=' + IdToken);
    except
      on E: Exception do begin
        Exit;
      end;
    end;

    if IdHTTP.ResponseCode = 200 then begin
      Claims := ToClaims(ValidationResponse);

      // "Once you get these claims, you still need to check that the aud claim
      // contains one of your app's client IDs. If it does, then the token is
      // both valid and intended for your client, and you can safely retrieve
      // and use the user's unique Google ID from the sub claim."
      // - https://developers.google.com/identity/sign-in/web/backend-auth
      if Claims.aud = MY_GOOGLE_SIGNIN_CLIENT_ID then begin
         // ok -> set response to OK and store user information in session
         Response.ResponseNo := 200;

         Request.Session.Content.Values['name'] := Claims.name;
         Request.Session.Content.Values['email'] := Claims.email;
         Request.Session.Content.Values['email_verified'] := Claims.email_verified;
         Request.Session.Content.Values['picture'] := Claims.picture;
      end;
    end;
  finally
    IdHTTP.Free;
  end;
end;

end.

