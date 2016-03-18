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

unit AirportUnit;

// note: this is unsupported example code

interface

uses
  Generics.Collections, Classes;

type
 IAirport = interface
    ['{10DA08A8-823E-49C2-83C8-E7B142FCF1C5}']
    function GetCode: string;
    function GetName: string;
  end;

  TAirport = class(TInterfacedObject, IAirport)
  private
    FName: string;
    FCode: string;
  public
    constructor Create(const ACode: string; const AName: string);

    function GetCode: string;
    function GetName: string;
  end;

  TAirports = class(TDictionary<string, IAirport>)
  public
    procedure Add(const Airport: IAirport);
  end;

  IAirportManager = interface
  ['{4B5CC7A7-DE9F-4C4D-96DB-A84B0E7145D6}']
    function Airports: TAirports;
  end;

  TAirportManager = class(TInterfacedObject, IAirportManager)
    FAirports: TAirports;
  public
    constructor Create;
    destructor Destroy; override;

    function Airports: TAirports;
  end;

implementation

{ TAirport }

constructor TAirport.Create(const ACode, AName: string);
begin
  inherited Create;

  FCode := ACode;
  FName := AName;
end;

function TAirport.GetCode: string;
begin
  Result := FCode;
end;

function TAirport.GetName: string;
begin
  Result := FName;
end;

{ TAirports }

procedure TAirports.Add(const Airport: IAirport);
begin
  AddOrSetValue(Airport.GetCode, Airport);
end;

{ TAirportManager }

constructor TAirportManager.Create;
begin
  inherited;

  FAirports := TAirports.Create;

  Airports.Add(TAirport.Create('AAL', 'Aalborg'));
  Airports.Add(TAirport.Create('AGB', 'Augsburg'));
  Airports.Add(TAirport.Create('BER', 'Brandenburg'));
  Airports.Add(TAirport.Create('BFD', 'Bielefeld'));
  Airports.Add(TAirport.Create('CBU', 'Cottbus-Drewitz'));
  Airports.Add(TAirport.Create('CGN', 'K�ln/Bonn'));
  Airports.Add(TAirport.Create('AAL', 'Aalborg'));
  Airports.Add(TAirport.Create('AAT', 'Alturas'));
  Airports.Add(TAirport.Create('BAH', 'Bahrain'));
  Airports.Add(TAirport.Create('BBC', 'Bay City'));
  Airports.Add(TAirport.Create('CAI', 'Cairo'));
  Airports.Add(TAirport.Create('CBG', 'Cambridge'));
end;

destructor TAirportManager.Destroy;
begin
  FAirports.Free;

  inherited;
end;

function TAirportManager.Airports: TAirports;
begin
  Result := FAirports;
end;

end.
