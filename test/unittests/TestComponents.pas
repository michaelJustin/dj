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

unit TestComponents;

interface

uses
  djInterfaces, djWebComponent, djAbstractHandler, djServerContext, djTypes,
  IdCustomHTTPServer,
  Dialogs, SysUtils, Classes;

type

  // based on TdjAbstractHandler ---------------------------------------------

  THelloHandler = class(TdjAbstractHandler)
  public
    procedure Handle(Target: string; Context: TdjServerContext;
      Request: TdjRequest; Response: TdjResponse); override;
  end;


  // based on TdjWebComponent ------------------------------------------------

  TExamplePage = class(TdjWebComponent)
  public
    procedure OnGet(Request: TdjRequest; Response: TdjResponse);
      override;
  end;

  THello2WebComponent = class(TdjWebComponent)
  public
    procedure Service(Context: TdjServerContext; Request: TdjRequest; Response: TdjResponse); override;
  end;

  TExceptionInInitComponent = class(TdjWebComponent)
  public
    procedure Init(const Config: IWebComponentConfig); override;
  end;

  TExceptionComponent = class(TdjWebComponent)
  public
    procedure Service(Context: TdjServerContext; Request: TdjRequest; Response: TdjResponse); override;
  end;

  TGetComponent = class(TdjWebComponent)
  public
    procedure OnGet(Request: TdjRequest; Response: TdjResponse);
      override;
  end;

  TNoMethodComponent = class(TdjWebComponent)
  end;

  TNoOpComponent = class(TdjWebComponent)
  public
    procedure OnGet(Request: TdjRequest; Response: TdjResponse);
      override;
  end;

  TPostComponent = class(TdjWebComponent)
  public
    procedure OnPost(Request: TdjRequest; Response: TdjResponse);
      override;
  end;

  TLogComponent = class(TdjWebComponent)
  public
    procedure OnGet(Request: TdjRequest; Response: TdjResponse);
      override;
  end;

implementation

type
  EUnitTestException = class(Exception);

{ TExamplePage }

procedure TExamplePage.OnGet(Request: TdjRequest; Response: TdjResponse);
begin
  Response.ContentText := 'example';
end;

{ THello2WebComponent }

procedure THello2WebComponent.Service(Context: TdjServerContext;
  Request: TdjRequest; Response: TdjResponse);
begin
  Response.ContentText := 'Hello universe!';
end;

{ TExceptionComponent }

procedure TExceptionComponent.Service(Context: TdjServerContext;
  Request: TdjRequest; Response: TdjResponse);
begin
  raise EUnitTestException.Create('test');
end;

{ TGetComponent }

procedure TGetComponent.OnGet(Request: TdjRequest; Response: TdjResponse);
begin
  Response.ContentText := 'Hello';
end;

{ THelloHandler }

procedure THelloHandler.Handle(Target: string; Context: TdjServerContext;
  Request: TdjRequest; Response: TdjResponse);
begin
  Response.ContentText := 'Hello world!';
  Response.ResponseNo := 200;
end;

{ TNoOpComponent }

procedure TNoOpComponent.OnGet(Request: TdjRequest; Response: TdjResponse);
begin
  WriteLn('>>>> ' + GetWebComponentConfig.GetInitParameter('a'));
end;

{ TLogComponent }

procedure TLogComponent.OnGet(Request: TdjRequest; Response: TdjResponse);
var
  Value: string;
begin
  Config.GetContext.Log('This is a log message sent from TLogComponent.OnGet ...');

  Value := Config.GetContext.GetInitParameter('key');

  Config.GetContext.Log('Value=' + Value);

  Response.ContentText := 'TLogComponent';
end;

{ TPostComponent }

procedure TPostComponent.OnPost(Request: TdjRequest; Response: TdjResponse);
begin
  Response.ContentText := 'posted.this';
end;

{ TExceptionInInitComponent }

procedure TExceptionInInitComponent.Init(const Config: IWebComponentConfig);
begin
  inherited;

  raise EUnitTestException.Create('error');
end;

end.
