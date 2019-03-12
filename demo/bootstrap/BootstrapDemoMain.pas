(*

    Daraja HTTP Framework
    Copyright (C) Michael Justin

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

// note: this is unsupported example code

unit BootstrapDemoMain;

interface

procedure Demo;

implementation

uses
  {$IFDEF DARAJA_LOGGING}
  djLogAPI,
  djLogOverSimpleLogger,
  SimpleLogger,
  {$ENDIF DARAJA_LOGGING}
  AjaxStatsCmp,
  djDefaultHandler,
  djDefaultWebComponent,
  djHandlerList,
  djInterfaces,
  djNCSALogHandler,
  djServer,
  djStatisticsHandler,
  djWebAppContext,
  FileUploadCmp,
  FormCmp,
  IdGlobal,
  IndexCmp,
  ShellAPI,
  ShutdownHelper,
  SourceCmp,
  ThankYouCmp;

procedure ConfigureLogging;
begin
  {$IFDEF DARAJA_LOGGING}
  SimpleLogger.Configure('defaultLogLevel', 'info');
  SimpleLogger.Configure('showDateTime', 'true');
  {$ENDIF DARAJA_LOGGING}
end;

procedure Demo;
var
  Server: TdjServer;
  HandlerList: IHandlerContainer;
  DefaultHandler: IHandler;
  LogHandler: IHandler;
  Context: TdjWebAppContext;
begin
  ConfigureLogging;

  Server := TdjServer.Create(8080);
  try
    // add statistics handler
    StatsWrapper := TdjStatisticsHandler.Create;
    Server.AddHandler(StatsWrapper);

    // add a handlerlist with a TdjDefaultHandler
    DefaultHandler := TdjDefaultHandler.Create;
    HandlerList := TdjHandlerList.Create;
    HandlerList.AddHandler(DefaultHandler);
    Server.AddHandler(HandlerList);

    // get a context handler for the root context, with session support
    Context := TdjWebAppContext.Create('demo', True);

    // -----------------------------------------------------------------------
    // register the Web Components
    Context.Add(TdjDefaultWebComponent, '/'); // for static contant
    Context.Add(TIndexPage, '/index.html'); // home page
    Context.Add(TFormPage, '/form.html');  // form demo
    Context.Add(TThankYouPage, '/thankyou.html'); // form demo
    Context.Add(TUploadPage, '/upload.html'); // file upload demo
    Context.Add(TAjaxStatsJson, '/ajaxstats.json'); // live statistics demo
    Context.Add(TSourcePage, '/source.html'); // view source
    // -----------------------------------------------------------------------

    // add the "demo" context
    Server.Add(Context);

    // add NCSA logger handler (at the end to log all handlers) --------------
    LogHandler := TdjNCSALogHandler.Create;
    Server.AddHandler(LogHandler);

    // allow Ctrl+C
    SetShutdownHook(Server);

    // start the server
    Server.Start;

    // launch browser
    ShellExecute(0, 'open', PChar('http://127.0.0.1:8080/demo/index.html'), '',
      '', 0);

    // terminate
    WriteLn('Hit any key to terminate.');
    ReadLn;

  finally
    Server.Free;
  end;
end;

end.
