{-----------------------------------------------------------------------------
 Unit Name: ufMain
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  01.03.2004
 Purpose:   Main Form
 History:
-----------------------------------------------------------------------------}
unit ufMain;

interface

{$I kinode01.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs, Gauges, SLForms, XPMenu,
  ComCtrls, ExtCtrls, StdCtrls, Buttons, Menus, ImgList, ActnList, ShpCtrl2, uhOper, Forms,
  WcBitBtn;

type
  Tfm_Main = class(TSLForm)
    sb_Main: TStatusBar;
    pn_Place_Container: TPanel;
    pn_Choice: TPanel;
    pn_Date: TPanel;
    lbl_Date: TLabel;
    dtp_Date: TDateTimePicker;
    pn_Select: TPanel;
    pn_Tariff: TPanel;
    lbl_Tariff: TLabel;
    pn_Info: TPanel;
    pn_Zal: TPanel;
    lbl_Zal: TLabel;
    cmb_Zal: TComboBox;
    pn_BigOne: TPanel;
    pn_Main_Container: TPanel;
    pn_Command: TPanel;
    pn_Cmd_Left: TPanel;
    bt_CmdReserve: TBitBtn;
    bt_CmdRestore: TBitBtn;
    bt_CmdOneTicket: TBitBtn;
    pn_Cmd_Right: TPanel;
    bt_CmdPosterminal: TBitBtn;
    bt_CmdCancel: TBitBtn;
    bt_CmdPrint: TBitBtn;
    iml_Main: TImageList;
    iml_MainTicket: TImageList;
    iml_Sell: TImageList;
    acl_Main: TActionList;
    acExit: TAction;
    acAbout: TAction;
    acOptions: TAction;
    acSalesJournal: TAction;
    acGenre: TAction;
    acCard: TAction;
    acSeans: TAction;
    acFilm: TAction;
    acInviter: TAction;
    acPerson: TAction;
    acTopogr: TAction;
    acGrouper: TAction;
    acFullScreen: TAction;
    acRepert: TAction;
    acReportSend: TAction;
    acTicket: TAction;
    acCost: TAction;
    acTariff: TAction;
    acDailyReport: TAction;
    acInfo: TAction;
    acKKMOptions: TAction;
    acConnRestore: TAction;
    acHde: TAction;
    acToggleQm: TAction;
    acRefresh: TAction;
    acl_MainTicket: TActionList;
    saPrint: TAction;
    saClear: TAction;
    saPosterminal: TAction;
    saMakeItSo: TAction;
    saRestore: TAction;
    saOneTicket: TAction;
    saReserve: TAction;
    mm_Main: TMainMenu;
    miFile: TMenuItem;
    miReportSend: TMenuItem;
    miLine14: TMenuItem;
    miExit: TMenuItem;
    miSpravochniki: TMenuItem;
    miTopogr: TMenuItem;
    miLine10: TMenuItem;
    miGenre: TMenuItem;
    miRejiser: TMenuItem;
    miProducer: TMenuItem;
    miMakers: TMenuItem;
    miSuppliers: TMenuItem;
    miLine13: TMenuItem;
    miSeansTimes: TMenuItem;
    miFilm: TMenuItem;
    miLine16: TMenuItem;
    miTicket: TMenuItem;
    miDocuments: TMenuItem;
    miCost: TMenuItem;
    miTariff: TMenuItem;
    miLine20: TMenuItem;
    miActions: TMenuItem;
    miLine26: TMenuItem;
    miLine25: TMenuItem;
    miPrint: TMenuItem;
    miLine21: TMenuItem;
    miCancel: TMenuItem;
    miLine23: TMenuItem;
    miPosterminal: TMenuItem;
    miOneTicket: TMenuItem;
    miReserve: TMenuItem;
    miLine24: TMenuItem;
    miRestore: TMenuItem;
    miCurCost: TMenuItem;
    miRepert: TMenuItem;
    miReports: TMenuItem;
    miTickets: TMenuItem;
    miDailyReport: TMenuItem;
    N1: TMenuItem;
    miInfo: TMenuItem;
    miService: TMenuItem;
    miKKMOptions: TMenuItem;
    miOptions: TMenuItem;
    miLine15: TMenuItem;
    miConnRestore: TMenuItem;
    miLine19: TMenuItem;
    miPrinterReload: TMenuItem;
    miLine22: TMenuItem;
    miFullScreen: TMenuItem;
    miHelp: TMenuItem;
    miHelpIndex: TMenuItem;
    miAbout: TMenuItem;
    pop_MainTicket: TPopupMenu;
    miLineActions1Start: TMenuItem;
    miLineActions1Foo: TMenuItem;
    miLineActions1Print: TMenuItem;
    miLineActions2Foo: TMenuItem;
    miLineActions1Clear: TMenuItem;
    miLineActions3Foo: TMenuItem;
    miLineActions1Pos: TMenuItem;
    miLineActions1One: TMenuItem;
    miLineActions1Reserve: TMenuItem;
    miLineActions4Foo: TMenuItem;
    miLineActions1Restore: TMenuItem;
    miLineActions5Foo: TMenuItem;
    miLineActions2Finish: TMenuItem;
    pop_Ticket: TPopupMenu;
    miTicketTypesInfo: TMenuItem;
    ppmLine1Start: TMenuItem;
    ppmMostUsed1: TMenuItem;
    ppmMostUsed2: TMenuItem;
    ppmMostUsed3: TMenuItem;
    ppmLine2Finish: TMenuItem;
    ppmCancelForeign: TMenuItem;
    ppmLine3Foo: TMenuItem;
    ppmForMoney: TMenuItem;
    ppmLine4Foo: TMenuItem;
    ppmForFree: TMenuItem;
    ppmLine5Start: TMenuItem;
    ppmLine6Finish: TMenuItem;
    miLine11: TMenuItem;
    pn_Header: TPanel;
    gg_Progress: TGauge;
    sb_Up: TSpeedButton;
    sb_Today: TSpeedButton;
    sb_Down: TSpeedButton;
    iml_Film: TImageList;
    tcx_Select: TSeatEx;
    st_Tariff: TSpeedShapeBtnEx;
    st_Info: TSpeedShapeBtnEx;
    ppmLine5Foo: TMenuItem;
    ppmShowHint: TMenuItem;
    acShowHint: TAction;
    acSeatCanceledShow: TAction;
    acSeatFreedShow: TAction;
    acSeatRestoredShow: TAction;
    miShowHint: TMenuItem;
    miSeatFreedShow: TMenuItem;
    miSeatCanceledShow: TMenuItem;
    miSeatRestoredShow: TMenuItem;
    bt_CmdFree: TBitBtn;
    saFree: TAction;
    miFree: TMenuItem;
    miLineActions1Free: TMenuItem;
    miLineActions6Foo: TMenuItem;
    ppmFastOptions: TMenuItem;
    ppmSeatCanceledShow: TMenuItem;
    ppmSeatFreedShow: TMenuItem;
    ppmSeatRestoredShow: TMenuItem;
    acPrinterTest: TAction;
    miPrinterTest: TMenuItem;
    acPrinterInit: TAction;
    acPrintSerial: TAction;
    miPrintSerial: TMenuItem;
    acGlobalRowShow: TAction;
    miGlobalRowShow: TMenuItem;
    bt_Exit: TWc_BitBtn;
    acPrintCheq: TAction;
    miPrintCheq: TMenuItem;
    miLine12: TMenuItem;
    miCheq: TMenuItem;
    miLineActions7Foo: TMenuItem;
    miLineActions1Cheq: TMenuItem;
    acSeatCheqedShow: TAction;
    miSeatCheqedShow: TMenuItem;
    ppmSeatCheqedShow: TMenuItem;
    acTicketReport: TAction;
    miTicketReport: TMenuItem;
    miLine27: TMenuItem;
    miLine28: TMenuItem;
    N2: TMenuItem;
    miLine29: TMenuItem;
    acPrice: TAction;
    miPrice: TMenuItem;
    acAbonem: TAction;
    miAbonem: TMenuItem;
    acAbonJournal: TAction;
    miLine30: TMenuItem;
    miJournalAbonem: TMenuItem;
    acDebugMode: TAction;
    miRefresh: TMenuItem;
    acSalesReport: TAction;
    miSalesReport: TMenuItem;
    tbc_Zal_List: TTabControl;
    tbc_Film_List: TTabControl;
    sbx_Cntr: TScrollBox;
    imgLogoOdeum: TImage;
    imgLogoCinema: TImage;
    st_Test_Hint: TStaticText;
    cbShowHint: TCheckBox;
    lbl_NoRepert: TLabel;
    iml_Zal: TImageList;
    miPrintMaket: TMenuItem;
    miMaketVer1: TMenuItem;
    miMaketVer2: TMenuItem;
    // --------------------------------------------------------------------------
    procedure acExitExecute(Sender: TObject);
    procedure acFullScreenExecute(Sender: TObject);
    procedure acFullScreenUpdate(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    // --------------------------------------------------------------------------
    procedure sb_UpClick(Sender: TObject);
    procedure sb_DownClick(Sender: TObject);
    procedure sb_TodayClick(Sender: TObject);
    procedure dtp_DateKeyPress(Sender: TObject; var Key: Char);
    // --------------------------------------------------------------------------
    procedure Process_Zal_Change(Sender: TObject; ProgressBar: TGauge);
    procedure Process_Date_Change(Sender: TObject; SeansReload: Boolean; ProgressBar: TGauge);
    procedure Process_Film_Change(Sender: TObject; SeansReload: Boolean; ProgressBar: TGauge);
    // --------------------------------------------------------------------------
    procedure Process_PX(Sender: TObject; ProgressBar: TGauge; Pst: TSaleType;
      bCheq: Boolean; AddPrintCount: Integer);
    // --------------------------------------------------------------------------
    // Нажатие левой
    procedure TicketLeftClick(Sender: TObject);
    // Нажатие правой
    procedure TicketRightClick(Sender: TObject);
    // Получение свойств нужного типа билета
    procedure tcx_GetTicketProps(Sender: TObject; const TicketKod,
      TicketVer: Integer; var TicketName: string; var TicketBgColor,
      TicketFontColor: TColor);
    // Обработка выделения
    procedure odm_SelectRangeAfter(Sender: TObject; RangeRect: TRect);
    procedure odm_SelectRangeBefore(Sender: TObject; RangeRect: TRect);
    procedure tcx_SeatExSelect(Sender: TObject; const MultipleAction: Boolean;
      var DoCtrlSelect: Boolean);
    procedure tcx_SeatExCmd(Sender: TObject; const CmdEx: TOperActionEx;
      var DoCtrlChange: Boolean);
    // --------------------------------------------------------------------------
    procedure TicketForceCancel(Sender: TObject);
    // --------------------------------------------------------------------------
    // Справочники
    // --------------------------------------------------------------------------
    procedure acCardExecute(Sender: TObject);
    procedure acGenreExecute(Sender: TObject);
    procedure acSeansExecute(Sender: TObject);
    procedure acFilmExecute(Sender: TObject);
    procedure acInviterExecute(Sender: TObject);
    procedure acPersonExecute(Sender: TObject);
    procedure acRepertExecute(Sender: TObject);
    procedure acAbonJournalExecute(Sender: TObject);
    procedure acCostExecute(Sender: TObject);
    procedure acTariffExecute(Sender: TObject);
    procedure acPriceExecute(Sender: TObject);
    procedure acGrouperExecute(Sender: TObject);
    procedure acOptionsExecute(Sender: TObject);
    procedure acTicketExecute(Sender: TObject);
    procedure acAbonemExecute(Sender: TObject);
    // --------------------------------------------------------------------------
    procedure acSalesJournalExecute(Sender: TObject);
    procedure acReportSendExecute(Sender: TObject);
    procedure acDailyReportExecute(Sender: TObject);
    procedure acTicketReportExecute(Sender: TObject);
    procedure acSalesReportExecute(Sender: TObject);
    // --------------------------------------------------------------------------
    procedure acShowHintExecute(Sender: TObject);
    procedure acShowHintUpdate(Sender: TObject);
    // --------------------------------------------------------------------------
    procedure acSeatCanceledShowExecute(Sender: TObject);
    procedure acSeatCanceledShowUpdate(Sender: TObject);
    // --------------------------------------------------------------------------
    procedure acSeatFreedShowExecute(Sender: TObject);
    procedure acSeatFreedShowUpdate(Sender: TObject);
    // --------------------------------------------------------------------------
    procedure acSeatRestoredShowExecute(Sender: TObject);
    procedure acSeatRestoredShowUpdate(Sender: TObject);
    // --------------------------------------------------------------------------
    procedure acGlobalRowShowExecute(Sender: TObject);
    procedure acGlobalRowShowUpdate(Sender: TObject);
    // --------------------------------------------------------------------------
    procedure acInfoExecute(Sender: TObject);
    procedure acInfoUpdate(Sender: TObject);
    procedure acKKMOptionsExecute(Sender: TObject);
    // --------------------------------------------------------------------------
    procedure acHdeExecute(Sender: TObject);
    procedure acToggleQmExecute(Sender: TObject);
    procedure st_InfoClick(Sender: TObject);
    procedure SetDefOpt(Sender: TObject);
    // --------------------------------------------------------------------------
    // Продажа подготовленных билетов за нал. и бесплатно
    procedure saPrintExecute(Sender: TObject);
    // Продажа подготовленных билетов по постерминалу
    procedure saPosterminalExecute(Sender: TObject);
    // Сброс подготовленных билетов
    procedure saClearExecute(Sender: TObject);
    procedure saMakeItSoExecute(Sender: TObject);
    // Бронь подготовленных билетов
    procedure saReserveExecute(Sender: TObject);
    // Продажа подготовленных билетов (печать одним билетом)
    procedure saOneTicketExecute(Sender: TObject);
    // Возврат реализованных билетов
    procedure saRestoreExecute(Sender: TObject);
    // Освобождение брони
    procedure saFreeExecute(Sender: TObject);
    // --------------------------------------------------------------------------
    // Обновление карты зала
    procedure acRefreshExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure st_Ctrl_MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    // --------------------------------------------------------------------------
    procedure dtp_DateChange(Sender: TObject);
    procedure cmb_ZalChange(Sender: TObject);
    procedure tbc_Zal_ListChange(Sender: TObject);
    procedure tbc_Film_ListChange(Sender: TObject);
    procedure acPrinterInitExecute(Sender: TObject);
    procedure acPrinterInitUpdate(Sender: TObject);
    procedure acPrinterTestExecute(Sender: TObject);
    procedure acPrintSerialExecute(Sender: TObject);
    procedure acPrintSerialUpdate(Sender: TObject);
    procedure acPrintCheqExecute(Sender: TObject);
    procedure acPrintCheqUpdate(Sender: TObject);
    procedure acConnRestoreExecute(Sender: TObject);
    procedure acConnRestoreUpdate(Sender: TObject);
    // --------------------------------------------------------------------------
    function UpdateStatusBar(What: Integer): Boolean;
    procedure acTopogrExecute(Sender: TObject);
    procedure acTopogrUpdate(Sender: TObject);
    procedure SaveOdeumMapToFile(Sender: TObject);
    procedure acSeatCheqedShowExecute(Sender: TObject);
    procedure acSeatCheqedShowUpdate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sb_MainDblClick(Sender: TObject);
    procedure acDebugModeExecute(Sender: TObject);
    procedure MaketVerChoose(Sender: TObject);
    // --------------------------------------------------------------------------
  private
    FWDelta, FHDelta: Integer;
    ActiveFirstTime: Boolean;
    LostFirstTime: Boolean;
    { Private declarations }
    procedure ScrollMove(px, py: byte);
    function SetMainStatus(PanelIndex: Integer; StatusText: string): Boolean;
    function ResolvePopupComponent(const Sender: TObject; const Popup: TPopupMenu;
      var MenuItem: TMenuItem; var SeatEx: TSeatEx): Boolean;
    // --------------------------------------------------------------------------
  public
    { Public declarations }
    fRptReloaded: Boolean;
    procedure LoadDigests(ProgressBar: TGauge);
    procedure AdjustZalPosSbx(HorzPos, VertPos: Integer);
  end;

var
  fm_Main: Tfm_Main;

implementation

uses
  Bugger, uhGetver, StrConsts, uTools, ufSplash, uhLoader, uhTicket, uhMain,
  ufGenre, ufFilm, ufSeans, ufTariff, ufCost, ufRepert, uhCommon, urCommon,
  uhBase, uhTariff, uhPrint, ufInfo, ufDRpAz, ufDRpBe, ufDRpEx, ufPrice,
  ufAbjnl;

{$R *.DFM}

const
  UnitName: string = 'ufMain';
  VK_NONE: Word = 0;
  dsc_number: Word = 0;

procedure Tfm_Main.LoadDigests(ProgressBar: TGauge);
const
  ProcName: string = 'LoadDigests';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  i, tmp_Zal_Kod, tmp_Odeum_Horz_Pos, tmp_Odeum_Vert_Pos: integer;
  tmp_Print_Maket_Version, tmp_Print_Maket_Horz_Shift, tmp_Print_Maket_Vert_Shift: integer;
  tmp_Odeum_Show_Hint: string;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  Time_Start := Now;
  // --------------------------------------------------------------------------
  // Подготовка некоторых констант
  // --------------------------------------------------------------------------
  Cur_Film_Kod := -1;
  Cur_Film_Nam := '';
  Cur_Seans_Time := '';
  // --------------------------------------------------------------------------
  // 2.1) Загрузка всех залов
  // --------------------------------------------------------------------------
  if not Load_All_Zals(cmb_Zal.Items, pn_Place_Container,
    odm_SelectRangeBefore, odm_SelectRangeAfter,
    pop_Ticket, TicketLeftClick,
    tcx_SeatExSelect, tcx_SeatExCmd, tcx_GetTicketProps) then
  begin
    Application.MessageBox(PChar('Не могу загрузить залы. Ошибка такая:' + c_CRLF +
      c_Separator_20 + c_CRLF + c_CRLF + DBLastError2), 'Loading error', MB_ICONERROR);
  end;
  tbc_Zal_List.Tabs.Assign(cmb_Zal.Items);
  // --------------------------------------------------------------------------
  // 2.2) Загрузка всех типов билетов
  // --------------------------------------------------------------------------
  if not Load_All_Ticket_Types(iml_Sell, pop_Ticket, ppmForFree.MenuIndex, ppmForMoney.MenuIndex,
    ppmLine1Start.MenuIndex, ppmLine2Finish.MenuIndex, miCurCost, SLXPMenu.Font, TicketRightClick)
      then
  begin
    Application.MessageBox(PChar('Не могу загрузить типы билетов. Ошибка такая:' + c_CRLF +
      c_Separator_20 + c_CRLF + c_CRLF + DBLastError2), 'Loading error', MB_ICONERROR);
  end;
  // --------------------------------------------------------------------------
  // 2.3) Загрузка всех тарифов
  // --------------------------------------------------------------------------
  if False then
    if (not Load_All_Tariffs) and False then
    begin
      Application.MessageBox(PChar('Не могу загрузить тарифы. Ошибка такая:' + c_CRLF +
        c_Separator_20 + c_CRLF + c_CRLF + DBLastError2), 'Loading error', MB_ICONERROR);
    end;
  // --------------------------------------------------------------------------
  // Загрузка текущего зала
  // --------------------------------------------------------------------------
  dtp_Date.Date := now;
  Cur_Date := dtp_Date.Date;
  with cmb_Zal do
    if Items.Count > 0 then
    begin
      ItemIndex := Items.Count - 1;
      tmp_Zal_Kod := Integer(Items.Objects[ItemIndex]);
      // --------------------------------------------------------------------------
      if LoadInitParameterInt(s_Preferences_Section, s_OdeumKod, tmp_Zal_Kod, tmp_Zal_Kod) then
      begin
        for i := 0 to Items.Count - 1 do
          if Integer(Items.Objects[i]) = tmp_Zal_Kod then
          begin
            ItemIndex := i;
            tmp_Zal_Kod := Integer(Items.Objects[ItemIndex]);
          end;
      end;
      // --------------------------------------------------------------------------
      if LoadInitParameterInt(s_Preferences_Section, s_CommonOdeumHorzPos, Common_Odeum_Horz_Pos,
        tmp_Odeum_Horz_Pos) then
      begin
        if (tmp_Odeum_Horz_Pos >= 0) and (tmp_Odeum_Horz_Pos <= 100) then
          Common_Odeum_Horz_Pos := tmp_Odeum_Horz_Pos;
      end;
      // --------------------------------------------------------------------------
      if LoadInitParameterInt(s_Preferences_Section, s_CommonOdeumVertPos, Common_Odeum_Vert_Pos,
        tmp_Odeum_Vert_Pos) then
      begin
        if (tmp_Odeum_Vert_Pos >= 0) and (tmp_Odeum_Vert_Pos <= 100) then
          Common_Odeum_Vert_Pos := tmp_Odeum_Vert_Pos;
      end;
      // --------------------------------------------------------------------------
      Process_Zal_Change(nil, ProgressBar);
      // --------------------------------------------------------------------------
      SaveInitParameter(s_Preferences_Section, s_OdeumKod, IntToStr(tmp_Zal_Kod));
      SaveInitParameter(s_Preferences_Section, s_CommonOdeumHorzPos, IntToStr(tmp_Odeum_Horz_Pos));
      SaveInitParameter(s_Preferences_Section, s_CommonOdeumVertPos, IntToStr(tmp_Odeum_Vert_Pos));
      // --------------------------------------------------------------------------
      if LoadInitParameterStr(s_Preferences_Section, s_CommonOdeumShowHint, s_Yes,
        tmp_Odeum_Show_Hint) then
      begin
        if (UpperCase(tmp_Odeum_Show_Hint) = UpperCase(s_Yes)) then
        begin
          tmp_Odeum_Show_Hint := s_Yes;
          sbx_Cntr.ShowHint := true;
        end
        else if (UpperCase(tmp_Odeum_Show_Hint) = UpperCase(s_No)) then
        begin
          tmp_Odeum_Show_Hint := s_No;
          sbx_Cntr.ShowHint := false;
        end;
      end;
      SaveInitParameter(s_Preferences_Section, s_CommonOdeumShowHint, tmp_Odeum_Show_Hint);
      // --------------------------------------------------------------------------
    end
    else
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error - there is no zal.');
    end;
  // --------------------------------------------------------------------------
  // Загрузка остальных настроек
  // --------------------------------------------------------------------------
  if LoadInitParameterInt(s_Preferences_Section, s_PrintMaketVersion, Print_Maket_Version,
    tmp_Print_Maket_Version) then
  begin
    if (tmp_Print_Maket_Version > 0) and (tmp_Print_Maket_Version < 10000) then
      Print_Maket_Version := tmp_Print_Maket_Version;
  end;
  // --------------------------------------------------------------------------
  SaveInitParameter(s_Preferences_Section, s_PrintMaketVersion, IntToStr(Print_Maket_Version));
  // --------------------------------------------------------------------------
  for i := 0 to miPrintMaket.Count - 1 do
  begin
    if miPrintMaket.Items[i].Tag = Print_Maket_Version then
      miPrintMaket.Items[i].Checked := True;
  end;
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(0, UnitName, ProcName, 'Print_Maket_Version = ['
    + IntToStr(Print_Maket_Version) + ']');
{$ENDIF}
  // --------------------------------------------------------------------------
  if LoadInitParameterInt(s_Preferences_Section, s_PrintMaketHorzShift, Print_Maket_Horz_Shift,
    tmp_Print_Maket_Horz_Shift) then
  begin
    if (tmp_Print_Maket_Horz_Shift > -1000) and (tmp_Print_Maket_Horz_Shift < 1000) then
      Print_Maket_Horz_Shift := tmp_Print_Maket_Horz_Shift;
  end;
  // --------------------------------------------------------------------------
  SaveInitParameter(s_Preferences_Section, s_PrintMaketHorzShift, IntToStr(Print_Maket_Horz_Shift));
  // --------------------------------------------------------------------------
  if LoadInitParameterInt(s_Preferences_Section, s_PrintMaketVertShift, Print_Maket_Vert_Shift,
    tmp_Print_Maket_Vert_Shift) then
  begin
    if (tmp_Print_Maket_Vert_Shift > -1000) and (tmp_Print_Maket_Vert_Shift < 1000) then
      Print_Maket_Vert_Shift := tmp_Print_Maket_Vert_Shift;
  end;
  // --------------------------------------------------------------------------
  SaveInitParameter(s_Preferences_Section, s_PrintMaketVertShift, IntToStr(Print_Maket_Vert_Shift));
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMessEnh(0, UnitName, ProcName, 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0')
    + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure ConvertCoords(C1, C2: TControl; P1: TPoint; var P2: TPoint);
begin
  p2 := p1;
  if (c1 is TControl) then
    p2 := (c1 as TControl).ClientToScreen(p1);
  if (c2 is TControl) then
    p2 := (c2 as TControl).ScreenToClient(p2);
end;

procedure Tfm_Main.acExitExecute(Sender: TObject);
begin
  Close;
end;

procedure Tfm_Main.acFullScreenExecute(Sender: TObject);
begin
  pn_BigOne.SetFocus;
  FullScreen := not FullScreen;
  pn_BigOne.SetFocus;
end;

procedure Tfm_Main.acFullScreenUpdate(Sender: TObject);
begin
  acFullScreen.Checked := FullScreen;
end;

procedure Tfm_Main.acAboutExecute(Sender: TObject);
begin
  if Assigned(fm_Splash) then
    with fm_Splash do
    begin
      if Visible then
        Close;
      FormClean(True);
      SetTimer(-1, False);
      tmr_Splash.OnTimer := tmr_SplashTimer;
      SetTimer(187000, True);
      ShowModal;
      SetForegroundWindow(Application.MainForm.Handle);
    end;
end;

procedure Tfm_Main.ScrollMove(px, py: byte);
const
  ProcName: string = 'ScrollMove';
  {
var
  wx, wy: integer;
  wx1, wy1: integer;
  }
begin
  with sbx_Cntr do
    if ComponentCount > 0 then
    begin
      with HorzScrollBar do
      begin
        {
        wx := round(sqr(ClientWidth) / Range);
        }
        Position := Round((Range - ClientWidth) * px / 100
          + (sqr(ClientWidth) / Range) * (px - 50) / 50);
        {
        wx1 := round(Position * 100 / (Range - ClientWidth));
        }
      end;
      with VertScrollBar do
      begin
        {
        wy := round(sqr(ClientHeight) / Range);
        }
        Position := Round((Range - ClientHeight) * py / 100
          + (sqr(ClientHeight) / Range) * (py - 50) / 50);
        {
        wy1 := round(Position * 100 / (Range - ClientHeight));
        }
      end;
      {
      Caption :=
        format('fmMain - wx=%u, wy=%u, ClX=%u, ClY=%u, RngX=%u, RngY=%u, psX=%u=%u%%, ScX=%u, psY=%u=%u%%, ScY=%u',
        [wx, wy, ClientWidth, ClientHeight, HorzScrollBar.Range, VertScrollBar.Range,
        HorzScrollBar.Position, wx1, HorzScrollBar.ScrollPos, VertScrollBar.Position, wy1,
        VertScrollBar.ScrollPos]);
      }
    end;
end;

function Tfm_Main.SetMainStatus(PanelIndex: Integer; StatusText: string): Boolean;
const
  ProcName: string = 'SetMainStatus';
begin
  Result := False;
  if (PanelIndex > -1) and (sb_Main.Panels.Count > PanelIndex) then
  begin
    if Length(StatusText) > 0 then
      sb_Main.Panels[PanelIndex].Text := StatusText
    else
      sb_Main.Panels[PanelIndex].Text := '---';
    Update;
    Result := True;
  end;
end;

function Tfm_Main.UpdateStatusBar(What: Integer): Boolean;
var
  HostName: string;
  HostAddress: string;
  HostAddr: LongInt;
begin
  // --------------------------------------------------------------------------
  Result := True;
  if (What = -1) or (What = 0) then
    SetMainStatus(0, 'Session = ' + IntToStr(Global_Session_ID));
  if (What = -1) or (What = 1) or (What = 2) then
    if GetHostInfoEx(HostName, HostAddress, HostAddr) then
    begin
      SetMainStatus(1, HostName);
      SetMainStatus(2, HostAddress);
    end
    else
    begin
      SetMainStatus(1, 'localhost');
      SetMainStatus(2, '127.0.0.1');
    end;
  if (What = -1) or (What = 3) then
    SetMainStatus(3, Global_User_Nam);
  if (What = -1) or (What = 4) then
    if DBConnected2 then
      SetMainStatus(4, 'Connected to DB')
    else
    begin
      SetMainStatus(4, 'Lost connection');
      if LostFirstTime then
      begin
        MessageDlg('Пропало соединение с БД. Особые приметы: TCP/IP, Firebird 1.5, не кусается.'
          + #13 + #10 + 'Прошу вернуть за вознаграждение.' + #13 + #10
          + '--' + #13 + #10 + 'P.S. Проверьте сетевое соединение и перезапустите программу.',
          mtConfirmation, [mbOK], 0);
        LostFirstTime := False;
      end;
    end;
  if (What = -1) or (What = 5) then
  begin
    if fRptReloaded then
      SetMainStatus(5, 'Monitoring changes ...')
    else
      SetMainStatus(5, 'Repertuar updated !');
  end;
  Update;
  // --------------------------------------------------------------------------
end;

procedure Tfm_Main.FormCreate(Sender: TObject);
begin
  fRptReloaded := True;
  LostFirstTime := True;
  ActiveFirstTime := True;
  FWDelta := -1;
  FHDelta := -1;
  GetModuleVersionStr_App;
  Caption := Caption + ' (ver ' + sApp_FileVersion + ')';
  ScrollMove(50, 50);
  Application.HintPause := 250;
  Application.HintHidePause := 45000;
  GlobalColumnShow := True;
  GlobalRowShow := True;
  GlobalSeatCanceledShow := False;
  GlobalSeatFreedShow := False;
  GlobalSeatRestoredShow := False;
  GlobalSeatCheqedShow := False;
end;

procedure Tfm_Main.FormActivate(Sender: TObject);
const
  ProcName: string = 'FormActivate';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  SetProgressMinMax(0, 100, 0, False);
  if ActiveFirstTime then
  begin
    acInfo.Execute;
    ActiveFirstTime := False;
    SetForegroundWindow(Self.Handle);
  end;
  UpdateStatusBar(-1);
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Main.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
const
  VertWheelPoints: Integer = 32;
  HorzWheelPoints: Integer = 24;
var
  LocalPos: TPoint;
  HotControl: TControl;
begin
  // --------------------------------------------------------------------------
  if (ActiveControl is TComboBox) then
  begin
    ActiveControl := FindNextControl(Self.ActiveControl, True, False, True);
    Handled := True;
    Exit;
  end;
  with pn_BigOne do
  begin
    ConvertCoords(nil, pn_BigOne, MousePos, LocalPos);
    HotControl := ControlAtPos(LocalPos, False, True);
  end;
  if ((HotControl is TPanel) and (HotControl = pn_Main_Container)) then
    with sbx_Cntr do
    begin
      VertScrollBar.Position := VertScrollBar.Position - Sign(WheelDelta) * VertWheelPoints;
      Handled := True;
    end
  else if ((HotControl is TPanel)
    and ((HotControl = pn_Command) or (HotControl = pn_Header))) then
    with sbx_Cntr do
    begin
      HorzScrollBar.Position := HorzScrollBar.Position - Sign(WheelDelta) * HorzWheelPoints;
      Handled := True;
    end;
  // --------------------------------------------------------------------------
end;

procedure Tfm_Main.sb_UpClick(Sender: TObject);
begin
  if dtp_Date.Enabled then
  begin
    dtp_Date.Date := dtp_Date.Date + 1;
    dtp_DateChange(Sender);
  end;
end;

procedure Tfm_Main.sb_DownClick(Sender: TObject);
begin
  if dtp_Date.Enabled then
  begin
    dtp_Date.Date := dtp_Date.Date - 1;
    dtp_DateChange(Sender);
  end;
end;

procedure Tfm_Main.sb_TodayClick(Sender: TObject);
begin
  if dtp_Date.Enabled then
  begin
    dtp_Date.Date := Now;
    if fRptReloaded then
      dtp_DateChange(Sender)
    else
      Process_Date_Change(nil, False, gg_Progress);
  end;
end;

procedure Tfm_Main.dtp_DateKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = Char(VK_SPACE)) then
  begin
    dtp_Date.Date := Now;
  end;
end;

procedure Tfm_Main.Process_Zal_Change(Sender: TObject; ProgressBar: TGauge);
const
  ProcName: string = 'Process_Zal_Change';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  tmp_Zal_Kod: integer;
begin
  Time_Start := Now;
  // --------------------------------------------------------------------------
  // Смена текущего зала
  // --------------------------------------------------------------------------
  DEBUGMessBrk(0, 'Begin Zal Change');
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$IFDEF Debug_Level_6}
  if Assigned(Sender) and (Sender is TComponent) then
    DEBUGMessEnh(0, UnitName, ProcName, 'Sender = ' + (Sender as TComponent).Name
      + ' (' + Sender.ClassName + ')')
  else
    DEBUGMessEnh(0, UnitName, ProcName, 'Sender is null.');
{$ENDIF}
  // --------------------------------------------------------------------------
  // sbx_Cntr.Visible := False;
  LostFirstTime := True;
  with cmb_Zal do
  begin
    if ItemIndex = -1 then
      tmp_Zal_Kod := -1
    else
    begin
      tmp_Zal_Kod := Integer(Items.Objects[ItemIndex]);
      tbc_Zal_List.TabIndex := ItemIndex;
    end;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, 'Zal_Kod = (' + IntToStr(tmp_Zal_Kod) + ')');
  if tbc_Film_List.TabIndex <> -1 then
    DEBUGMessEnh(0, UnitName, ProcName, 'Description is (' +
      cmb_Zal.Items[cmb_Zal.ItemIndex] + ')');
  Change_Cur_Zal(tmp_Zal_Kod, False, tbc_Film_List.Tabs, pn_Place_Container,
    sbx_Cntr, Process_Film_Change, ProgressBar);
  Emblema_Loaded := False;
  // --------------------------------------------------------------------------
  if (Cur_Panel_Cntr is TOdeumPanel) then
    with (Cur_Panel_Cntr as TOdeumPanel) do
    begin
      imgLogoOdeum.Picture.Bitmap.Assign(OdeumLogo);
      imgLogoCinema.Picture.Bitmap.Assign(CinemaLogo);
      with (Cur_Panel_Cntr as TOdeumPanel) do
        if (Length(Hint) > 0) then
          st_Test_Hint.Hint := Hint
        else
          st_Test_Hint.Hint := Caption;
    end;
  // --------------------------------------------------------------------------
  AdjustZalPosSbx(Common_Odeum_Horz_Pos, Common_Odeum_Vert_Pos);
  ScrollMove(50, 50);
  if Cur_Repert_Kod > -1 then
  begin
    tbc_Film_List.TabIndex := tbc_Film_List.Tabs.IndexOfObject(TObject(Cur_Repert_Kod));
    DEBUGMessEnh(0, UnitName, ProcName, 'TabIndex = ' + IntToStr(tbc_Film_List.TabIndex));
  end;
  Refresh_TC_Count(3);
  fRptReloaded := True;
  UpdateStatusBar(5);
  // sbx_Cntr.Visible := True;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  DEBUGMessBrk(0, 'End Zal Change');
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMessEnh(0, UnitName, ProcName, 'Work time - (' + IntToStr(Hour) + ':' +
    FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3,
    '0') + ')');
  // --------------------------------------------------------------------------
end;

procedure Tfm_Main.Process_Date_Change(Sender: TObject; SeansReload: Boolean; ProgressBar: TGauge);
const
  ProcName: string = 'Process_Date_Change';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
begin
  Time_Start := Now;
  // --------------------------------------------------------------------------
  // Смена рабочей даты
  // --------------------------------------------------------------------------
  DEBUGMessBrk(0, 'Begin Date Change');
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$IFDEF Debug_Level_6}
  if Assigned(Sender) and (Sender is TComponent) then
    DEBUGMessEnh(0, UnitName, ProcName, 'Sender = ' + (Sender as TComponent).Name
      + ' (' + Sender.ClassName + ')')
  else
    DEBUGMessEnh(0, UnitName, ProcName, 'Sender is null.');
{$ENDIF}
  // --------------------------------------------------------------------------
  // sbx_Cntr.Visible := False;
  LostFirstTime := True;
  DateSeparator := '/';
  DEBUGMessEnh(0, UnitName, ProcName, 'Date is (' +
    FormatDateTime('dd/mm/yyyy', dtp_Date.Date) + ')');
  if dtp_Date.Enabled then
  try
    dtp_Date.Enabled := False;
    cmb_Zal.Enabled := False;
    // --------------------------------------------------------------------------
    // Обновление состояния
    // --------------------------------------------------------------------------
    // set Date from Control
    Change_Cur_Date(dtp_Date.Date, not Assigned(Sender), tbc_Film_List.Tabs,
      Process_Film_Change, SeansReload, ProgressBar);
    AdjustZalPosSbx(Common_Odeum_Horz_Pos, Common_Odeum_Vert_Pos);
    ScrollMove(50, 50);
  finally
    cmb_Zal.Enabled := True;
    dtp_Date.Enabled := True;
    // sbx_Cntr.Visible := True;
  end
  else
    DEBUGMessEnh(0, UnitName, ProcName, 'Error: Film change failed.');
  Refresh_TC_Count(4);
  fRptReloaded := True;
  UpdateStatusBar(5);
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  DEBUGMessBrk(0, 'End Date Change');
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMessEnh(0, UnitName, ProcName, 'Work time - (' + IntToStr(Hour) + ':' +
    FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3,
    '0') + ')');
  // --------------------------------------------------------------------------
end;

procedure Tfm_Main.Process_Film_Change(Sender: TObject; SeansReload: Boolean; ProgressBar: TGauge);
const
  ProcName: string = 'Process_Film_Change';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  tmpFilm_Kod: integer;
  s: string;
  d_REPERT_DATE: TDate;
  i_REPERT_ZAL: Integer;
  str_ZAL_DESC: string;
  i_REPERT_SEANS: Integer;
  str_SEANS_TIME: string;
  i_REPERT_FILM: Integer;
  str_FILM_NAM, str_FILM_DESC: string;
  i_REPERT_TARIFF: Integer;
  str_TARIFF_DESC, str_TARIFF_COMMENT, str_REPERT_DESC: string;
  Counter: Integer;
  // TariffCaptionLen: Integer;
  bv: Boolean;
  nb: TCursor;
  i, indx: Integer;
begin
  Time_Start := Now;
  // --------------------------------------------------------------------------
  // Смена текущего сеанса
  // --------------------------------------------------------------------------
  DEBUGMessBrk(0, 'Begin Film Change');
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$IFDEF Debug_Level_6}
  if Assigned(Sender) and (Sender is TComponent) then
    DEBUGMessEnh(0, UnitName, ProcName, 'Sender = ' + (Sender as TComponent).Name
      + ' (' + Sender.ClassName + ')')
  else
    DEBUGMessEnh(0, UnitName, ProcName, 'Sender is null.');
{$ENDIF}
  // --------------------------------------------------------------------------
  LostFirstTime := True;
  bv := True;
  nb := Screen.Cursor;
  if tbc_Film_List.Enabled then
  try
    dtp_Date.Enabled := False;
    cmb_Zal.Enabled := False;
    tbc_Film_List.Enabled := False;
    Screen.Cursor := crAppStart;
    // --------------------------------------------------------------------------
    ProgressBar.Visible := True;
    ProgressBar.Progress := 0;
    // bv := sbx_Cntr.Visible;
    // sbx_Cntr.Visible := False;
    if Assigned(Cur_Panel_Cntr) then
    try
      bv := Cur_Panel_Cntr.Visible;
      Cur_Panel_Cntr.Visible := False;
    except
      DEBUGMessEnh(0, UnitName, ProcName, 'Error: Setting Cur_Panel_Cntr.Visible = 0 failed.');
    end;
    // --------------------------------------------------------------------------
    DEBUGMessEnh(0, UnitName, ProcName, 'SeansReload = ' + BoolYesNo[SeansReload]);
    with tbc_Film_List do
    begin
      if SeansReload and (Cur_Repert_Kod > 0) then
      begin
        // todo: Restore Cur_Repert_Kod
        indx := -1;
        try
          for i := 0 to Tabs.Count - 1 do
          begin
            if Cur_Repert_Kod = Integer(Tabs.Objects[i]) then
              indx := i;
          end;
        except
          indx := -1;
        end;
        if (indx > 0) then
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'indx = ' + IntToStr(indx) + ', text = ' +
            Tabs[indx]);
          try
            TabIndex := indx;
          except
          end;
        end
        else
          DEBUGMessEnh(0, UnitName, ProcName, 'Cur_Repert Tab not found.');
      end;
      if TabIndex = -1 then
        tmpFilm_Kod := -1
      else
        tmpFilm_Kod := Integer(Integer(Tabs.Objects[TabIndex]));
    end;
    // --------------------------------------------------------------------------
    DEBUGMessEnh(0, UnitName, ProcName, 'Film_Kod = (' + IntToStr(tmpFilm_Kod) + ')');
{$IFDEF Debug_Level_6}
    if Assigned(Sender) and (Sender is TComponent) then
      DEBUGMessEnh(0, UnitName, ProcName, 'Sender = ' + (Sender as TComponent).Name
        + ' (' + Sender.ClassName + ')')
    else
      DEBUGMessEnh(0, UnitName, ProcName, 'Sender is null.');
{$ENDIF}
    if (Sender <> Self) then
    begin
      // --------------------------------------------------------------------------
      // Очистка выделенных мест
      // --------------------------------------------------------------------------
      if Cur_Repert_Kod > 0 then
      begin
        Counter := 0 {Op_Clear_Sel(True, 0, Cur_Repert_Kod, True)};
        DEBUGMessEnh(0, UnitName, ProcName, 'Cleared = ' + IntToStr(Counter));
      end;
      if tmpFilm_Kod > 0 then
      begin
        Counter := 0 {Op_Clear_Sel(True, 0, tmpFilm_Kod, True)};
        DEBUGMessEnh(0, UnitName, ProcName, 'Cleared = ' + IntToStr(Counter));
      end;
    end;
    // --------------------------------------------------------------------------
    with tbc_Film_List do
      if TabIndex <> -1 then
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Description is (' +
          tbc_Film_List.Tabs[tbc_Film_List.TabIndex] + ')');
        tbc_Film_List.Visible := True;
        tbc_Film_List.Enabled := True;
        pn_Header.Caption := FormatDateTime('ddd, d mmm yyyy', Cur_Date) +
          ' - ' + tbc_Film_List.Tabs[tbc_Film_List.TabIndex] + ' - [' +
          IntToStr(tmpFilm_Kod) + ']';
      end
      else
      begin
        tbc_Film_List.Visible := False;
        pn_Header.Caption := 'Сегодня - ' + FormatDateTime('ddd,d mmm yyyy',
          now) + '. Выбранная дата - ' + FormatDateTime('ddd, d mmm yyyy',
          Cur_Date) + '.';
      end;
    // --------------------------------------------------------------------------
    if Get_Repert_Props(tmpFilm_Kod, d_REPERT_DATE, i_REPERT_ZAL, str_ZAL_DESC,
      i_REPERT_SEANS, str_SEANS_TIME, i_REPERT_FILM, str_FILM_NAM, str_FILM_DESC,
      i_REPERT_TARIFF, str_TARIFF_DESC, str_TARIFF_COMMENT, str_REPERT_DESC) > 0 then
    begin
      Cur_Film_Kod := i_REPERT_FILM;
      Cur_Film_Nam := str_FILM_NAM;
      Cur_Seans_Time := str_SEANS_TIME;
    end
    else
    begin
      Cur_Film_Kod := 0;
      Cur_Film_Nam := '';
      Cur_Seans_Time := '';
    end;
    // --------------------------------------------------------------------------
    pn_Header.Hint := 'Код репертуара = ' + IntToStr(tmpFilm_Kod) + c_CRLF +
      'Время сеанса = ' + str_SEANS_TIME + c_CRLF + 'Код фильма = ' +
      IntToStr(i_REPERT_FILM) + c_CRLF + 'Название фильма = "' + str_FILM_NAM +
      '"';
    st_Tariff.Hint := 'Код тарифа = ' + IntToStr(i_REPERT_TARIFF) + c_CRLF +
      'Тариф = ' + str_TARIFF_DESC + c_CRLF + 'Комментарий тарифа = "' +
      str_TARIFF_COMMENT + '"';
    // --------------------------------------------------------------------------
    s := st_Tariff.Caption;
    Change_Cur_Seans(tmpFilm_Kod, False, s, pop_Ticket, ppmForMoney, miCurCost,
      Self.SLXPMenu.Font, ProgressBar);
    // --------------------------------------------------------------------------
    {
    if Get_Caption_Length(s, st_Tariff.FixedFont) > (st_Tariff.Width * 9) div 10 then
    begin
      TariffCaptionLen := Get_Caption_Max_Len(s, c_Space, (st_Tariff.Width * 9) div 10,
        st_Tariff.FixedFont);
      if Length(s) > TariffCaptionLen then
        st_Tariff.Caption := FormatTextToMax(s, TariffCaptionLen, c_Space, True)
      else
        st_Tariff.Caption := s;
    end
    else
      st_Tariff.Caption := s;
    }
    st_Tariff.Caption := s;
    // --------------------------------------------------------------------------
  finally
    // sbx_Cntr.Visible := bv;
    ProgressBar.Progress := 100;
    ProgressBar.Visible := False;
    // --------------------------------------------------------------------------
    dtp_Date.Enabled := True;
    cmb_Zal.Enabled := True;
    tbc_Film_List.Enabled := True;
    if Assigned(Cur_Panel_Cntr) then
    try
      Cur_Panel_Cntr.Visible := bv;
    except
      DEBUGMessEnh(0, UnitName, ProcName, 'Error: Setting Cur_Panel_Cntr.Visible = 1 failed.');
    end;
    Screen.Cursor := nb;
  end
  else
    DEBUGMessEnh(0, UnitName, ProcName, 'Error: Film change failed.');
  Refresh_TC_Count(5);
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  DEBUGMessBrk(0, 'End Film Change');
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMessEnh(0, UnitName, ProcName, 'Work time - (' + IntToStr(Hour) + ':' +
    FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3,
    '0') + ')');
  // --------------------------------------------------------------------------
end;

procedure Tfm_Main.Process_PX(Sender: TObject; ProgressBar: TGauge; Pst: TSaleType;
  bCheq: Boolean; AddPrintCount: Integer);
const
  ProcName: string = 'Process_PX';
var
  // bv: Boolean;
  nb: TCursor;
begin
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  // bv := True;
  nb := Screen.Cursor;
  if tbc_Film_List.Enabled then
  try
    dtp_Date.Enabled := False;
    cmb_Zal.Enabled := False;
    tbc_Film_List.Enabled := False;
    Screen.Cursor := crAppStart;
    // --------------------------------------------------------------------------
    ProgressBar.Visible := True;
    ProgressBar.Progress := 0;
    // --------------------------------------------------------------------------
    {
    if Assigned(Cur_Panel_Cntr) then
    try
      bv := Cur_Panel_Cntr.Visible;
      Cur_Panel_Cntr.Visible := False;
    except
      DEBUGMessEnh(0, UnitName, ProcName, 'Error: Setting Cur_Panel_Cntr.Visible = 0 failed.');
    end;
    }
    // --------------------------------------------------------------------------
    PX_Sale(ProgressBar, Pst, bCheq, AddPrintCount);
  finally
    // --------------------------------------------------------------------------
    ProgressBar.Progress := 100;
    ProgressBar.Visible := False;
    // --------------------------------------------------------------------------
    dtp_Date.Enabled := True;
    cmb_Zal.Enabled := True;
    tbc_Film_List.Enabled := True;
    {
    if Assigned(Cur_Panel_Cntr) then
    try
      Cur_Panel_Cntr.Visible := bv;
    except
      DEBUGMessEnh(0, UnitName, ProcName, 'Error: Setting Cur_Panel_Cntr.Visible = 1 failed.');
    end;
    }
    Screen.Cursor := nb;
  end;
  Refresh_TC_Count(6);
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.TicketLeftClick(Sender: TObject);
const
  ProcName: string = 'TicketLeftClick';
begin
{$IFDEF Debug_Level_8}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  if Assigned(Sender) and (Sender is TComponent) then
    DEBUGMessEnh(0, UnitName, ProcName, 'Sender = ' + (Sender as TComponent).Name
      + ' (' + Sender.ClassName + ')')
  else
    DEBUGMessEnh(0, UnitName, ProcName, 'Sender is null.');
{$ENDIF}
  // --------------------------------------------------------------------------
  Refresh_TC_Count(7);
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_8}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

function Tfm_Main.ResolvePopupComponent(const Sender: TObject; const Popup: TPopupMenu;
  var MenuItem: TMenuItem; var SeatEx: TSeatEx): Boolean;
begin
  Result := False;
  try
    if Assigned(Sender) and (Sender is TMenuItem) and Assigned(Popup) then
    begin
      MenuItem := (Sender as TMenuItem);
      with Popup do
        if Assigned(PopupComponent) and (PopupComponent is TSeatEx) then
        begin
          SeatEx := (PopupComponent as TSeatEx);
          Result := True;
        end;
    end;
  except
  end;
end;

procedure Tfm_Main.TicketRightClick(Sender: TObject);
const
  ProcName: string = 'TicketRightClick';
var
  tmpMenuItem: TMenuItem;
  tmpSeatEx: TSeatEx;
  tmpSXInfo: TSXInfo;
  tmpTicketKod, tmpTicketVer: Integer;
  // tmpCtrlSelect: Boolean;
begin
  // --------------------------------------------------------------------------
  // Вызов из всплывающего меню
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  if Assigned(Sender) and (Sender is TComponent) then
    DEBUGMessEnh(0, UnitName, ProcName, 'Sender = ' + (Sender as TComponent).Name
      + ' (' + Sender.ClassName + ')')
  else
    DEBUGMessEnh(0, UnitName, ProcName, 'Sender is null.');
{$ENDIF}
  // --------------------------------------------------------------------------
  if ResolvePopupComponent(Sender, pop_Ticket, tmpMenuItem, tmpSeatEx) then
  begin
    DEBUGMessEnh(0, UnitName, ProcName, 'tmpMenuItem = ' + tmpMenuItem.Caption
      + ' [' + IntToStr(tmpMenuItem.Tag) + ']');
    with tmpSeatEx do
    begin
{$IFDEF Debug_Level_6}
      DEBUGMessEnh(0, UnitName, ProcName, 'Name = ' + Name);
      DEBUGMessEnh(0, UnitName, ProcName, 'SeatState = ' + c_TicketState[SeatState]);
      DEBUGMessEnh(0, UnitName, ProcName, 'Foreign = ' + c_Triplean[Foreign]);
      DEBUGMessEnh(0, UnitName, ProcName, 'Selected = ' + c_Boolean[Selected]);
      DEBUGMessEnh(0, UnitName, ProcName, 'Printed = ' + c_Boolean[Printed]);
      DEBUGMessEnh(0, UnitName, ProcName, 'Cheqed = ' + c_Boolean[Cheqed]);
{$ENDIF}
      if (tmpMenuItem.Tag > 0) then
      begin
        tmpTicketKod := tmpMenuItem.Tag;
        tmpTicketVer := -1;
        if (tbc_Film_List.Tabs.Count > 0) then
        begin
          // tmpCtrlSelect := False;
          if {(1 = 2) and}(SeatState in [tsFree, tsReserved]) and (not Selected) then
          begin
{$IFDEF Debug_Level_5}
            DEBUGMessEnh(0, UnitName, ProcName, 'First select...');
{$ENDIF}
            Tag := -2;
            Click;
            // tcx_SeatExSelect(tmpSeatEx, False, tmpCtrlSelect);
            // tmpSeatEx.Selected := tmpCtrlSelect;
          end; // if (SeatState in ...
          if (Foreign = trNo) and Selected then
          begin
            // todo: Get latest SaleCost value
            if ((SeatState = tsFree)
              or (SeatState = tsReserved) and (TicketVer > 0)) then
            begin
{$IFDEF Debug_Level_5}
              DEBUGMessEnh(0, UnitName, ProcName, 'Let''s prepare...');
{$ENDIF}
              tmpSXInfo.Action := c_OperActionEx2Int[oxPrepare];
              tmpSXInfo.vTicketKod := tmpTicketKod;
              tmpSXInfo.vTicketVer := tmpTicketVer;
              DoCommandForExCtrls(Cur_Panel_Cntr, tmpSXInfo);
              Tag := -3;
            end
            else if (SeatState = tsPrepared) then
            begin
              TicketKod := tmpTicketKod;
              TicketVer := tmpTicketVer;
              Tag := -4;
            end
            else if (SeatState = tsReserved) then
            begin
              TicketKod := tmpTicketKod;
              TicketVer := tmpTicketVer;
              Tag := -5;
            end;
          end; // if (Foreign = trNo) and Selected ...
        end; // if (tbc_Film_List.Tabs.Count > 0) ...
      end; // if (tmpMenuItem.Tag > 0) ...
    end; // with
  end; // if
  // --------------------------------------------------------------------------
  Refresh_TC_Count(8);
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.tcx_GetTicketProps(Sender: TObject;
  const TicketKod, TicketVer: Integer; var TicketName: string;
  var TicketBgColor, TicketFontColor: TColor);
const
  ProcName: string = 'tcx_GetTicketProps';
var
  i: Integer;
begin
{$IFDEF Debug_Level_8}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  if (TicketKod >= Low(c_TicketProps)) and (TicketKod <= High(c_TicketProps)) then
  begin
    TicketName := c_TicketProps[TicketKod].Name;
    TicketBgColor := c_TicketProps[TicketKod].BgColor;
    TicketFontColor := c_TicketProps[TicketKod].FontColor;
  end
  else
  begin
    TicketName := 'Undefined';
    TicketBgColor := clLtGray;
    TicketFontColor := clDkGray;
  end;
  if (Sender is TSeatEx) then
    with (Sender as TSeatEx) do
    begin
      for i := Low(vInfo) to High(vInfo) do
        if (vInfo[i].irSpecial > vInfo_Special_Base) and (vInfo[i].irKod = TicketKod) then
        begin
          SaleCost := vInfo[i].irCost;
        end;
    end;
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_8}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.odm_SelectRangeBefore(Sender: TObject;
  RangeRect: TRect);
const
  ProcName: string = 'odm_SelectRangeBefore';
begin
{$IFDEF Debug_Level_5}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  with RangeRect do
    DEBUGMessEnh(0, UnitName, ProcName, Format('RangeRect is (%u,%u) - (%u,%u)',
      [Left, Top, Right, Bottom]));
{$ENDIF}
  OperModFinal([poCommitTransactionAfter]);
{$IFDEF Debug_Level_5}
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.odm_SelectRangeAfter(Sender: TObject;
  RangeRect: TRect);
const
  ProcName: string = 'odm_SelectRangeAfter';
begin
{$IFDEF Debug_Level_5}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  with RangeRect do
    DEBUGMessEnh(0, UnitName, ProcName, Format('RangeRect is (%u,%u) - (%u,%u)',
      [Left, Top, Right, Bottom]));
{$ENDIF}
  OperModFinal([poCommitTransactionAfter]);
  Refresh_TC_Count(9);
{$IFDEF Debug_Level_5}
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.tcx_SeatExSelect(Sender: TObject; const MultipleAction: Boolean;
  var DoCtrlSelect: Boolean);
const
  ProcName: string = 'tcx_SeatExSelect';
var
  Sndr: TSeatEx;
  int_Oper_Kod: integer;
  str_Oper_Serial: string;
  tError_Kod: Integer;
  tError_Text: string;
  _ProcTransOptions: TTransOptions;
begin
{$IFDEF Debug_Level_8}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, 'DoCtrlSelect = ' + c_Boolean[DoCtrlSelect]);
{$ENDIF}
  if Assigned(Sender) and (Sender is TSeatEx) then
  begin
    Sndr := (Sender as TSeatEx);
    with Sndr do
    begin
      _ProcTransOptions := [poStartTransAction];
      if not MultipleAction then
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Click is single.');
        _ProcTransOptions := _ProcTransOptions + [poCommitTransActionAfter];
      end;
      if (not Selected) then
      begin
{$IFDEF Debug_Level_8}
        DEBUGMessEnh(0, UnitName, ProcName, 'Name = ' + Name);
        DEBUGMessEnh(0, UnitName, ProcName, 'SeatState = ' + c_TicketState[SeatState]);
        DEBUGMessEnh(0, UnitName, ProcName, 'Foreign = ' + c_Triplean[Foreign]);
        DEBUGMessEnh(0, UnitName, ProcName, 'Selected = ' + c_Boolean[Selected]);
        DEBUGMessEnh(0, UnitName, ProcName, 'Printed = ' + c_Boolean[Printed]);
        DEBUGMessEnh(0, UnitName, ProcName, 'Cheqed = ' + c_Boolean[Cheqed]);
{$ENDIF}
{$IFDEF Debug_Level_7}
        DEBUGMessEnh(0, UnitName, ProcName, 'Let''s select...');
{$ENDIF}
        DoCtrlSelect := OperModify(_ProcTransOptions,
          oaSelect, PrintCount, Cheqed,
          SeatRow, SeatColumn, -1,
          Cur_Repert_Kod, TicketKod, Reason, int_Oper_Kod, str_Oper_Serial,
          tError_Kod, tError_Text);
        if (not DoCtrlSelect) and ((tError_Kod = 231) or (tError_Kod = 232)) then
        begin
          DoCtrlSelect := False;
        end;
        if DoCtrlSelect then
        begin
        end;
{$IFDEF Debug_Level_7}
        DEBUGMessEnh(0, UnitName, ProcName, 'Select result = ' + c_Boolean[DoCtrlSelect]);
{$ENDIF}
      end
      else
      begin
{$IFDEF Debug_Level_7}
        DEBUGMessEnh(0, UnitName, ProcName, 'Let''s cancel native...');
{$ENDIF}
        DoCtrlSelect := OperModify(_ProcTransOptions,
          oaCancel, PrintCount, Cheqed,
          SeatRow, SeatColumn, -2,
          Cur_Repert_Kod, TicketKod, Reason, int_Oper_Kod, str_Oper_Serial,
          tError_Kod, tError_Text);
        if (not DoCtrlSelect) and ((tError_Kod = 231) or (tError_Kod = 232)) then
        begin
          DoCtrlSelect := False;
        end;
        if DoCtrlSelect then
        begin
        end;
{$IFDEF Debug_Level_7}
        DEBUGMessEnh(0, UnitName, ProcName, 'Cancel  result = ' + c_Boolean[DoCtrlSelect]);
{$ENDIF}
      end;
    end;
  end;
{$IFDEF Debug_Level_8}
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.tcx_SeatExCmd(Sender: TObject; const CmdEx: TOperActionEx;
  var DoCtrlChange: Boolean);
const
  ProcName: string = 'tcx_SeatExCmd';
var
  Sndr: TSeatEx;
  // --------------------------------------------------------------------------
  Restore_Reason: Integer;
  // tmp_Choice: Integer;
  // b_YesToAll_Realized, b_NoToAll_Realized: Boolean;
  // i, i_Count: Integer;
  s: string;
  // --------------------------------------------------------------------------
  int_Oper_Kod: integer;
  str_Oper_Serial: string;
  tError_Kod: Integer;
  tError_Text: string;
begin
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, 'DoCtrlReserve = ' + c_Boolean[DoCtrlChange]);
{$ENDIF}
  DoCtrlChange := False;
  // b_YesToAll_Realized := False;
  // b_NoToAll_Realized := False;
  if Assigned(Sender) and (Sender is TSeatEx) then
  begin
    Sndr := (Sender as TSeatEx);
    with Sndr do
    begin
      case CmdEx of
        // --------------------------------------------------------------------------
        oxReserve:
          begin
            if (Foreign = trNo) and (SeatState = tsPrepared) then
            begin
{$IFDEF Debug_Level_6}
              DEBUGMessEnh(0, UnitName, ProcName, 'Name = ' + Name);
              DEBUGMessEnh(0, UnitName, ProcName, 'SeatState = ' + c_TicketState[SeatState]);
              DEBUGMessEnh(0, UnitName, ProcName, 'Foreign = ' + c_Triplean[Foreign]);
              DEBUGMessEnh(0, UnitName, ProcName, 'Selected = ' + c_Boolean[Selected]);
              DEBUGMessEnh(0, UnitName, ProcName, 'Printed = ' + c_Boolean[Printed]);
              DEBUGMessEnh(0, UnitName, ProcName, 'Cheqed = ' + c_Boolean[Cheqed]);
{$ENDIF}
{$IFDEF Debug_Level_5}
              DEBUGMessEnh(0, UnitName, ProcName, 'Let''s do reserve ...');
{$ENDIF}
              DoCtrlChange := OperModify([poStartTransAction],
                oaReserve, PrintCount, Cheqed,
                SeatRow, SeatColumn, -3,
                Cur_Repert_Kod, TicketKod, Reason, int_Oper_Kod, str_Oper_Serial,
                tError_Kod, tError_Text);
              if (not DoCtrlChange) and ((tError_Kod = 231) or (tError_Kod = 232)) then
              begin
                DoCtrlChange := False;
              end;
{$IFDEF Debug_Level_5}
              DEBUGMessEnh(0, UnitName, ProcName, 'DoCtrlChange result = ' +
                c_Boolean[DoCtrlChange]);
{$ENDIF}
              if DoCtrlChange then
              begin
                // all ok, do default handling
              end
              else
              begin
                // todo: error handling
                MessageBox(0, PChar('---   Operation failure   ---' + c_CRLF +
                  'Вроде бы все правильно, но забронировать билет не получается.'
                  + c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF
                  + 'Код ошибки = ' + IntToStr(tError_Kod) + ';' + c_CRLF + tError_Text),
                  'Ticket reserve', MB_ICONERROR);
              end; // if DoCtrlChange
            end;
          end; // oxReserve
        // --------------------------------------------------------------------------
        oxFree:
          begin
            if (Foreign = trNo) and Selected and (SeatState = tsReserved) then
            begin
{$IFDEF Debug_Level_6}
              DEBUGMessEnh(0, UnitName, ProcName, 'Name = ' + Name);
              DEBUGMessEnh(0, UnitName, ProcName, 'SeatState = ' + c_TicketState[SeatState]);
              DEBUGMessEnh(0, UnitName, ProcName, 'Foreign = ' + c_Triplean[Foreign]);
              DEBUGMessEnh(0, UnitName, ProcName, 'Selected = ' + c_Boolean[Selected]);
              DEBUGMessEnh(0, UnitName, ProcName, 'Printed = ' + c_Boolean[Printed]);
              DEBUGMessEnh(0, UnitName, ProcName, 'Cheqed = ' + c_Boolean[Cheqed]);
{$ENDIF}
{$IFDEF Debug_Level_5}
              DEBUGMessEnh(0, UnitName, ProcName, 'Let''s do free ...');
{$ENDIF}
              DoCtrlChange := OperModify([poStartTransAction],
                oaFree, PrintCount, Cheqed,
                SeatRow, SeatColumn, -4,
                Cur_Repert_Kod, TicketKod, Reason, int_Oper_Kod, str_Oper_Serial,
                tError_Kod, tError_Text);
              if (not DoCtrlChange) and ((tError_Kod = 231) or (tError_Kod = 232)) then
              begin
                DoCtrlChange := False;
              end;
{$IFDEF Debug_Level_5}
              DEBUGMessEnh(0, UnitName, ProcName, 'DoCtrlChange result = ' +
                c_Boolean[DoCtrlChange]);
{$ENDIF}
              if DoCtrlChange then
              begin
                // all ok, do default handling
              end
              else
              begin
                // todo: error handling
                MessageBox(0, PChar('---   Operation failure   ---' + c_CRLF +
                  'Вроде бы все правильно, но освободить забронированный билет не получается.'
                  + c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF
                  + 'Код ошибки = ' + IntToStr(tError_Kod) + ';' + c_CRLF + tError_Text),
                  'Ticket free', MB_ICONERROR);
              end; // if DoCtrlChange
            end;
          end; // oxFree
        // --------------------------------------------------------------------------
        oxRestore:
          begin
            if (Foreign = trNo) and Selected and (SeatState = tsRealized) then
            begin
              // todo: choose Restore_Reason
              Restore_Reason := -1;
              DEBUGMessEnh(0, UnitName, ProcName, 'Choosing Restore_Reason...');
              s := Sndr.Hint;
              s := Format(Restore_Mess, [SeatRow, SeatColumn, s]);
              case MessageDlg(s, mtWarning, [mbYes, mbNo, mbNoToAll], 0) of
                mrYes:
                  Restore_Reason := 3;
                mrNo:
                  Restore_Reason := -2;
                mrNoToAll:
                  begin
                    Restore_Reason := -3;
                    // b_NoToAll_Realized := True;
                  end;
              end;
              DEBUGMessEnh(0, UnitName, ProcName, 'Restore_Reason = ' + IntToStr(Restore_Reason));
              if (Restore_Reason > -1) then
              begin
{$IFDEF Debug_Level_6}
                DEBUGMessEnh(0, UnitName, ProcName, 'Name = ' + Name);
                DEBUGMessEnh(0, UnitName, ProcName, 'SeatState = ' + c_TicketState[SeatState]);
                DEBUGMessEnh(0, UnitName, ProcName, 'Foreign = ' + c_Triplean[Foreign]);
                DEBUGMessEnh(0, UnitName, ProcName, 'Selected = ' + c_Boolean[Selected]);
                DEBUGMessEnh(0, UnitName, ProcName, 'Printed = ' + c_Boolean[Printed]);
                DEBUGMessEnh(0, UnitName, ProcName, 'Cheqed = ' + c_Boolean[Cheqed]);
{$ENDIF}
{$IFDEF Debug_Level_5}
                DEBUGMessEnh(0, UnitName, ProcName, 'Let''s do restore ...');
{$ENDIF}
                DoCtrlChange := OperModify([poStartTransAction, poCommitTransActionAfter],
                  oaRestore, PrintCount, Cheqed,
                  SeatRow, SeatColumn, -4,
                  Cur_Repert_Kod, TicketKod, Restore_Reason, int_Oper_Kod, str_Oper_Serial,
                  tError_Kod, tError_Text);
                if (not DoCtrlChange) and ((tError_Kod = 231) or (tError_Kod = 232)) then
                begin
                  DoCtrlChange := False;
                end;
{$IFDEF Debug_Level_5}
                DEBUGMessEnh(0, UnitName, ProcName, 'DoCtrlChange result = ' +
                  c_Boolean[DoCtrlChange]);
{$ENDIF}
                if DoCtrlChange then
                begin
                  // all ok, do default handling
                end
                else
                begin
                  // todo: error handling
                  MessageBox(0, PChar('---   Operation failure   ---' + c_CRLF +
                    'Вроде бы все правильно, но вернуть билет не получается.'
                    + c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF
                    + 'Код ошибки = ' + IntToStr(tError_Kod) + ';' + c_CRLF + tError_Text),
                    'Ticket restore', MB_ICONERROR);
                end; // if DoCtrlChange
              end
              else // if (Restore_Reason > -1) then
              begin
{$IFDEF Debug_Level_5}
                DEBUGMessEnh(0, UnitName, ProcName, 'Let''s cancel native...');
{$ENDIF}
                DoCtrlChange := OperModify([poStartTransAction, poCommitTransActionAfter],
                  oaCancel, PrintCount, Cheqed,
                  SeatRow, SeatColumn, -2,
                  Cur_Repert_Kod, TicketKod, Reason, int_Oper_Kod, str_Oper_Serial,
                  tError_Kod, tError_Text);
                if (not DoCtrlChange) and ((tError_Kod = 231) or (tError_Kod = 232)) then
                begin
                  DoCtrlChange := False;
                end;
{$IFDEF Debug_Level_5}
                DEBUGMessEnh(0, UnitName, ProcName, 'DoCtrlChange result = ' +
                  c_Boolean[DoCtrlChange]);
{$ENDIF}
              end; // if (Restore_Reason > -1) then
            end; // if
          end; // oxRestore
      else //case
        // ignore
{$IFDEF Debug_Level_5}
        DEBUGMessEnh(0, UnitName, ProcName, 'DoCtrlChange result = ' +
          c_Boolean[DoCtrlChange]);
{$ENDIF}
      end; //case
    end;
  end;
{$IFDEF Debug_Level_6}
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.TicketForceCancel(Sender: TObject);
const
  ProcName: string = 'TicketForceCancel';
var
  tmpMenuItem: TMenuItem;
  tmpSeatEx: TSeatEx;
  MakeCancel: Boolean;
  int_Oper_Kod: integer;
  str_Oper_Serial: string;
  tError_Kod: Integer;
  tError_Text: string;
begin
  // --------------------------------------------------------------------------
  // Вызов из всплывающего меню
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  if Assigned(Sender) and (Sender is TComponent) then
    DEBUGMessEnh(0, UnitName, ProcName, 'Sender = ' + (Sender as TComponent).Name
      + ' (' + Sender.ClassName + ')')
  else
    DEBUGMessEnh(0, UnitName, ProcName, 'Sender is null.');
{$ENDIF}
  // --------------------------------------------------------------------------
  if ResolvePopupComponent(Sender, pop_Ticket, tmpMenuItem, tmpSeatEx) then
  begin
    with tmpSeatEx do
    begin
{$IFDEF Debug_Level_6}
      DEBUGMessEnh(0, UnitName, ProcName, 'Name = ' + Name);
      DEBUGMessEnh(0, UnitName, ProcName, 'SeatState = ' + c_TicketState[SeatState]);
      DEBUGMessEnh(0, UnitName, ProcName, 'Foreign = ' + c_Triplean[Foreign]);
      DEBUGMessEnh(0, UnitName, ProcName, 'Selected = ' + c_Boolean[Selected]);
      DEBUGMessEnh(0, UnitName, ProcName, 'Printed = ' + c_Boolean[Printed]);
      DEBUGMessEnh(0, UnitName, ProcName, 'Cheqed = ' + c_Boolean[Cheqed]);
{$ENDIF}
      if (Selected and (Foreign in [trUnknown, trYes]))
        or ((SeatState = tsPrepared) and (Foreign in [trNo])) then
      begin
{$IFDEF Debug_Level_5}
        DEBUGMessEnh(0, UnitName, ProcName, 'Let''s cancel foreign...');
{$ENDIF}
        MakeCancel := OperModify([poStartTransAction, poCommitTransActionAfter],
          oaCancel, PrintCount, Cheqed,
          SeatRow, SeatColumn, -5,
          Cur_Repert_Kod, TicketKod, Reason, int_Oper_Kod, str_Oper_Serial,
          tError_Kod, tError_Text);
        if (not MakeCancel) and ((tError_Kod = 231) or (tError_Kod = 232)) then
        begin
          MakeCancel := False;
        end;
{$IFDEF Debug_Level_5}
        DEBUGMessEnh(0, UnitName, ProcName, 'Cancel  result = ' + c_Boolean[MakeCancel]);
{$ENDIF}
        // --------------------------------------------------------------------------
        if MakeCancel then
        begin
          // all ok, do default handling
          Selected := False;
        end
        else
        begin
          // todo: error handling
          MessageBox(0, PChar('---   Operation failure   ---' + c_CRLF +
            'Вроде бы все правильно, но отменить выделение не получается.'
            + c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF
            + 'Код ошибки = ' + IntToStr(tError_Kod) + ';' + c_CRLF + tError_Text),
            'Ticket cancel', MB_ICONERROR);
        end; // if MakeCancel
      end; // if
    end; // with
  end; // if
  Refresh_TC_Count(10);
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.acCardExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    // todo: showmodal
  end;
end;

procedure Tfm_Main.acPriceExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    acPriceShowModal(-1);
    // Process_Date_Change(nil, True, gg_Progress);
  end;
end;

procedure Tfm_Main.acCostExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    // todo: cur_tariff_kod param send
    acCostShowModal(-1);
    Process_Date_Change(nil, True, gg_Progress);
  end;
end;

procedure Tfm_Main.acFilmExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    // todo: cur_film_kod param send
    acFilmShowModal(Cur_Film_Kod);
    // Process_Date_Change(nil, True, gg_Progress);
  end;
end;

procedure Tfm_Main.acGenreExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    acGenreShowModal(nil);
    // Process_Date_Change(nil, True, gg_Progress);
  end;
end;

procedure Tfm_Main.acGrouperExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    // todo: showmodal
  end;
end;

procedure Tfm_Main.acInviterExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    // todo: showmodal
  end;
end;

procedure Tfm_Main.acOptionsExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    // todo: showmodal
  end;
end;

procedure Tfm_Main.acTicketExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    // todo: showmodal
  end;
end;

procedure Tfm_Main.acAbonemExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    // todo: showmodal
  end;
end;

procedure Tfm_Main.acPersonExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    // todo: showmodal
  end;
end;

procedure Tfm_Main.acRepertExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    acRepertShowModal(Cur_Date, Cur_Zal_Kod);
    Process_Date_Change(nil, True, gg_Progress);
  end;
end;

procedure Tfm_Main.acAbonJournalExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    acAbJnlShowModal(Cur_Date, Cur_Zal_Kod);
    // Process_Date_Change(nil, True, gg_Progress);
  end;
end;

procedure Tfm_Main.acSeansExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    acSeansShowModal(nil);
    // Process_Date_Change(nil, True, gg_Progress);
  end;
end;

procedure Tfm_Main.acTariffExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    // todo: cur_tariff_kod param send
    acTariffShowModal(-1);
    Process_Date_Change(nil, True, gg_Progress);
  end;
end;

procedure Tfm_Main.acSalesJournalExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    // todo: showmodal
  end;
end;

procedure Tfm_Main.acReportSendExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    // todo: showmodal
  end;
end;

procedure Tfm_Main.acDailyReportExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    acDRpAzShowModal(Cur_Date, Cur_Zal_Kod);
    // Process_Date_Change(nil, True, gg_Progress);
  end;
end;

procedure Tfm_Main.acTicketReportExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    acDRpBeShowModal(Cur_Date, Cur_Zal_Kod);
    // Process_Date_Change(nil, True, gg_Progress);
  end;
end;

procedure Tfm_Main.acSalesReportExecute(Sender: TObject);
begin
  if TestDBConnect then
  begin
    acDRpExShowModal(Cur_Date, Cur_Zal_Kod);
    // Process_Date_Change(nil, True, gg_Progress);
  end;
end;

procedure Tfm_Main.acShowHintExecute(Sender: TObject);
const
  ProcName: string = 'acShowHintExecute';
begin
{$IFDEF Debug_Level_6}
  if Assigned(Sender) and (Sender is TComponent) then
    DEBUGMessEnh(0, UnitName, ProcName, 'Sender = ' + (Sender as TComponent).Name
      + ' (' + Sender.ClassName + ')')
  else
    DEBUGMessEnh(0, UnitName, ProcName, 'Sender is null.');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Application.ShowHint := not Application.ShowHint;
  sbx_Cntr.ShowHint := not sbx_Cntr.ShowHint;
end;

procedure Tfm_Main.acShowHintUpdate(Sender: TObject);
begin
  // acShowHint.Checked := Application.ShowHint;
  acShowHint.Checked := sbx_Cntr.ShowHint;
end;

procedure Tfm_Main.acSeatCanceledShowExecute(Sender: TObject);
begin
  GlobalSeatCanceledShow := not GlobalSeatCanceledShow;
  RepaintSeatExCtrls(Self);
end;

procedure Tfm_Main.acSeatCanceledShowUpdate(Sender: TObject);
begin
  acSeatCanceledShow.Checked := GlobalSeatCanceledShow;
end;

procedure Tfm_Main.acSeatFreedShowExecute(Sender: TObject);
begin
  GlobalSeatFreedShow := not GlobalSeatFreedShow;
  RepaintSeatExCtrls(Self);
end;

procedure Tfm_Main.acSeatFreedShowUpdate(Sender: TObject);
begin
  acSeatFreedShow.Checked := GlobalSeatFreedShow;
end;

procedure Tfm_Main.acSeatRestoredShowExecute(Sender: TObject);
begin
  GlobalSeatRestoredShow := not GlobalSeatRestoredShow;
  RepaintSeatExCtrls(Self);
end;

procedure Tfm_Main.acSeatRestoredShowUpdate(Sender: TObject);
begin
  acSeatRestoredShow.Checked := GlobalSeatRestoredShow;
end;

procedure Tfm_Main.acSeatCheqedShowExecute(Sender: TObject);
begin
  GlobalSeatCheqedShow := not GlobalSeatCheqedShow;
  RepaintSeatExCtrls(Self);
  Refresh_TC_Count(18);
end;

procedure Tfm_Main.acSeatCheqedShowUpdate(Sender: TObject);
begin
  acSeatCheqedShow.Checked := GlobalSeatCheqedShow;
end;

procedure Tfm_Main.acGlobalRowShowExecute(Sender: TObject);
begin
  GlobalRowShow := not GlobalRowShow;
  RepaintSeatExCtrls(Self);
end;

procedure Tfm_Main.acGlobalRowShowUpdate(Sender: TObject);
begin
  acGlobalRowShow.Checked := GlobalRowShow;
end;

procedure Tfm_Main.acInfoExecute(Sender: TObject);
const
  ProcName: string = 'acInfoExecute';
begin
  // --------------------------------------------------------------------------
  // Информационное окно
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  if Assigned(fm_Info) then
  begin
    if fm_Info.Visible then
    try
      DEBUGMessEnh(0, UnitName, ProcName, 'fmInfo.Hide');
      fm_Info.Hide;
    finally
      // acInfo.Checked := False;
    end
    else
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'fmInfo.Show');
      fm_Info.Show;
      // acInfo.Checked := True;
    end;
  end
  else
  try
    Application.CreateForm(Tfm_Info, fm_Info);
    DEBUGMessEnh(0, UnitName, ProcName, 'fmInfo.Show - after Create');
    fm_Info.Show;
    // acInfo.Checked := True;
  except
    fm_Info.Free;
    fm_Info := nil;
    // acInfo.Checked := False;
  end;
  Refresh_TC_Count(11);
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.acInfoUpdate(Sender: TObject);
var
  ch: Boolean;
begin
  //
  ch := False;
  if Assigned(fm_Info) then
    ch := fm_Info.Visible;
  acInfo.Checked := ch;
  // tcx_Select.Selected := ch;
end;

procedure Tfm_Main.acKKMOptionsExecute(Sender: TObject);
begin
  //

end;

procedure Tfm_Main.acHdeExecute(Sender: TObject);
begin
  //
end;

procedure Tfm_Main.acToggleQmExecute(Sender: TObject);
begin
  //
end;

procedure Tfm_Main.st_InfoClick(Sender: TObject);
begin
  //
end;

procedure Tfm_Main.SetDefOpt(Sender: TObject);
begin
  //
end;

procedure Tfm_Main.saPrintExecute(Sender: TObject);
const
  ProcName: string = 'acPrintExecute';
begin
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  Process_PX(Sender, gg_Progress, pxCash, Print_Cheq, 1);
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.saPosterminalExecute(Sender: TObject);
const
  ProcName: string = 'acPosterminalExecute';
begin
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  Process_PX(Sender, gg_Progress, pxPosterminal, True, 1);
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.saClearExecute(Sender: TObject);
const
  ProcName: string = 'acClearExecute';
var
  MakeClear: Boolean;
  int_Total_Count, int_Cleared_Count: integer;
  tError_Kod: Integer;
  tError_Text: string;
begin
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  MakeClear := OperClear(0, Cur_Repert_Kod, int_Total_Count, int_Cleared_Count, tError_Kod,
    tError_Text);
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_5}
  DEBUGMessEnh(0, UnitName, ProcName, 'Clear  result = ' + c_Boolean[MakeClear]);
{$ENDIF}
  Refresh_TC_Count(12);
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.saMakeItSoExecute(Sender: TObject);
const
  ProcName: string = 'acMakeItSoExecute';
begin
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  Process_PX(Sender, gg_Progress, pxCheq, True, 0);
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.saReserveExecute(Sender: TObject);
const
  ProcName: string = 'acReserveExecute';
var
  tmpSXInfo: TSXInfo;
begin
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  if True then
  begin
    tmpSXInfo.Action := c_OperActionEx2Int[oxReserve];
    OperModFinal([poCommitTransactionAfter]);
    DoCommandForExCtrls(Cur_Panel_Cntr, tmpSXInfo);
    OperModFinal([poCommitTransactionAfter]);
  end;
  // --------------------------------------------------------------------------
  Refresh_TC_Count(13);
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.saOneTicketExecute(Sender: TObject);
const
  ProcName: string = 'acOneTicketExecute';
begin
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  // todo: One ticket print
  // --------------------------------------------------------------------------
  Refresh_TC_Count(14);
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.saRestoreExecute(Sender: TObject);
const
  ProcName: string = 'acRestoreExecute';
var
  tmpSXInfo: TSXInfo;
begin
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  if True then
  begin
    tmpSXInfo.Action := c_OperActionEx2Int[oxRestore];
    DoCommandForExCtrls(Cur_Panel_Cntr, tmpSXInfo);
  end;
  // --------------------------------------------------------------------------
  Refresh_TC_Count(15);
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.saFreeExecute(Sender: TObject);
const
  ProcName: string = 'acFreeExecute';
var
  tmpSXInfo: TSXInfo;
begin
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  if True then
  begin
    tmpSXInfo.Action := c_OperActionEx2Int[oxFree];
    OperModFinal([poCommitTransactionAfter]);
    DoCommandForExCtrls(Cur_Panel_Cntr, tmpSXInfo);
    OperModFinal([poCommitTransactionAfter]);
  end;
  // --------------------------------------------------------------------------
  Refresh_TC_Count(16);
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.acRefreshExecute(Sender: TObject);
begin
  // --------------------------------------------------------------------------
  // Обновление карты зала
  // --------------------------------------------------------------------------
  TestDBConnect;
  Process_Date_Change(nil, True, gg_Progress);
  // --------------------------------------------------------------------------
end;

procedure Tfm_Main.AdjustZalPosSbx(HorzPos, VertPos: Integer);
const
  ProcName: string = 'AdjustZalPosSbx';
var
  bv: Boolean;
begin
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, format('0. frm[ %d, %d, %d, %d], tbc[ %d, %d, %d, %d]',
    [Self.Left, Self.Top, Self.ClientWidth, Self.ClientHeight,
    tbc_Film_List.Left, tbc_Film_List.Top, tbc_Film_List.ClientWidth, tbc_Film_List.ClientHeight]));
{$ENDIF}
  // bv := sbx_Cntr.Visible;
  // sbx_Cntr.Visible := False;
  bv := True;
  if Assigned(Cur_Panel_Cntr) then
  begin
    bv := Cur_Panel_Cntr.Visible;
    Cur_Panel_Cntr.Visible := False;
  end;
  sbx_Cntr.VertScrollBar.Position := 0;
  sbx_Cntr.HorzScrollBar.Position := 0;
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(0, UnitName, ProcName, format('1. sb1[ %d, %d, %d, %d], cup[ %d, %d, %d, %d]',
    [sbx_Cntr.Left, sbx_Cntr.Top, sbx_Cntr.Width, sbx_Cntr.Height,
    Cur_Panel_Cntr.Left, Cur_Panel_Cntr.Top, Cur_Panel_Cntr.Width, Cur_Panel_Cntr.Height]));
{$ENDIF}
  Cur_Panel_Cntr.Left := 0;
  Cur_Panel_Cntr.Top := 0;
  if (FWDelta <= 0) then
    FWDelta := Self.Width - sbx_Cntr.Width;
  if (FHDelta <= 0) then
    FHDelta := Self.Height - sbx_Cntr.Height;
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(0, UnitName, ProcName, format('2. Delta[ %d, %d, %d, %d], cup[ %d, %d, %d, %d]',
    [FWDelta, FHDelta, (Self.Width - FWDelta), (Self.Height - FHDelta),
    Cur_Panel_Cntr.Left, Cur_Panel_Cntr.Top, Cur_Panel_Cntr.Width, Cur_Panel_Cntr.Height]));
{$ENDIF}
  if (Self.Width - FWDelta) > Cur_Panel_Cntr.Width then
  begin
    // Cur_Panel_Cntr.Left := ((Self.Width - FWDelta) - Cur_Panel_Cntr.Width) div 2; // hCenter
    Cur_Panel_Cntr.Left := round(((Self.Width - FWDelta) - Cur_Panel_Cntr.Width) * HorzPos / 100)
      - 1;
  end
  else
  begin
    Cur_Panel_Cntr.Left := 0;
  end;
  if (Self.Height - FHDelta) > Cur_Panel_Cntr.Height then
  begin
    // Cur_Panel_Cntr.Top := ((Self.Height - FHDelta) - Cur_Panel_Cntr.Height) div 2; // vCenter
    Cur_Panel_Cntr.Top := round(((Self.Height - FHDelta) - Cur_Panel_Cntr.Height) * VertPos / 100)
      - tbc_Film_List.Canvas.TextHeight('Test');
  end
  else
  begin
    Cur_Panel_Cntr.Top := 0;
  end;
  if Assigned(Cur_Panel_Cntr) then
  begin
    Cur_Panel_Cntr.Visible := bv;
  end;
  // sbx_Cntr.Visible := bv;
{$IFDEF Debug_Level_9}
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.FormResize(Sender: TObject);
const
  ProcName: string = 'FormResize';
begin
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  AdjustZalPosSbx(Common_Odeum_Horz_Pos, Common_Odeum_Vert_Pos);
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.st_Ctrl_MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
begin
  GetCursorPos(P);
  Application.ActivateHint(P);
end;

procedure Tfm_Main.dtp_DateChange(Sender: TObject);
begin
  Process_Date_Change(Sender, False, gg_Progress);
end;

procedure Tfm_Main.cmb_ZalChange(Sender: TObject);
begin
  Process_Zal_Change(Sender, gg_Progress);
end;

procedure Tfm_Main.tbc_Zal_ListChange(Sender: TObject);
begin
  cmb_Zal.ItemIndex := tbc_Zal_List.TabIndex;
  Process_Zal_Change(Sender, gg_Progress);
end;

procedure Tfm_Main.tbc_Film_ListChange(Sender: TObject);
begin
  Process_Film_Change(Sender, False, gg_Progress);
end;

procedure Tfm_Main.acPrinterInitExecute(Sender: TObject);
begin
  Emblema_Loaded := False;
end;

procedure Tfm_Main.acPrinterInitUpdate(Sender: TObject);
begin
  acPrinterInit.Checked := not Emblema_Loaded;
end;

procedure Tfm_Main.acPrinterTestExecute(Sender: TObject);
var
  odm: TOdeumPanel;
begin
  // --------------------------------------------------------------------------
  if (Cur_Panel_Cntr is TOdeumPanel) then
  begin
    odm := (Cur_Panel_Cntr as TOdeumPanel);
    Test_TC_Print_Bmp('-=- test1 -=-', '-=- test2 -=-', odm.CinemaLogo, odm.OdeumLogo);
    ShowMessage('Test is done.');
  end
  else
  begin
    ShowMessage('Test is not possible.');
  end;
  // --------------------------------------------------------------------------
end;

procedure Tfm_Main.acPrintSerialExecute(Sender: TObject);
begin
  Print_Serial_Num := not Print_Serial_Num;
end;

procedure Tfm_Main.acPrintSerialUpdate(Sender: TObject);
begin
  acPrintSerial.Checked := Print_Serial_Num;
end;

procedure Tfm_Main.acPrintCheqExecute(Sender: TObject);
begin
  Print_Cheq := not Print_Cheq;
  Refresh_TC_Count(17);
end;

procedure Tfm_Main.acPrintCheqUpdate(Sender: TObject);
begin
  acPrintCheq.Checked := Print_Cheq;
  tcx_Select.Selected := not acPrintCheq.Checked;
end;

procedure Tfm_Main.acConnRestoreExecute(Sender: TObject);
begin
  // todo: Restore connection
end;

procedure Tfm_Main.acConnRestoreUpdate(Sender: TObject);
begin
  acConnRestore.Checked := DBConnected2;
end;

procedure Tfm_Main.acTopogrExecute(Sender: TObject);
var
  i, i_Count: Integer;
  tmpComponent: TComponent;
  ssTmp: TSeatEx;
  vMapColor, vRegularBrushColor, vRegularFontColor, vRegularPenColor: TColor;
begin
  if (Cur_Panel_Cntr is TOdeumPanel) then
    with (Cur_Panel_Cntr as TOdeumPanel) do
    begin
      // --------------------------------------------------------------------------
      MapMode := not MapMode;
      if MapMode then
      begin
        vMapColor := clWhite;
        vRegularBrushColor := clWhite;
        vRegularFontColor := clBlack;
        vRegularPenColor := clRed;
      end
      else
      begin
        vMapColor := clBackground;
        vRegularBrushColor := clWhite;
        vRegularFontColor := clBlack;
        vRegularPenColor := clBlack;
      end;
      // --------------------------------------------------------------------------
      Color := vMapColor;
      Font.Color := vMapColor;
      // --------------------------------------------------------------------------
      i_Count := Cur_Panel_Cntr.ComponentCount - 1;
      for i := 0 to i_Count do
      begin
        tmpComponent := Cur_Panel_Cntr.Components[i];
        if (tmpComponent is TSeatEx) then
        begin
          ssTmp := (tmpComponent as TSeatEx);
          with ssTmp do
          begin
            RegularBrush.Color := vRegularBrushColor;
            RegularFont.Color := vRegularFontColor;
            RegularPen.Color := vRegularPenColor;
          end;
        end;
      end; // for i := 0 to i_Count do
      // --------------------------------------------------------------------------
    end; // with
end;

procedure Tfm_Main.acTopogrUpdate(Sender: TObject);
begin
  if (Cur_Panel_Cntr is TOdeumPanel) then
    acTopogr.Checked := (Cur_Panel_Cntr as TOdeumPanel).MapMode;
end;

procedure Tfm_Main.SaveOdeumMapToFile(Sender: TObject);
const
  ProcName: string = 'SaveOdeumMapToFile';
var
  Bitmap: TBitmap;
  MyRect: TRect;
  strFileName: string;
begin
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  // Save Odeum map to file as BMP
  // --------------------------------------------------------------------------
  if (Cur_Panel_Cntr is TOdeumPanel) then
    with (Cur_Panel_Cntr as TOdeumPanel) do
    begin
      MyRect := Rect(0, 0, Cur_Panel_Cntr.Width, Cur_Panel_Cntr.Height);
{$IFDEF Debug_Level_6}
      DEBUGMessEnh(0, UnitName, ProcName, format('MyRect (%u, %u - %u, %u)',
        [MyRect.Left, MyRect.Top, MyRect.Right, MyRect.Bottom]));
{$ENDIF}
      Bitmap := TBitmap.Create;
      try
        Bitmap.Width := Cur_Panel_Cntr.Width;
        Bitmap.Height := Cur_Panel_Cntr.Height;
        Bitmap.Canvas.CopyRect(MyRect, Canvas, MyRect);
        Inc(dsc_number);
        strFileName := CinemaName + ' - ' + OdeumName + ' (' + IntToStr(OdeumCapacity) + ') @'
          + FormatDateTime('(yyyy-mm-dd`hh-nn-ss)', Now) + ' #' + IntToStr(dsc_number) + '.bmp';
        Bitmap.SaveToFile(strFileName);
{$IFDEF Debug_Level_6}
        DEBUGMessEnh(0, UnitName, ProcName, 'Saved to file "' + strFileName + '"');
{$ENDIF}
        MessageDlg('Saved to file "' + strFileName + '"', mtInformation, [mbOK], 0);
      finally
        Bitmap.Free;
      end; // try
    end; // with
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Main.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  vDirection: Integer;
  vIndex: Integer;
begin
  // --------------------------------------------------------------------------
  // Change TabIndex for tbc_Film_List
  // --------------------------------------------------------------------------
  if (ssCtrl in Shift) and (Key in [VK_LEFT, VK_RIGHT, VK_TAB]) and (not (ssAlt in Shift)) then
  begin
    vDirection := 0;
    if (Key = VK_LEFT) or (([ssCtrl, ssShift] = Shift) and (Key = VK_TAB)) then
    begin
      // Reverse order
      vDirection := -1;
    end
    else if (Key = VK_RIGHT) or (([ssCtrl] = Shift) and (Key = VK_TAB)) then
    begin
      // Direct order
      vDirection := 1;
    end;
    if (vDirection <> 0) then
    begin
      Key := VK_NONE;
      if tbc_Film_List.Enabled and (tbc_Film_List.Tabs.Count > 0) then
      begin
        vIndex := tbc_Film_List.TabIndex + vDirection;
        if (vIndex < 0) then
          vIndex := 0
        else if (vIndex >= tbc_Film_List.Tabs.Count) then
          vIndex := tbc_Film_List.Tabs.Count - 1;
        if (vIndex <> tbc_Film_List.TabIndex) then
        begin
          tbc_Film_List.TabIndex := vIndex;
          Process_Film_Change(Sender, False, gg_Progress);
        end;
      end;
    end;
  end;
  // --------------------------------------------------------------------------
  // Change ItemIndex for cmb_Zal
  // --------------------------------------------------------------------------
  if ([ssCtrl] = Shift) and (Key in [VK_PRIOR, VK_NEXT]) then
  begin
    vDirection := 0;
    if (Key = VK_PRIOR) then
    begin
      // Reverse order
      vDirection := -1;
    end
    else if (Key = VK_NEXT) then
    begin
      // Direct order
      vDirection := 1;
    end;
    if (vDirection <> 0) then
    begin
      Key := VK_NONE;
      if cmb_Zal.Enabled and (cmb_Zal.Items.Count > 0) then
      begin
        vIndex := cmb_Zal.ItemIndex + vDirection;
        if (vIndex < 0) then
          vIndex := 0
        else if (vIndex >= cmb_Zal.Items.Count) then
          vIndex := cmb_Zal.Items.Count - 1;
        if (vIndex <> cmb_Zal.ItemIndex) then
        begin
          cmb_Zal.ItemIndex := vIndex;
          Process_Zal_Change(Sender, gg_Progress);
        end;
      end;
    end;
  end;
  // --------------------------------------------------------------------------
  // Change Date value for dtp_Date
  // --------------------------------------------------------------------------
  if ([ssCtrl] = Shift) and (Key in [VK_DOWN, VK_UP, VK_SPACE]) then
  begin
    vDirection := 0;
    if (Key = VK_DOWN) then
    begin
      // Reverse order
      vDirection := 1;
    end
    else if (Key = VK_UP) then
    begin
      // Direct order
      vDirection := 2;
    end
    else if (Key = VK_SPACE) then
    begin
      // Direct order
      vDirection := 3;
    end;
    if (vDirection <> 0) then
    begin
      Key := VK_NONE;
      if dtp_Date.Enabled then
      begin
        case vDirection of
          1:
            dtp_Date.Date := dtp_Date.Date - 1;
          2:
            dtp_Date.Date := dtp_Date.Date + 1;
          3:
            dtp_Date.Date := Now;
        end;
        dtp_DateChange(Sender);
      end;
    end;
  end;
  // --------------------------------------------------------------------------
end;

procedure Tfm_Main.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // foo
end;

procedure Tfm_Main.sb_MainDblClick(Sender: TObject);
begin
  if not fRptReloaded then
    Process_Date_Change(nil, False, gg_Progress);
end;

procedure Tfm_Main.acDebugModeExecute(Sender: TObject);
begin
  acDebugMode.Checked := not acDebugMode.Checked;
  if acDebugMode.Checked then
  begin
    GlobalColumnShow := True;
    GlobalRowShow := True;
    sbx_Cntr.ShowHint := True;
    GlobalSeatCanceledShow := True;
    GlobalSeatFreedShow := True;
    GlobalSeatRestoredShow := True;
    GlobalSeatCheqedShow := True;
    // Print_Cheq := False;
  end
  else
  begin
    // GlobalColumnShow := True;
    // GlobalRowShow := True;
    // sbx_Cntr.ShowHint := True;
    GlobalSeatCanceledShow := False;
    GlobalSeatFreedShow := False;
    GlobalSeatRestoredShow := False;
    GlobalSeatCheqedShow := False;
  end;
  RepaintSeatExCtrls(Self);
end;

procedure Tfm_Main.MaketVerChoose(Sender: TObject);
const
  ProcName: string = 'MaketVerChoose';
begin
  //
  if (Sender is TMenuItem) then
  begin
    Print_Maket_Version := (Sender as TMenuItem).Tag;
{$IFDEF Debug_Level_6}
    DEBUGMessEnh(0, UnitName, ProcName, 'Print_Maket_Version = ['
      + IntToStr(Print_Maket_Version) + ']');
{$ENDIF}
    SaveInitParameter(s_Preferences_Section, s_PrintMaketVersion, IntToStr(Print_Maket_Version));
    (Sender as TMenuItem).Checked := True;
  end;
end;

end.

