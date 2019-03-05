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

unit OpenIDCallbackResource;

interface

uses
  djWebComponent, djTypes;

type

  { TOpenIDCallbackResource }

  TOpenIDCallbackResource = class(TdjWebComponent)
  public
    procedure OnGet(Request: TdjRequest; Response: TdjResponse); override;
  end;

implementation

uses
  OpenIDHelper,
  IdHTTP, SysUtils, Classes;

{ TOpenIDCallbackResource }

// https://developers.google.com/identity/protocols/OpenIDConnect

// https://openid.net/specs/openid-connect-core-1_0.html#AuthResponse

// "When using the Authorization Code Flow, the Client MUST validate the response according to RFC 6749, especially Sections 4.1.2 and 10.12."

procedure TOpenIDCallbackResource.OnGet(Request: TdjRequest;
  Response: TdjResponse);
var
  AuthCode: string;
begin
  AuthCode := Request.Params.Values['code'];

  WriteLn('AuthCode: ' + AuthCode);

  Response.ContentType := 'text/plain';
  Response.CharSet := 'utf-8';
end;

end.

