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

uses
  djWebComponent, djTypes;

type
  TFormPage = class(TdjWebComponent)
  public
    procedure OnGet(Request: TdjRequest; Response: TdjResponse); override;
    procedure OnPost(Request: TdjRequest; Response: TdjResponse); override;
  end;

implementation

uses
  {$IFDEF FPC}
  IdCustomHTTPServer, IdGlobal, IdURI, IdGlobalProtocols,
  {$ENDIF}
  BindingFramework;

{ TFormPage }

procedure TFormPage.OnGet(Request: TdjRequest;
  Response: TdjResponse);
begin
  Response.ContentText := Bind(Config.GetContext.GetContextPath, 'form.html');
  Response.ContentType := 'text/html';
  Response.CharSet := 'utf-8';
end;

{$IFDEF FPC}

// based on class function TIdURI.URLDecode in Indy rev 5498

function MyURLDecode(ASrc: string; AByteEncoding: IIdTextEncoding = nil
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  ): string;
var
  i, SrcLen: Integer;
  ESC: string;
  LChars: TIdWideChars;
  LBytes: TIdBytes;
begin
  Result := '';    {Do not Localize}
  LChars := nil;
  LBytes := nil;
  EnsureEncoding(AByteEncoding, encUTF8);
  // S.G. 27/11/2002: Spaces is NOT to be encoded as "+".
  // S.G. 27/11/2002: "+" is a field separator in query parameter, space is...
  // S.G. 27/11/2002: well, a space
  // ASrc := ReplaceAll(ASrc, '+', ' ');  {do not localize}
  i := 1;
  SrcLen := Length(ASrc);
  while i <= SrcLen do begin
    if ASrc[i] <> '%' then begin  {do not localize}
      AppendByte(LBytes, Ord(ASrc[i])); // Copy the char
      Inc(i); // Then skip it
    end else begin
      Inc(i); // skip the % char
      if not CharIsInSet(ASrc, i, 'uU') then begin  {do not localize}
        // simple ESC char
        ESC := Copy(ASrc, i, 2); // Copy the escape code
        Inc(i, 2); // Then skip it.
        try
          AppendByte(LBytes, Byte(IndyStrToInt('$' + ESC))); {do not localize}
        except end;
      end else
      begin
        // unicode ESC code

        // RLebeau 5/10/2006: under Win32, the character will likely end
        // up as '?' in the Result when converted from Unicode to Ansi,
        // but at least the URL will be parsed properly

        ESC := Copy(ASrc, i+1, 4); // Copy the escape code
        Inc(i, 5); // Then skip it.
        try
          if LChars = nil then begin
            SetLength(LChars, 1);
          end;
          LChars[0] := WideChar(IndyStrToInt('$' + ESC));  {do not localize}
          AppendBytes(LBytes, AByteEncoding.GetBytes(LChars));
        except end;
      end;
    end;
  end;
  // ----------------------------
  // Free Pascal 3.0.4 workaround: use AByteEncoding
  //{$IFDEF STRING_IS_ANSI}
  //EnsureEncoding(ADestEncoding, encOSDefault);
  //CheckByteEncoding(LBytes, AByteEncoding, ADestEncoding);
  //SetString(Result, PAnsiChar(LBytes), Length(LBytes));
  //{$ELSE}
  //Result := AByteEncoding.GetString(LBytes);
  //{$ENDIF}
  Result := string(AByteEncoding.GetString(LBytes));
  // ----------------------------
end;

// based on https://stackoverflow.com/questions/24861793

procedure MyDecodeAndSetParams(ARequestInfo: TIdHTTPRequestInfo);
var
  i, j : Integer;
  AValue, s: string;
  // ----------------------------
  // Free Pascal 3.0.4 workaround: use MyURLDecode and UTF8
  // LEncoding: IIdTextEncoding;
  // ----------------------------
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
    // Free Pascal 3.0.4 workaround
    // LEncoding := CharsetToEncoding(ARequestInfo.CharSet);
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
      // ----------------------------
      // Free Pascal 3.0.4 workaround: use MyURLDecode and UTF8
      // ARequestInfo.Params.Add(TIdURI.URLDecode(s, LEncoding));
      ARequestInfo.Params.Add(MyURLDecode(s, IndyTextEncoding_UTF8));
      // ----------------------------
      i := j + 1;
    end;
  finally
    ARequestInfo.Params.EndUpdate;
  end;
end;
{$ENDIF}

procedure TFormPage.OnPost(Request: TdjRequest;
  Response: TdjResponse);
var
  Text: string;
  Pass: string;
  Checkbox: string;
begin
  {$IFDEF FPC}
  MyDecodeAndSetParams(Request);
  {$ENDIF}

  // read form data
  Text := Request.Params.Values['textfield1'];
  Pass := Request.Params.Values['exampleInputPassword1'];
  Checkbox := Request.Params.Values['checkbox1'];

  // store data in session
  Request.Session.Content.Values['form:textfield1'] := Text;
  Request.Session.Content.Values['form:exampleInputPassword1'] := Pass;
  Request.Session.Content.Values['form:checkbox1'] := Checkbox;

  // redirect to thankyou page
  Response.Redirect('thankyou.html');
end;

end.

