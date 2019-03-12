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

unit AjaxStatsCmp;

// note: this is unsupported example code

interface

uses
  djWebComponent, djStatisticsHandler, djTypes;

var
  StatsWrapper: TdjStatisticsHandler;

type
  TAjaxStatsJson = class(TdjWebComponent)
  public
    procedure OnGet(Request: TdjRequest; Response: TdjResponse); override;
  end;

implementation

uses
  SysUtils;

function AddJson(const AKey: string; const AValue: int64): string;
begin
  Result := Format('"%s":"%d"', [AKey, AValue]);
end;

{ TAjaxStatsJson }

procedure TAjaxStatsJson.OnGet;
begin
  Sleep(2000); // limit refresh rate

  Response.ContentText := '{' + AddJson('requests', StatsWrapper.Requests) +
    ',' + AddJson('active', StatsWrapper.RequestsActive) + ',' +
    AddJson('responses1xx', StatsWrapper.Responses1xx) + ',' +
    AddJson('responses2xx', StatsWrapper.Responses2xx) + ',' +
    AddJson('responses3xx', StatsWrapper.Responses3xx) + ',' +
    AddJson('responses4xx', StatsWrapper.Responses4xx) + ',' +
    AddJson('responses5xx', StatsWrapper.Responses5xx) + '}';

  Response.ContentType := 'application/json';
  Response.CharSet := 'utf-8';
end;

end.


