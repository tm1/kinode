{-----------------------------------------------------------------------------
 Unit Name: uhMain
 Author:    n0mad
 Version:   1.1.6.87
 Creation:  27.08.2003
 Purpose:   Main form helper
 History:
-----------------------------------------------------------------------------}
unit uhMain;

interface

{$I kinode01.inc}

uses
  Classes, Extctrls, ShpCtrl2;

// --------------------------------------------------------------------------
function Check_Cntr: boolean; // ready
function Check_Film: boolean; // ready
function Update_DB_Conn_State: boolean; // ready
function Update_Changes_Monitor: boolean; // ready
// --------------------------------------------------------------------------
function Load_Repert(NewDate: TDateTime; NewZal: integer; Film_Items: TStrings):
  integer; // Загрузка репертуара для этого зала на эту дату
// --------------------------------------------------------------------------
procedure Refresh_TC_Count(Cho: Integer);
// --------------------------------------------------------------------------

const
  Cur_Panel_Cntr: TCustomPanel = nil;
  Cur_Date: TDateTime = -1;
  Cur_Zal_Kod: integer = -1;
  Cur_Repert_Kod: integer = -1;
  Cur_Tarif: Integer = -1;
  Cur_Film_Kod: integer = -1;
  Cur_Film_Nam: string = '';
  Cur_Seans_Time: string = '';
  Print_Cheq: Boolean = true;

implementation

uses
  Bugger, SysUtils, Dialogs, uTools, udBase, uhCommon, urCommon, ufMain,
  StrConsts, uhTicket, ufInfo;

const
  UnitName: string = 'uhMain';

function Check_Cntr: boolean; // ready
begin
  Result := false;
  if Assigned(Cur_Panel_Cntr) then
    if length(Cur_Panel_Cntr.Name) > 6 then
      if copy(Cur_Panel_Cntr.Name, 1, 6) = 'pnZal_' then
        Result := true;
end;

function Check_Film: boolean; // ready
begin
  Result := false;
  if Assigned(fm_Main) then
    if Assigned(fm_Main.tbc_Film_List) then
      Result := fm_Main.tbc_Film_List.Visible;
end;

function Update_DB_Conn_State: boolean; // ready
begin
  Result := false;
  if Assigned(fm_Main) then
  begin
    fm_Main.UpdateStatusBar(4);
    Result := True;
  end;
end;

function Update_Changes_Monitor: boolean; // ready
begin
  Result := false;
  if Assigned(fm_Main) then
  begin
    fm_Main.fRptReloaded := False;
    fm_Main.UpdateStatusBar(5);
    Result := True;
  end;
end;

function Load_Repert(NewDate: TDateTime; NewZal: integer; Film_Items: TStrings):
  integer; // Загрузка репертуара для этого зала на эту дату
const
  ProcName: string = 'Load_Repert';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  // Загрузка репертуара для этого зала на эту дату
  // --------------------------------------------------------------------------
  // 1) Фильтр на ds_Repert
  // --------------------------------------------------------------------------
  // Cur_Repert_Kod := -1;
  DEBUGMessEnh(0, UnitName, ProcName, 'NewZal = ' + IntToStr(NewZal));
  DEBUGMessEnh(0, UnitName, ProcName, 'NewDate = (' + DateToStr(NewDate) + ')');
  with dm_Base.ds_Repert do
  begin
    try
      Close;
      if Assigned(Params.FindParam(s_IN_FILT_MODE_ODEUM)) then
        ParamByName(s_IN_FILT_MODE_ODEUM).AsInteger := 0;
      if Assigned(Params.FindParam(s_IN_FILT_REPERT_ODEUM)) then
        ParamByName(s_IN_FILT_REPERT_ODEUM).AsInteger := NewZal;
      if Assigned(Params.FindParam(s_IN_FILT_MODE_DATE)) then
        ParamByName(s_IN_FILT_MODE_DATE).AsInteger := 0;
      if Assigned(Params.FindParam(s_IN_FILT_REPERT_DATE)) then
        ParamByName(s_IN_FILT_REPERT_DATE).AsDate := NewDate;
      Prepare;
      Open;
      First;
      Last;
      Combo_Load_Repert(dm_Base.ds_Repert, Film_Items);
    except
      on E: Exception do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
        DEBUGMessEnh(0, UnitName, ProcName, 'Reopening for (' + Name + ') is failed.');
      end;
    end;
{$IFDEF Debug_Level_6}
    DEBUGMessEnh(0, UnitName, ProcName, Name + '.Active = ' + BoolYesNo[Active]
      + ', RecordCount = (' + IntToStr(RecordCount) + ')');
{$ENDIF}
    Result := Film_Items.Count;
    DEBUGMessEnh(0, UnitName, ProcName, 'Film_Items = ' +
      IntToStr(Film_Items.Count));
    {
    if Film_Items.Count > 0 then
    begin
      Cur_Repert_Kod := Integer(Film_Items.Objects[0]);
      TabIndex := Film_Items.IndexOfObject(TObject(Cur_Repert_Kod));
      DEBUGMessEnh(0, UnitName, ProcName, 'TabIndex = ' + IntToStr(TabIndex));
    end;
    }
    DEBUGMessEnh(0, UnitName, ProcName, 'Cur_Repert_Kod = ' +
      IntToStr(Cur_Repert_Kod));
    // Active := false;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Refresh_TC_Count(Cho: Integer);
const
  ProcName: string = 'Refresh_TC_Count';
  {
  select
    TKT.TICKET_KOD,
    TKT.TICKET_NAM,
    TKT.TICKET_CLASS,
    TKT.CLASS_NAM,
    TKT.CLASS_TO_PRINT,
    TKT.CLASS_FOR_FREE,
    TKT.CLASS_INVITED_GUEST,
    TKT.CLASS_GROUP_VISIT,
    TKT.CLASS_VIP_CARD,
    TKT.CLASS_VIP_BYNAME,
    TKT.CLASS_SEASON_TICKET,
    TKT.TICKET_CALCUL1,
    TKT.TICKET_CONST1,
    TKT.TICKET_LABEL,
    TKT.TICKET_SERIALIZE,
    TKT.TICKET_BGCOLOR,
    TKT.TICKET_FNTCOLOR,
    TKT.TICKET_MENU_ORDER,
    TKT.TICKET_FREEZED
  from
    SP_TICKET_LIST_S(
      :IN_FILT_MODE,
      :IN_FILT_PARAM1) TKT
  }
var
  vInfo_count, i, k: Integer;
  Count_All,
    Count_Local_All, Count_Local_Sel,
    Count_Local_Sold, Sum_Local_Sold,
    Count_Net_All, Count_Net_Sel,
    Count_Free, Count_Broken, Count_Prepared, Sum_Prepared,
    Count_Reserved, Sum_Reserved,
    Total_Count_NotPaid,
    Total_Count_Credit, Total_Sum_Credit,
    Total_Count_Cash, Total_Sum_Cash,
    Total_Count_Cheqed, Total_Sum_Cheqed: Integer;
  ssTmp: TSeatEx;
  s: string;
  b: Boolean;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  //  if Assigned(fmMain) and Assigned(TicketTypesList) and fmMain.tbcFilm.Visible and Check_Cntr then
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Count_Local_All := 0;
  Count_Local_Sel := 0;
  Count_Local_Sold := 0;
  Sum_Local_Sold := 0;
  Count_Net_All := 0;
  Count_Net_Sel := 0;
  Count_Free := 0;
  Count_Broken := 0;
  Count_Prepared := 0;
  Sum_Prepared := 0;
  Count_Reserved := 0;
  Sum_Reserved := 0;
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Total_Count_NotPaid := 0;
  Total_Sum_Credit := 0;
  Total_Count_Credit := 0;
  Total_Sum_Cash := 0;
  Total_Count_Cash := 0;
  Total_Sum_Cheqed := 0;
  Total_Count_Cheqed := 0;
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if Assigned(fm_Main) then
  begin
    b := (not Print_Cheq) and GlobalSeatCheqedShow;
    vInfo_count := (High(vInfo) - Low(vInfo) + 1);
    if (vInfo_count > 0) then
    begin
      // --------------------------------------------------------------------------
      // Reset vInfo items
      // --------------------------------------------------------------------------
      for i := Low(vInfo) to High(vInfo) do
      begin
        if (vInfo[i].irSpecial < vInfo_Special_Base) then
        begin
          vInfo[i].irCountPrep := 0;
          vInfo[i].irSumPrep := 0;
          vInfo[i].irCountCash := 0;
          vInfo[i].irSumCash := 0;
          vInfo[i].irCountCredit := 0;
          vInfo[i].irSumCredit := 0;
        end
        else if (vInfo[i].irSpecial > vInfo_Special_Base) then
        begin
          // --------------------------------------------------------------------------
          try
            vInfo[i].irCountPrep := 0;
            vInfo[i].irSumPrep := 0;
            vInfo[i].irCountCash := 0;
            vInfo[i].irSumCash := 0;
            vInfo[i].irCountCredit := 0;
            vInfo[i].irSumCredit := 0;
          except
          end;
        end; // if
      end; // for i := Low(vInfo) to High(vInfo) do
      // --------------------------------------------------------------------------
      // Count Cur_Panel_Cntr components
      // --------------------------------------------------------------------------
      if Check_Cntr and fm_Main.tbc_Film_List.Visible then
      begin
        for k := Cur_Panel_Cntr.ComponentCount - 1 downto 0 do
        begin
          if (Cur_Panel_Cntr.Components[k] is TSeatEx) then
          begin
            // --------------------------------------------------------------------------
            ssTmp := (Cur_Panel_Cntr.Components[k] as TSeatEx);
            {
            c_TicketState: array[TTicketState] of string =
            ('Свободно (Free)', 'Сломано (Broken)', 'Подготовлено (Prepared)',
              'Зарезервировано (Reserved)', 'Продано (Realized)');
            TTicketState = (tsFree, tsBroken, tsPrepared, tsReserved, tsRealized);
            }
            // --------------------------------------------------------------------------
            // Count all
            // --------------------------------------------------------------------------
            if (ssTmp.SeatState in [tsFree, tsRealized]) then
              if (ssTmp.Foreign = trNo) then
              begin
                inc(Count_Local_All);
                if ssTmp.Selected then
                begin
                  if (ssTmp.SeatState in [tsFree]) then
                    inc(Count_Local_Sel)
                  else if (ssTmp.SeatState in [tsRealized]) then
                    if (not ssTmp.Cheqed) then
                    begin
                      inc(Count_Local_Sold);
                      Sum_Local_Sold := Sum_Local_Sold + ssTmp.SaleCost;
                    end;
                end;
              end
              else
              begin
                inc(Count_Net_All);
                if ssTmp.Selected then
                begin
                  inc(Count_Net_Sel);
                end;
              end;
            // --------------------------------------------------------------------------
            case ssTmp.SeatState of
              tsFree:
                begin
                  inc(Count_Free);
                  // --------------------------------------------------------------------------
                  {
                  if ssTmp.Selected then
                    if (ssTmp.Foreign = trNo) then
                    begin
                      inc(Count_Local_Sel);
                    end
                    else
                    begin
                      inc(Count_Net_Sel);
                    end;
                  }
                  // --------------------------------------------------------------------------
                end; // tsFree
              tsBroken:
                begin
                  inc(Count_Broken);
                end; // tsBroken
              tsPrepared:
                begin
                  inc(Count_Prepared);
                  Sum_Prepared := Sum_Prepared + ssTmp.SaleCost;
                end; // tsPrepared
              tsReserved:
                begin
                  inc(Count_Reserved);
                  Sum_Reserved := Sum_Reserved + ssTmp.SaleCost;
                  if ssTmp.Selected then
                  begin
                    inc(Count_Prepared);
                    Sum_Prepared := Sum_Prepared + ssTmp.SaleCost;
                  end;
                end; // tsReserved
              tsRealized:
                begin
                  // --------------------------------------------------------------------------
                  // Search through vInfo items
                  // --------------------------------------------------------------------------
                  for i := Low(vInfo) to High(vInfo) do
                  begin
                    if (vInfo[i].irSpecial > vInfo_Special_Base) then
                      if (ssTmp.TicketKod = vInfo[i].irKod) then
                      begin
                        {
                        c_SfToStr: array[TSaleForm] of string =
                        ('0 - Not paid (Неоплачено)', '1 - Cash (Наличные)', '2 - Credit (Кредитка)',
                          '3 - Cariboo (Карибу)', '4 - Wapiti (Вапити)');
                        TSaleForm = (sfNotPaid, sfCash, sfCredit, sfCariboo, sfWapiti);
                        }
                        case ssTmp.SaleForm of
                          sfNotPaid:
                            begin
                              vInfo[i].irCountCash := vInfo[i].irCountCash + 1;
                              vInfo[i].irSumCash := vInfo[i].irSumCash + ssTmp.SaleCost;
                              inc(Total_Count_NotPaid);
                            end; // tsReserved
                          sfCash:
                            begin
                              if ssTmp.Cheqed then
                              begin
                                vInfo[i].irCountCash := vInfo[i].irCountCash + 1;
                                vInfo[i].irSumCash := vInfo[i].irSumCash + ssTmp.SaleCost;
                                inc(Total_Count_Cheqed);
                                Total_Sum_Cheqed := Total_Sum_Cheqed + ssTmp.SaleCost;
                              end
                              else if b then
                              begin
                                vInfo[i].irCountCash := vInfo[i].irCountCash + 1;
                                vInfo[i].irSumCash := vInfo[i].irSumCash + ssTmp.SaleCost;
                                inc(Total_Count_Cash);
                                Total_Sum_Cash := Total_Sum_Cash + ssTmp.SaleCost;
                              end;
                            end; // tsReserved
                          sfCredit:
                            begin
                              vInfo[i].irCountCredit := vInfo[i].irCountCredit + 1;
                              vInfo[i].irSumCredit := vInfo[i].irSumCredit + ssTmp.SaleCost;
                              Total_Sum_Credit := Total_Sum_Credit + ssTmp.SaleCost;
                              inc(Total_Count_Credit);
                            end; // tsReserved
                          sfCariboo:
                            begin
                            end; // tsReserved
                          sfWapiti:
                            begin
                            end; // tsReserved
                        end; // case
                      end; // if
                  end; // for i := Low(vInfo) to High(vInfo) do
                  // --------------------------------------------------------------------------
                end; // tsRealized
            else
              //foo
            end; // case
            // --------------------------------------------------------------------------
          end; // if (Cur_Panel_Cntr.Components[k] is TTicketControl) then
        end; // for
      end; // if
    end; // if (vInfo_count > 0) then
    // --------------------------------------------------------------------------
    // Iterate through vInfo items
    // --------------------------------------------------------------------------
    for i := Low(vInfo) to High(vInfo) do
    begin
      // Итого на продажу
      if (vInfo[i].irSpecial = vInfo_Special_Base - vInfo_Special_Sale) then
      begin
        vInfo[i].irCountCash := Count_Prepared;
        vInfo[i].irSumCash := Sum_Prepared;
      end;
      // Помеченные места
      if (vInfo[i].irSpecial = vInfo_Special_Base - vInfo_Special_Selected) then
      begin
        vInfo[i].irCountCash := Count_Local_Sel;
        vInfo[i].irCountCredit := Count_Local_Sold;
        vInfo[i].irSumCash := Sum_Local_Sold;
      end;
      // Свободные места
      if (vInfo[i].irSpecial = vInfo_Special_Base - vInfo_Special_Free) then
      begin
        vInfo[i].irCountCash := Count_Free;
        vInfo[i].irSumCash := -1;
      end;
      // Итого по пропущенным
      if (vInfo[i].irSpecial = vInfo_Special_Base - vInfo_Special_Skiped) then
      begin
        if b then
        begin
          vInfo[i].irCountCash := Total_Count_Cash;
          vInfo[i].irSumCash := Total_Sum_Cash;
        end
        else
        begin
          vInfo[i].irCountCash := 0;
          vInfo[i].irSumCash := -1;
        end;
      end;
      // Итого по брони
      if (vInfo[i].irSpecial = vInfo_Special_Base - vInfo_Special_Reserved) then
      begin
        vInfo[i].irCountCash := Count_Reserved;
        vInfo[i].irSumCash := Sum_Reserved;
      end;
      // Итого по постерминалу
      if (vInfo[i].irSpecial = vInfo_Special_Base - vInfo_Special_Credit) then
      begin
        vInfo[i].irCountCash := Total_Count_Credit;
        vInfo[i].irSumCash := Total_Sum_Credit;
      end;
      // Итого по наличности
      if (vInfo[i].irSpecial = vInfo_Special_Base - vInfo_Special_Cash) then
      begin
        vInfo[i].irCountCash := Total_Count_Cash + Total_Count_Cheqed;
        vInfo[i].irSumCash := Total_Sum_Cash + Total_Sum_Cheqed;
      end;
      // Итого по всем
      if (vInfo[i].irSpecial = vInfo_Special_Base - vInfo_Special_Total) then
      begin
        vInfo[i].irCountCash := Total_Count_Cash + Total_Count_Cheqed + Total_Count_Credit +
          Total_Count_NotPaid;
        vInfo[i].irSumCash := Total_Sum_Cash + Total_Sum_Cheqed + Total_Sum_Credit;
      end;
    end; // for i := Low(vInfo) to High(vInfo) do
  end;
  Count_All := Count_Local_All + Count_Net_All;
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  s := Format('Помеч. %u, своб. [%u] из %u. Сеть: %u из %u. Сломано = %u.',
    [Count_Local_Sel, Count_Free,
    Count_All, Count_Net_Sel, Count_Net_All, Count_Broken]);
  DEBUGMessEnh(0, UnitName, ProcName, '[ ' + IntToStr(Cho) + ' ] Length(' + IntToStr(length(s))
    + ') = "' + s + '"');
  fm_Main.st_Info.Caption := Format('Помеч. %u из %u своб. На продажу %u билета(ов), %u тенге.',
    [Count_Local_Sel, Count_Free, Count_Prepared, Sum_Prepared]);
  fm_Main.st_Info.Hint := fm_Main.st_Info.Caption;
  UpdateInfoView(False);
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

end.

