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

unit lazutf8helper;

// note: this is unsupported example code

interface

{$i IdCompilerDefines.inc}

uses
  djTypes;

procedure MyDecodeAndSetParams(const ARequestInfo: TdjRequest);

implementation

uses
  IdURI, IdGlobal, IdGlobalProtocols;

procedure MyDecodeAndSetParams(const ARequestInfo: TdjRequest);
var
  i, j : Integer;
  AValue, s: string;
  LEncoding: IIdTextEncoding;
begin
  AValue := ARequestInfo.UnparsedParams;
  // Convert special characters
  // ampersand '&' separates values    {Do not Localize}
  ARequestInfo.Params.BeginUpdate;
  try
    ARequestInfo.Params.Clear;
    // TODO: provide an event or property that lets the user specify
    // which charset to use for decoding query string parameters.  We
    // should not be using the 'Content-Type' charset for that.  For
    // 'application/x-www-form-urlencoded' forms, we should be, though...
    LEncoding := CharsetToEncoding(ARequestInfo.CharSet);
    i := 1;
    while i <= Length(AValue) do
    begin
      j := i;
      while (j <= Length(AValue)) and (AValue[j] <> '&') do {do not localize}
      begin
        Inc(j);
      end;
      s := Copy(AValue, i, j-i);
      // See RFC 1866 section 8.2.1. TP
      s := ReplaceAll(s, '+', ' ');  {do not localize}
      {$IFDEF FPC}
      ARequestInfo.Params.Add(TIdURI.URLDecode(s,{$IFDEF FPC_UNICODESTRINGS}LEncoding{$ELSE}IndyTextEncoding_UTF8, IndyTextEncoding(DefaultSystemCodePage){$ENDIF}));
      {$ELSE}
      Request.Params.Add(TIdURI.URLDecode(s,IndyTextEncoding_UTF8));
      {$ENDIF}
      i := j + 1;
    end;
  finally
    ARequestInfo.Params.EndUpdate;
  end;
end;


end.

