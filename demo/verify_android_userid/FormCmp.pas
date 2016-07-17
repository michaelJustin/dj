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

unit FormCmp;

// note: this is unsupported example code

interface

{$i IdCompilerDefines.inc}

uses
  djWebComponent,
  IdCustomHTTPServer;

type

  { TFormPage }

  TFormPage = class(TdjWebComponent)
  private
    function GetGoogleTokenInfo(const AToken: string): string;
  public
    procedure OnGet(Request: TIdHTTPRequestInfo; Response:
      TIdHTTPResponseInfo); override;

    procedure OnPost(Request: TIdHTTPRequestInfo; Response:
      TIdHTTPResponseInfo); override;
  end;

implementation

uses
  IdHTTP, BindingFramework;

{ TFormPage }

function TFormPage.GetGoogleTokenInfo(const AToken: string): string;
const
  URL = 'https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=';
var
  Client: TIdHTTP;
begin
  Client := TIdHTTP.Create;
  try
    Result := Client.Get(URL + AToken);
  finally
    Client.Free;
  end;
end;

procedure TFormPage.OnGet(Request: TIdHTTPRequestInfo;
  Response: TIdHTTPResponseInfo);
begin
  Response.ContentText := Bind(Config.GetContext.GetContextPath, 'form.html');
  Response.ContentType := 'text/html';
  Response.CharSet := 'utf-8';
end;

procedure TFormPage.OnPost(Request: TIdHTTPRequestInfo;
  Response: TIdHTTPResponseInfo);
var
  Token, TokenInfo: string;
begin
  // read form data
  Token := Request.Params.Values['textfield1'];

  // pass it to Google API
  TokenInfo := GetGoogleTokenInfo(Token);

  // store data in session
  Request.Session.Content.Values['form:tokenInfo'] := TokenInfo;

  // redirect to thankyou page
  Response.Redirect('thankyou.html');
end;

end.

