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

unit djFileUploadHelper;

// note: this is unsupported example code

interface

{$i IdCompilerDefines.inc}

uses
  IdMessageCoder, IdCustomHTTPServer;

type
  TMimeHandler = procedure(var VDecoder: TIdMessageDecoder;
    var VMsgEnd: Boolean; const Response: TIdHTTPResponseInfo) of object;

procedure HandleMultipartUpload(Request: TIdHTTPRequestInfo; Response:
  TIdHTTPResponseInfo; MimeHandler: TMimeHandler);

implementation

uses
  IdGlobalProtocols, IdGlobal,
  IdMessageCoderMIME,
  Classes, SysUtils;

procedure HandleMultipartUpload(Request: TIdHTTPRequestInfo; Response:
  TIdHTTPResponseInfo; MimeHandler: TMimeHandler);
var
  LBoundary, LBoundaryStart, LBoundaryEnd: string;
  LDecoder: TIdMessageDecoder;
  LLine: string;
  LBoundaryFound, LIsStartBoundary, LMsgEnd: Boolean;
begin
  LBoundary := ExtractHeaderSubItem(Request.ContentType, 'boundary',
    QuoteHTTP);
  if LBoundary = '' then
  begin
    Response.ResponseNo := 400;
    Response.CloseConnection := True;
    Response.WriteHeader;
    Exit;
  end;

  LBoundaryStart := '--' + LBoundary;
  LBoundaryEnd := LBoundaryStart + '--';

  LDecoder := TIdMessageDecoderMIME.Create(nil);
  try
    TIdMessageDecoderMIME(LDecoder).MIMEBoundary := LBoundary;
    LDecoder.SourceStream := Request.PostStream;
    LDecoder.FreeSourceStream := False;

    LBoundaryFound := False;
    LIsStartBoundary := False;
    repeat
      LLine := ReadLnFromStream(Request.PostStream, -1, True);
      if LLine = LBoundaryStart then
      begin
        LBoundaryFound := True;
        LIsStartBoundary := True;
      end
      else if LLine = LBoundaryEnd then
      begin
        LBoundaryFound := True;
      end;
    until LBoundaryFound;

    if (not LBoundaryFound) or (not LIsStartBoundary) then
    begin
      Response.ResponseNo := 400;
      Response.CloseConnection := True;
      Response.WriteHeader;
      Exit;
    end;

    LMsgEnd := False;
    repeat
      TIdMessageDecoderMIME(LDecoder).MIMEBoundary := LBoundary;
      LDecoder.SourceStream := Request.PostStream;
      LDecoder.FreeSourceStream := False;

      LDecoder.ReadHeader;
      case LDecoder.PartType of
        mcptText, mcptAttachment:
          begin
            MimeHandler(LDecoder, LMsgEnd, Response);
          end;
        mcptIgnore:
          begin
            LDecoder.Free;
            LDecoder := TIdMessageDecoderMIME.Create(nil);
          end;
        mcptEOF:
          begin
            LDecoder.Free;
            LMsgEnd := True;
          end;
      end;
    until (LDecoder = nil) or LMsgEnd;
  finally
    LDecoder.Free;
  end;
end;
end.

