{-----------------------------------------------------------------------------
 Unit Name: uhTicket
 Author:    n0mad
 Version:   1.1.7.94
 Creation:  27.08.2003
 Purpose:   Main form helper
 History:
-----------------------------------------------------------------------------}
unit uhTicket;

interface

{$I kinode01.inc}

uses
  Classes, Db, Gauges, Extctrls, Forms, Menus, Controls, Graphics, ComCtrls;

type
  PCreateMenuRec = ^TCreateMenuRec;
  TCreateMenuRec = record
    fTicketImageList: TImageList;
    fTicketPopupMenu: TPopupMenu;
    fIndexFreeTicketSubMenu, fIndexPaidTicketSubMenu, fIndexInsertStart,
      fIndexInsertFinish: integer;
    fIndexAllTicketSubMenuSplit: integer;
    fAllTicketSubMenu: TMenuItem;
    fMenuFont: TFont;
    fTicketRightClick: TNotifyEvent;
    fvInfoShift: Integer;
  end;

  TInfoRec = record
    irLvIdx: Integer;
    irKod: Integer;
    irName: string;
    irBgColor: TColor;
    irFontColor: TColor;
    // bPrint: Boolean;
    irbFree: Boolean;
    // bInvited: Boolean;
    // bGroup: Boolean;
    // bVipCard: Boolean;
    // bVipByName: Boolean;
    // bSeason: Boolean;
    // bSerial: Boolean;
    // MenuOrder: Integer;
    irSpecial: Integer;
    irCost: Integer;
    irCountPrep: Integer;
    irSumPrep: Integer;
    irCountCash: Integer;
    irSumCash: Integer;
    irCountCredit: Integer;
    irSumCredit: Integer;
  end;

function Get_Caption_Length(_Text: string; _Font: TFont): Integer;
function Get_Caption_Max_Len(_Text: string; _FillChar: Char; MaxW: Integer; _Font: TFont): Integer;
function Load_All_Ticket_Types(const TicketImageList: TImageList; const
  TicketPopupMenu: TPopupMenu; const IndexFreeTicketSubMenu,
  IndexPaidTicketSubMenu, IndexInsertStart, IndexInsertFinish: Integer; const
  AllTicketSubMenu: TMenuItem; const MenuFont: TFont; const TicketRightClick:
  TNotifyEvent): Boolean; // Загрузка всех типов билетов
function Load_Tariff(NewRepert: integer; var RateDesc: string; TicketPopupMenu:
  TPopupMenu; PaidTicketSubMenu, AllTicketSubMenu: TMenuItem; MenuFont: TFont):
  integer; // Загрузка тарифов для этого репертуара

const
  Max_MenuText_Width: Integer = 100;
  vInfo_Special_Base: Integer = -5000;
  vInfo_Special_Delim: Integer = 0;
  vInfo_Special_Sale: Integer = 11;
  vInfo_Special_Selected: Integer = 12;
  vInfo_Special_Free: Integer = 13;
  vInfo_Special_Skiped: Integer = 14;
  vInfo_Special_Reserved: Integer = 21;
  vInfo_Special_Credit: Integer = 22;
  vInfo_Special_Cash: Integer = 23;
  vInfo_Special_Total: Integer = 24;

var
  vInfo: array of TInfoRec;

implementation

uses
  SysUtils, Math, Bugger, uTools, uhCommon, udBase, ufMain, uhMain,
  urLoader, urCommon, StrConsts, ufInfo;

const
  UnitName: string = 'uhTicket';

function Get_Caption_Length(_Text: string; _Font: TFont): Integer;
var
  Bitmap: TBitmap;
begin
  Result := 0;
  if (length(_Text) > 0) and Assigned(_Font) then
  begin
    Bitmap := TBitmap.Create;
    try
      Bitmap.Canvas.Font.Assign(_Font);
      Result := Bitmap.Canvas.TextWidth(_Text);
    finally
      Bitmap.Free;
    end;
  end;
end;

function Get_Caption_Max_Len(_Text: string; _FillChar: Char; MaxW: Integer; _Font: TFont): Integer;
var
  len: Integer;
  s: string;
begin
  Result := -1;
  if (MaxW > 0) and Assigned(_Font) then
  begin
    len := 0;
    s := '';
    if Get_Caption_Length(_Text, _Font) < MaxW then
    begin
      len := Length(_Text) + 1;
      s := _Text + _FillChar;
    end;
    while Get_Caption_Length(s, _Font) < MaxW do
    begin
      if Length(_Text) > len then
        s := Copy(_Text, 1, len)
      else
        s := _Text + StringOfChar(_FillChar, len);
      Inc(len);
    end;
    Result := len;
  end;
end;

function Get_Rate_Desc(i_Rate, i_Ticket: Integer; var i_Cost: Integer; var b_Freezed: Boolean):
  Integer;
const
  ProcName: string = 'Get_Rate_Desc';
begin
  // --------------------------------------------------------------------------
  // Загрузка тарифа из запроса
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  i_Cost := 0;
  b_Freezed := false;
  Result := 0;
  {
  SELECT
      WOR.WORTH_KOD,
      WOR.WORTH_RATE,
      WOR.RATE_DESC,
      WOR.WORTH_TICKET,
      WOR.TICKET_NAM,
      WOR.WORTH_VALUE,
      WOR.WORTH_TAG,
      WOR.USERID
  FROM
      WORTH_VIEW WOR
  WHERE
      (
      (:PARAM1 = 0)
      OR
      (WORTH_RATE = :PARAM1)
      )
  }
  if (i_Rate > 0) then
  begin
    with dm_Base.ds_Cost do
    begin
      if Assigned(Params.FindParam(s_IN_FILT_TARIFF_KOD)) then
        if (not Active) or ((i_Rate > 0)
          and (ParamByName(s_IN_FILT_TARIFF_KOD).AsInteger <> i_Rate)) then
        begin
{$IFDEF Debug_Level_6}
          DEBUGMessEnh(0, UnitName, ProcName, 'Reopen for ' + s_IN_FILT_TARIFF_KOD + ' = (' +
            IntToStr(i_Rate) + ')');
{$ENDIF}
          try
            Close;
            ParamByName(s_IN_FILT_TARIFF_KOD).AsInteger := i_Rate;
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
        if (Assigned(FieldByName(s_COST_VALUE)) and
          Assigned(FieldByName(s_COST_TICKET_KOD))) then
          if Locate(s_COST_TICKET_KOD, i_Ticket, []) then
          begin
            i_Cost := FieldByName(s_COST_VALUE).AsInteger;
            b_Freezed := (FieldByName(s_COST_FREEZED).AsInteger <> 0);
{$IFDEF Debug_Level_9}
            DEBUGMessEnh(0, UnitName, ProcName, 'i_Cost = (' + IntToStr(i_Cost) + ')');
{$ENDIF}
            Result := 1;
          end;
      end
      else // if Active then
        DEBUGMessEnh(0, UnitName, ProcName, 'Cost for i_Rate = (' +
          IntToStr(i_Rate) + ') not found.');
    end;
  end
  else // if (i_Rate > 0) then
  begin
{$IFDEF Debug_Level_9}
    DEBUGMessEnh(0, UnitName, ProcName, 'Cost for i_Rate = (' +
      IntToStr(i_Rate) + ') not searched.');
{$ENDIF}
  end;
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Modify_Ticket_Desc(_Rate: integer; TicketPopupMenu: TPopupMenu;
  PaidTicketSubMenu, AllTicketSubMenu: TMenuItem; MenuFont: TFont);
// ready partially
const
  ProcName: string = 'Modify_Ticket_Desc';
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  function Get_Caption_Addon(_Text: string; MaxW: Integer; _Font: TFont):
      Integer;
  var
    len: Integer;
  begin
    Result := -1;
    if (MaxW > 0) and Assigned(_Font) then
    begin
      len := 0;
      while Get_Caption_Length(_Text + StringOfChar(c_Space, len), _Font) < MaxW do
        Inc(len);
      Result := len;
    end;
  end;
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  procedure Modify_Menu(i_Ticket: Integer; var Caption: string; var Freezed: Boolean);
  var
    i1, p1, i_Cost: Integer;
    s1, s2: string;
  begin
    p1 := Pos(c_Menu_In_Str, Caption);
    Freezed := false;
    if (i_Ticket > 0) and (p1 > 0) then
    begin
      s2 := '';
      if (Get_Rate_Desc(_Rate, i_Ticket, i_Cost, Freezed) > 0) then
        if (i_Cost > 0) then
          s2 := Format('%8u', [i_Cost]) + c_Space + c_Valuta
        else
          s2 := '0';
      s1 := Copy(Caption, 1, p1 + Length(c_Menu_In_Str) - 1);
      i1 := -1;
      if (Max_MenuText_Width > 0) and Assigned(MenuFont) then
        i1 := Get_Caption_Addon(s1, Max_MenuText_Width, MenuFont);
      if i1 < 0 then
        i1 := 2;
      Caption := s1 + StringOfChar(c_Space, i1 + 1) + s2;
{$IFDEF Debug_Level_9}
      DEBUGMessEnh(0, UnitName, ProcName, 'Cap[' + IntToStr(i_Ticket) + '] = "'
        + Caption + '".');
{$ENDIF}
    end; // if
  end;
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  procedure Modify_vInfo(i_Ticket: Integer; var i_Cost: integer; var Freezed, ForFree: Boolean);
  begin
    i_Cost := 0;
    Freezed := false;
    ForFree := true;
    if (i_Ticket > 0) then
    begin
      if (Get_Rate_Desc(_Rate, i_Ticket, i_Cost, Freezed) > 0) then
        ForFree := false;
{$IFDEF Debug_Level_9}
      DEBUGMessEnh(0, UnitName, ProcName, 'i_Cost[' + IntToStr(i_Ticket) + '] = "'
        + IntToStr(i_Cost) + '".');
{$ENDIF}
    end; // if
  end;
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var
  i: Integer;
  s: string;
  frz, ffr: Boolean;
  vCost: Integer;
begin
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  if Assigned(TicketPopupMenu) then
    with TicketPopupMenu do
      for i := 0 to Items.Count - 1 do
      begin
        s := Items[i].Caption;
        Modify_Menu(Items[i].Tag, s, frz);
        Items[i].Caption := s;
        Items[i].Visible := not frz;
      end;
  if Assigned(PaidTicketSubMenu) then
    with PaidTicketSubMenu do
      for i := 0 to Count - 1 do
      begin
        s := Items[i].Caption;
        Modify_Menu(Items[i].Tag, s, frz);
        Items[i].Caption := s;
        Items[i].Visible := not frz;
      end;
  if Assigned(AllTicketSubMenu) then
    with AllTicketSubMenu do
      for i := 0 to Count - 1 do
      begin
        s := Items[i].Caption;
        Modify_Menu(Items[i].Tag, s, frz);
        Items[i].Caption := s;
        Items[i].Visible := not frz;
{$IFDEF Debug_Level_6}
        if Items[i].Visible and (Items[i].Tag > 0) then
          DEBUGMessEnh(0, UnitName, ProcName, 'Cap[' + FixFmt(Items[i].Tag, 2, '0')
            + '] = "' + s + '".');
{$ENDIF}
      end;
  for i := Low(vInfo) to High(vInfo) do
  begin
    if (vInfo[i].irSpecial < vInfo_Special_Base) then
    begin
      vInfo[i].irCost := 0;
      vInfo[i].irCountCash := 0;
      if (_Rate > 0) then
        vInfo[i].irSumCash := 0
      else
        vInfo[i].irSumCash := -1;
    end
    else if (vInfo[i].irSpecial > vInfo_Special_Base) then
    begin
      // --------------------------------------------------------------------------
      try
        Modify_vInfo(vInfo[i].irKod, vCost, frz, ffr);
        vInfo[i].irCost := vCost;
        vInfo[i].irCountCash := 0;
        if (_Rate > 0) then
          vInfo[i].irSumCash := 0
        else
          vInfo[i].irSumCash := -1;
      except
      end;
    end; // if
  end; // for
  UpdateInfoView(False);
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

function Load_Tariff(NewRepert: integer; var RateDesc: string; TicketPopupMenu:
  TPopupMenu; PaidTicketSubMenu, AllTicketSubMenu: TMenuItem; MenuFont: TFont):
  integer; // Загрузка тарифов для этого репертуара
const
  ProcName: string = 'Load_Tariff';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  i_Rate: Integer;
begin
  Time_Start := Now;
  DEBUGMessBrk(0, 'Load Tariff Start');
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  // Загрузка тарифов для этого репертуара
  // --------------------------------------------------------------------------
  // 1) Фильтр на ds_Cost_View
  // --------------------------------------------------------------------------
  Result := 0;
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  i_Rate := -1;
  with dm_Base.ds_Repert do
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
      if Locate(s_REPERT_KOD, NewRepert, []) then
      begin
        i_Rate := FieldByName(s_REPERT_TARIFF_KOD).AsInteger;
        RateDesc := ' ' + FieldByName(s_TARIFF_DESC).AsString + ' ';
      end
      else
      begin
        RateDesc := ''; // StringOfChar(' ', 40);
      end;
    end;
    {
    if i_Rate > -1 then
    begin
      //
    end;
    }
    Modify_Ticket_Desc(i_Rate, TicketPopupMenu, PaidTicketSubMenu,
      AllTicketSubMenu, MenuFont);
    Cur_Tarif := i_Rate;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  DEBUGMessBrk(0, 'Load Tariff End');
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMessEnh(0, UnitName, ProcName, 'Work time - (' + IntToStr(Hour) + ':' +
    FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0')
    + ')');
end;

procedure Clear_User_Interface(const TicketImageList: TImageList; const
  TicketPopupMenu: TPopupMenu; var vIndexFreeTicketSubMenu,
  vIndexPaidTicketSubMenu, vIndexInsertStart, vIndexInsertFinish: Integer; const
  AllTicketSubMenu: TMenuItem);
const
  ProcName: string = 'Clear_User_Interface';
var
  tmpMenuItem, FreeMenuItem, PaidMenuItem: TMenuItem;
  check1, check2, check3: boolean;
  i: integer;
begin
  // --------------------------------------------------------------------------
  // Очистка интерфейса (меню и списка картинок)
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_7}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  // with fmMain do
  begin
    if Assigned(TicketImageList) then
      TicketImageList.Clear;
    if Assigned(TicketPopupMenu) then
    begin
      check1 := ((vIndexFreeTicketSubMenu > -1) and (vIndexFreeTicketSubMenu <
        TicketPopupMenu.Items.Count));
      check2 := ((vIndexPaidTicketSubMenu > -1) and (vIndexPaidTicketSubMenu <
        TicketPopupMenu.Items.Count));
      check3 := ((vIndexInsertStart > -1) and (vIndexInsertStart <
        TicketPopupMenu.Items.Count)
        and (vIndexInsertFinish > -1) and (vIndexInsertFinish <
        TicketPopupMenu.Items.Count)
        and (vIndexInsertFinish > vIndexInsertStart));
      FreeMenuItem := nil;
      PaidMenuItem := nil;
      if check1 then
      try
        FreeMenuItem := TicketPopupMenu.Items[vIndexFreeTicketSubMenu];
        FreeMenuItem.Clear;
{$IFDEF Debug_Level_7}
        DEBUGMessEnh(0, UnitName, ProcName, 'FreeMenuItem[' +
          IntToStr(FreeMenuItem.MenuIndex) + '] = ' + FreeMenuItem.Caption);
{$ENDIF}
      except
      end;
      if check2 then
      try
        PaidMenuItem := TicketPopupMenu.Items[vIndexPaidTicketSubMenu];
        PaidMenuItem.Clear;
{$IFDEF Debug_Level_7}
        DEBUGMessEnh(0, UnitName, ProcName, 'PaidMenuItem[' +
          IntToStr(PaidMenuItem.MenuIndex) + '] = ' + PaidMenuItem.Caption);
{$ENDIF}
      except
      end;
      i := vIndexInsertStart + 1;
      with TicketPopupMenu do
        if check1 and check2 and check3 then
        begin
          try
{$IFDEF Debug_Level_7}
            tmpMenuItem := TicketPopupMenu.Items[vIndexInsertStart];
            DEBUGMessEnh(0, UnitName, ProcName, 'InsertStartMenu[' +
              IntToStr(tmpMenuItem.MenuIndex) + '] = ' + tmpMenuItem.Caption);
{$ENDIF}
            tmpMenuItem := TicketPopupMenu.Items[vIndexInsertFinish];
{$IFDEF Debug_Level_7}
            DEBUGMessEnh(0, UnitName, ProcName, 'InsertFinishMenu[' +
              IntToStr(tmpMenuItem.MenuIndex) + '] = ' + tmpMenuItem.Caption);
{$ENDIF}
            while (i < tmpMenuItem.MenuIndex) and (i < Items.Count) do
            begin
              if (Items[i].Tag > 0) or ((Items[i].Tag = -1)) then
              begin
{$IFDEF Debug_Level_7}
                DEBUGMessEnh(0, UnitName, ProcName, 'Deleted menuitem[' +
                  IntToStr(i) + '] - (' + Items[i].Caption + ')');
{$ENDIF}
                Items.Delete(i);
              end
              else
                inc(i);
            end;
            vIndexInsertFinish := tmpMenuItem.MenuIndex;
{$IFDEF Debug_Level_7}
            DEBUGMessEnh(0, UnitName, ProcName, 'InsertFinishMenu[' +
              IntToStr(tmpMenuItem.MenuIndex) + '] = ' + tmpMenuItem.Caption);
{$ENDIF}
          except
          end;
          if Assigned(FreeMenuItem) then
          try
            vIndexFreeTicketSubMenu := FreeMenuItem.MenuIndex;
{$IFDEF Debug_Level_7}
            DEBUGMessEnh(0, UnitName, ProcName, 'FreeMenuItem[' +
              IntToStr(FreeMenuItem.MenuIndex) + '] = ' + FreeMenuItem.Caption);
{$ENDIF}
          except
          end;
          if Assigned(PaidMenuItem) then
          try
            vIndexPaidTicketSubMenu := PaidMenuItem.MenuIndex;
{$IFDEF Debug_Level_7}
            DEBUGMessEnh(0, UnitName, ProcName, 'PaidMenuItem[' +
              IntToStr(PaidMenuItem.MenuIndex) + '] = ' + PaidMenuItem.Caption);
{$ENDIF}
          except
          end;
        end;
    end;
    if Assigned(AllTicketSubMenu) then
    begin
      AllTicketSubMenu.Clear;
    end;
  end;
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_7}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Load_User_Interface_Info_Start(const TicketImageList: TImageList; const
  TicketPopupMenu: TPopupMenu;
  const IndexFreeTicketSubMenu, IndexPaidTicketSubMenu, IndexInsertStart,
  IndexInsertFinish: integer;
  const AllTicketSubMenu: TMenuItem);
const
  ProcName: string = 'Load_User_Interface_Info_Start';
var
  sh, k: Integer;
  // index: Integer;
  // bm: TBitmap;
begin
{$IFDEF Debug_Level_7}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  with dm_Base do
  begin
    {
    // if Assigned(fm_Main) then
    bm := TBitmap.Create;
    with bm do
    try
      Width := TicketImageList.Width;
      Height := TicketImageList.Height;
      Canvas.Pen.Style := psSolid;
      Transparent := true;
      TransparentMode := tmFixed;
      TransparentColor := clBtnFace;
      Canvas.Brush.Color := TransparentColor;
      Canvas.Pen.Color := TransparentColor;
      Canvas.Rectangle(0, 0, Width, Height);
      Canvas.Pen.Color := clBlack;
      Canvas.Brush.Color := fm_Main.tcx_Select.SelectBrush.Color;
      Canvas.Rectangle(0, 2, Width, Height - 2);
      Canvas.Pen.Color := fm_Main.tcx_Select.SelectFont.Color;
      Canvas.Brush.Style := bsClear;
      // Canvas.Rectangle(6, 4, Width - 6, Height - 4);
      //Canvas.Rectangle(2, 4, Width div 3 + 2, Height div 3 + 2);
      Canvas.Rectangle(2 * Width div 3, 2 * Height div 3 - 2, Width - 2, Height - 4);
      // index := TicketImageList.Add(bm, nil);
    finally
    end;
    }
    // --------------------------------------------------------------------------
    try
      SetLength(vInfo, 4);
      sh := 0;
      k := 0;
      // --------------------------------------------------------------------------
      if (Low(vInfo) <= (sh + k)) and ((sh + k) <= High(vInfo)) then
      begin
        vInfo[sh + k].irLvIdx := -1;
        vInfo[sh + k].irKod := vInfo_Special_Base - vInfo_Special_Sale;
        vInfo[sh + k].irName := 'Итого на продажу';
        vInfo[sh + k].irBgColor := clSilver;
        vInfo[sh + k].irFontColor := clBlack;
        vInfo[sh + k].irbFree := false;
        vInfo[sh + k].irSpecial := vInfo[sh + k].irKod;
        vInfo[sh + k].irCost := -1;
        vInfo[sh + k].irCountCash := -1;
        vInfo[sh + k].irSumCash := -1;
      end
      else
        DEBUGMessEnh(0, UnitName, ProcName, 'Error: (sh + k) = ' +
          IntToStr(sh + k) + ' out of vInfo range.');
      // --------------------------------------------------------------------------
      Inc(k);
      if (Low(vInfo) <= (sh + k)) and ((sh + k) <= High(vInfo)) then
      begin
        vInfo[sh + k].irLvIdx := -1;
        vInfo[sh + k].irKod := vInfo_Special_Base - vInfo_Special_Selected;
        vInfo[sh + k].irName := 'Помеченные места';
        vInfo[sh + k].irBgColor := clRed; // fm_Main.tcx_Select.SelectBrush.Color;
        vInfo[sh + k].irFontColor := clWhite; // fm_Main.tcx_Select.SelectFont.Color;
        vInfo[sh + k].irbFree := false;
        vInfo[sh + k].irSpecial := vInfo[sh + k].irKod;
        vInfo[sh + k].irCost := -1;
        vInfo[sh + k].irCountCash := -1;
        vInfo[sh + k].irSumCash := -1;
      end
      else
        DEBUGMessEnh(0, UnitName, ProcName, 'Error: (sh + k) = ' +
          IntToStr(sh + k) + ' out of vInfo range.');
      // --------------------------------------------------------------------------
      Inc(k);
      if (Low(vInfo) <= (sh + k)) and ((sh + k) <= High(vInfo)) then
      begin
        vInfo[sh + k].irLvIdx := -1;
        vInfo[sh + k].irKod := vInfo_Special_Base - vInfo_Special_Free;
        vInfo[sh + k].irName := 'Свободные места';
        vInfo[sh + k].irBgColor := clWhite; // fm_Main.tcx_Select.RegularBrush.Color;
        vInfo[sh + k].irFontColor := clBlack; // fm_Main.tcx_Select.RegularFont.Color;
        vInfo[sh + k].irbFree := false;
        vInfo[sh + k].irSpecial := vInfo[sh + k].irKod;
        vInfo[sh + k].irCost := -1;
        vInfo[sh + k].irCountCash := -1;
        vInfo[sh + k].irSumCash := -1;
      end
      else
        DEBUGMessEnh(0, UnitName, ProcName, 'Error: (sh + k) = ' +
          IntToStr(sh + k) + ' out of vInfo range.');
      // --------------------------------------------------------------------------
      Inc(k);
      if (Low(vInfo) <= (sh + k)) and ((sh + k) <= High(vInfo)) then
      begin
        vInfo[sh + k].irLvIdx := -1;
        vInfo[sh + k].irKod := vInfo_Special_Base - vInfo_Special_Delim;
        vInfo[sh + k].irName := StringOfChar('-', 40);
        vInfo[sh + k].irBgColor := clWindow;
        vInfo[sh + k].irFontColor := clWindow;
        vInfo[sh + k].irbFree := false;
        vInfo[sh + k].irSpecial := vInfo[sh + k].irKod;
        vInfo[sh + k].irCost := -1;
        vInfo[sh + k].irCountCash := -1;
        vInfo[sh + k].irSumCash := -1;
      end
      else
        DEBUGMessEnh(0, UnitName, ProcName, 'Error: (sh + k) = ' +
          IntToStr(sh + k) + ' out of vInfo range.');
      // --------------------------------------------------------------------------
    except
      on E: Exception do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
        DEBUGMessEnh(0, UnitName, ProcName, 'Adding at begin of vInfo failed.');
      end;
    end; // try
  end; // with dm_Base do
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_7}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Add_Ticket_Desc(i_TICKET_KOD: integer;
  str_TICKET_NAM, str_TICKET_LABEL: string;
  b_TICKET_SERIAL: boolean;
  i_TICKET_CLASS: integer;
  b_CLASS_PRINT, b_CLASS_FREE, b_CLASS_GUEST,
  b_CLASS_GROUPED, b_CLASS_CARDED1, b_CLASS_CARDED2, b_CLASS_ABON: boolean;
  c_TICKET_BGCOLOR, c_TICKET_FNTCOLOR: TColor;
  i_TICKET_MENU_ORDER: integer;
  PointerToData: Pointer);
const
  ProcName: string = 'Add_Ticket_Desc';
var
  check1, check2, check3: boolean;
  tmpMenuItem, tmpMenuItem2nd, FreeTicketSubMenu, PaidTicketSubMenu: TMenuItem;
  bm: TBitmap;
  Index, vidx: integer;
  CreateMenuRec: PCreateMenuRec;
  // vStr: string;
begin
  // --------------------------------------------------------------------------
  // Добавление типа билета в интерфейс
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_7}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  DEBUGMessEnh(0, UnitName, ProcName, 'Ticket_Kod = (' + IntToStr(i_Ticket_Kod) + ')');
{$ENDIF}
  if Assigned(PointerToData) then
  begin
    CreateMenuRec := PointerToData;
    if Assigned(CreateMenuRec^.fTicketImageList)
      and Assigned(CreateMenuRec^.fTicketPopupMenu)
      and Assigned(CreateMenuRec^.fAllTicketSubMenu)
      and Assigned(CreateMenuRec^.fMenuFont)
      and Assigned(CreateMenuRec^.fTicketRightClick) then
    begin
      check1 := ((CreateMenuRec^.fIndexFreeTicketSubMenu > -1) and
        (CreateMenuRec^.fIndexFreeTicketSubMenu <
        CreateMenuRec^.fTicketPopupMenu.Items.Count));
      check2 := ((CreateMenuRec^.fIndexPaidTicketSubMenu > -1) and
        (CreateMenuRec^.fIndexPaidTicketSubMenu <
        CreateMenuRec^.fTicketPopupMenu.Items.Count));
      check3 := ((CreateMenuRec^.fIndexInsertStart > -1) and
        (CreateMenuRec^.fIndexInsertStart <
        CreateMenuRec^.fTicketPopupMenu.Items.Count)
        and (CreateMenuRec^.fIndexInsertFinish > -1) and
        (CreateMenuRec^.fIndexInsertFinish <
        CreateMenuRec^.fTicketPopupMenu.Items.Count)
        and (CreateMenuRec^.fIndexInsertFinish >
        CreateMenuRec^.fIndexInsertStart));
      if check1 and check2 and check3 then
      begin
        // --------------------------------------------------------------------------
        // Создание картинки
        // --------------------------------------------------------------------------
        bm := TBitmap.Create;
        with bm do
        try
          Width := CreateMenuRec^.fTicketImageList.Width;
          Height := CreateMenuRec^.fTicketImageList.Height;
          Canvas.Pen.Style := psSolid;
          Transparent := true;
          TransparentMode := tmFixed;
          TransparentColor := clBtnFace;
          Canvas.Brush.Color := TransparentColor;
          Canvas.Pen.Color := TransparentColor;
          Canvas.Rectangle(0, 0, Width, Height);
          Canvas.Pen.Color := clBlack;
          Canvas.Brush.Color := TColor(c_TICKET_BGCOLOR);
          Canvas.Rectangle(0, 2, Width, Height - 2);
          Canvas.Pen.Color := TColor(c_TICKET_FNTCOLOR);
          Canvas.Brush.Style := bsClear;
          // Canvas.Rectangle(6, 4, Width - 6, Height - 4);
          //Canvas.Rectangle(2, 4, Width div 3 + 2, Height div 3 + 2);
          Canvas.Rectangle(2 * Width div 3, 2 * Height div 3 - 2,
            Width - 2, Height - 4);
          index := CreateMenuRec^.fTicketImageList.Add(bm, nil);
        finally
        end;
        // --------------------------------------------------------------------------
        // Создание меню
        // --------------------------------------------------------------------------
        FreeTicketSubMenu :=
          CreateMenuRec^.fTicketPopupMenu.Items[CreateMenuRec^.fIndexFreeTicketSubMenu];
{$IFDEF Debug_Level_7}
        DEBUGMessEnh(0, UnitName, ProcName, 'FreeTicketSubMenu[' +
          IntToStr(CreateMenuRec^.fIndexFreeTicketSubMenu) + ',' +
          IntToStr(FreeTicketSubMenu.MenuIndex) + '] = ' +
          FreeTicketSubMenu.Caption);
{$ENDIF}
        PaidTicketSubMenu :=
          CreateMenuRec^.fTicketPopupMenu.Items[CreateMenuRec^.fIndexPaidTicketSubMenu];
{$IFDEF Debug_Level_7}
        DEBUGMessEnh(0, UnitName, ProcName, 'PaidTicketSubMenu[' +
          IntToStr(CreateMenuRec^.fIndexPaidTicketSubMenu) + ',' +
          IntToStr(PaidTicketSubMenu.MenuIndex) + '] = ' +
          PaidTicketSubMenu.Caption);
{$ENDIF}
        if i_TICKET_MENU_ORDER = 0 then
        begin
          if b_CLASS_FREE then
          begin
            tmpMenuItem := TMenuItem.Create(FreeTicketSubMenu);
            tmpMenuItem.Name := 'mi_Free_' + FixFmt(i_TICKET_KOD, 14, '0');
            // submenu for free types
            tmpMenuItem.Caption := FixFmt(i_TICKET_CLASS, 2, ' ') + ':' +
              FixFmt(i_TICKET_KOD, 2, '0') + ' - "' + str_Ticket_Nam + '"';
            FreeTicketSubMenu.Add(tmpMenuItem);
{$IFDEF Debug_Level_7}
            DEBUGMessEnh(0, UnitName, ProcName, 'tmpMenuItem1[' +
              IntToStr(i_Ticket_Kod) + ',' + IntToStr(tmpMenuItem.MenuIndex) +
              '] = ' + tmpMenuItem.Caption);
{$ENDIF}
          end
          else
          begin
            tmpMenuItem := TMenuItem.Create(PaidTicketSubMenu);
            tmpMenuItem.Name := 'mi_Paid_' + FixFmt(i_TICKET_KOD, 14, '0');
            // submenu for other types
            tmpMenuItem.Caption := FixFmt(i_TICKET_CLASS, 2, ' ') + ':' +
              FixFmt(i_TICKET_KOD, 2, '0') + ' - "' + str_Ticket_Nam + '"';
            tmpMenuItem.Caption := tmpMenuItem.Caption + c_Menu_In_Str;
            PaidTicketSubMenu.Add(tmpMenuItem);
{$IFDEF Debug_Level_7}
            DEBUGMessEnh(0, UnitName, ProcName, 'tmpMenuItem2[' + IntToStr(i_Ticket_Kod) + ',' +
              IntToStr(tmpMenuItem.MenuIndex) + '] = ' + tmpMenuItem.Caption);
{$ENDIF}
          end;
        end
        else
        begin
          tmpMenuItem2nd :=
            CreateMenuRec^.fTicketPopupMenu.Items[CreateMenuRec^.fIndexInsertFinish];
{$IFDEF Debug_Level_7}
          DEBUGMessEnh(0, UnitName, ProcName, 'InsertFinishMenu[' +
            IntToStr(CreateMenuRec^.fIndexInsertStart) + ',' + IntToStr(tmpMenuItem2nd.MenuIndex) +
            '] = ' + tmpMenuItem2nd.Caption);
{$ENDIF}
          tmpMenuItem := TMenuItem.Create(CreateMenuRec^.fTicketPopupMenu);
          tmpMenuItem.Name := 'mi_MostUsed_' + FixFmt(i_TICKET_KOD, 14, '0');
          // upper level
          tmpMenuItem.Caption := FixFmt(i_TICKET_CLASS, 2, ' ') + ':' +
            FixFmt(i_TICKET_KOD, 2, '0') + ' - "' + str_Ticket_Nam + '"';
          if not b_CLASS_FREE then
            tmpMenuItem.Caption := tmpMenuItem.Caption + c_Menu_In_Str;
          CreateMenuRec^.fTicketPopupMenu.Items.Insert(CreateMenuRec^.fIndexInsertFinish,
            tmpMenuItem);
{$IFDEF Debug_Level_7}
          DEBUGMessEnh(0, UnitName, ProcName, 'tmpMenuItem3[' + IntToStr(i_Ticket_Kod) + ',' +
            IntToStr(tmpMenuItem.MenuIndex) + '] = ' + tmpMenuItem.Caption);
{$ENDIF}
          CreateMenuRec^.fIndexInsertFinish := tmpMenuItem2nd.MenuIndex;
          CreateMenuRec^.fIndexFreeTicketSubMenu := FreeTicketSubMenu.MenuIndex;
          CreateMenuRec^.fIndexPaidTicketSubMenu := PaidTicketSubMenu.MenuIndex;
        end;
        if Assigned(tmpMenuItem) then
        begin
          tmpMenuItem.ImageIndex := index;
          tmpMenuItem.Tag := i_TICKET_KOD;
          tmpMenuItem.GroupIndex := i_TICKET_CLASS;
          tmpMenuItem.OnClick := CreateMenuRec^.fTicketRightClick;
          Max_MenuText_Width := Max(Max_MenuText_Width,
            Get_Caption_Length(tmpMenuItem.Caption, CreateMenuRec^.fMenuFont));
          // --------------------------------------------------------------------------
          // Полный список в главном меню
          // --------------------------------------------------------------------------
          tmpMenuItem2nd := TMenuItem.Create(CreateMenuRec^.fAllTicketSubMenu);
          // tmpMenuItem.Name := 'mi_AllTicket_' + FixFmt(i_TICKET_KOD, 14, '0');
          tmpMenuItem2nd.Caption := tmpMenuItem.Caption;
          tmpMenuItem2nd.ImageIndex := tmpMenuItem.ImageIndex;
          tmpMenuItem2nd.Tag := tmpMenuItem.Tag;
          tmpMenuItem2nd.OnClick := tmpMenuItem.OnClick;
          if i_TICKET_MENU_ORDER = 0 then
            CreateMenuRec^.fAllTicketSubMenu.Insert(CreateMenuRec^.fAllTicketSubMenu.Count,
              tmpMenuItem2nd)
          else
          begin
            CreateMenuRec^.fAllTicketSubMenu.Insert(CreateMenuRec^.fIndexAllTicketSubMenuSplit,
              tmpMenuItem2nd);
            CreateMenuRec^.fIndexAllTicketSubMenuSplit :=
              CreateMenuRec^.fIndexAllTicketSubMenuSplit + 1;
          end;
          // --------------------------------------------------------------------------
          //  Заполнение строк информационного списка
          // --------------------------------------------------------------------------
          vidx := CreateMenuRec^.fvInfoShift;
          // --------------------------------------------------------------------------
          if (Low(vInfo) <= vidx) and (vidx <= High(vInfo)) then
          begin
            vInfo[vidx].irLvIdx := -1;
            vInfo[vidx].irKod := i_TICKET_KOD;
            vInfo[vidx].irName := FixFmt(i_TICKET_CLASS, 2, ' ') + ':' +
              FixFmt(i_TICKET_KOD, 2, '0') + ' - "' + str_Ticket_Nam + '"';
            vInfo[vidx].irBgColor := TColor(c_TICKET_BGCOLOR);
            vInfo[vidx].irFontColor := TColor(c_TICKET_FNTCOLOR);
            vInfo[vidx].irbFree := b_CLASS_FREE;
            vInfo[vidx].irSpecial := 3001;
            vInfo[vidx].irCost := 0;
            vInfo[vidx].irCountCash := -1;
            vInfo[vidx].irSumCash := 0;
            CreateMenuRec^.fvInfoShift := vidx + 1;
          end
          else
            DEBUGMessEnh(0, UnitName, ProcName, 'Error: vidx = ' +
              IntToStr(vidx) + ' out of vInfo range.');
          // --------------------------------------------------------------------------
        end;
      end;
    end;
  end;
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(0, UnitName, ProcName, 'str_Ticket_Nam = (' + str_TICKET_NAM + ')');
{$ENDIF}
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_7}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Load_Ticket_Desc(DataSet: TDataSet; Ticket_Kod: Integer;
  PointerData: Pointer);
const
  ProcName: string = 'Load_Ticket_Desc';
begin
  // --------------------------------------------------------------------------
  // Загрузка типа билета из запроса
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_7}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  if Assigned(Dataset) and Dataset.Active then
  begin
    with Dataset do
      if FieldByName(s_TICKET_KOD).AsInteger = Ticket_Kod then
      try
        Add_Ticket_Desc(FieldByName(s_TICKET_KOD).AsInteger,
          FieldByName(s_TICKET_NAM).AsString,
          FieldByName(s_TICKET_LABEL).AsString,
          FieldByName(s_TICKET_SERIALIZE).AsBoolean,
          FieldByName(s_TICKET_CLASS).AsInteger,
          FieldByName(s_CLASS_TO_PRINT).AsBoolean,
          FieldByName(s_CLASS_FOR_FREE).AsBoolean,
          FieldByName(s_CLASS_INVITED_GUEST).AsBoolean,
          FieldByName(s_CLASS_GROUP_VISIT).AsBoolean,
          FieldByName(s_CLASS_VIP_CARD).AsBoolean,
          FieldByName(s_CLASS_VIP_BYNAME).AsBoolean,
          FieldByName(s_CLASS_SEASON_TICKET).AsBoolean,
          FieldByName(s_TICKET_BGCOLOR).AsInteger,
          FieldByName(s_TICKET_FNTCOLOR).AsInteger,
          FieldByName(s_TICKET_MENU_ORDER).AsInteger,
          PointerData);
        {
        str_TICKET_NAM, str_TICKET_LABEL: string;
        b_TICKET_SERIAL: boolean;
        i_TICKET_CLASS: integer;
        b_CLASS_PRINT, b_CLASS_FREE, b_CLASS_GUEST,
        b_CLASS_GROUPED, b_CLASS_CARDED, b_CLASS_ABON: boolean;
        c_TICKET_BGCOLOR, c_TICKET_FNTCOLOR: TColor;
        i_TICKET_MENU_ORDER: integer;
        i_TICKET_TAG: integer);
        }
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Add_Ticket_Desc failed.');
        end;
      end
      else
        DEBUGMessEnh(0, UnitName, ProcName, 'Dataset is not positioned.');
  end
  else
    DEBUGMessEnh(0, UnitName, ProcName, 'Dataset is null or not opened.');
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_7}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

function fchp_Ticket_Desc(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam:
  string; var _Kod: integer; var _Nam: string; PointerToData: Pointer): boolean;
const
  ProcName: string = 'fchp_Ticket_Desc';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := false;
  if Assigned(DataSet) and (length(s_DataSet_Kod) > 0) and (length(s_DataSet_Nam)
    > 0) and DataSet.Active then
  try
    if Assigned(DataSet.FieldByName(s_DataSet_Kod)) then
      _Kod := DataSet.FieldByName(s_DataSet_Kod).AsInteger;
    // --------------------------------------------------------------------------
    // Загрузка типа билета из запроса
    // --------------------------------------------------------------------------
    Load_Ticket_Desc(DataSet, _Kod, PointerToData);
    // --------------------------------------------------------------------------
    Result := true;
  except
  end;
end;

function Combo_Load_Ticket_Desc(DataSet: TDataSet; Lines: TStrings;
  PointerToData: Pointer): integer;
const
  ProcName: string = 'Combo_Load_Ticket_Desc';
begin
  // --------------------------------------------------------------------------
  //
  // --------------------------------------------------------------------------
  Result := Combo_Load_DataSet(DataSet, Lines, s_TICKET_KOD, s_TICKET_NAM,
    fchp_Ticket_Desc, PointerToData);
end;

procedure Load_User_Interface_Info_Finish(const TicketImageList: TImageList;
  const TicketPopupMenu: TPopupMenu; const IndexFreeTicketSubMenu,
  IndexPaidTicketSubMenu, IndexInsertStart, IndexInsertFinish: Integer; const
  AllTicketSubMenu: TMenuItem);
const
  ProcName: string = 'Load_User_Interface_Info_Finish';
var
  vInfo_count, sh, k: Integer;
  // index: Integer;
  // bm: TBitmap;
  check1, check2: boolean;
  tmpMenuItem, FreeMenuItem, PaidMenuItem: TMenuItem;
begin
{$IFDEF Debug_Level_7}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  begin
    if Assigned(TicketPopupMenu) then
    begin
      check1 := ((IndexFreeTicketSubMenu > -1) and (IndexFreeTicketSubMenu <
        TicketPopupMenu.Items.Count));
      check2 := ((IndexPaidTicketSubMenu > -1) and (IndexPaidTicketSubMenu <
        TicketPopupMenu.Items.Count));
      {
      check3 := ((vIndexInsertStart > -1) and (vIndexInsertStart < TicketPopupMenu.Items.Count)
        and (vIndexInsertFinish > -1) and (vIndexInsertFinish < TicketPopupMenu.Items.Count)
        and (vIndexInsertFinish > vIndexInsertStart));
      }
      if check1 then
      try
        FreeMenuItem := TicketPopupMenu.Items[IndexFreeTicketSubMenu];
        //
        tmpMenuItem := TMenuItem.Create(FreeMenuItem);
        tmpMenuItem.Caption := '-';
        FreeMenuItem.Insert(0, tmpMenuItem);
        //
        tmpMenuItem := TMenuItem.Create(FreeMenuItem);
        tmpMenuItem.Caption := '-= ' + FreeMenuItem.Caption + ' =-';
        tmpMenuItem.Enabled := false;
        FreeMenuItem.Insert(0, tmpMenuItem);
        //
        tmpMenuItem := TMenuItem.Create(FreeMenuItem);
        tmpMenuItem.Caption := '-';
        FreeMenuItem.Insert(FreeMenuItem.Count, tmpMenuItem);
        //
        tmpMenuItem := TMenuItem.Create(FreeMenuItem);
        tmpMenuItem.Caption := '-= Выберите =-';
        tmpMenuItem.Enabled := false;
        FreeMenuItem.Insert(FreeMenuItem.Count, tmpMenuItem);
        //
      except
      end;
      if check2 then
      try
        PaidMenuItem := TicketPopupMenu.Items[IndexPaidTicketSubMenu];
        //
        tmpMenuItem := TMenuItem.Create(PaidMenuItem);
        tmpMenuItem.Caption := '-';
        PaidMenuItem.Insert(0, tmpMenuItem);
        //
        tmpMenuItem := TMenuItem.Create(PaidMenuItem);
        tmpMenuItem.Caption := '-= ' + PaidMenuItem.Caption + ' =-';
        tmpMenuItem.Enabled := false;
        PaidMenuItem.Insert(0, tmpMenuItem);
        //
        tmpMenuItem := TMenuItem.Create(PaidMenuItem);
        tmpMenuItem.Caption := '-';
        PaidMenuItem.Insert(PaidMenuItem.Count, tmpMenuItem);
        //
        tmpMenuItem := TMenuItem.Create(PaidMenuItem);
        tmpMenuItem.Caption := '-= Выберите =-';
        tmpMenuItem.Enabled := false;
        PaidMenuItem.Insert(PaidMenuItem.Count, tmpMenuItem);
        //
      except
      end;
      if Assigned(AllTicketSubMenu) then
      try
        //
        tmpMenuItem := TMenuItem.Create(AllTicketSubMenu);
        tmpMenuItem.Caption := '-';
        AllTicketSubMenu.Insert(0, tmpMenuItem);
        //
        tmpMenuItem := TMenuItem.Create(AllTicketSubMenu);
        tmpMenuItem.Caption := '-= Типы билетов =-';
        tmpMenuItem.Enabled := false;
        AllTicketSubMenu.Insert(0, tmpMenuItem);
        //
        tmpMenuItem := TMenuItem.Create(AllTicketSubMenu);
        tmpMenuItem.Caption := '-';
        AllTicketSubMenu.Insert(AllTicketSubMenu.Count, tmpMenuItem);
        //
        tmpMenuItem := TMenuItem.Create(AllTicketSubMenu);
        tmpMenuItem.Caption := '-= Выберите =-';
        tmpMenuItem.Enabled := false;
        AllTicketSubMenu.Insert(AllTicketSubMenu.Count, tmpMenuItem);
        //
      except
      end;
    end;
  end;
  {}
  tmpMenuItem := nil;
  if not Assigned(tmpMenuItem) then
    {}
    with dm_Base do
    begin
      {
      bm := TBitmap.Create;
      with bm do
      try
        Width := TicketImageList.Width;
        Height := TicketImageList.Height;
        Canvas.Pen.Style := psSolid;
        Transparent := true;
        TransparentMode := tmFixed;
        TransparentColor := clBtnFace;
        Canvas.Brush.Color := TransparentColor;
        Canvas.Pen.Color := TransparentColor;
        Canvas.Rectangle(0, 0, Width, Height);
        Canvas.Pen.Color := clBlack;
        Canvas.Brush.Color := fm_Main.tcx_Select.SelectBrush.Color;
        Canvas.Rectangle(0, 2, Width, Height - 2);
        Canvas.Pen.Color := fm_Main.tcx_Select.SelectFont.Color;
        Canvas.Brush.Style := bsClear;
        // Canvas.Rectangle(6, 4, Width - 6, Height - 4);
        //Canvas.Rectangle(2, 4, Width div 3 + 2, Height div 3 + 2);
        Canvas.Rectangle(2 * Width div 3, 2 * Height div 3 - 2,
          Width - 2, Height - 4);
        // index := TicketImageList.Add(bm, nil);
      finally
      end;
      }
      // --------------------------------------------------------------------------
      try
        sh := High(vInfo) + 1;
        vInfo_count := (High(vInfo) - Low(vInfo) + 1);
        SetLength(vInfo, vInfo_count + 5);
        k := 0;
        // --------------------------------------------------------------------------
        if (Low(vInfo) <= (sh + k)) and ((sh + k) <= High(vInfo)) then
        begin
          vInfo[sh + k].irLvIdx := -1;
          vInfo[sh + k].irKod := vInfo_Special_Base - vInfo_Special_Skiped;
          vInfo[sh + k].irName := StringOfChar('-', 40);
          vInfo[sh + k].irBgColor := clWindow;
          vInfo[sh + k].irFontColor := clWindow;
          vInfo[sh + k].irbFree := false;
          vInfo[sh + k].irSpecial := vInfo[sh + k].irKod;
          vInfo[sh + k].irCost := -1;
          vInfo[sh + k].irCountCash := -1;
          vInfo[sh + k].irSumCash := -1;
        end
        else
          DEBUGMessEnh(0, UnitName, ProcName, 'Error: (sh + k) = ' +
            IntToStr(sh + k) + ' out of vInfo range.');
        // --------------------------------------------------------------------------
        Inc(k);
        if (Low(vInfo) <= (sh + k)) and ((sh + k) <= High(vInfo)) then
        begin
          vInfo[sh + k].irLvIdx := -1;
          vInfo[sh + k].irKod := vInfo_Special_Base - vInfo_Special_Reserved;
          vInfo[sh + k].irName := 'Итого по брони';
          vInfo[sh + k].irBgColor := $00AAFFFF; // fm_Main.tcx_Select.ReserveBrushColor;
          vInfo[sh + k].irFontColor := clBlack; // fm_Main.tcx_Select.ReserveFontColor;
          vInfo[sh + k].irbFree := false;
          vInfo[sh + k].irSpecial := vInfo[sh + k].irKod;
          vInfo[sh + k].irCost := -1;
          vInfo[sh + k].irCountCash := -1;
          vInfo[sh + k].irSumCash := -1;
        end
        else
          DEBUGMessEnh(0, UnitName, ProcName, 'Error: (sh + k) = ' +
            IntToStr(sh + k) + ' out of vInfo range.');
        // --------------------------------------------------------------------------
        Inc(k);
        if (Low(vInfo) <= (sh + k)) and ((sh + k) <= High(vInfo)) then
        begin
          vInfo[sh + k].irLvIdx := -1;
          vInfo[sh + k].irKod := vInfo_Special_Base - vInfo_Special_Credit;
          vInfo[sh + k].irName := 'Итого по постерминалу';
          vInfo[sh + k].irBgColor := clLtGray;
          vInfo[sh + k].irFontColor := clBlack;
          vInfo[sh + k].irbFree := false;
          vInfo[sh + k].irSpecial := vInfo[sh + k].irKod;
          vInfo[sh + k].irCost := -1;
          vInfo[sh + k].irCountCash := -1;
          vInfo[sh + k].irSumCash := -1;
        end
        else
          DEBUGMessEnh(0, UnitName, ProcName, 'Error: (sh + k) = ' +
            IntToStr(sh + k) + ' out of vInfo range.');
        // --------------------------------------------------------------------------
        Inc(k);
        if (Low(vInfo) <= (sh + k)) and ((sh + k) <= High(vInfo)) then
        begin
          vInfo[sh + k].irLvIdx := -1;
          vInfo[sh + k].irKod := vInfo_Special_Base - vInfo_Special_Cash;
          vInfo[sh + k].irName := 'Итого по наличности';
          vInfo[sh + k].irBgColor := clDkGray;
          vInfo[sh + k].irFontColor := clBlack;
          vInfo[sh + k].irbFree := false;
          vInfo[sh + k].irSpecial := vInfo[sh + k].irKod;
          vInfo[sh + k].irCost := -1;
          vInfo[sh + k].irCountCash := -1;
          vInfo[sh + k].irSumCash := -1;
        end
        else
          DEBUGMessEnh(0, UnitName, ProcName, 'Error: (sh + k) = ' +
            IntToStr(sh + k) + ' out of vInfo range.');
        // --------------------------------------------------------------------------
        Inc(k);
        if (Low(vInfo) <= (sh + k)) and ((sh + k) <= High(vInfo)) then
        begin
          vInfo[sh + k].irLvIdx := -1;
          vInfo[sh + k].irKod := vInfo_Special_Base - vInfo_Special_Total;
          vInfo[sh + k].irName := 'Итого по всем';
          vInfo[sh + k].irBgColor := clWindow;
          vInfo[sh + k].irFontColor := clBlack;
          vInfo[sh + k].irbFree := false;
          vInfo[sh + k].irSpecial := vInfo[sh + k].irKod;
          vInfo[sh + k].irCost := -1;
          vInfo[sh + k].irCountCash := -1;
          vInfo[sh + k].irSumCash := -1;
        end
        else
          DEBUGMessEnh(0, UnitName, ProcName, 'Error: (sh + k) = ' +
            IntToStr(sh + k) + ' out of vInfo range.');
        // --------------------------------------------------------------------------
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Adding at end of vInfo failed.');
        end;
      end; // try
    end; // with dm_Base do
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_7}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

function Load_All_Ticket_Types(const TicketImageList: TImageList; const
  TicketPopupMenu: TPopupMenu; const IndexFreeTicketSubMenu,
  IndexPaidTicketSubMenu, IndexInsertStart, IndexInsertFinish: Integer; const
  AllTicketSubMenu: TMenuItem; const MenuFont: TFont; const TicketRightClick:
  TNotifyEvent): Boolean;
const
  ProcName: string = 'Load_All_Ticket_Types';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  varIndexFreeTicketSubMenu, varIndexPaidTicketSubMenu, varIndexInsertStart,
    varIndexInsertFinish: Integer;
  tmpFreeSubMenu, tmpPaidSubMenu: TMenuItem;
  check1, check2: boolean;
  CreateMenuData: TCreateMenuRec;
  rec_count, vInfo_count, sh: Integer;
begin
  Time_Start := Now;
  // --------------------------------------------------------------------------
  // 2.2) Загрузка всех типов билетов
  // --------------------------------------------------------------------------
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  Result := false;
  // --------------------------------------------------------------------------
  with dm_Base.ds_Ticket do
  begin
    // --------------------------------------------------------------------------
    check1 := ((IndexFreeTicketSubMenu > -1) and (IndexFreeTicketSubMenu <
      TicketPopupMenu.Items.Count));
    check2 := ((IndexPaidTicketSubMenu > -1) and (IndexPaidTicketSubMenu <
      TicketPopupMenu.Items.Count));
    tmpFreeSubMenu := nil;
    if check1 then
    try
      tmpFreeSubMenu := TicketPopupMenu.Items[IndexFreeTicketSubMenu];
      tmpFreeSubMenu.GroupIndex := 0;
    except
    end;
    tmpPaidSubMenu := nil;
    if check2 then
    try
      tmpPaidSubMenu := TicketPopupMenu.Items[IndexPaidTicketSubMenu];
      tmpPaidSubMenu.GroupIndex := 0;
    except
    end;
    // --------------------------------------------------------------------------
    varIndexFreeTicketSubMenu := IndexFreeTicketSubMenu;
    varIndexPaidTicketSubMenu := IndexPaidTicketSubMenu;
    varIndexInsertStart := IndexInsertStart;
    varIndexInsertFinish := IndexInsertFinish;
    // --------------------------------------------------------------------------
    Clear_User_Interface(TicketImageList, TicketPopupMenu,
      varIndexFreeTicketSubMenu, varIndexPaidTicketSubMenu,
      varIndexInsertStart, varIndexInsertFinish, AllTicketSubMenu);
    // --------------------------------------------------------------------------
    Load_User_Interface_Info_Start(TicketImageList, TicketPopupMenu,
      varIndexFreeTicketSubMenu, varIndexPaidTicketSubMenu,
      varIndexInsertStart, varIndexInsertFinish, AllTicketSubMenu);
    // --------------------------------------------------------------------------
    Max_MenuText_Width := -1;
    // --------------------------------------------------------------------------
    {
    SELECT
        TIC.TICKET_KOD,
        TIC.TICKET_NAM,
        TIC.TICKET_LABEL,
        TIC.TICKET_SERIAL,
        TIC.TICKET_CLASS,
        TIC.CLASS_NAM,
        TIC.CLASS_PRINT,
        TIC.CLASS_FREE,
        TIC.CLASS_GROUPED,
        TIC.TICKET_MAKET,
        TIC.TICKET_BGCOLOR,
        TIC.TICKET_FNTCOLOR,
        TIC.TICKET_MENU_ORDER,
        TIC.TICKET_USE_COUNT,
        TIC.TICKET_LAST_ACCESS,
        TIC.TICKET_VISIBLE,
        TIC.TICKET_TAG,
        TIC.USERID
    FROM
        TICKET_VIEW TIC
    WHERE
        ((:PARAM1 = 0)
        OR ((:PARAM1 = 1) AND (TICKET_VISIBLE = 1))
        OR ((:PARAM1 = 2) AND (TICKET_MENU_ORDER > 0))
        OR ((:PARAM1 = 3) AND (TICKET_CLASS = :PARAM2))
        OR ((:PARAM1 = 4) AND (CLASS_FREE = :PARAM2)))
    }
    {
    select
      TIC.TICKET_KOD,
      TIC.TICKET_NAM,
      TIC.TICKET_CLASS,
      TIC.CLASS_NAM,
      TIC.CLASS_PRINT,
      TIC.CLASS_FREE,
      TIC.CLASS_GROUPED,
      TIC.TICKET_CALCUL1,
      TIC.TICKET_CONST1,
      TIC.TICKET_MAKET,
      TIC.MAKET_NAM,
      TIC.TICKET_LABEL,
      TIC.TICKET_SERIALIZE,
      TIC.TICKET_BGCOLOR,
      TIC.TICKET_FNTCOLOR,
      TIC.TICKET_MENU_ORDER,
      TIC.TICKET_ENABLED,
      TIC.SESSION_ID
    from
      TICKET TIC
    where
      ((:IN_FILT_MODE = 0)
      or ((:IN_FILT_MODE = 1) and (TICKET_ENABLED = 1))
      or ((:IN_FILT_MODE = 2) and (TICKET_MENU_ORDER > 0))
      or ((:IN_FILT_MODE = 3) and (TICKET_CLASS = :IN_FILT_PARAM1))
      or ((:IN_FILT_MODE = 4) and (CLASS_FREE = :IN_FILT_PARAM1)))
    order by
      TICKET_KOD
    }
    // --------------------------------------------------------------------------
    try
      Close;
      if Assigned(Params.FindParam(s_IN_FILT_MODE)) then
        ParamByName(s_IN_FILT_MODE).AsInteger := 1;
      if Assigned(Params.FindParam(s_IN_FILT_PARAM1)) then
        ParamByName(s_IN_FILT_PARAM1).AsInteger := 0;
      Prepare;
      Open;
      First;
      Last;
      First;
      rec_count := RecordCount;
      // --------------------------------------------------------------------------
      DEBUGMessEnh(0, UnitName, ProcName, 'Increasing length of vInfo by '
        + IntToStr(rec_count));
      sh := High(vInfo) + 1;
      vInfo_count := (High(vInfo) - Low(vInfo) + 1);
      try
        SetLength(vInfo, vInfo_count + rec_count);
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'SetLength for vInfo failed.');
        end;
      end; // try
      // --------------------------------------------------------------------------
      CreateMenuData.fTicketImageList := TicketImageList;
      CreateMenuData.fTicketPopupMenu := TicketPopupMenu;
      CreateMenuData.fIndexFreeTicketSubMenu := varIndexFreeTicketSubMenu;
      CreateMenuData.fIndexPaidTicketSubMenu := varIndexPaidTicketSubMenu;
      CreateMenuData.fIndexInsertStart := varIndexInsertStart;
      CreateMenuData.fIndexInsertFinish := varIndexInsertFinish;
      CreateMenuData.fIndexAllTicketSubMenuSplit := 0;
      CreateMenuData.fAllTicketSubMenu := AllTicketSubMenu;
      CreateMenuData.fMenuFont := MenuFont;
      CreateMenuData.fTicketRightClick := TicketRightClick;
      CreateMenuData.fvInfoShift := sh;
      //
      Combo_Load_Ticket_Desc(dm_Base.ds_Ticket, nil, @CreateMenuData);
      Close;
      Result := true;
    except
      on E: Exception do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
        DEBUGMessEnh(0, UnitName, ProcName, 'Loading Ticket types failed.');
      end;
    end;
    //
    if Assigned(tmpFreeSubMenu) then
      varIndexFreeTicketSubMenu := tmpFreeSubMenu.MenuIndex;
    if Assigned(tmpPaidSubMenu) then
      varIndexPaidTicketSubMenu := tmpPaidSubMenu.MenuIndex;
    Load_User_Interface_Info_Finish(TicketImageList, TicketPopupMenu,
      varIndexFreeTicketSubMenu, varIndexPaidTicketSubMenu,
      varIndexInsertStart, varIndexInsertFinish, AllTicketSubMenu);
  end;
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

{
initialization
  lv_Info_Buffer := TListView.Create(fm_Main);
  lv_Info_Buffer.Parent := fm_Main;
  lv_Info_Buffer.Columns.Add;
  lv_Info_Buffer.Columns[0].Caption := 'Код типа билета';
  lv_Info_Buffer.Columns[0].Width := 0;
  lv_Info_Buffer.Columns.Add;
  lv_Info_Buffer.Columns[1].Caption := 'Тип билета';
  lv_Info_Buffer.Columns[1].Width := -1;
  lv_Info_Buffer.Columns.Add;
  lv_Info_Buffer.Columns[2].Caption := 'Печать';
  lv_Info_Buffer.Columns[2].Width := -1;

finalization
  FreeAndNil(lv_Info_Buffer);
}

end.

