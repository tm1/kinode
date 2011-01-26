unit uhBase;

interface

{$I kinode01.inc}

uses
  Classes, Extctrls, Forms, Menus, Controls, Graphics, Gauges, ShpCtrl2;

{
type
  TOperAction = (oaUnknown, oaReserve, oaSale, oaActualize, oaModify, oaFree, oaRestore, oaSelect,
    oaCancel);

const
  c_OperActionPfx: array[TOperAction] of Char =
  ('-', 'R', 'P', 'A', 'M', 'J', 'F', 'S', 'C');

  c_OperActionDesc: array[TOperAction] of string =
  ('Неопределено (Unknown) [ - ]', 'Reserve (Бронь) [ R ]',
    'Sale (Продажа) [ P ]', 'Actualize (Продажа брони) [ A ]', 'Modify (Изменение) [ M ]',
    'Free (Снятие брони) [ J ]', 'Restore (Возврат) [ F ]',
    'Select (Выделение) [ S ]', 'Cancel (Отмена) [ C ]');
}

type
  TSeansChangeEvent = procedure(Sender: TObject; SeansReload: Boolean; ProgressBar: TGauge) of
    object;

  TEnumTransOptions = (poStartTransAction, poCommitTransActionBefore, poRollbackTransActionBefore,
    poCommitTransActionAfter, poRollbackTransActionAfter);
  TTransOptions = set of TEnumTransOptions;

  // --------------------------------------------------------------------------
procedure Change_Cur_Zal(NewZal: integer; FirstTime: boolean; Film_Items:
  TStrings; pnZal_Container: TPanel; sbx_Cntr: TScrollBox; Change_Seans_Proc:
  TSeansChangeEvent; ProgressBar: TGauge); // Смена зала
procedure Change_Cur_Date(NewDate: TDateTime; FirstTime: boolean; Film_Items:
  TStrings; Change_Seans_Proc: TSeansChangeEvent; SeansReload: Boolean;
  ProgressBar: TGauge); // Смена даты
procedure Change_Cur_Seans(NewSeans: integer; FirstTime: boolean; var
  str_RateDesc: string; TicketPopupMenu: TPopupMenu; PaidTicketSubMenu,
  AllTicketSubMenu: TMenuItem; MenuFont: TFont; ProgressBar: TGauge); // Смена сеанса
// --------------------------------------------------------------------------
function OperModify(const ProcTransOptions: TTransOptions;
  const Oper_Action: TOperAction;
  const Oper_Print_Count: Integer;
  const {Oper_Printed,} Oper_Cheqed: Boolean;
  const Oper_Row, Oper_Column: Integer;
  const Oper_Sale_Form: Integer;
  const Oper_Repert_Kod, Oper_Ticket_Kod: Integer;
  const Oper_Reason: Integer;
  var Oper_Kod: Integer; var Oper_Serial: string;
  var Error_Kod: Integer; var Error_Text: string): Boolean;
// --------------------------------------------------------------------------
function OperModFinal(const ProcTransOptions: TTransOptions): Boolean;
// --------------------------------------------------------------------------
function OperClear(const Clear_Mode, Oper_Repert_Kod: Integer;
  var Total_Count, Cleared_Count: Integer;
  var Error_Kod: Integer; var Error_Text: string): Boolean;
// --------------------------------------------------------------------------

implementation

uses
  Bugger, SysUtils, Dialogs, Math, udBase, uTools, uhCommon, uhOper,
  uhLoader, urLoader, uhMain, uhTicket, urCommon, StrConsts;

const
  UnitName: string = 'uhMain';

procedure Update_Zal_Map(NewZal: integer; FirstTime: boolean; pnZal_Container:
  TPanel; sbx_Cntr: TScrollBox); // Смена карты зала
const
  ProcName: string = 'Update_Zal_Map';
var
  str_Panel_Name_0: string;
  tmp_Zal_Panel_0: TOdeumPanel;
  Source: TComponent;
begin
{$IFDEF Debug_Level_8}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Смена карты зала
  // --------------------------------------------------------------------------
  if (Cur_Zal_Kod <> NewZal) or FirstTime then
  begin
    str_Panel_Name_0 := 'pnZal_' + IntToStr(NewZal);
    Source := pnZal_Container.FindComponent(str_Panel_Name_0);
    if (Source is TOdeumPanel) then
      tmp_Zal_Panel_0 := (Source as TOdeumPanel)
    else
      tmp_Zal_Panel_0 := nil;
    if (not Assigned(tmp_Zal_Panel_0)) or (tmp_Zal_Panel_0.OdeumKod <> NewZal) then
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error - "' + str_Panel_Name_0 +
        '" not found or invalid.');
    end
    else
    begin
      {
      sbx_Cntr.Align := alNone;
      }
      if Check_Cntr then
      begin
{$IFDEF Debug_Level_8}
        DEBUGMessEnh(0, UnitName, ProcName, 'Old - Cur_Panel_Cntr is "' +
          Cur_Panel_Cntr.Name + '".');
{$ENDIF}
{$IFDEF Debug_Level_9}
        DEBUGMessEnh(0, UnitName, ProcName, 'Before - Cur_Panel_Cntr.Owner is "'
          + Cur_Panel_Cntr.Owner.Name + '".');
        DEBUGMessEnh(0, UnitName, ProcName, 'Before - Cur_Panel_Cntr.Parent is "'
          + Cur_Panel_Cntr.Parent.Name + '".');
{$ENDIF}
        Cur_Panel_Cntr.Owner.RemoveComponent(Cur_Panel_Cntr);
        pnZal_Container.InsertComponent(Cur_Panel_Cntr);
        Cur_Panel_Cntr.Parent := pnZal_Container;
{$IFDEF Debug_Level_9}
        DEBUGMessEnh(0, UnitName, ProcName, 'After - Cur_Panel_Cntr.Owner is "'
          + Cur_Panel_Cntr.Owner.Name + '".');
        DEBUGMessEnh(0, UnitName, ProcName, 'After - Cur_Panel_Cntr.Parent is "'
          + Cur_Panel_Cntr.Parent.Name + '".');
{$ENDIF}
      end
{$IFDEF Debug_Level_8}
      else
        DEBUGMessEnh(0, UnitName, ProcName, 'Old - Cur_Panel_Cntr is nil.')
{$ENDIF}
        ;
      Cur_Panel_Cntr := tmp_Zal_Panel_0;
{$IFDEF Debug_Level_8}
      DEBUGMessEnh(0, UnitName, ProcName, 'New - Cur_Panel_Cntr is "' +
        Cur_Panel_Cntr.Name + '".');
{$ENDIF}
{$IFDEF Debug_Level_9}
      DEBUGMessEnh(0, UnitName, ProcName, 'Before - Cur_Panel_Cntr.Owner is "' +
        Cur_Panel_Cntr.Owner.Name + '".');
      DEBUGMessEnh(0, UnitName, ProcName, 'Before - Cur_Panel_Cntr.Parent is "'
        + Cur_Panel_Cntr.Parent.Name + '".');
{$ENDIF}
      Cur_Panel_Cntr.Owner.RemoveComponent(Cur_Panel_Cntr);
      sbx_Cntr.InsertComponent(Cur_Panel_Cntr);
      Cur_Panel_Cntr.Parent := sbx_Cntr;
      Cur_Panel_Cntr.Left := 0;
      Cur_Panel_Cntr.Top := 0;
      {
      sbx_Cntr.Width := Screen.Width;
      sbx_Cntr.Height := Screen.Height;
      sbx_Cntr.Align := alClient;
      }
{$IFDEF Debug_Level_9}
      DEBUGMessEnh(0, UnitName, ProcName, 'After - Cur_Panel_Cntr.Owner is "' +
        Cur_Panel_Cntr.Owner.Name + '".');
      DEBUGMessEnh(0, UnitName, ProcName, 'After - Cur_Panel_Cntr.Parent is "' +
        Cur_Panel_Cntr.Parent.Name + '".');
{$ENDIF}
    end;
    Cur_Zal_Kod := NewZal;
  end;
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_8}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Change_Cur_Zal(NewZal: integer; FirstTime: boolean; Film_Items:
  TStrings; pnZal_Container: TPanel; sbx_Cntr: TScrollBox; Change_Seans_Proc:
  TSeansChangeEvent; ProgressBar: TGauge); // Смена зала
const
  ProcName: string = 'Change_Cur_Zal';
var
  str_RptPref1, str_RptPref2: string;
  i, indx, Old_Repert_Kod: Integer;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  // Смена зала
  // --------------------------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, 'FirstTime = ' + BoolYesNo[FirstTime]);
  DEBUGMessEnh(0, UnitName, ProcName, 'Cur_Zal_Kod = ' + IntToStr(Cur_Zal_Kod));
  DEBUGMessEnh(0, UnitName, ProcName, 'NewZal = ' + IntToStr(NewZal));
  if ((Cur_Zal_Kod <> NewZal) or FirstTime) and TestDBConnect then
  begin
    // Emblema_Loaded := 0;
    Old_Repert_Kod := Cur_Repert_Kod;
    if (Cur_Zal_Kod > -1) then
    begin
      str_RptPref1 := s_RptPref + FormatDateTime('_YYYY_MM_DD_', Cur_Date) + IntToStr(Cur_Zal_Kod);
      SaveToMemListStr(str_RptPref1, IntToStr(Old_Repert_Kod));
    end;
    Update_Zal_Map(NewZal, FirstTime, pnZal_Container, sbx_Cntr);
    str_RptPref2 := s_RptPref + FormatDateTime('_YYYY_MM_DD_', Cur_Date) + IntToStr(Cur_Zal_Kod);
    Cur_Repert_Kod := -1;
    if Load_Repert(Cur_Date, Cur_Zal_Kod, Film_Items) > {0} -1 then
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'LoadRepert() passed.');
      DEBUGMessEnh(0, UnitName, ProcName, 'Films list is (' + Film_Items.CommaText + ')');
      LoadFromMemListInt(str_RptPref2, Cur_Repert_Kod, Old_Repert_Kod);
      DEBUGMessEnh(0, UnitName, ProcName, 'Old_Repert_Kod = ' + IntToStr(Old_Repert_Kod));
      if Film_Items.Count > 0 then
      begin
        indx := 0;
        if FirstTime or true then
        begin
          // todo: Restore Cur_Repert_Kod
          try
            for i := 0 to Film_Items.Count - 1 do
            begin
              if Old_Repert_Kod = Integer(Film_Items.Objects[i]) then
                indx := i;
            end;
          except
            indx := 0;
          end;
          // ItemIndex := indx;
        end;
        Cur_Repert_Kod := Integer(Film_Items.Objects[indx]);
        SaveToMemListStr(str_RptPref2, IntToStr(Old_Repert_Kod));
      end;
      // fm_Main.tbcFilm.OnChange(nil);
      DEBUGMessEnh(0, UnitName, ProcName, 'Cur_Repert_Kod = ' + IntToStr(Cur_Repert_Kod));
      if Assigned(Change_Seans_Proc) then
      try
        DEBUGMessEnh(0, UnitName, ProcName, 'Calling - Change_Seans_Proc(nil)');
        Change_Seans_Proc(nil, True, ProgressBar);
      except
      end;
      DEBUGMessEnh(0, UnitName, ProcName, 'Cur_Repert_Kod = ' + IntToStr(Cur_Repert_Kod));
    end;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Change_Cur_Date(NewDate: TDateTime; FirstTime: boolean; Film_Items:
  TStrings; Change_Seans_Proc: TSeansChangeEvent; SeansReload: Boolean;
  ProgressBar: TGauge); // Смена даты
const
  ProcName: string = 'Change_Cur_Date';
var
  str_RptPref1, str_RptPref2: string;
  i, indx, Old_Repert_Kod: Integer;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  // Смена даты
  // --------------------------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, 'FirstTime = ' + BoolYesNo[FirstTime]);
  DEBUGMessEnh(0, UnitName, ProcName, 'Cur_Date = (' + DateToStr(Cur_Date) + ')');
  DEBUGMessEnh(0, UnitName, ProcName, 'NewDate = (' + DateToStr(NewDate) + ')');
  if (Cur_Date <> NewDate) or FirstTime then
  begin
    Old_Repert_Kod := Cur_Repert_Kod;
    if true then
    begin
      str_RptPref1 := s_RptPref + FormatDateTime('_YYYY_MM_DD_', Cur_Date) + IntToStr(Cur_Zal_Kod);
      SaveToMemListStr(str_RptPref1, IntToStr(Old_Repert_Kod));
    end;
    Cur_Date := NewDate;
    str_RptPref2 := s_RptPref + FormatDateTime('_YYYY_MM_DD_', Cur_Date) + IntToStr(Cur_Zal_Kod);
    if Load_Repert(Cur_Date, Cur_Zal_Kod, Film_Items) > {0} -1 then
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'LoadRepert() passed.');
      DEBUGMessEnh(0, UnitName, ProcName, 'Films list is (' + Film_Items.CommaText + ')');
      LoadFromMemListInt(str_RptPref2, Cur_Repert_Kod, Old_Repert_Kod);
      DEBUGMessEnh(0, UnitName, ProcName, 'Old_Repert_Kod = ' + IntToStr(Old_Repert_Kod));
      if Film_Items.Count > 0 then
      begin
        indx := 0;
        if FirstTime or true then
        begin
          // todo: Restore Cur_Repert_Kod
          try
            for i := 0 to Film_Items.Count - 1 do
            begin
              if Old_Repert_Kod = Integer(Film_Items.Objects[i]) then
                indx := i;
            end;
          except
            indx := 0;
          end;
          // ItemIndex := indx;
        end;
        Cur_Repert_Kod := Integer(Film_Items.Objects[indx]);
        SaveToMemListStr(str_RptPref2, IntToStr(Old_Repert_Kod));
      end;
      // fm_Main.tbcFilm.OnChange(nil);
      DEBUGMessEnh(0, UnitName, ProcName, 'Cur_Repert_Kod = ' + IntToStr(Cur_Repert_Kod));
      if Assigned(Change_Seans_Proc) then
      try
        DEBUGMessEnh(0, UnitName, ProcName, 'Calling - Change_Seans_Proc(nil)');
        Change_Seans_Proc(nil, SeansReload or true, ProgressBar);
      except
      end;
      DEBUGMessEnh(0, UnitName, ProcName, 'Cur_Repert_Kod = ' + IntToStr(Cur_Repert_Kod));
    end;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Change_Cur_Seans(NewSeans: integer; FirstTime: boolean; var
  str_RateDesc: string; TicketPopupMenu: TPopupMenu; PaidTicketSubMenu,
  AllTicketSubMenu: TMenuItem; MenuFont: TFont; ProgressBar: TGauge); // Смена сеанса
const
  ProcName: string = 'Change_Cur_Seans';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  // Смена сеанса
  // --------------------------------------------------------------------------
  Cur_Repert_Kod := NewSeans;
  Load_Tariff(NewSeans, str_RateDesc, TicketPopupMenu, PaidTicketSubMenu,
    AllTicketSubMenu, MenuFont);
  if Check_Film then
    Load_All_TC(NewSeans, Progressbar);
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function OperModify(const ProcTransOptions: TTransOptions;
  const Oper_Action: TOperAction;
  const Oper_Print_Count: Integer;
  const {Oper_Printed,} Oper_Cheqed: Boolean;
  const Oper_Row, Oper_Column: Integer;
  const Oper_Sale_Form: Integer;
  const Oper_Repert_Kod, Oper_Ticket_Kod: Integer;
  const Oper_Reason: Integer;
  var Oper_Kod: Integer; var Oper_Serial: string;
  var Error_Kod: Integer; var Error_Text: string): Boolean;
const
  ProcName: string = 'OperModify';
var
  var_Error_Kod: Integer;
  var_Error_Text: string;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  Result := False;
  with dm_Base.sp_Oper_Mod do
  try
    if Assigned(dm_Base) and Assigned(dm_Base.sp_Oper_Mod) then
    begin
      if (Tag < 0) or (Length(StoredProcName) = 0) then
      begin
        ParamCheck := true;
        StoredProcName := '';
        StoredProcName := s_IP_OPER_MOD;
        Tag := 0;
      end;
      // ------------ Checking transaction ------------
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      // TEnumTransOptions = (poStartTransAction, poCommitTransAction, poRollbackTransAction);
      if (Transaction <> nil) and Transaction.InTransaction then
      begin
        if (poCommitTransActionBefore in ProcTransOptions) then
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Commit Before');
          Transaction.Commit;
        end
        else if (poRollbackTransActionBefore in ProcTransOptions) then
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Rollback Before');
          Transaction.Rollback;
        end;
      end;
      // ------------ Starting transaction ------------
      if (Transaction <> nil) and not Transaction.InTransaction then
      begin
        if (poStartTransAction in ProcTransOptions) then
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.StartTransaction');
          Transaction.StartTransaction;
        end;
      end;
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      // ------------ Setting params ------------
      if Assigned(Params.FindParam(s_IN_OPER_ACTION)) then
        ParamByName(s_IN_OPER_ACTION).AsString := c_OperActionPfx[Oper_Action];
      // ------------
      {
      if Assigned(Params.FindParam(s_IN_OPER_PRINTED)) then
        ParamByName(s_IN_OPER_PRINTED).AsInteger := c_Bool2Int[Oper_Printed];
      }
      // ------------
      if Assigned(Params.FindParam(s_IN_OPER_PRINT_COUNT)) then
        ParamByName(s_IN_OPER_PRINT_COUNT).AsInteger := Oper_Print_Count;
      // ------------
      if Assigned(Params.FindParam(s_IN_OPER_CHEQED)) then
        ParamByName(s_IN_OPER_CHEQED).AsInteger := c_Bool2Int[Oper_Cheqed];
      // ------------
      if Assigned(Params.FindParam(s_IN_OPER_PLACE_ROW)) then
        ParamByName(s_IN_OPER_PLACE_ROW).AsInteger := Oper_Row;
      // ------------
      if Assigned(Params.FindParam(s_IN_OPER_PLACE_COL)) then
        ParamByName(s_IN_OPER_PLACE_COL).AsInteger := Oper_Column;
      // ------------
      if Assigned(Params.FindParam(s_IN_OPER_SALE_FORM)) then
        ParamByName(s_IN_OPER_SALE_FORM).AsInteger := Oper_Sale_Form;
      // ------------
      if Assigned(Params.FindParam(s_IN_OPER_REPERT_KOD)) then
        ParamByName(s_IN_OPER_REPERT_KOD).AsInteger := Oper_Repert_Kod;
      // ------------
      if Assigned(Params.FindParam(s_IN_OPER_TICKET_KOD)) then
        ParamByName(s_IN_OPER_TICKET_KOD).AsInteger := Oper_Ticket_Kod;
      // ------------
      if Assigned(Params.FindParam(s_IN_OPER_MISC_REASON)) then
        ParamByName(s_IN_OPER_MISC_REASON).AsInteger := Oper_Reason;
      // ------------
      if Assigned(Params.FindParam(s_IN_SESSION_ID)) then
        ParamByName(s_IN_SESSION_ID).AsInt64 := Global_Session_ID;
      // ------------
      DEBUGMessEnh(0, UnitName, ProcName, s_OPER_ACTION + ' = ' + c_OperActionDesc[Oper_Action]);
      // DEBUGMessEnh(0, UnitName, ProcName, s_IN_OPER_PRINTED + ' = ' + c_Boolean[Oper_Printed]);
      DEBUGMessEnh(0, UnitName, ProcName, s_IN_OPER_PRINT_COUNT + ' = ' +
        IntToStr(Oper_Print_Count));
      DEBUGMessEnh(0, UnitName, ProcName, s_IN_OPER_CHEQED + ' = ' + c_Boolean[Oper_Cheqed]);
      DEBUGMessEnh(0, UnitName, ProcName, s_IN_OPER_PLACE_ROW + ' = ' + IntToStr(Oper_Row));
      DEBUGMessEnh(0, UnitName, ProcName, s_IN_OPER_PLACE_COL + ' = ' + IntToStr(Oper_Column));
      DEBUGMessEnh(0, UnitName, ProcName, s_IN_OPER_SALE_FORM + ' = ' + IntToStr(Oper_Sale_Form));
      DEBUGMessEnh(0, UnitName, ProcName, s_IN_OPER_REPERT_KOD + ' = ' + IntToStr(Oper_Repert_Kod));
      DEBUGMessEnh(0, UnitName, ProcName, s_IN_OPER_TICKET_KOD + ' = ' + IntToStr(Oper_Ticket_Kod));
      DEBUGMessEnh(0, UnitName, ProcName, s_IN_OPER_MISC_REASON + ' = ' + IntToStr(Oper_Reason));
      DEBUGMessEnh(0, UnitName, ProcName, s_IN_SESSION_ID + ' = ' + IntToStr(Global_Session_ID));
      DEBUGMessEnh(0, UnitName, ProcName, 'Prepare');
      Prepare;
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.TRParams = ('
        + Transaction.TRParams.CommaText + ')');
      ExecProc;
      // ------------ Closing transaction ------------
      if (Transaction <> nil) and Transaction.InTransaction then
      begin
        if (poCommitTransActionAfter in ProcTransOptions) then
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Commit After');
          Transaction.Commit;
        end
        else if (poRollbackTransActionAfter in ProcTransOptions) then
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Rollback After');
          Transaction.Rollback;
        end;
      end;
      // ------------ Returning params ------------
      Oper_Kod := -2;
      try
        if Assigned(FieldByName[s_OUT_OPER_KOD]) then
          Oper_Kod := FieldByName[s_OUT_OPER_KOD].AsInteger;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_OUT_OPER_KOD +
            ') is failed.');
        end;
      end;
      // ------------
      Oper_Serial := '';
      try
        if Assigned(FieldByName[s_OUT_OPER_SERIAL]) then
          Oper_Serial := FieldByName[s_OUT_OPER_SERIAL].AsString;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_OUT_OPER_SERIAL +
            ') is failed.');
        end;
      end;
      Error_Text := var_Error_Text;
      DEBUGMessEnh(0, UnitName, ProcName, s_ERROR_TEXT + ' = ' + var_Error_Text);
      // ------------
      var_Error_Kod := 0;
      try
        if Assigned(FieldByName[s_ERROR_ID]) then
          var_Error_Kod := FieldByName[s_ERROR_ID].AsInteger;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_ERROR_ID +
            ') is failed.');
        end;
      end;
      Error_Kod := var_Error_Kod;
      DEBUGMessEnh(0, UnitName, ProcName, s_ERROR_ID + ' = ' + IntToStr(var_Error_Kod));
      // ------------
      var_Error_Text := '-*-';
      try
        if Assigned(FieldByName[s_ERROR_TEXT]) then
          var_Error_Text := FieldByName[s_ERROR_TEXT].AsString;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_ERROR_TEXT +
            ') is failed.');
        end;
      end;
      Error_Text := var_Error_Text;
      DEBUGMessEnh(0, UnitName, ProcName, s_ERROR_TEXT + ' = ' + var_Error_Text);
      // ------------
      DEBUGMessEnh(0, UnitName, ProcName, s_OUT_OPER_KOD + ' = ' + IntToStr(Oper_Kod));
      DEBUGMessEnh(0, UnitName, ProcName, s_OUT_OPER_SERIAL + ' = ' + Oper_Serial);
      // ------------
      case Oper_Action of
        oaReserve, oaSale, oaActualize, oaFree, oaRestore:
          if (var_Error_Kod = 2) and (Oper_Kod > 0) then
            Result := true;
        oaSelect:
          if ((var_Error_Kod = 1) or (var_Error_Kod = 2)) and (Oper_Kod > 0) then
            Result := true;
        oaCancel:
          if (var_Error_Kod = 3) and (Oper_Kod > 0) then
            Result := true;
      end;
      {
      if (not Result) and ((var_Error_Kod = 231) or (var_Error_Kod = 232)) then
      begin
        // Must Refresh Data
        Result := false;
      end;
      }
      // ------------ Check done ------------
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
    end;
  except
    on E: Exception do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'Exception during call to stored proc ('
        + StoredProcName + ').');
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      DBLastError1 := E.Message;
      Error_Text := E.Message;
    end;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function OperModFinal(const ProcTransOptions: TTransOptions): Boolean;
const
  ProcName: string = 'OperModFinal';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  Result := False;
  with dm_Base.sp_Oper_Mod do
  try
    if Assigned(dm_Base) and Assigned(dm_Base.sp_Oper_Mod) then
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      // ------------ Closing transaction ------------
      if (Transaction <> nil) and Transaction.InTransaction then
      begin
        if (poCommitTransActionAfter in ProcTransOptions) then
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Commit After');
          Transaction.Commit;
        end
        else if (poRollbackTransActionAfter in ProcTransOptions) then
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Rollback After');
          Transaction.Rollback;
        end;
        DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' +
          BoolYesNo[Transaction.Active]);
      end;
    end;
  except
    on E: Exception do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'Exception during closing transaction for ('
        + StoredProcName + ').');
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      DBLastError1 := E.Message;
      // Error_Text := E.Message;
    end;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function OperClear(const Clear_Mode, Oper_Repert_Kod: Integer;
  var Total_Count, Cleared_Count: Integer;
  var Error_Kod: Integer; var Error_Text: string): Boolean;
const
  ProcName: string = 'OperClear';
var
  var_Error_Kod: Integer;
  var_Error_Text: string;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  Result := False;
  with dm_Base.sp_Oper_Clr do
  try
    if Assigned(dm_Base) and Assigned(dm_Base.sp_Oper_Clr) then
    begin
      ParamCheck := true;
      StoredProcName := '';
      StoredProcName := s_IP_OPER_CLR;
      // ------------ Setting params ------------
      if Assigned(Params.FindParam(s_IN_CLEAR_MODE)) then
        ParamByName(s_IN_CLEAR_MODE).AsInteger := Clear_Mode;
      // ------------
      if Assigned(Params.FindParam(s_IN_OPER_REPERT_KOD)) then
        ParamByName(s_IN_OPER_REPERT_KOD).AsInteger := Oper_Repert_Kod;
      // ------------
      if Assigned(Params.FindParam(s_IN_SESSION_ID)) then
        ParamByName(s_IN_SESSION_ID).AsInt64 := Global_Session_ID;
      // ------------
      DEBUGMessEnh(0, UnitName, ProcName, s_IN_OPER_REPERT_KOD + ' = ' + IntToStr(Oper_Repert_Kod));
      DEBUGMessEnh(0, UnitName, ProcName, s_IN_SESSION_ID + ' = ' + IntToStr(Global_Session_ID));
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      Prepare;
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.TRParams = ('
        + Transaction.TRParams.CommaText + ')');
      ExecProc;
      // ------------ Returning params ------------
      Total_Count := -2;
      try
        if Assigned(FieldByName[s_OUT_TOTAL_COUNT]) then
          Total_Count := FieldByName[s_OUT_TOTAL_COUNT].AsInteger;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_OUT_TOTAL_COUNT +
            ') is failed.');
        end;
      end;
      // ------------
      Cleared_Count := -2;
      try
        if Assigned(FieldByName[s_OUT_CLEARED_COUNT]) then
          Cleared_Count := FieldByName[s_OUT_CLEARED_COUNT].AsInteger;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_OUT_CLEARED_COUNT +
            ') is failed.');
        end;
      end;
      // ------------
      var_Error_Kod := 0;
      try
        if Assigned(FieldByName[s_ERROR_ID]) then
          var_Error_Kod := FieldByName[s_ERROR_ID].AsInteger;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_ERROR_ID +
            ') is failed.');
        end;
      end;
      Error_Kod := var_Error_Kod;
      DEBUGMessEnh(0, UnitName, ProcName, s_ERROR_ID + ' = ' + IntToStr(var_Error_Kod));
      // ------------
      var_Error_Text := '-*-';
      try
        if Assigned(FieldByName[s_ERROR_TEXT]) then
          var_Error_Text := FieldByName[s_ERROR_TEXT].AsString;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_ERROR_TEXT +
            ') is failed.');
        end;
      end;
      Error_Text := var_Error_Text;
      DEBUGMessEnh(0, UnitName, ProcName, s_ERROR_TEXT + ' = ' + var_Error_Text);
      // ------------
      DEBUGMessEnh(0, UnitName, ProcName, s_OUT_TOTAL_COUNT + ' = ' + IntToStr(Total_Count));
      DEBUGMessEnh(0, UnitName, ProcName, s_OUT_CLEARED_COUNT + ' = ' + IntToStr(Cleared_Count));
      // ------------
      if (var_Error_Kod = 1) {and (Cleared_Count > 0)} then
        Result := true;
      {
      if (not Result) and ((var_Error_Kod = 231) or (var_Error_Kod = 232)) then
      begin
        // Must Refresh Data
        Result := false;
      end;
      }
      // ------------ Check done ------------
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
    end;
  except
    on E: Exception do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'Exception during call to stored proc ('
        + StoredProcName + ').');
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      DBLastError1 := E.Message;
      Error_Text := E.Message;
    end;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

end.

