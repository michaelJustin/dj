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
  private
    function CheckPwd(const Username, Password: string): Boolean;
  public
    procedure OnGet(Request: TdjRequest; Response: TdjResponse); override;
    procedure OnPost(Request: TdjRequest; Response: TdjResponse); override;
  end;

implementation

procedure TLoginResource.OnGet(Request: TdjRequest; Response: TdjResponse);
begin
  Response.ContentText := '<!DOCTYPE html>' + #13
    + '<html lang="en">' + #13
    + '  <head>' + #13
    + '    <title>Login form</title>' + #13
    + '  </head>' + #13
    + '  <body>' + #13
    + '    <h1>Login</h1>' + #13
    + '    <form method="post">' + #13
    + '     Username: <input type="text" name="username" required>' +#13
    + '     Password: <input type="password" name="password" required>' + #13
    + '     <input type="submit" name="submit" value="Login">' + #13
    + '    </form>' + #13
    + '  </body>' + #13
    + '</html>';

  Response.ContentType := 'text/html';
  Response.CharSet := 'utf-8';
end;

procedure TLoginResource.OnPost(Request: TdjRequest; Response: TdjResponse);
var
  Username: string;
  Password: string;
begin
  // read form data
  Username := Utf8ToString(RawByteString(Request.Params.Values['username']));
  Password := Utf8ToString(RawByteString(Request.Params.Values['password']));

  if CheckPwd(Username, Password) then
  begin
    // store username in session
    Request.Session.Content.Values['auth:username'] := Username;
    // success: redirect to target page
    Response.Redirect(Request.Session.Content.Values['auth:target']);
  end else begin
    // bad user/password: return authentication error
    Response.Redirect('/loginError');
  end;
end;

function TLoginResource.CheckPwd(const Username, Password: string): Boolean;
begin
  Result := False;

  if Username = 'guest' then
  begin
    Result := Password = 'guest';
  end;
end;

end.

