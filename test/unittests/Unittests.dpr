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

program Unittests;

{$APPTYPE CONSOLE}

uses
  djServerInterfaces in '..\..\source\djServerInterfaces.pas',
  djAbstractHandler in '..\..\source\djAbstractHandler.pas',
  djWebComponent in '..\..\source\djWebComponent.pas',
  djWebComponentHandler in '..\..\source\djWebComponentHandler.pas',
  djContextHandlerCollection in '..\..\source\djContextHandlerCollection.pas',
  djWebComponentContextHandler in '..\..\source\djWebComponentContextHandler.pas',
  djGenericHolder in '..\..\source\djGenericHolder.pas',
  djWebComponentHolder in '..\..\source\djWebComponentHolder.pas',
  djLifeCycle in '..\..\source\djLifeCycle.pas',
  djGenericWebComponent in '..\..\source\djGenericWebComponent.pas',
  djAbstractConnector in '..\..\source\djAbstractConnector.pas',
  djHTTPServer in '..\..\source\djHTTPServer.pas',
  djContextHandler in '..\..\source\djContextHandler.pas',
  djServer in '..\..\source\djServer.pas',
  djServerBase in '..\..\source\djServerBase.pas',
  djPathMap in '..\..\source\djPathMap.pas',
  djInitParameters in '..\..\source\djInitParameters.pas',
  djAbstractConfig in '..\..\source\djAbstractConfig.pas',
  djContextConfig in '..\..\source\djContextConfig.pas',
  djWebComponentConfig in '..\..\source\djWebComponentConfig.pas',
  djContextMap in '..\..\source\djContextMap.pas',
  djHTTPConnector in '..\..\source\djHTTPConnector.pas',
  djInterfaces in '..\..\source\djInterfaces.pas',
  djServerContext in '..\..\source\djServerContext.pas',
  djWebAppContext in '..\..\source\djWebAppContext.pas',
  djHandlerList in '..\..\source\djHandlerList.pas',
  djWebComponentHolders in '..\..\source\djWebComponentHolders.pas',
  djWebComponentMappings in '..\..\source\djWebComponentMappings.pas',
  djWebComponentMapping in '..\..\source\djWebComponentMapping.pas',
  djPlatform in '..\..\source\djPlatform.pas',
  djGlobal in '..\..\source\djGlobal.pas',
  djHTTPConstants in '..\..\source\djHTTPConstants.pas',
  djHandlerWrapper in '..\..\source\djHandlerWrapper.pas',
  djAbstractHandlerContainer in '..\..\source\djAbstractHandlerContainer.pas',
  djHandlerCollection in '..\..\source\djHandlerCollection.pas',
  djDefaultHandler in '..\..\source\optional\djDefaultHandler.pas',
  djDefaultWebComponent in '..\..\source\optional\djDefaultWebComponent.pas',
  djStacktrace in '..\..\source\optional\djStacktrace.pas',
  djStatisticsHandler in '..\..\source\optional\djStatisticsHandler.pas',
  {$IFDEF DARAJA_LOGGING}
  djLogAPI,
  djLogOverSimpleLogger,
  {$ENDIF}
  djPathMapTests,
  djWebAppContextTests,
  djWebComponentHolderTests,
  djWebComponentHandlerTests,
  djDefaultWebComponentTests,
  djTestConfigAPI in 'djTestConfigAPI.pas',
  TestClient in 'TestClient.pas',
  TestComponents in 'TestComponents.pas',
  UnicodeText in 'UnicodeText.pas',
  TestSessions in 'TestSessions.pas',
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  SysUtils;

begin
  RegisterTests('', [TdjPathMapTests.Suite]);
  RegisterTests('', [TdjWebComponentHolderTests.Suite]);
  RegisterTests('', [TdjWebComponentHandlerTests.Suite]);
  RegisterTests('', [TdjWebAppContextTests.Suite]);
  RegisterTests('', [TdjDefaultWebComponentTests.Suite]);
  
  RegisterTests('', [TSessionTests.Suite]);
  RegisterTests('', [TAPIConfigTests.Suite]);

  if FindCmdLineSwitch('text-mode', ['-', '/'], true) then
    TextTestRunner.RunRegisteredTests(rxbContinue)
  else
  begin
    ReportMemoryLeaksOnShutDown := True;
    TGUITestRunner.RunRegisteredTests;
  end;

end.

