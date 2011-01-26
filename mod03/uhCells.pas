{-----------------------------------------------------------------------------
 Unit Name: uhCells
 Author:    n0mad
 Version:   1.1.7.83
 Creation:  28.08.2003
 Purpose:   Cells creation
 History:
-----------------------------------------------------------------------------}
unit uhCells;

interface

uses
  Classes, Extctrls, Menus, ShpCtrl2;

type
  PEventStoreRec = ^TEventStoreRec;
  TEventStoreRec = record
    fTicketPopupMenu: TPopupMenu;
    fTicketLeftClick: TNotifyEvent;
    fSeatExSelect: TSeatExSelectEvent;
    fSeatExCmd: TSeatExCmdEvent;
    fGetTicketProps: TGetTicketPropsEvent;
  end;

procedure CreateCell(Zal_Num: integer; Panel: TOdeumPanel; EventStore:
  TEventStoreRec; var _ControlEx: TSeatEx; Multiplr: real;
  n_Row, n_Column: Byte; n_Left, n_Top, n_Width, n_Height, n_Type: integer);
procedure CreateSimpleCell(Zal_Num: integer; Panel: TOdeumPanel; var _Shape: TShape;
  Multiplr: real; n_Row, n_Column: Byte; n_Left, n_Top, n_Width, n_Height,
  n_State: integer);

implementation

uses
  SysUtils, urLoader, strConsts;

const
  UnitName: string = 'uhCells';

procedure CreateCell(Zal_Num: integer; Panel: TOdeumPanel; EventStore:
  TEventStoreRec; var _ControlEx: TSeatEx; Multiplr: real;
  n_Row, n_Column: Byte; n_Left, n_Top, n_Width, n_Height, n_Type: integer);
const
  ProcName: string = 'CreateCell';
begin
  _ControlEx := TSeatEx.Create(Panel);
  _ControlEx.Name := Panel.Name + '_TC_Z' + IntToStr(Zal_Num) + '_R' +
    IntToStr(n_Row) + '_C' + IntToStr(n_Column);
  _ControlEx.Parent := Panel;
  _ControlEx.SeatColumn := n_Column;
  _ControlEx.SeatRow := n_Row;
  _ControlEx.Left := round(n_Left * Multiplr) + round(MarginHorzLeft * Multiplr);
  _ControlEx.Top := round(n_Top * Multiplr) + round(MarginVertTop * Multiplr);
  _ControlEx.Width := round(n_Width * Multiplr);
  _ControlEx.Height := round(n_Height * Multiplr);
  if n_Type = 0 then
    _ControlEx.SeatState := tsFree
  else
    _ControlEx.SeatState := tsBroken;
  _ControlEx.ShowHint := True;
  _ControlEx.PopupMenu := EventStore.fTicketPopupMenu;
  _ControlEx.OnClick := EventStore.fTicketLeftClick;
  _ControlEx.OnSeatExSelect := EventStore.fSeatExSelect;
  _ControlEx.OnSeatExCmd := EventStore.fSeatExCmd;
  _ControlEx.OnGetTicketProps := EventStore.fGetTicketProps;
  _ControlEx.ShowHint := false;
  _ControlEx.ParentShowHint := true;
end;

procedure CreateSimpleCell(Zal_Num: integer; Panel: TOdeumPanel; var _Shape: TShape;
  Multiplr: real; n_Row, n_Column: Byte; n_Left, n_Top, n_Width, n_Height,
  n_State: integer);
const
  ProcName: string = 'CreateSimpleCell';
begin
  _Shape := TShape.Create(Panel);
  _Shape.Name := Panel.Name + '_Sh_Z' + IntToStr(Zal_Num) + '_R' +
    IntToStr(n_Row) + '_C' + IntToStr(n_Column);
  _Shape.Parent := Panel;
  _Shape.Left := round(n_Left * Multiplr) + round(MarginHorzLeft * Multiplr);
  _Shape.Top := round(n_Top * Multiplr) + round(MarginVertTop * Multiplr);
  _Shape.Width := round(n_Width * Multiplr);
  _Shape.Height := round(n_Height * Multiplr);
  _Shape.Tag := n_State;
end;

end.

