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

unit LoginResource;

interface

uses
  djWebComponent, djTypes;

type
  TLoginResource = class(TdjWebComponent)
  public
    procedure OnPost(Request: TdjRequest; Response: TdjResponse); override;
  end;

implementation

uses
  BindingHelper,
  IdHTTP, superobject;

// see https://developers.google.com/identity/sign-in/web/backend-auth
// requires OpenSSL libraries in application folder

procedure TLoginResource.OnPost(Request: TdjRequest; Response: TdjResponse);
const
  VALIDATION_URL = 'https://oauth2.googleapis.com/tokeninfo';
var
  IdToken: string;
  IdHTTP: TIdHTTP;
  ValidationResponse: string;
  Claims: ISuperObject;
begin
  inherited;

  // sent via XMLHttpRequest from script
  IdToken := Request.Params.Values['idtoken'];

  IdHTTP := TIdHTTP.Create;
  try
    ValidationResponse := IdHTTP.Get(VALIDATION_URL + '?id_token=' + IdToken);

    if IdHTTP.ResponseCode = 200 then begin
      Claims := SO(ValidationResponse);

      // "Once you get these claims, you still need to check that the aud claim
      // contains one of your app's client IDs. If it does, then the token is
      // both valid and intended for your client, and you can safely retrieve
      // and use the user's unique Google ID from the sub claim."
      // - https://developers.google.com/identity/sign-in/web/backend-auth

      if Claims.S['aud'] = GOOGLE_SIGNIN_CLIENT_ID then begin
         // ok -> store user information
         Request.Session.Content.Values['name'] := Claims.S['name'];
         Request.Session.Content.Values['email'] := Claims.S['email'];
         Request.Session.Content.Values['email_verified'] := Claims.S['email_verified'];
         Request.Session.Content.Values['picture'] := Claims.S['picture'];

         Response.Redirect(Request.Referer);
      end;
    end;
  finally
    IdHTTP.Free;
  end;
end;

end.

