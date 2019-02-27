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
 DEFAULT_GOOGLE_SIGNIN_CLIENT_ID = 'YOUR_CLIENT_ID.apps.googleusercontent.com';
 GOOGLE_SIGNIN_CLIENT_ID = '235205874120-cfbi689k9opeaq9g028i0e9s59hkqqbm.apps.googleusercontent.com';

function Bind(Context, FileName: string; SessionParams: TStrings): string;

implementation

uses
  SysUtils;

function Bind(Context, FileName: string; SessionParams: TStrings): string;
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
      '#{google-signin-client_id}',
      GOOGLE_SIGNIN_CLIENT_ID,
      [rfReplaceAll]);

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

  Result := StringReplace(Result,
      '#{name}',
      SessionParams.Values['name'],
      [rfReplaceAll]);

  Result := StringReplace(Result,
      '#{email}',
      SessionParams.Values['email'],
      [rfReplaceAll]);

  Result := StringReplace(Result,
      '#{email_verified}',
      SessionParams.Values['email_verified'],
      [rfReplaceAll]);

  Result := StringReplace(Result,
      '#{picture}',
      SessionParams.Values['picture'],
      [rfReplaceAll]);


end;

end.
