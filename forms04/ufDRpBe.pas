{-----------------------------------------------------------------------------
 Unit Name: ufDRpBe
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  08.01.2005
 Purpose:   Ticket Report Preview
 History:
-----------------------------------------------------------------------------}
unit ufDRpBe;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, SLForms, Dialogs,
  FR_Class, FR_DSet, FR_DBSet, StdCtrls, Db, Grids, DBGrids, ExtCtrls,
  Buttons, WcBitBtn, ComCtrls, DBCtrls, ImgList, ActnList,
  FR_E_HTM, FR_E_CSV, FR_E_TXT, FR_E_RTF;

type
  Tfm_DRpBe = class(TSLForm)
    frReport_Ticket: TfrReport;
    dsrc_Master: TDataSource;
    pn_Top: TPanel;
    gb_Edit: TGroupBox;
    lbl_1st: TLabel;
    dtp_Date_Filt: TDateTimePicker;
    sb_Up: TSpeedButton;
    sb_Down: TSpeedButton;
    sb_Today: TSpeedButton;
    lbl_Zal: TLabel;
    dbcm_Zal: TComboBox;
    cmb_Report_Mode: TComboBox;
    bt_ShowReport: TBitBtn;
    bt_Refresh: TBitBtn;
    RPImageList: TImageList;
    RPActionList: TActionList;
    DTRefresh: TAction;
    DTExit: TAction;
    DTAltExit: TAction;
    DTStatusBar: TStatusBar;
    pn_Bottom: TPanel;
    pn_Close: TPanel;
    bt_Close: TBitBtn;
    dsrc_Detail: TDataSource;
    dbgr_Data_Master: TDBGrid;
    Splitter1: TSplitter;
    dbgr_Data_Detail: TDBGrid;
    frDBds_Master: TfrDBDataSet;
    frDBds_Detail: TfrDBDataSet;
    DTPreview: TAction;
    dsrc_Abonem: TDataSource;
    frDBds_Abonem: TfrDBDataSet;
    dbgr_Data: TDBGrid;
    Splitter3: TSplitter;
    frRTFExport1: TfrRTFExport;
    frTextExport1: TfrTextExport;
    frCSVExport1: TfrCSVExport;
    frHTMExport1: TfrHTMExport;
    procedure sb_DownClick(Sender: TObject);
    procedure sb_TodayClick(Sender: TObject);
    procedure sb_UpClick(Sender: TObject);
    procedure bt_CloseClick(Sender: TObject);
    procedure bt_RefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure PrepReport(Sender: TObject);
    procedure bt_ShowReportClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DTStatusBarClick(Sender: TObject);
    procedure Activate_After_Once(Sender: TObject);
    procedure DTRefreshUpdate(Sender: TObject);
    procedure frReport_TicketGetValue(const ParName: string;
      var ParValue: Variant);
    procedure frReport_TicketUserFunction(const Name: string; p1, p2,
      p3: Variant; var Val: string);
  private
    FNotYetActivated: Boolean;
    function SetDTStatus(PanelIndex: Integer; StatusText: string): Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

procedure acDRpBeShowModal(v_Repert_Date: TDateTime; v_Repert_Odeum: Integer);

var
  fm_DRpBe: Tfm_DRpBe;
  pm_Repert_Date: TDateTime;
  pm_Repert_Odeum: Integer;

implementation

uses
  Bugger, pFIBDataSet, udBase, urCommon, uhMain, StrConsts, uhCommon;

{$R *.DFM}

const
  UnitName: string = 'ufDRpBe';

var
  cv_Repert_Date: TDateTime;
  // cv_Repert_Odeum: Integer;

procedure acDRpBeShowModal(v_Repert_Date: TDateTime; v_Repert_Odeum: Integer);
const
  ProcName: string = 'acDRpBeShowModal';
begin
  // --------------------------------------------------------------------------
  // Ежедневный отчет
  // --------------------------------------------------------------------------
  DEBUGMessBrk(1, ')   >>> [' + UnitName + '::' + ProcName + '] >>>   (');
  // DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  try
    pm_Repert_Date := v_Repert_Date;
    pm_Repert_Odeum := v_Repert_Odeum;
    Application.CreateForm(Tfm_DRpBe, fm_DRpBe);
    DEBUGMessEnh(0, UnitName, ProcName, fm_DRpBe.Name + '.ShowModal');
    fm_DRpBe.ShowModal;
  finally
    fm_DRpBe.Free;
    fm_DRpBe := nil;
  end;
  // --------------------------------------------------------------------------
  // DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  DEBUGMessBrk(-1, ')   <<< [' + UnitName + '::' + ProcName + '] <<<   (');
end;

procedure Tfm_DRpBe.sb_UpClick(Sender: TObject);
begin
  if dtp_Date_Filt.Enabled then
  begin
    dtp_Date_Filt.Date := dtp_Date_Filt.Date + 1;
    dtp_Date_Filt.OnChange(Self);
  end;
end;

procedure Tfm_DRpBe.bt_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure Tfm_DRpBe.bt_RefreshClick(Sender: TObject);
begin
  PrepReport(Sender);
end;

procedure Tfm_DRpBe.FormCreate(Sender: TObject);
begin
  // --------------------------------------------------------------------------
  FNotYetActivated := true;
  // --------------------------------------------------------------------------
  dtp_Date_Filt.Date := pm_Repert_Date;
  cv_Repert_Date := dtp_Date_Filt.Date;
  // --------------------------------------------------------------------------
  if (cmb_Report_Mode.Items.Count > 0) then
    cmb_Report_Mode.ItemIndex := 0;
  // --------------------------------------------------------------------------
end;

procedure Tfm_DRpBe.FormActivate(Sender: TObject);
const
  ProcName: string = 'FormActivate';
var
  OldCursor: TCursor;
  Old_Zal_Indx: Integer;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  {
  if Assigned(dbcm_Zal.ListSource) then
    if Assigned(dbcm_Zal.ListSource.DataSet) then
    begin
      dbcm_Zal.ListSource.DataSet.Active := true;
      dbcm_Zal.ListSource.DataSet.Last;
      dbcm_Zal.ListSource.DataSet.First;
    end;
  }
  OldCursor := Screen.Cursor;
  try
    Screen.Cursor := crSQLWait;
    with dbcm_Zal, dm_Base do
    begin
      Old_Zal_Indx := ItemIndex;
      if (Old_Zal_Indx < 0) then
        Old_Zal_Indx := 0;
      ds_Zal.Close;
      // Обновляем Select-sql из репозитория, если нужно
      ds_Zal.Prepare;
      ds_Zal.Open;
      Combo_Load_Zal(ds_Zal, Items);
      if Items.Count > 0 then
        ItemIndex := 0;
      if Old_Zal_Indx < Items.Count then
        ItemIndex := Old_Zal_Indx;
      if FNotYetActivated then
      begin
        Activate_After_Once(nil);
        FNotYetActivated := False;
      end
      else if Assigned(OnChange) then
        OnChange(Self);
      DTStatusBarClick(Sender);
    end;
    //
  finally
    Screen.Cursor := OldCursor;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_DRpBe.sb_DownClick(Sender: TObject);
begin
  if dtp_Date_Filt.Enabled then
  begin
    dtp_Date_Filt.Date := dtp_Date_Filt.Date - 1;
    dtp_Date_Filt.OnChange(Self);
  end;
end;

procedure Tfm_DRpBe.sb_TodayClick(Sender: TObject);
begin
  if dtp_Date_Filt.Enabled then
  begin
    dtp_Date_Filt.Date := Now;
    dtp_Date_Filt.OnChange(Self);
  end;
end;

procedure Tfm_DRpBe.PrepReport(Sender: TObject);
const
  ProcName: string = 'PrepReport';
var
  OldCursor: TCursor;
  Report_Mode: Integer;
  Odeum_Kod: Integer;
  s: string;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  {
  // --------------------------------------------------------------------------
  // dsrc_Master - ds_Rep_Ticket_Odeums
  // --------------------------------------------------------------------------
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
    SP_ODEUM_RF(:IN_FILT_ODEUM) ODM
  // --------------------------------------------------------------------------
  // dsrc_Detail - ds_Rep_Ticket_Tickets
  // --------------------------------------------------------------------------
  select
    OPR.OPER_ODEUM_KOD,
    OPR.OPER_ODEUM_VER,
    OPR.OPER_TICKET_KOD,
    OPR.OPER_TICKET_VER,
    OPR.TICKET_NAM,
    OPR.TICKET_BGCOLOR,
    OPR.TICKET_FNTCOLOR,
    OPR.OPER_STATE,
    OPR.OPER_COST_VALUE,
    OPR.OPER_SALE_FORM,
    OPR.OPER_SALE_FORM_DESC,
    OPR.TOTAL_OPER_COUNT,
    OPR.TOTAL_OPER_SUM,
    OPR.TOTAL_PRINT_COUNT
  from RP_OPER_TKT (
    :IN_REPORT_MODE,
    :ODEUM_KOD,
    :FOO_DATE,
    :IN_SESSION_ID) OPR
  // --------------------------------------------------------------------------
  // dsrc_Master2 - ds_Rep_Daily_Abonem
  // --------------------------------------------------------------------------
  select
    AJN.ABJNL_SALE_DATE,
    AJN.ABJNL_STATE,
    AJN.ABJNL_ABONEM_KOD,
    AJN.ABJNL_ABONEM_VER,
    AJN.ABONEM_NAM,
    AJN.PRICE_VALUE,
    AJN.ABJNL_CHEQED,
    AJN.TOTAL_ABJNL_COUNT,
    AJN.TOTAL_ABJNL_SUM
  from RP_ABJNL_C (
    :IN_REPORT_MODE,
    :IN_FILT_DATE,
    :IN_SESSION_ID) AJN
  // --------------------------------------------------------------------------
  }
  Report_Mode := cmb_Report_Mode.ItemIndex;
  DTStatusBarClick(Sender);
  OldCursor := Screen.Cursor;
  try
    Screen.Cursor := crSQLWait;
    dtp_Date_Filt.Enabled := false;
    dbcm_Zal.Enabled := false;
    cmb_Report_Mode.Enabled := false;
    sb_Up.Enabled := false;
    sb_Down.Enabled := false;
    sb_Today.Enabled := false;
    // --------------------------------------------------------------------------
    if (dsrc_Master.DataSet is TpFIBDataSet) and (dsrc_Abonem.DataSet is TpFIBDataSet) then
    begin
      with (dsrc_Master.DataSet as TpFIBDataSet) do
      begin
        DisableControls;
        try
          try
            DEBUGMessEnh(0, UnitName, ProcName, Name + '.Close');
            Close;
          except
            on E: Exception do
            begin
              DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
              DEBUGMessEnh(0, UnitName, ProcName, Name + '.Close failed.');
            end;
          end;
          try
            // Обновляем Select-sql из репозитория, если нужно
            Prepare;
            // ------------ Setting params ------------
            if Assigned(Params.FindParam(s_IN_REPORT_MODE)) then
            begin
              ParamByName(s_IN_REPORT_MODE).AsVariant := Null;
              case Report_Mode of
                0:
                  begin
                    ParamByName(s_IN_REPORT_MODE).AsInteger := 0;
                  end;
                1:
                  begin
                    ParamByName(s_IN_REPORT_MODE).AsInteger := 1;
                  end;
              else
                // foo
              end;
              DEBUGMessEnh(0, UnitName, ProcName, s_IN_REPORT_MODE + ' = (' +
                IntToStr(Report_Mode) + ')');
            end
            else
              DEBUGMessEnh(0, UnitName, ProcName, s_IN_REPORT_MODE + ' param not found.');
            // ------------
            if Assigned(Params.FindParam(s_IN_FILT_ODEUM)) then
            begin
              ParamByName(s_IN_FILT_ODEUM).AsVariant := Null;
              case Report_Mode of
                0:
                  begin
                    Odeum_Kod := -1;
                    try
                      if dbcm_Zal.ItemIndex > -1 then
                        Odeum_Kod := Integer(dbcm_Zal.Items.Objects[dbcm_Zal.ItemIndex]);
                    except
                      Odeum_Kod := -1;
                    end;
                    ParamByName(s_IN_FILT_ODEUM).AsInteger := Odeum_Kod;
                  end;
                1:
                  begin
                    ParamByName(s_IN_FILT_ODEUM).AsInteger := Cur_Zal_Kod;
                  end;
              else
                // foo
              end;
              s := '<null>';
              if not ParamByName(s_IN_FILT_ODEUM).IsNull then
              try
                s := ParamByName(s_IN_FILT_ODEUM).AsString;
              except
                s := '<error>';
              end;
              DEBUGMessEnh(0, UnitName, ProcName, s_IN_FILT_ODEUM + ' = (' + s + ')');
            end
            else
              DEBUGMessEnh(0, UnitName, ProcName, s_IN_FILT_ODEUM + ' param not found.');
            // ------------
            cv_Repert_Date := Now;
            if Assigned(Params.FindParam(s_IN_FILT_DATE)) then
            begin
              ParamByName(s_IN_FILT_DATE).AsVariant := Null;
              case Report_Mode of
                0:
                  begin
                    ParamByName(s_IN_FILT_DATE).AsDate := dtp_Date_Filt.Date;
                    cv_Repert_Date := dtp_Date_Filt.Date;
                  end;
                1:
                  begin
                    ParamByName(s_IN_FILT_DATE).AsDate := Cur_Date;
                    cv_Repert_Date := Cur_Date;
                  end;
              else
                // foo
              end;
              s := '<null>';
              if not ParamByName(s_IN_FILT_DATE).IsNull then
              try
                s := ParamByName(s_IN_FILT_DATE).AsString;
              except
                s := '<error>';
              end;
              DEBUGMessEnh(0, UnitName, ProcName, s_IN_FILT_DATE + ' = (' + s + ')');
            end
            else
              DEBUGMessEnh(0, UnitName, ProcName, s_IN_FILT_DATE + ' param not found.');
            // ------------
            if Assigned(Params.FindParam(s_IN_SESSION_ID)) then
            begin
              ParamByName(s_IN_SESSION_ID).AsInt64 := Global_Session_ID;
              DEBUGMessEnh(0, UnitName, ProcName, s_IN_SESSION_ID + ' = (' +
                IntToStr(Global_Session_ID) + ')');
            end;
            // ------------
            {
            DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' +
              BoolYesNo[Transaction.Active]);
            // Обновляем Select-sql из репозитория, если нужно
            Prepare;
            }
            DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' +
              BoolYesNo[Transaction.Active]);
            DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.TRParams = ('
              + Transaction.TRParams.CommaText + ')');
            // ------------
            DEBUGMessEnh(0, UnitName, ProcName, Name + '.Open');
            Open;
            First;
            Last;
            // ------------
            First;
          except
            on E: Exception do
            begin
              DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
              DEBUGMessEnh(0, UnitName, ProcName, Name + '.Open failed.');
            end;
          end;
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.RecordCount = ' +
            IntToStr(RecordCount));
        finally
          EnableControls;
        end; // try
      end; // with
      with (dsrc_Abonem.DataSet as TpFIBDataSet) do
      begin
        DisableControls;
        try
          try
            DEBUGMessEnh(0, UnitName, ProcName, Name + '.Close');
            Close;
          except
            on E: Exception do
            begin
              DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
              DEBUGMessEnh(0, UnitName, ProcName, Name + '.Close failed.');
            end;
          end;
          try
            // Обновляем Select-sql из репозитория, если нужно
            Prepare;
            // ------------ Setting params ------------
            if Assigned(Params.FindParam(s_IN_REPORT_MODE)) then
            begin
              ParamByName(s_IN_REPORT_MODE).AsInteger := 1;
              DEBUGMessEnh(0, UnitName, ProcName, s_IN_REPORT_MODE + ' = (' +
                IntToStr(Report_Mode) + ')');
            end;
            // ------------
            cv_Repert_Date := Now;
            if Assigned(Params.FindParam(s_IN_FILT_DATE)) then
            begin
              ParamByName(s_IN_FILT_DATE).AsVariant := Null;
              case Report_Mode of
                0:
                  begin
                    ParamByName(s_IN_FILT_DATE).AsDate := dtp_Date_Filt.Date;
                    cv_Repert_Date := dtp_Date_Filt.Date;
                  end;
                1:
                  begin
                    ParamByName(s_IN_FILT_DATE).AsDate := Cur_Date;
                    cv_Repert_Date := Cur_Date;
                  end;
              else
                // foo
              end;
              s := '<null>';
              if not ParamByName(s_IN_FILT_DATE).IsNull then
              try
                s := ParamByName(s_IN_FILT_DATE).AsString;
              except
                s := '<error>';
              end;
              DEBUGMessEnh(0, UnitName, ProcName, s_IN_FILT_DATE + ' = (' + s + ')');
            end;
            // ------------
            if Assigned(Params.FindParam(s_IN_SESSION_ID)) then
            begin
              ParamByName(s_IN_SESSION_ID).AsInt64 := Global_Session_ID;
              DEBUGMessEnh(0, UnitName, ProcName, s_IN_SESSION_ID + ' = (' +
                IntToStr(Global_Session_ID) + ')');
            end;
            // ------------
            {
            DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' +
              BoolYesNo[Transaction.Active]);
            // Обновляем Select-sql из репозитория, если нужно
            Prepare;
            }
            DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' +
              BoolYesNo[Transaction.Active]);
            DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.TRParams = ('
              + Transaction.TRParams.CommaText + ')');
            // ------------
            DEBUGMessEnh(0, UnitName, ProcName, Name + '.Open');
            Open;
            First;
            Last;
            // ------------
            First;
          except
            on E: Exception do
            begin
              DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
              DEBUGMessEnh(0, UnitName, ProcName, Name + '.Open failed.');
            end;
          end;
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.RecordCount = ' +
            IntToStr(RecordCount));
        finally
          EnableControls;
        end; // try
      end; // with
    end; // if
  finally
    // --------------------------------------------------------------------------
    case Report_Mode of
      0:
        begin
          dtp_Date_Filt.Enabled := true;
          dbcm_Zal.Enabled := true;
        end;
      1:
        begin
          dtp_Date_Filt.Enabled := false;
          dbcm_Zal.Enabled := false;
        end;
    else
      // foo
    end;
    cmb_Report_Mode.Enabled := true;
    sb_Up.Enabled := true;
    sb_Down.Enabled := true;
    sb_Today.Enabled := true;
    DTStatusBarClick(Sender);
    Screen.Cursor := OldCursor;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_DRpBe.bt_ShowReportClick(Sender: TObject);
const
  ProcName: string = 'ShowReport';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  frReport_Ticket.ShowReport;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_DRpBe.FormClose(Sender: TObject; var Action: TCloseAction);
const
  ProcName: string = 'FormClose';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function Tfm_DRpBe.SetDTStatus(PanelIndex: Integer; StatusText: string): Boolean;
const
  ProcName: string = 'SetDTStatus';
begin
  Result := false;
  if (PanelIndex > -1) and (DTStatusBar.Panels.Count > PanelIndex) then
  begin
    if Length(StatusText) > 0 then
      DTStatusBar.Panels[PanelIndex].Text := StatusText
    else
      DTStatusBar.Panels[PanelIndex].Text := '---';
    Result := true;
  end;
end;

procedure Tfm_DRpBe.DTStatusBarClick(Sender: TObject);
begin
  // --------------------------------------------------------------------------
  if Assigned(dbgr_Data_Master.DataSource) and
    Assigned(dbgr_Data_Master.DataSource.DataSet) then
  begin
    if dbgr_Data_Master.DataSource.DataSet.Active then
    begin
      SetDTStatus(1, 'Active');
    end
    else
    begin
      SetDTStatus(1, 'Not active');
    end;
    SetDTStatus(3, IntToStr(dbgr_Data_Master.DataSource.DataSet.RecordCount));
  end
  else
  begin
    SetDTStatus(1, 'Unknown');
    SetDTStatus(3, '');
  end;
  // --------------------------------------------------------------------------
  if Assigned(dbgr_Data_Detail.DataSource) and
    Assigned(dbgr_Data_Detail.DataSource.DataSet) then
  begin
    if dbgr_Data_Detail.DataSource.DataSet.Active then
    begin
      SetDTStatus(5, 'Active');
    end
    else
    begin
      SetDTStatus(5, 'Not active');
    end;
    SetDTStatus(7, IntToStr(dbgr_Data_Detail.DataSource.DataSet.RecordCount));
  end
  else
  begin
    SetDTStatus(5, 'Unknown');
    SetDTStatus(7, '');
  end;
  // --------------------------------------------------------------------------
end;

procedure Tfm_DRpBe.Activate_After_Once(Sender: TObject);
const
  ProcName: string = 'Activate_After_Once';
var
  i, indx: Integer;
begin
  // --------------------------------------------------------------------------
  if (dsrc_Master.DataSet is TpFIBDataSet) then
    with (dsrc_Master.DataSet as TpFIBDataSet) do
    begin
      DisableControls;
      try
        try
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.Close');
          Close;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, Name + '.Close failed.');
          end;
        end;
        try
          // Обновляем Select-sql из репозитория, если нужно
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.Prepare');
          Prepare;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, Name + '.Prepare failed.');
          end;
        end;
      finally
        EnableControls;
      end; // try
    end; // if
  // --------------------------------------------------------------------------
  if (dsrc_Detail.DataSet is TpFIBDataSet) then
    with (dsrc_Detail.DataSet as TpFIBDataSet) do
    begin
      DisableControls;
      try
        try
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.Close');
          Close;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, Name + '.Close failed.');
          end;
        end;
        try
          // Обновляем Select-sql из репозитория, если нужно
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.Prepare');
          Prepare;
          // Задаем параметр
          ParamByName(s_IN_REPORT_MODE).AsInteger := 10;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, Name + '.Prepare failed.');
          end;
        end;
      finally
        EnableControls;
      end; // try
    end; // if
  // --------------------------------------------------------------------------
  if (dsrc_Abonem.DataSet is TpFIBDataSet) then
    with (dsrc_Abonem.DataSet as TpFIBDataSet) do
    begin
      DisableControls;
      try
        try
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.Close');
          Close;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, Name + '.Close failed.');
          end;
        end;
        try
          // Обновляем Select-sql из репозитория, если нужно
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.Prepare');
          Prepare;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, Name + '.Prepare failed.');
          end;
        end;
      finally
        EnableControls;
      end; // try
    end; // if
  // --------------------------------------------------------------------------
  dtp_Date_Filt.Date := pm_Repert_Date;
  with dbcm_Zal do
    if Items.Count > 0 then
    begin
      indx := 0;
      if ItemIndex > -1 then
        indx := ItemIndex;
      if pm_Repert_Odeum > 0 then
      try
        for i := 0 to Items.Count - 1 do
        begin
          if pm_Repert_Odeum = Integer(Items.Objects[i]) then
            indx := i;
        end;
      except
        indx := 0;
      end;
      ItemIndex := indx;
      if Assigned(OnChange) then
        OnChange(Self);
      DEBUGMessEnh(0, UnitName, ProcName, Name + '.OnChange done.');
    end;
  // --------------------------------------------------------------------------
end;

procedure Tfm_DRpBe.DTRefreshUpdate(Sender: TObject);
begin
  DTStatusBarClick(Sender);
end;

procedure Tfm_DRpBe.frReport_TicketGetValue(const ParName: string;
  var ParValue: Variant);
var
  s: string;
  p: Integer;
begin
  if (UpperCase(ParName) = 'REPORT_DATE') then
  begin
    ParValue := FormatDateTime('ddd, dd mmmm, yyyy г.', cv_Repert_Date);
  end
  else if (UpperCase(ParName) = 'REPORT_CINEMA_NAM') then
  begin
    s := dbcm_Zal.Text;
    p := Pos(' - ', s);
    if (p > 0) and (Length(s) > 0) then
      ParValue := Copy(s, 1, p - 1)
    else
      ParValue := s;
  end
  else if (UpperCase(ParName) = 'DBUSER_NAM') then
  begin
    ParValue := Global_User_Nam;
  end
  else if (LowerCase(ParName) = 'void') then
  begin
    ParValue := 'null';
  end;
end;

procedure Tfm_DRpBe.frReport_TicketUserFunction(const Name: string; p1, p2,
  p3: Variant; var Val: string);
var
  ch: Boolean;
begin
  // uf_iif( [FIELD1] = 1, [FIELD2], 0)
  if (UpperCase(Name) = 'UF_IIF') then
  begin
    try
      // осторожно - рекуррсия !!!
      ch := frParser.Calc(p1);
      // результат - это форматированная строка, поэтому заключаем в кавычки
      if ch then
        Val := '''' + IntToStr(p2) + ''''
      else
        Val := '''' + IntToStr(p3) + '''';
    except
      Val := '-1';
    end;
  end
end;

end.

