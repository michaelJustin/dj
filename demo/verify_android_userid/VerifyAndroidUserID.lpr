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
    develop commercial activities involving the Daraja framework without
    disclosing the source code of your own applications. These activities
    include: offering paid services to customers as an ASP, shipping Daraja
    with a closed source product.
    
*)

program VerifyAndroidUserID;

// note: this is unsupported example code

{$i IdCompilerDefines.inc}

uses
{$IFDEF LINUX}
  cthreads,
{$ENDIF}
  djServer,
  djWebAppContext,
  djDefaultWebComponent,
  djInterfaces,
  {$IFDEF DARAJA_LOGGING}
  djLogAPI, djLogOverSimpleLogger,
  {$ENDIF}
  FormCmp in 'FormCmp.pas',
  ThankYouCmp in 'ThankYouCmp.pas',
  IdGlobal,
  SysUtils, ShellAPI;

  procedure Demo;
  var
    Server: TdjServer;
    Context: TdjWebAppContext;
  begin
    Server := TdjServer.Create;
    try
      // get a context handler for the 'demo' context
      Context := TdjWebAppContext.Create('demo', True);

      // -----------------------------------------------------------------------
      // register the Web Components
      Context.Add(TdjDefaultWebComponent, '/');
      Context.Add(TFormPage, '/form.html');
      Context.Add(TThankYouPage, '/thankyou.html');
      // -----------------------------------------------------------------------

      // add the context
      Server.Add(Context);

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

      ShellExecute(0, nil, 'http://localhost:8081/demo/form.html',nil,nil,1);

      ReadLn;

    finally
      Server.Free;
    end;
  end;

begin
  Demo;
end.
