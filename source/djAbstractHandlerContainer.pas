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

unit djAbstractHandlerContainer;

interface

{$i IdCompilerDefines.inc}

uses
  djAbstractHandler,
  djInterfaces;

type
  (**
   * This is the base class for handlers that may contain other handlers.
   *)
  TdjAbstractHandlerContainer = class(TdjAbstractHandler, IHandlerContainer)

  protected
    (**
     * Add a handler.
     * \param Handler the handler to be added.
     *)
    procedure AddHandler(const Handler: IHandler); virtual; abstract;

    (**
     * Remove a handler.
     * \param Handler the handler to be removed.
     *)
    procedure RemoveHandler(const Handler: IHandler); virtual; abstract;

  end;

implementation

{ TdjAbstractHandlerContainer }

end.
