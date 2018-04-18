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
      SL.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'webapps/'
       + Context + '/' + FileName);
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
      '#{djf.version}',
      DWF_SERVER_VERSION,
      [rfReplaceAll]);

  Result := StringReplace(Result,
      '<bs:bootstrap_css />',
      '<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">',
      [rfReplaceAll]);

  Result := StringReplace(Result,
      '<bs:bootstrap_js />',
      '<script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha384-tsQFqpEReu7ZLhBV2VZlAu7zcOV+rXbYlF2cqB8txI/8aZajjp4Bqd+V6D5IgvKT" crossorigin="anonymous"></script>' + #13
    + '<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js" integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ" crossorigin="anonymous"></script>' + #13
    + '<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>' + #13,
      [rfReplaceAll]);

  Result := StringReplace(Result,
      '<bs:footer />',
      '<footer class="footer" id="contact">'
    + '    <div class="row">'
    + '        <div class="col-md-12">'
    + '            <a href="http://getbootstrap.com/">Bootstrap</a> Copyright (c) 2011-2018 Twitter, Inc., Copyright (c) 2011-2018 The Bootstrap Authors, licensed under MIT License. Open Sans licensed under Apache License, version 2.0'
    + '        </div>'
    + '    </div>'
    + '</footer>',
      []);

end;

end.
