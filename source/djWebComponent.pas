(*

    Daraja Framework
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

unit djWebComponent;

interface

{$i IdCompilerDefines.inc}

uses
  djGenericWebComponent, djServerContext,
{$IFDEF DARAJA_LOGGING}
  djLogAPI, djLoggerFactory,
{$ENDIF DARAJA_LOGGING}
  djTypes;

type
  (**
   * A base class which can be subclassed to create a HTTP component
   * for a Web site.
   *
   * A subclass of TdjWebComponent must override at least one method, usually one of these:
   * \li OnGet, if the web component supports HTTP GET requests
   * \li OnPost, for HTTP POST requests
   * \li OnPut, for HTTP PUT requests
   * \li OnDelete, for HTTP DELETE requests
   *)
  TdjWebComponent = class(TdjGenericWebComponent)
  private
{$IFDEF DARAJA_LOGGING}
    Logger: ILogger;
{$ENDIF DARAJA_LOGGING}

  protected
    (**
     * Called by the server (via the service method) to allow a component to handle a DELETE request.
     *)
    procedure OnDelete(Request: TdjRequest; Response: TdjResponse); virtual;

    (**
     * Called by the server (via the service method) to allow a component to handle a GET request.
     *)
    procedure OnGet(Request: TdjRequest; Response: TdjResponse); virtual;

    (**
     * Called by the server (via the service method) to allow a component to handle a HEAD request.
     *)
    procedure OnHead(Request: TdjRequest; Response: TdjResponse); virtual;

    (**
     * Called by the server (via the service method) to allow a component to handle a OPTIONS request.
     *)
    procedure OnOptions(Request: TdjRequest; Response: TdjResponse); virtual;

    (**
     * Called by the server (via the service method) to allow a component to handle a POST request.
     *)
    procedure OnPost(Request: TdjRequest; Response: TdjResponse); virtual;

    (**
     * Called by the server (via the service method) to allow a component to handle a PUT request.
     *)
    procedure OnPut(Request: TdjRequest; Response: TdjResponse); virtual;

    (**
     * Called by the server (via the service method) to allow a component to handle a TRACE request.
     *)
    procedure OnTrace(Request: TdjRequest; Response: TdjResponse); virtual;

    (**
     * Called by the server (via the service method) to allow a component to handle a PATCH request.
     * \sa http://tools.ietf.org/html/rfc5789
     *)
    procedure OnPatch(Request: TdjRequest; Response: TdjResponse); virtual;

  public
    constructor Create;

    destructor Destroy; override;

    (**
     * Dispatches client requests to the protected service method.
     *
     * \note a custom Web Component should not override this method.
     *
     * \param Context HTTP server context
     * \param Request HTTP request
     * \param Response HTTP response
     * \throws EWebComponentException if an exception occurs that interferes with the component's normal operation
     *)
    procedure Service(Context: TdjServerContext; Request: TdjRequest; Response:
      TdjResponse); override;

  end;

  (**
   * Class reference to TdjWebComponent
   *)
  TdjWebComponentClass = class of TdjWebComponent;

implementation

uses
  IdCustomHTTPServer;

const
  HTTP_ERROR_METHOD_NOT_ALLOWED = 405;

{ TdjWebComponent }

constructor TdjWebComponent.Create;
begin
  inherited;

  // logging -----------------------------------------------------------------
{$IFDEF DARAJA_LOGGING}
  Logger := TdjLoggerFactory.GetLogger('dj.' + TdjWebComponent.ClassName);
{$ENDIF DARAJA_LOGGING}

{$IFDEF LOG_CREATE}Trace('Created');{$ENDIF}
end;

destructor TdjWebComponent.Destroy;
begin
{$IFDEF LOG_DESTROY}Trace('Destroy');{$ENDIF}

  inherited;
end;

procedure TdjWebComponent.OnDelete(Request: TdjRequest; Response: TdjResponse);
begin
  Response.ResponseNo := HTTP_ERROR_METHOD_NOT_ALLOWED;
end;

procedure TdjWebComponent.OnGet(Request: TdjRequest; Response: TdjResponse);
begin
  Response.ResponseNo := HTTP_ERROR_METHOD_NOT_ALLOWED;
end;

procedure TdjWebComponent.OnHead(Request: TdjRequest; Response: TdjResponse);
begin
  Response.ResponseNo := HTTP_ERROR_METHOD_NOT_ALLOWED;
end;

procedure TdjWebComponent.OnOptions(Request: TdjRequest; Response: TdjResponse);
begin
  Response.ResponseNo := HTTP_ERROR_METHOD_NOT_ALLOWED;
end;

procedure TdjWebComponent.OnPost(Request: TdjRequest; Response: TdjResponse);
begin
  Response.ResponseNo := HTTP_ERROR_METHOD_NOT_ALLOWED;
end;

procedure TdjWebComponent.OnPut(Request: TdjRequest; Response: TdjResponse);
begin
  Response.ResponseNo := HTTP_ERROR_METHOD_NOT_ALLOWED;
end;

procedure TdjWebComponent.OnTrace(Request: TdjRequest; Response: TdjResponse);
begin
  Response.ResponseNo := HTTP_ERROR_METHOD_NOT_ALLOWED;
end;

procedure TdjWebComponent.OnPatch(Request: TdjRequest; Response: TdjResponse);
begin
  Response.ResponseNo := HTTP_ERROR_METHOD_NOT_ALLOWED;
end;

procedure TdjWebComponent.Service(Context: TdjServerContext;
  Request: TdjRequest; Response: TdjResponse);
begin
  case Request.CommandType of
    hcHEAD:
      begin
        OnHead(Request, Response);
      end;
    hcGET:
      begin
        OnGet(Request, Response);
      end;
    hcPOST:
      begin
        OnPost(Request, Response);
      end;
    hcDELETE:
      begin
        OnDelete(Request, Response);
      end;
    hcPUT:
      begin
        OnPut(Request, Response);
      end;
    hcTRACE:
      begin
        OnTrace(Request, Response);
      end;
    hcOPTION:
      begin
        OnOptions(Request, Response);
      end;
  else
    begin
      if Request.Command = 'PATCH' then
      begin
        OnPatch(Request, Response);
      end
      else
      begin
{$IFDEF DARAJA_LOGGING}
        Logger.Error('Unknown HTTP method');
{$ENDIF DARAJA_LOGGING}
      end;
    end;
  end;
end;

end.

