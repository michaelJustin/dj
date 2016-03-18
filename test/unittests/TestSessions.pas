(*
    Daraja Framework
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
    develop commercial activities involving the Daraja framework without
    disclosing the source code of your own applications. These activities
    include: offering paid services to customers as an ASP, shipping Daraja 
    with a closed source product.

*)

unit TestSessions;

interface

uses
  {$IFDEF FPC}fpcunit,testregistry{$ELSE}TestFramework{$ENDIF};

type
  TSessionTests = class(TTestCase)
  published
    procedure TestCreateSession;

    // with web context -------------------------------------------------------
    procedure TestAutoCreateHandlerFirst;

    procedure TestAutoCreateContextFirst;

    // no web context ---------------------------------------------------------
    procedure TestAutoCreateNoContextHandlerFirst;

    // procedure TestAutoCreateNoContextConnectorFirst;

    // check POST has session -------------------------------------------------
    procedure TestPostHasSession;

  end;

implementation

uses
  TestClient,
  djWebAppContext, djServerContext, djInterfaces, djWebComponent, djServer,
  djHandlerWrapper, djHTTPConnector,
  IdCustomHTTPServer, IdHTTP,
  Dialogs, SysUtils, Classes;

type
  TExamplePage = class(TdjWebComponent)
  public
    procedure OnGet(Request: TIdHTTPRequestInfo; Response:
      TIdHTTPResponseInfo); override;
  end;

  TSessionDetector = class(TdjHandlerWrapper)
  public
    procedure Handle(Target: string; Context: TdjServerContext; Request:
      TIdHTTPRequestInfo; Response: TIdHTTPResponseInfo); override;
  end;

  TSessionComponent = class(TdjWebComponent)
  public
    procedure Service(Context: TdjServerContext; Request: TIdHTTPRequestInfo; Response:
      TIdHTTPResponseInfo); override;
  end;

  TSessionPOSTComponent = class(TdjWebComponent)
  public
    procedure OnPost(Request: TIdHTTPRequestInfo; Response:
      TIdHTTPResponseInfo); override;
  end;

// helper functions ----------------------------------------------------------

function Get(Document: string; Host: string = 'http://127.0.0.1'): string;
begin
  Result := TdjHTTPClient.Get(Document, Host);
end;


{ TExamplePage }

procedure TExamplePage.OnGet(Request: TIdHTTPRequestInfo;
  Response: TIdHTTPResponseInfo);
begin
  Response.ContentText := 'example';
end;

{ TSessionDetector }

procedure TSessionDetector.Handle(Target: string; Context: TdjServerContext;
  Request: TIdHTTPRequestInfo; Response: TIdHTTPResponseInfo);
begin
  inherited; // required to get a session (in "with context" mode)

  if Assigned(Request.Session) then
  begin
    Response.ContentText := 'success';
  end else
  begin
    Response.ContentText := 'no session';
  end;

  Response.ResponseNo := 200;
end;

{ TSessionTests }

 procedure TSessionTests.TestAutoCreateHandlerFirst;
var
  Server: TdjServer;
  Handler: IHandler;
  Context: TdjWebAppContext;
begin
  Server := TdjServer.Create;
  try
    // Handler
    Handler := TSessionDetector.Create;
    Server.AddHandler(Handler);

    // create component and register it
    Context := TdjWebAppContext.Create('session', True);
    Context.Add(TExamplePage, '/example');
    Server.Add(Context);

    Server.Start;

    CheckEquals('success', Get('/session/example'));

  finally
    Server.Free;
  end;
end;

procedure TSessionTests.TestAutoCreateContextFirst;
var
  Server: TdjServer;
  Handler: IHandler;
  Context: TdjWebAppContext;
begin
  Server := TdjServer.Create;
  try
    // create component and register it
    Context := TdjWebAppContext.Create('session', True);
    Context.Add(TExamplePage, '/example');
    Server.Add(Context);

    // Handler
    Handler := TSessionDetector.Create;
    Server.AddHandler(Handler);

    Server.Start;

    CheckEquals('success', Get('/session/example'));

  finally
    Server.Free;
  end;
end;

procedure TSessionTests.TestAutoCreateNoContextHandlerFirst;
var
  Server: TdjServer;
  Connector: TdjHTTPConnector;
begin
  Server := TdjServer.Create;
  try
    // add test handler first!
    // TODO support AutoStartSession when Handler is added after connector
    Server.AddHandler(TSessionDetector.Create);

    // add a configured connector TODO DOC not (Server)!
    Connector := TdjHTTPConnector.Create(Server.Handler);
    Connector.Host := '127.0.0.1';
    Connector.Port := 80;
    Connector.HTTPServer.AutoStartSession := True;
    Server.AddConnector(Connector);

    Server.Start;

    CheckEquals('success', Get('/test'));

  finally
    Server.Free;
  end;
end;

(*
procedure TSessionTests.TestAutoCreateNoContextConnectorFirst;
var
  Server: TdjServer;
  Connector: TdjHTTPConnector;
begin
  Server := TdjServer.Create;

  try
    // add a configured connector TODO DOC not (Server)!
    Connector := TdjHTTPConnector.Create(Server.Handler);
    Connector.Host := '127.0.0.1';
    Connector.Port := 80;
    Connector.HTTPServer.AutoStartSession := True;
    Server.AddConnector(Connector);

    // add test handler
    // TODO support AutoStartSession when Handler is added after connector
    Server.AddHandler(TSessionDetector.Create);

    Server.Start;

    CheckEquals('success', Get('/test'));

  finally
    Server.Free;
  end;

end;
*)

procedure TSessionTests.TestCreateSession;
var
  Server: TdjServer;
  Context: TdjWebAppContext;
begin
  Server := TdjServer.Create;
  try
    // create component and register it
    Context := TdjWebAppContext.Create('get');
    Context.Add(TSessionComponent, '/hello');

    Server.Add(Context);
    Server.Start;

    Get('/get/hello')

  finally
    Server.Free;
  end;
end;

procedure TSessionTests.TestPostHasSession;
var
  Server: TdjServer;
  Context: TdjWebAppContext;
  Client: TIdHTTP;
  SL: TStrings;
begin
  Server := TdjServer.Create;
  try
    // create component and register it
    Context := TdjWebAppContext.Create('post', True);
    Context.Add(TSessionPOSTComponent, '/hello');

    Server.Add(Context);
    Server.Start;

    Client := TIdHTTP.Create;
    try
      SL := TStringList.Create;
      try
        CheckEquals('success', Client.Post('http://127.0.0.1/post/hello', SL ));
      finally
        SL.Free;
      end;
    finally
      Client.Free;
    end;
  finally
    Server.Free;
  end;
end;

{ TSessionComponent }

procedure TSessionComponent.Service(Context: TdjServerContext;
  Request: TIdHTTPRequestInfo; Response: TIdHTTPResponseInfo);
begin
  Assert(not Assigned(Request.Session));

  GetSession(Context, Request, Response);

  Assert(Assigned(Request.Session));

  Config.GetContext.Log('SessionID: ' + Request.Session.SessionID);
end;

{ TSessionPOSTComponent }

procedure TSessionPOSTComponent.OnPost(Request: TIdHTTPRequestInfo;
  Response: TIdHTTPResponseInfo);
begin
  if Assigned(Request.Session) then
  begin
    Response.ContentText := 'success';
  end else
  begin
    Response.ContentText := 'no session';
  end;

  Response.ResponseNo := 200;
end;

end.
