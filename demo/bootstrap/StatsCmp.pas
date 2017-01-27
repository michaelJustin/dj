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

unit StatsCmp;

// note: this is unsupported example code

interface

{$i IdCompilerDefines.inc}

uses
  djWebComponent, djStatisticsHandler, djTypes;

var
  StatsWrapper: TdjStatisticsHandler;

type
  TStatsPage = class(TdjWebComponent)
  public
    procedure OnGet(Request: TdjRequest; Response: TdjResponse); override;
  end;

implementation

uses
  BindingFramework,
  SysUtils;

{ TStatsPage }

procedure TStatsPage.OnGet(Request: TdjRequest;
  Response: TdjResponse);
var
  Tmp: string;
begin
  Tmp := Bind(Config.GetContext.GetContextPath, 'stats.html');
  Tmp := StringReplace(Tmp, '#{requests}',
    IntToStr(StatsWrapper.Requests), []);

  Tmp := StringReplace(Tmp, '#{requestsactive}',
    IntToStr(StatsWrapper.RequestsActive), []);

  Tmp := StringReplace(Tmp, '#{responses1xx}',
    IntToStr(StatsWrapper.Responses1xx), []);

  Tmp := StringReplace(Tmp, '#{responses2xx}',
    IntToStr(StatsWrapper.Responses2xx), []);

  Tmp := StringReplace(Tmp, '#{responses3xx}',
    IntToStr(StatsWrapper.Responses3xx), []);

  Tmp := StringReplace(Tmp, '#{responses4xx}',
    IntToStr(StatsWrapper.Responses4xx), []);

  Tmp := StringReplace(Tmp, '#{responses5xx}',
    IntToStr(StatsWrapper.Responses5xx), []);

  Response.ContentText := Tmp;
  Response.ContentType := 'text/html';
  Response.CharSet := 'utf-8';
end;

end.
