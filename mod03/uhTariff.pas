{-----------------------------------------------------------------------------
 Unit Name: uhTariff
 Author:    n0mad
 Version:   1.1.6.87
 Creation:  27.08.2003
 Purpose:   Tariff helper
 History:
-----------------------------------------------------------------------------}
unit uhTariff;

interface

{$I kinode01.inc}

uses
  Classes, Gauges, Extctrls, Forms, Menus, Controls, Graphics;

function Load_All_Tariffs: boolean;
function Get_Tariff_Desc(i_Tariff: Integer; var s_Nam, s_Desc, s_Comment: string;
  var i_Base_Cost: Integer; var b_Freezed: Boolean): Integer;
// --------------------------------------------------------------------------

implementation

uses
  Bugger, SysUtils, StrConsts, uTools, udBase, urCommon;

const
  UnitName: string = 'uhTariff';

function Load_All_Tariffs: boolean;
const
  ProcName: string = 'Load_All_Tariffs';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
begin
  Time_Start := Now;
  // --------------------------------------------------------------------------
  // 2.3) Загрузка всех тарифов
  // --------------------------------------------------------------------------
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  Result := false;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMessEnh(0, UnitName, ProcName, 'Work time - (' + IntToStr(Hour) + ':' +
    FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0')
    + ')');
end;

function Get_Tariff_Desc(i_Tariff: Integer; var s_Nam, s_Desc, s_Comment: string;
  var i_Base_Cost: Integer; var b_Freezed: Boolean): Integer;
const
  ProcName: string = 'Get_Tariff_Desc';
begin
  // --------------------------------------------------------------------------
  // Загрузка тарифа из запроса
  // --------------------------------------------------------------------------
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  s_Nam := '<none>';
  s_Desc := '<none>';
  s_Comment := '<none>';
  i_Base_Cost := 0;
  b_Freezed := false;
  Result := 0;
  with dm_Base.ds_Tariff do
  begin
    if (not Active) then
    begin
      try
        Close;
        Prepare;
        Open;
        First;
        Last;
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
    end;
    if Active then
    begin
      First;
      if Assigned(FieldByName(s_TARIFF_KOD)) then
      begin
        if Locate(s_TARIFF_KOD, i_Tariff, []) then
        begin
          if Assigned(FieldByName(s_TARIFF_NAM)) then
            s_Nam := FieldByName(s_TARIFF_NAM).AsString;
          if Assigned(FieldByName(s_TARIFF_DESC)) then
            s_Desc := FieldByName(s_TARIFF_DESC).AsString;
          if Assigned(FieldByName(s_TARIFF_COMMENT)) then
            s_Comment := FieldByName(s_TARIFF_COMMENT).AsString;
          if Assigned(FieldByName(s_TARIFF_BASE_COST)) then
            i_Base_Cost := FieldByName(s_TARIFF_BASE_COST).AsInteger;
          if Assigned(FieldByName(s_TARIFF_FREEZED)) then
            b_Freezed := (FieldByName(s_TARIFF_FREEZED).AsInteger <> 0);
          DEBUGMessEnh(0, UnitName, ProcName, 'Found - s_Nam = (' + s_Nam + '), i_Base_Cost = (' +
            IntToStr(i_Base_Cost) + '), b_Freezed = ' + BoolYesNo[b_Freezed]);
          Result := 1;
        end
        else
          DEBUGMessEnh(0, UnitName, ProcName, 'Tariff with ID = (' +
            IntToStr(i_Tariff) + ') not found.');
      end
      else
        DEBUGMessEnh(0, UnitName, ProcName, s_TARIFF_KOD + ' field not found in dataset.');
    end
    else
      DEBUGMessEnh(0, UnitName, ProcName, 'Tariff dataset is not active.');
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

end.

