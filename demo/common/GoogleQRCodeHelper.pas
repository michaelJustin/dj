(*
   Copyright (C) Michael Justin

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)

unit GoogleQRCodeHelper;

// note: this is unsupported example code

interface

{$i IdCompilerDefines.inc}

uses
  Classes;

(**
 * Create a PNG image stream for the given text.
 *)
procedure ReadURIToQRCodePNG(const AText: string; const AStream: TStream);

implementation

uses
  IdHTTP, IdURI;

procedure ReadURIToQRCodePNG(const AText: string; const AStream: TStream);
var
  HTTP: TIdHTTP;
begin
  HTTP := TIdHTTP.Create(nil);
  try
    HTTP.Get(
      'http://chart.apis.google.com/chart?chs=180x180&cht=qr&chld=M&chl='
     + TIdURI.ParamsEncode(AText), AStream);
  finally
    HTTP.Free;
  end;
end;

end.
