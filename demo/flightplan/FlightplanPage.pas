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

unit FlightplanPage;

// note: this is unsupported example code

interface

uses
  AirportUnit, djWebComponent, djInterfaces,
  IdCustomHTTPServer, IdURI, Generics.Collections, Classes;

type
  TFlightplanPage = class(TdjWebComponent)
  private
    AirportManager: IAirportManager;

    procedure ChooseDestination(Response: TIdHTTPResponseInfo; const ID:
      string);

    function GetDepartures(const ID1: string): string;

    function GetFlightsHtml(const ID1, ID2: string; const ADate: TDateTime): string;

    procedure ChooseDate(var Response: TIdHTTPResponseInfo; const
      ID1: string; const ID2: string);

    procedure ChooseFlight(var Response: TIdHTTPResponseInfo; const
      ID1: string; const ID2: string; Dat: string);

  public
    procedure Init(const Config: IWebComponentConfig); override;

    procedure OnGet(Request: TIdHTTPRequestInfo; Response:
      TIdHTTPResponseInfo); override;

    procedure OnPost(Request: TIdHTTPRequestInfo; Response:
      TIdHTTPResponseInfo); override;
  end;

implementation

uses
  BindingFramework,
  SysUtils;

{ TFlightplanPage }

function TFlightplanPage.GetDepartures(const ID1: string): string;
var
  AirportNames: TStringList;
  I: Integer;
  A: IAirport;
  Name: string;
  Code: string;
  Old: string;
  SL: TStrings;
begin
  AirportNames := TStringlist.Create;
  try
    for A in AirportManager.Airports.Values do
    begin
      AirportNames.Values[A.GetName] := A.GetCode;
    end;
    AirportNames.Sorted := True;

    Old := '';
    SL := TStringList.Create;
    try

      for I := 0 to AirportNames.Count - 1 do
      begin
        Name := AirportNames.Names[I];
        Code := AirportNames.Values[Name];
        // add divider
        if Old <> Name[1] then
        begin
          Old := Name[1];
          SL.Add(Format('<li data-role="list-divider">%s</li>', [Old]));
        end;

        if ID1 <> '' then
        begin
          if ID1 = Code then Continue;

          // add entry with "from" and "to" ids
          SL.Add(Format('<li><a href="?id1=%s&id2=%s">%s</a></li>',
            [ID1, Code, UTF8Encode(Name)]));
        end
        else
        begin
          // add entry
          SL.Add(Format('<li><a href="?id1=%s">%s</a></li>',
            [Code, UTF8Encode(Name)]));
        end;
      end;

      Result := SL.Text;
    finally

      SL.Free;
    end;
  finally
    AirportNames.Free;
  end;
end;

function TFlightplanPage.GetFlightsHtml(const ID1, ID2: string;
  const ADate: TDateTime): string;
var
  SL: TStrings;
  I: Integer;
  S: string;
begin
  SL := TStringList.Create;
  try
    for I := 9 to 17 do
    begin
      S := DateTimeToStr(ADate + EncodeTime(I, 0, 0, 0));
      SL.Add(Format('<li>%s</li>', [S]));
    end;
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

procedure TFlightplanPage.Init(const Config: IWebComponentConfig);
begin
  inherited;

  AirportManager := TAirportManager.Create;
end;

procedure TFlightplanPage.OnGet(Request: TIdHTTPRequestInfo;
  Response: TIdHTTPResponseInfo);
var
  ID1, ID2, Dat: string;
  Tmp: string;
begin
  ID1 := Request.Params.Values['id1'];
  ID2 := Request.Params.Values['id2'];
  Dat := Request.Params.Values['dat'];

  if (ID1 <> '') and (ID2 <> '') and (Dat <> '') then
  begin
    ChooseFlight(Response, ID1, ID2, Dat);
  end else if (ID1 <> '') and (ID2 <> '') then
  begin
    ChooseDate(Response, ID1, ID2);
  end
  else if ID1 <> '' then
  begin
    ChooseDestination(Response, ID1);
  end
  else
  begin
    Tmp := Bind('index.html');
    Tmp := StringReplace(Tmp, '#{airports}', GetDepartures(''), []);
    Response.ContentText := Tmp;
  end;
end;

procedure TFlightplanPage.OnPost(Request: TIdHTTPRequestInfo;
  Response: TIdHTTPResponseInfo);
var
  Month, Day, Year: string;
  ID1, ID2: string;
  D: TDateTime;
  Target: string;
begin
  Month := Request.Params.Values['select-choice-month'];
  Day := Request.Params.Values['select-choice-day'];
  Year := Request.Params.Values['select-choice-year'];

  D := EncodeDate(StrToInt(Year), StrToInt(Month), StrToInt(Day));

  ID1 := Request.Params.Values['id1'];
  ID2 := Request.Params.Values['id2'];

  Target := Format('?id1=%s&id2=%s&dat=%d', [ID1, ID2, Trunc(D)]);

  Response.Redirect(Target);
end;

procedure TFlightplanPage.ChooseFlight(var Response: TIdHTTPResponseInfo; const
      ID1: string; const ID2: string; Dat: string);
var
  Tmp: string;
  Name1: string;
  Name2: string;
  SelectedDate: TDateTime;
begin
  Name1 := AirportManager.Airports.Items[ID1].GetName + ' (' + ID1 + ')';
  Name2 := AirportManager.Airports.Items[ID2].GetName + ' (' + ID2 + ')';

  SelectedDate := FloatToDateTime(StrToFloat(Dat));

  Tmp := Bind('flight.html');
  Tmp := StringReplace(Tmp, '#{id1}', ID1, [rfReplaceAll]);
  Tmp := StringReplace(Tmp, '#{id2}', ID2, [rfReplaceAll]);
  Tmp := StringReplace(Tmp, '#{selectedDate}', DateToStr(SelectedDate), [rfReplaceAll]);
  Tmp := StringReplace(Tmp, '#{airport1}', Name1, [rfReplaceAll]);
  Tmp := StringReplace(Tmp, '#{airport2}', Name2, [rfReplaceAll]);
  Tmp := StringReplace(Tmp, '#{flights}', GetFlightsHtml(ID1, ID2, SelectedDate), []);
  Response.ContentText := Tmp;
end;

procedure TFlightplanPage.ChooseDestination(Response: TIdHTTPResponseInfo; const
  ID: string);
var
  Tmp: string;
  Name1: string;
begin
  Name1 := AirportManager.Airports.Items[ID].GetName + ' (' + ID + ')';

  Tmp := Bind('departure.html');
  Tmp := StringReplace(Tmp, '#{airport1}', Name1, [rfReplaceAll]);
  Tmp := StringReplace(Tmp, '#{airports}', GetDepartures(ID), []);
  Response.ContentText := Tmp;
end;

procedure TFlightplanPage.ChooseDate(var Response: TIdHTTPResponseInfo; const
  ID1: string; const ID2: string);
var
  Tmp: string;
  Name1: string;
  Name2: string;
begin
  Name1 := AirportManager.Airports.Items[ID1].GetName + ' (' + ID1 + ')';
  Name2 := AirportManager.Airports.Items[ID2].GetName + ' (' + ID2 + ')';

  Tmp := Bind('dates.html');
  Tmp := StringReplace(Tmp, '#{id1}', ID1, [rfReplaceAll]);
  Tmp := StringReplace(Tmp, '#{airport1}', Name1, [rfReplaceAll]);
  Tmp := StringReplace(Tmp, '#{airport2}', Name2, [rfReplaceAll]);

  Response.ContentText := Tmp;
end;

end.

