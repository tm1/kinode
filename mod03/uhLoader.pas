{-----------------------------------------------------------------------------
 Unit Name: uhLoader
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  16.05.2004
 Purpose:   Loader helper
 History:
-----------------------------------------------------------------------------}
unit uhLoader;

interface

{$I kinode01.inc}

uses
  Classes, ExtCtrls, Menus, Graphics, Db, ShpCtrl2;

const
  c_fZalNameLen = 250;

type
  PCreateZalRec = ^TCreateZalRec;
  TCreateZalRec = record
    fList: TStrings;
    fZalNum: integer;
    fZalName: string[c_fZalNameLen];
    fpnPanelContainer: TPanel;
    fpnPlaceContainer: TOdeumPanel;
    fodmSelectRangeBefore: TSelectRangeEvent;
    fodmSelectRangeAfter: TSelectRangeEvent;
    fppPopupMenu: TPopupMenu;
    ftcLeftClick: TNotifyEvent;
    ftcSeatExSelect: TSeatExSelectEvent;
    ftcSeatExCmd: TSeatExCmdEvent;
    ftcGetTicketProps: TGetTicketPropsEvent;
    // ftcChangeState: TNotifyEvent;
    // ftcChangeTicketType: TNotifyEvent;
    // ftcChangeUsedByNet: TNotifyEvent;
    fElemType: integer;
    fMultiplr: real;
    fAutosize: boolean;
    fBgColor: TColor;
  end;

function SetProgressMinMax(MinVal, MaxVal, InitVal: Integer; bShow: Boolean): Boolean;
function SetProgressPercent(ProgressVal: integer): Boolean;
// --------------------------------------------------------------------------
function Load_All_Zals(Lines: TStrings; Container: TPanel;
  odmSelectRangeBefore, odmSelectRangeAfter: TSelectRangeEvent; Popup: TPopupMenu;
  tcLeftClick: TNotifyEvent; tcSeatExSelect: TSeatExSelectEvent; tcSeatExCmd:
  TSeatExCmdEvent; tcGetTicketProps: TGetTicketPropsEvent): boolean;

implementation

uses
  Bugger, SysUtils, Gauges, Controls, Math, Forms, uThreads, uTools, uhCells, urLoader,
  ufSplash, ufMain, uhCommon, urCommon, udBase, StrConsts;

const
  UnitName: string = 'uhLoader';

function SetProgressMinMax(MinVal, MaxVal, InitVal: Integer; bShow: Boolean): Boolean;
var
  tmp_Gauge: TGauge;
begin
  Result := false;
  tmp_Gauge := nil;
  if Assigned(fm_Splash) and (Assigned(fm_Splash.gg_LoadProgress)) then
  try
    if fm_Splash.gg_LoadProgress.Visible then
      tmp_Gauge := fm_Splash.gg_LoadProgress;
  except
    tmp_Gauge := nil;
  end;
  if (not Assigned(tmp_Gauge)) and Assigned(fm_Main) then
  try
    tmp_Gauge := fm_Main.gg_Progress;
    tmp_Gauge.Visible := bShow;
  except
    tmp_Gauge := nil;
  end;
  if Assigned(tmp_Gauge) then
  begin
    tmp_Gauge.MinValue := MinVal;
    tmp_Gauge.MaxValue := MaxVal;
    tmp_Gauge.Progress := InitVal;
    Result := true;
  end;
end;

function SetProgressPercent(ProgressVal: integer): boolean;
var
  tmp_Gauge: TGauge;
begin
  Result := false;
  tmp_Gauge := nil;
  if Assigned(fm_Splash) then
  try
    if fm_Splash.gg_LoadProgress.Visible then
      tmp_Gauge := fm_Splash.gg_LoadProgress;
  except
    tmp_Gauge := nil;
  end;
  if (not Assigned(tmp_Gauge)) and Assigned(fm_Main) then
  try
    tmp_Gauge := fm_Main.gg_Progress;
    tmp_Gauge.Enabled;
  except
    tmp_Gauge := nil;
  end;
  if Assigned(tmp_Gauge) then
  begin
    tmp_Gauge.Progress := ProgressVal;
    Result := true;
  end;
end;

procedure Import_Zal_ThreadInit(PointerToData: Pointer; var ForceTerminated: boolean);
const
  ProcName: string = 'Import_Zal_ThreadInit';
begin
{$IFDEF Debug_Level_7}
  DEBUGMessEnh(0, UnitName, ProcName, 'ForceTerminated = (' + BoolYesNo[ForceTerminated] + ')');
{$ENDIF}
end;

procedure Import_Zal_ThreadProc(PointerToData: Pointer; var ForceTerminated: boolean);
const
  ProcName: string = 'Import_Zal_ThreadProc';
var
  count: integer;
  DataRec: PCreateZalRec;
  n_Row, n_Column, n_Left, n_Top, n_Width, n_Height, n_State: integer;
  SC_Cell: TSeatEx;
  SC: TShape;
  Max_Width, Max_Height: integer;
  EventStoreRec: TEventStoreRec;
  n_Horz_Shift, n_Vert_Shift: integer;
  tmp_Shape: TShape;
  tmp_SSBX: TSpeedShapeBtnEx;
  x_MarginHorzLeft, x_MarginHorzRight, y_MarginVertTop, y_MarginVertBottom: Integer;
  x_MarginDeltaLeft, x_MarginDeltaRight, y_MarginDeltaTop, y_MarginDeltaBottom: Integer;
  w_RiddleWidthPercent, h_RiddleHeight: Integer;
  Zal_Left, Zal_Right, Zal_Top, Zal_Bottom: Integer;
begin
  if Assigned(PointerToData) then
  begin
    DataRec := PointerToData;
{$IFDEF Debug_Level_9}
    DEBUGMessEnh(0, UnitName, ProcName, 'PointerToData = (' +
      IntToHex1(Integer(PointerToData), 8) + ')');
    DEBUGMessEnh(0, UnitName, ProcName, 'fZalNum = (' +
      IntToStr(DataRec^.fZalNum) + ')');
    DEBUGMessEnh(0, UnitName, ProcName, 'fZalName = "' + DataRec^.fZalName +
      '"');
{$ENDIF}
    if Assigned(DataRec^.fpnPlaceContainer) then
    begin
      // --------------------------------------------------------------------------
      // init
      // --------------------------------------------------------------------------
{$IFDEF Debug_Level_9}
      DEBUGMessEnh(0, UnitName, ProcName, 'fpnPlaceContainer = "' +
        DataRec^.fpnPlaceContainer.Name + '"');
{$ENDIF}
      count := 0;
      Max_Width := 100;
      Max_Height := 100;
      SetProgressMinMax(0, 100, 0, true);
      n_Horz_Shift := 0;
      n_Vert_Shift := 0;
      x_MarginHorzLeft := round(MarginHorzLeft * DataRec^.fMultiplr);
      x_MarginHorzRight := round(MarginHorzRight * DataRec^.fMultiplr);
      y_MarginVertTop := round(MarginVertTop * DataRec^.fMultiplr);
      y_MarginVertBottom := round(MarginVertBottom * DataRec^.fMultiplr);
      // --------------------------------------------------------------------------
      // start
      // --------------------------------------------------------------------------
      with dm_Base.ds_Place do
      begin
        DataRec^.fpnPlaceContainer.Visible := false;
        DisableControls;
        try
          Close;
          if Assigned(Params.FindParam(s_IN_FILT_ODEUM)) then
            ParamByName(s_IN_FILT_ODEUM).AsInteger := DataRec^.fZalNum;
          Prepare;
          Open;
          // Filter := s_Place_Zal + ' = ' + IntToStr(DataRec^.fZalNum);
          First;
          Last;
          First;
{$IFDEF Debug_Level_9}
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.Active = ' + BoolYesNo[Active]
            + ', RecordCount = (' + IntToStr(RecordCount) + ')');
{$ENDIF}
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, 'Reopening for (' + Name + ') is failed.');
            DBLastError2 := E.Message;
          end;
        end;
        // max_count := RecordCount;
        SetProgressMinMax(0, RecordCount, 0, true);
        // --------------------------------------------------------------------------
        // Cycle records
        // --------------------------------------------------------------------------
        if Active and (RecordCount > 0) then
        try
          n_Width := Integer(CellWidth);
          n_Height := Integer(CellHeight);
          EventStoreRec.fTicketPopupMenu := DataRec^.fppPopupMenu;
          EventStoreRec.fTicketLeftClick := DataRec^.ftcLeftClick;
          EventStoreRec.fSeatExSelect := DataRec^.ftcSeatExSelect;
          EventStoreRec.fSeatExCmd := DataRec^.ftcSeatExCmd;
          EventStoreRec.fGetTicketProps := DataRec^.ftcGetTicketProps;
          while not Eof do
          begin
            try
              inc(count);
              SetProgressPercent(count);
              n_Row := FieldByName(s_SEAT_ROW).AsInteger;
              n_Column := FieldByName(s_SEAT_COL).AsInteger;
              n_Left := FieldByName(s_SEAT_X).AsInteger;
              n_Top := FieldByName(s_SEAT_Y).AsInteger;
              n_State := 0;
              if Assigned(FieldByName(s_SEAT_BROKEN)) then
                n_State := FieldByName(s_SEAT_BROKEN).AsInteger;
              SC_Cell := nil;
              SC := nil;
              // --------------------------------------------------------------------------
              n_Left := n_Left + n_Horz_Shift;
              n_Top := n_Top + n_Vert_Shift;
              // --------------------------------------------------------------------------
              case DataRec^.fElemType of
                0:
                  begin
                    CreateCell(DataRec^.fZalNum, DataRec^.fpnPlaceContainer,
                      EventStoreRec, SC_Cell, DataRec^.fMultiplr, n_Row,
                      n_Column, n_Left, n_Top, n_Width, n_Height, n_State);
                    if Assigned(SC_Cell) then
                    begin
                      Max_Width := Max(Max_Width, SC_Cell.Left + SC_Cell.Width
                        + x_MarginHorzRight);
                      Max_Height := Max(Max_Height, SC_Cell.Top + SC_Cell.Height
                        + y_MarginVertBottom);
                    end;
                  end;
                1:
                  begin
                    CreateSimpleCell(DataRec^.fZalNum,
                      DataRec^.fpnPlaceContainer, SC, DataRec^.fMultiplr, n_Row,
                      n_Column, n_Left, n_Top, n_Width, n_Height, n_State);
                    if Assigned(SC) then
                    begin
                      Max_Width := Max(Max_Width, SC.Left + SC.Width
                        + x_MarginHorzRight);
                      Max_Height := Max(Max_Height, SC.Top + SC.Height
                        + y_MarginVertBottom);
                    end;
                  end;
              end;
              // --------------------------------------------------------------------------
            finally
              Next;
            end;
          end;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, Name + ' cycle failed.');
            DBLastError2 := E.Message;
          end;
        end
        else
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Not active or no records.');
        end;
        // --------------------------------------------------------------------------
        if DataRec^.fAutosize then
        begin
          DataRec^.fpnPlaceContainer.Width := Max_Width;
          DataRec^.fpnPlaceContainer.Height := Max_Height;
          // --------------------------------------------------------------------------
          x_MarginDeltaLeft := round(MarginDeltaLeft * DataRec^.fMultiplr);
          x_MarginDeltaRight := round(MarginDeltaRight * DataRec^.fMultiplr);
          y_MarginDeltaTop := round(MarginDeltaTop * DataRec^.fMultiplr);
          y_MarginDeltaBottom := round(MarginDeltaBottom * DataRec^.fMultiplr);
          // --------------------------------------------------------------------------
          Zal_Left := x_MarginHorzLeft - x_MarginDeltaLeft;
          Zal_Top := y_MarginVertTop - y_MarginDeltaTop;
          Zal_Right := Max_Width - x_MarginHorzRight + x_MarginDeltaRight;
          Zal_Bottom := Max_Height - y_MarginVertBottom + y_MarginDeltaBottom;
          // --------------------------------------------------------------------------
          // Left side
          // --------------------------------------------------------------------------
          tmp_Shape := TShape.Create(DataRec^.fpnPlaceContainer);
          tmp_Shape.Parent := DataRec^.fpnPlaceContainer;
          tmp_Shape.Left := Zal_Left;
          tmp_Shape.Width := MarginLineWidth;
          tmp_Shape.Top := Zal_Top;
          tmp_Shape.Height := Zal_Bottom - Zal_Top;
          // --------------------------------------------------------------------------
          // Right side
          // --------------------------------------------------------------------------
          tmp_Shape := TShape.Create(DataRec^.fpnPlaceContainer);
          tmp_Shape.Parent := DataRec^.fpnPlaceContainer;
          tmp_Shape.Left := Zal_Right - MarginLineWidth;
          tmp_Shape.Width := MarginLineWidth;
          tmp_Shape.Top := Zal_Top;
          tmp_Shape.Height := Zal_Bottom - Zal_Top;
          // --------------------------------------------------------------------------
          // Top line
          // --------------------------------------------------------------------------
          tmp_Shape := TShape.Create(DataRec^.fpnPlaceContainer);
          tmp_Shape.Parent := DataRec^.fpnPlaceContainer;
          tmp_Shape.Left := Zal_Left;
          tmp_Shape.Width := Zal_Right - Zal_Left;
          tmp_Shape.Top := Zal_Top;
          tmp_Shape.Height := MarginLineWidth;
          // --------------------------------------------------------------------------
          // Bottom line
          // --------------------------------------------------------------------------
          tmp_Shape := TShape.Create(DataRec^.fpnPlaceContainer);
          tmp_Shape.Parent := DataRec^.fpnPlaceContainer;
          tmp_Shape.Left := Zal_Left;
          tmp_Shape.Width := Zal_Right - Zal_Left;
          tmp_Shape.Top := Zal_Bottom - MarginLineWidth;
          tmp_Shape.Height := MarginLineWidth;
          // --------------------------------------------------------------------------
          // Riddle
          // --------------------------------------------------------------------------
          w_RiddleWidthPercent := round((abs(RiddleWidthPercent) mod 91)
            * (Zal_Right - Zal_Left) / 100);
          h_RiddleHeight := round(RiddleHeight * DataRec^.fMultiplr);
          tmp_SSBX := TSpeedShapeBtnEx.Create(DataRec^.fpnPlaceContainer);
          tmp_SSBX.Parent := DataRec^.fpnPlaceContainer;
          // tmp_SSBX.Caption := 'S c r e e n';
          tmp_SSBX.Caption := '===  Киноэкран  ===';
          tmp_SSBX.Margin := 1;
          tmp_SSBX.RegularBrush.Color := clWhite; // DataRec^.fpnPlaceContainer.Color;
          tmp_SSBX.RegularFont.Name := 'Times New Roman';
          tmp_SSBX.RegularFont.Height := -h_RiddleHeight + 8;
          // tmp_SSBX.RegularFont.Style := [fsBold];
          tmp_SSBX.RegularFont.Color := clBlack;
          tmp_SSBX.Hint := DataRec^.fpnPlaceContainer.Caption;
          tmp_SSBX.Left := Zal_Left + (Zal_Right - Zal_Left - w_RiddleWidthPercent) div 2;
          tmp_SSBX.Width := w_RiddleWidthPercent;
          tmp_SSBX.Top := Zal_Top - h_RiddleHeight div 2;
          tmp_SSBX.Height := h_RiddleHeight;
          // --------------------------------------------------------------------------
        end;
        DataRec^.fpnPlaceContainer.Visible := true;
        SetProgressMinMax(0, 100, 100, true);
        EnableControls;
      end;
{$IFDEF Debug_Level_6}
      DEBUGMessEnh(0, UnitName, ProcName, DataRec^.fpnPlaceContainer.Name +
        '.ComponentCount = ' +
        IntToStr(DataRec^.fpnPlaceContainer.ComponentCount));
{$ENDIF}
{$IFDEF Debug_Level_9}
      DEBUGMessEnh(0, UnitName, ProcName, DataRec^.fpnPlaceContainer.Name +
        '.Left = ' + IntToStr(DataRec^.fpnPlaceContainer.Left));
      DEBUGMessEnh(0, UnitName, ProcName, DataRec^.fpnPlaceContainer.Name +
        '.Top = ' + IntToStr(DataRec^.fpnPlaceContainer.Top));
      DEBUGMessEnh(0, UnitName, ProcName, DataRec^.fpnPlaceContainer.Name +
        '.Width = ' + IntToStr(DataRec^.fpnPlaceContainer.Width));
      DEBUGMessEnh(0, UnitName, ProcName, DataRec^.fpnPlaceContainer.Name +
        '.Height = ' + IntToStr(DataRec^.fpnPlaceContainer.Height));
      if Assigned(DataRec^.fpnPlaceContainer.Parent) then
        DEBUGMessEnh(0, UnitName, ProcName, DataRec^.fpnPlaceContainer.Name +
          '.Parent = ' + DataRec^.fpnPlaceContainer.Parent.Name)
      else
        DEBUGMessEnh(0, UnitName, ProcName, DataRec^.fpnPlaceContainer.Name +
          '.Parent = nil');
{$ENDIF}
      // --------------------------------------------------------------------------
      // finish
      // --------------------------------------------------------------------------
    end;
  end;
  ForceTerminated := true;
end;

procedure Import_Zal_ThreadFinal(PointerToData: Pointer; var ForceTerminated: boolean);
const
  ProcName: string = 'Import_Zal_ThreadFinal';
begin
{$IFDEF Debug_Level_7}
  DEBUGMessEnh(0, UnitName, ProcName, 'ForceTerminated = (' + BoolYesNo[ForceTerminated] + ')');
{$ENDIF}
end;

procedure Load_Zal_Map(DataSet: TDataSet; Zal_Num: integer; Zal_Desc: string;
  PointerToData: Pointer);
const
  ProcName: string = 'Load_Zal_Map';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  Import_Zal_Thread: TGenericThread;
  Data: PCreateZalRec;
  tmp_New_Panel: TOdeumPanel;
  StrStream: TStringStream;
  LogoBitmap: TBitmap;
  tmp_BgColor: integer;
begin
  Time_Start := Now;
  // --------------------------------------------------------------------------
  // Загрузка зала из запроса
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_7}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(0, UnitName, ProcName, 'PointerToData = (' +
    IntToHex1(Integer(PointerToData), 8) + ')');
  DEBUGMessEnh(0, UnitName, ProcName, 'Zal_Num = (' + IntToStr(Zal_Num) + ')');
{$ENDIF}
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(0, UnitName, ProcName, 'Zal_Desc = "' + Zal_Desc + '"');
{$ENDIF}
  if (Zal_Num > 0) and Assigned(PointerToData) then
  begin
{$IFDEF Debug_Level_9}
    DEBUGMessEnh(1, UnitName, ProcName, '->>');
    // --------------------------------------------------------------------------
    DEBUGMessBrk(0, 'Thread.Work.Start');
{$ENDIF}
    try
      Data := PointerToData;
      Data^.fZalNum := Zal_Num;
      Data^.fZalName := Copy(Zal_Desc, 1, c_fZalNameLen);
{$IFDEF Debug_Level_9}
      DEBUGMessEnh(0, UnitName, ProcName, 'fZalNum = (' + IntToStr(Data^.fZalNum) + ')');
{$ENDIF}
      // --------------------------------------------------------------------------
      if Assigned(Data^.fpnPanelContainer) then
      begin
        Data^.fZalNum := Zal_Num;
{$IFDEF Debug_Level_9}
        DEBUGMessEnh(0, UnitName, ProcName, 'fpnPanelContainer = "' +
          Data^.fpnPanelContainer.Name + '"');
{$ENDIF}
        try
          tmp_New_Panel := TOdeumPanel.Create(Data^.fpnPanelContainer);
          tmp_New_Panel.Name := 'pnZal_' + IntToStr(Zal_Num);
          tmp_New_Panel.Parent := Data^.fpnPanelContainer;
          tmp_New_Panel.Visible := false;
          tmp_New_Panel.Left := 0;
          tmp_New_Panel.Top := 0;
          tmp_New_Panel.Width := 100;
          tmp_New_Panel.Height := 100;
          tmp_New_Panel.BevelInner := bvRaised;
          tmp_New_Panel.BevelOuter := bvLowered;
          tmp_New_Panel.RangeEdgePen.Color := clBackground;
          tmp_New_Panel.RangeEdgePen.Width := 2;
          tmp_BgColor := clNavy;
          LoadInitParameterInt(s_Preferences_Section, s_OdeumBgColor + IntToStr(Data^.fZalNum),
            Data^.fBgColor, tmp_BgColor);
          tmp_New_Panel.Color := tmp_BgColor;
          SaveInitParameter(s_Preferences_Section, s_OdeumBgColor + IntToStr(Data^.fZalNum),
            IntToStr(tmp_BgColor));
          tmp_New_Panel.Font.Color := tmp_New_Panel.Color; // clBackground;
          tmp_New_Panel.AutoHint := false;
          tmp_New_Panel.Hint := '';
          // tmp_New_Panel.Hint := tmp_New_Panel.Name + ' - ' + Zal_Desc;
          // --------------------------------------------------------------------------
          // Default values
          // --------------------------------------------------------------------------
          {
          select
            ODM.ODEUM_KOD,
            ODM.ODEUM_NAM,
            ODM.ODEUM_CINEMA,
            ODM.CINEMA_NAM,
            ODM.ODEUM_PREFIX,
            ODM.ODEUM_CAPACITY,
            ODM.ODEUM_DESC,
            ODM.CINEMA_LOGO,
            ODM.ODEUM_LOGO
          from
            SP_ODEUM_LIST_S ODM
          }
          // --------------------------------------------------------------------------
          tmp_New_Panel.OdeumKod := Zal_Num;
          tmp_New_Panel.OdeumVer := 0;
          tmp_New_Panel.OdeumName := Zal_Desc;
          tmp_New_Panel.OdeumPrefix := 'AA';
          tmp_New_Panel.OdeumCapacity := 1234;
          // --------------------------------------------------------------------------
          if Assigned(DataSet) and DataSet.Active then
            if Assigned(DataSet.FieldByName(s_ODEUM_KOD)) and
              (Zal_Num = DataSet.FieldByName(s_ODEUM_KOD).AsInteger) then
            begin
              if Assigned(DataSet.FieldByName(s_ODEUM_NAM)) then
                tmp_New_Panel.OdeumName := DataSet.FieldByName(s_ODEUM_NAM).AsString;
              if Assigned(DataSet.FieldByName(s_ODEUM_PREFIX)) then
                tmp_New_Panel.OdeumPrefix := DataSet.FieldByName(s_ODEUM_PREFIX).AsString;
              if Assigned(DataSet.FieldByName(s_CINEMA_NAM)) then
                tmp_New_Panel.CinemaName := DataSet.FieldByName(s_CINEMA_NAM).AsString;
              if Assigned(DataSet.FieldByName(s_ODEUM_CAPACITY)) then
                tmp_New_Panel.OdeumCapacity := DataSet.FieldByName(s_ODEUM_CAPACITY).AsInteger;
              if Assigned(DataSet.FieldByName(s_ODEUM_LOGO))
                { and DataSet.FieldByName(s_ODEUM_LOGO).IsBlob }then
              begin
                LogoBitmap := TBitmap.Create;
                try
                  StrStream := TStringStream.Create(DataSet.FieldByName(s_ODEUM_LOGO).AsString);
                  try
                    LogoBitmap.LoadFromStream(StrStream);
                    // LogoBitmap.Monochrome := true;
                    tmp_New_Panel.OdeumLogo.Assign(LogoBitmap);
                  finally
                    StrStream.Free;
                  end;
                finally
                  LogoBitmap.Free;
                end;
              end; // if Assigned(...)
              if Assigned(DataSet.FieldByName(s_CINEMA_LOGO))
                { and DataSet.FieldByName(s_CINEMA_LOGO).IsBlob }then
              begin
                LogoBitmap := TBitmap.Create;
                try
                  StrStream := TStringStream.Create(DataSet.FieldByName(s_CINEMA_LOGO).AsString);
                  try
                    LogoBitmap.LoadFromStream(StrStream);
                    // LogoBitmap.Monochrome := true;
                    tmp_New_Panel.CinemaLogo.Assign(LogoBitmap);
                  finally
                    StrStream.Free;
                  end;
                finally
                  LogoBitmap.Free;
                end;
              end; // if Assigned(...)
            end; // if (test_zal_num)
          // --------------------------------------------------------------------------
          tmp_New_Panel.AutoHint := true;
          tmp_New_Panel.AutoHint := false;
          tmp_New_Panel.ShowHint := false;
          tmp_New_Panel.Caption := tmp_New_Panel.Hint;
          tmp_New_Panel.Hint := '';
          tmp_New_Panel.ParentShowHint := true;
          tmp_New_Panel.OnSelectRangeBefore := Data^.fodmSelectRangeBefore;
          tmp_New_Panel.OnSelectRangeAfter := Data^.fodmSelectRangeAfter;
          Data^.fpnPlaceContainer := tmp_New_Panel;
          Data^.fpnPlaceContainer.Visible := true;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, 'Error - Creating Zal(' +
              FixFmt(Zal_Num, 3, '0') + ')');
          end;
        end;
        // --------------------------------------------------------------------------
        if Assigned(Data^.fpnPlaceContainer) then
        begin
          try
            Import_Zal_Thread := TGenericThread.Create(tpNormal, @Import_Zal_ThreadInit,
              @Import_Zal_ThreadProc, @Import_Zal_ThreadFinal, PointerToData);
{$IFDEF Debug_Level_7}
            DEBUGMessEnh(0, UnitName, ProcName,
              'Import_Zal_Thread created. Handle = ('
              + IntToHex1(Import_Zal_Thread.Handle, 8) + ')');
{$ENDIF}
            // while Import_Zal_ThreadExecuted do
            while Import_Zal_Thread.Runing do
              Application.ProcessMessages;
{$IFDEF Debug_Level_7}
            DEBUGMessEnh(0, UnitName, ProcName, 'Thread done.');
{$ENDIF}
          except
            on E: Exception do
            begin
              DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
              DEBUGMessEnh(0, UnitName, ProcName, 'Import_Zal_Thread run failed.');
            end;
          end;
        end
        else
          DEBUGMessEnh(0, UnitName, ProcName,
            'Error - fpnPlaceContainer is null.');
        // --------------------------------------------------------------------------
      end
      else
        DEBUGMessEnh(0, UnitName, ProcName,
          'Error - fpnPanelContainer is null.');
    except
      on E: Exception do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
        DEBUGMessEnh(0, UnitName, ProcName, 'Import_Zal_Thread run failed.');
      end;
    end;
{$IFDEF Debug_Level_9}
    DEBUGMessBrk(0, 'Thread.Work.Finish');
    // --------------------------------------------------------------------------
    DEBUGMessEnh(-1, UnitName, ProcName, '<<-');
{$ENDIF}
  end
  else
  begin
    DEBUGMessEnh(0, UnitName, ProcName,
      'Error - parameters wrong or PointerToData is null.');
  end;
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_7}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMessEnh(0, UnitName, ProcName, 'Work time - (' + IntToStr(Hour) + ':' +
    FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3,
    '0') + ')');
end;

function fchp_Zal_Map(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string;
  var _Kod: integer; var _Nam: string; _PointerToData: Pointer): Boolean;
const
  ProcName: string = 'fchp_Zal_Map';
begin
  // --------------------------------------------------------------------------
  // Загрузка зала из запроса (2) Текущая запись
  // --------------------------------------------------------------------------
  Result := false;
  if Assigned(DataSet) and (length(s_DataSet_Kod) > 0) and
    (length(s_DataSet_Nam)
    > 0) and DataSet.Active then
  try
    if Assigned(DataSet.FieldByName(s_DataSet_Kod)) then
      _Kod := DataSet.FieldByName(s_DataSet_Kod).AsInteger;
    if Assigned(DataSet.FieldByName(s_DataSet_Nam)) then
      _Nam := DataSet.FieldByName(s_DataSet_Nam).AsString;
    // --------------------------------------------------------------------------
    // Загрузка зала из запроса
    // --------------------------------------------------------------------------
    Load_Zal_Map(DataSet, _Kod, _Nam, _PointerToData);
    // --------------------------------------------------------------------------
    Result := true;
  except
    on E: Exception do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'Getting field values failed.');
    end;
  end;
end;

function Combo_Load_Zal_Map(DataSet: TDataSet; Lines: TStrings; PointerData:
  Pointer): integer;
const
  ProcName: string = 'Combo_Load_Zal_Map';
begin
  // --------------------------------------------------------------------------
  // Загрузка залов из запроса
  // --------------------------------------------------------------------------
  Result := Combo_Load_DataSet(DataSet, Lines, s_ODEUM_KOD, s_ODEUM_DESC,
    fchp_Zal_Map, PointerData);
end;

function Load_All_Zals(Lines: TStrings; Container: TPanel;
  odmSelectRangeBefore, odmSelectRangeAfter: TSelectRangeEvent; Popup: TPopupMenu;
  tcLeftClick: TNotifyEvent; tcSeatExSelect: TSeatExSelectEvent; tcSeatExCmd:
  TSeatExCmdEvent; tcGetTicketProps: TGetTicketPropsEvent): boolean;
const
  ProcName: string = 'Load_All_Zals';
var
  Data: TCreateZalRec;
begin
  // --------------------------------------------------------------------------
  // 2.1) Загрузка всех залов
  // --------------------------------------------------------------------------
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  Result := false;
  if Assigned(Lines) and Assigned(Container) then
  begin
    Data.fList := nil;
    Data.fZalNum := 0;
    Data.fZalName := '';
    Data.fpnPanelContainer := Container;
    Data.fpnPlaceContainer := nil;
    Data.fodmSelectRangeBefore := odmSelectRangeBefore;
    Data.fodmSelectRangeAfter := odmSelectRangeAfter;
    Data.fppPopupMenu := Popup;
    Data.ftcLeftClick := tcLeftClick;
    Data.ftcSeatExSelect := tcSeatExSelect;
    Data.ftcSeatExCmd := tcSeatExCmd;
    Data.ftcGetTicketProps := tcGetTicketProps;
    Data.fElemType := 0;
    Data.fMultiplr := MultiplrMain;
    Data.fAutosize := true;
    Data.fBgColor := clBackground;
    if Combo_Load_Zal_Map(dm_Base.ds_Zal, Lines, @Data) >= 0 then
      Result := true;
  end
  else
  begin
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

end.

