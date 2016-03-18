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

unit BindingFramework;

// note: this is unsupported example code

interface

{$i IdCompilerDefines.inc}

function Bind(Context, FileName: string): string;

implementation

uses
  djGlobal,
  SysUtils, Classes;

function osname: string;
begin
  Result := {$IFDEF LINUX} 'Linux' {$ELSE} 'Windows' {$ENDIF};
end;

function Bind(Context, FileName: string): string;
var
  SL : TStringList;
begin
  SL := TStringList.Create;
    try
      SL.LoadFromFile(
        ExtractFilePath(ParamStr(0)) + 'webapps/' + Context + '/'
       + FileName);
      Result := SL.Text;
    finally
      SL.Free;
    end;

  Result := StringReplace(Result,
      '#{webContext.requestContextPath}',
      '/' + Context,
      [rfReplaceAll]);

  Result := StringReplace(Result,
      '#{osname}',
      osname,
      [rfReplaceAll]);

  Result := StringReplace(Result,
      '#{hwcfversion}',
      DWF_SERVER_VERSION,
      [rfReplaceAll]);

  Result := StringReplace(Result,
      '#{bootstrap.home}',
      'https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0',
      [rfReplaceAll]);

  Result := StringReplace(Result,
      '#{jquery.min.js}',
      'https://code.jquery.com/jquery-1.10.2.min.js',
      [rfReplaceAll]);

end;

end.
