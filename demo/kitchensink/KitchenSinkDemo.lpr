(*
    Daraja Web Framework
    Copyright (C) 2016 Michael Justin

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
    develop commercial activities involving the software without
    disclosing the source code of your own applications. These activities
    include: offering paid services to customers as an ASP, serving resources
    in a web application, shipping the Daraja Web Framework with a closed
    source product.
*)

program KitchenSinkDemo;

// note: this is unsupported example code

{$i IdCompilerDefines.inc}

uses
{$IFDEF LINUX}
  cthreads,
{$ENDIF}
  Interfaces, // ! fixes UTF-8 ContentLength bug
  djServer,
  djWebAppContext,
  djDefaultHandler,
  djDefaultWebComponent,
  djHandlerList,
  djInterfaces,
  djStatisticsHandler,
  djNCSALogHandler,
  {$IFDEF DARAJA_LOGGING}
  djLogAPI, djLogOverSimpleLogger,
  {$ENDIF}
  AjaxCmp in 'AjaxCmp.pas',
  AjaxStatsCmp in 'AjaxStatsCmp.pas',
  FileUploadCmp in 'FileUploadCmp.pas',
  FormCmp in 'FormCmp.pas',
  IndexCmp in 'IndexCmp.pas',
  HelloWorldCmp in 'HelloWorldCmp.pas',
  LoggingCmp in 'LoggingCmp.pas',
  QrCodeCmp in 'QrCodeCmp.pas',
  SourceCmp in 'SourceCmp.pas',
  StatsCmp in 'StatsCmp.pas',
  ThankYouCmp in 'ThankYouCmp.pas',
  IdGlobal,
  SysUtils;

  procedure Demo;
  var
    LogHandler: IHandler;
    Server: TdjServer;
    Context: TdjWebAppContext;
    HandlerList: IHandlerContainer;
    DefaultHandler: IHandler;
  begin
  {$IFDEF LINUX}
    GIdIconvUseTransliteration := True;
  {$ENDIF}

    Server := TdjServer.Create;
    try
      // add statistics handler
      StatsWrapper := TdjStatisticsHandler.Create;
      Server.AddHandler(StatsWrapper);

      // add a handlerlist with a TdjDefaultHandler
      DefaultHandler := TdjDefaultHandler.Create;
      HandlerList := TdjHandlerList.Create;
      HandlerList.AddHandler(DefaultHandler);
      Server.AddHandler(HandlerList);

      // get a context handler for the 'demo' context
      // the last parameter enables HTTP sessions in this context
      Context := TdjWebAppContext.Create('demo', True);

      // -----------------------------------------------------------------------
      // register the Web Components
      Context.Add(TdjDefaultWebComponent, '/');
      Context.Add(TAjaxPage, '/ajax.html');
      Context.Add(TIndexPage, '/index.html');
      Context.Add(THelloWorldPage, '/hello.html');
      Context.Add(TFormPage, '/form.html');
      Context.Add(TThankYouPage, '/thankyou.html');
      Context.Add(TQRCodePage, '/qr');
      Context.Add(TSourcePage, '/source.html');
      Context.Add(TLoggingPage, '/logging.html');
      Context.Add(TUploadPage, '/upload.html');
      Context.Add(TAjaxStatsPage, '/ajaxstats.html');
      Context.Add(TAjaxStatsJson, '/ajaxstats.json');
      // -----------------------------------------------------------------------

      // add the context
      Server.Add(Context);

      // add NCSA logger handler (at the end to log all handlers) --------------
      LogHandler := TdjNCSALogHandler.Create;
      Server.AddHandler(LogHandler);

      // use a connector on port 8081
      Server.AddConnector('0.0.0.0', 8081);

      try
        // start the server
        Server.Start;

      except
        on E: Exception do
        begin
          WriteLn(E.Message);
        end;
      end;

    {$IFDEF LINUX}
      while True do
        Sleep(MaxInt);
    {$ELSE}
      ReadLn;
    {$ENDIF}

    finally
      Server.Free;
    end;
  end;

  procedure CatchUnhandledException(Obj: TObject; Addr: Pointer;
    FrameCount: longint; Frames: PPointer);
  var
    Message: string;
    i: longint;
    hstdout: ^Text;
  begin
    hstdout := @stdout;
    Writeln(hstdout^, 'An unhandled exception occurred at $',
      HexStr(PtrUInt(Addr), SizeOf(PtrUInt) * 2), ' :');
    if Obj is Exception then
    begin
      Message := Exception(Obj).ClassName + ' : ' + Exception(Obj).Message;
      Writeln(hstdout^, Message);
    end
    else
      Writeln(hstdout^, 'Exception object ', Obj.ClassName, ' is not of class Exception.');
    Writeln(hstdout^, BackTraceStrFunc(Addr));
    if (FrameCount > 0) then
    begin
      for i := 0 to FrameCount - 1 do
        Writeln(hstdout^, '>', BackTraceStrFunc(Frames[i]));
    end;
    Writeln(hstdout^, '');
  end;

begin
  ExceptProc := @CatchUnhandledException;

  Demo;
end.
