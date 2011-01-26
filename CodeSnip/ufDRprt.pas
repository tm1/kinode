{-----------------------------------------------------------------------------
 Unit Name: ufDRprt
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  19.11.2004
 Purpose:   Daily Report Preview
 History:
-----------------------------------------------------------------------------}
unit ufDRprt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, SLForms, Dialogs,
  FR_Class, FR_DSet, FR_DBSet, StdCtrls, Db, Grids, DBGrids, ExtCtrls,
  Buttons, WcBitBtn, ComCtrls, DBCtrls, ImgList, ActnList;

type
  Tfm_DRprt = class(TSLForm)
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    dsrc_Data: TDataSource;
    pn_Top: TPanel;
    gb_Edit: TGroupBox;
    dbgr_Data: TDBGrid;
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
  private
    FNotYetActivated: Boolean;
    function SetDTStatus(PanelIndex: Integer; StatusText: string): Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

procedure acDRprtShowModal(v_Repert_Date: TDateTime; v_Repert_Odeum: Integer);

var
  fm_DRprt: Tfm_DRprt;
  pm_Repert_Date: TDateTime;
  pm_Repert_Odeum: Integer;

implementation

uses
  Bugger, pFIBDataSet, udBase, urCommon, uhMain, StrConsts, uhCommon;

{$R *.DFM}

const
  UnitName: string = 'ufDRprt';

procedure acDRprtShowModal(v_Repert_Date: TDateTime; v_Repert_Odeum: Integer);
const
  ProcName: string = 'acDRprtShowModal';
begin
  // --------------------------------------------------------------------------
  // ≈жедневный отчет
  // --------------------------------------------------------------------------
  DEBUGMessBrk(1, ')   >>> [' + UnitName + '::' + ProcName + '] >>>   (');
  // DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  try
    pm_Repert_Date := v_Repert_Date;
    pm_Repert_Odeum := v_Repert_Odeum;
    Application.CreateForm(Tfm_DRprt, fm_DRprt);
    DEBUGMessEnh(0, UnitName, ProcName, fm_DRprt.Name + '.ShowModal');
    fm_DRprt.ShowModal;
  finally
    fm_DRprt.Free;
    fm_DRprt := nil;
  end;
  // --------------------------------------------------------------------------
  // DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  DEBUGMessBrk(-1, ')   <<< [' + UnitName + '::' + ProcName + '] <<<   (');
end;

procedure Tfm_DRprt.sb_UpClick(Sender: TObject);
begin
  if dtp_Date_Filt.Enabled then
  begin
    dtp_Date_Filt.Date := dtp_Date_Filt.Date + 1;
    dtp_Date_Filt.OnChange(Self);
  end;
end;

procedure Tfm_DRprt.bt_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure Tfm_DRprt.bt_RefreshClick(Sender: TObject);
begin
  PrepReport(Sender);
end;

procedure Tfm_DRprt.FormCreate(Sender: TObject);
begin
  // --------------------------------------------------------------------------
  FNotYetActivated := true;
  // --------------------------------------------------------------------------
  dtp_Date_Filt.Date := pm_Repert_Date;
  // --------------------------------------------------------------------------
  if (cmb_Report_Mode.Items.Count > 0) then
    cmb_Report_Mode.ItemIndex := 0;
  // --------------------------------------------------------------------------
end;

procedure Tfm_DRprt.FormActivate(Sender: TObject);
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
    end;
    //
  finally
    Screen.Cursor := OldCursor;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_DRprt.sb_DownClick(Sender: TObject);
begin
  if dtp_Date_Filt.Enabled then
  begin
    dtp_Date_Filt.Date := dtp_Date_Filt.Date - 1;
    dtp_Date_Filt.OnChange(Self);
  end;
end;

procedure Tfm_DRprt.sb_TodayClick(Sender: TObject);
begin
  if dtp_Date_Filt.Enabled then
  begin
    dtp_Date_Filt.Date := Now;
    dtp_Date_Filt.OnChange(Self);
  end;
end;

procedure Tfm_DRprt.PrepReport(Sender: TObject);
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
  select
    RP_OPER_RF.OPER_REPERT_KOD,
    RP_OPER_RF.OPER_REPERT_VER,
    RP_OPER_RF.OPER_STATE,
    RP_OPER_RF.OPER_SELECTED,
    RP_OPER_RF.OPER_ACTION,
    RP_OPER_RF.OPER_ACTION_DESC,
    RP_OPER_RF.OPER_CHEQED,
    RP_OPER_RF.OPER_COST_VALUE,
    RP_OPER_RF.OPER_SALE_FORM,
    RP_OPER_RF.OPER_SALE_FORM_DESC,
    RP_OPER_RF.OPER_TICKET_KOD,
    RP_OPER_RF.OPER_TICKET_VER,
    RP_OPER_RF.TICKET_NAM,
    RP_OPER_RF.TICKET_BGCOLOR,
    RP_OPER_RF.TICKET_FNTCOLOR,
    RP_OPER_RF.OPER_MISC_REASON,
    RP_OPER_RF.DBUSER_KOD,
    RP_OPER_RF.DBUSER_NAM,
    RP_OPER_RF.SESSION_HOST,
    RP_OPER_RF.TOTAL_OPER_COUNT,
    RP_OPER_RF.TOTAL_OPER_SUM,
    RP_OPER_RF.TOTAL_PRINT_COUNT,
    RP_OPER_RF.ODEUM_DESC,
    RP_OPER_RF.SEANS_TIME,
    RP_OPER_RF.SEANS_FINISH,
    RP_OPER_RF.FILM_DESC,
    RP_OPER_RF.TARIFF_DESC
  from
    RP_OPER_RF(
      :IN_REPORT_MODE,
      :IN_FILT_ODEUM,
      :IN_FILT_DATE,
      :IN_FILT_REPERT,
      :IN_SESSION_ID)
  }
  // --------------------------------------------------------------------------
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
    if (dsrc_Data.DataSet is TpFIBDataSet) then
      with (dsrc_Data.DataSet as TpFIBDataSet) do
      begin
        DisableControls;
        try
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.Close');
          Close;
          Prepare;
          // ------------ Setting params ------------
          if Assigned(Params.FindParam(s_IN_REPORT_MODE)) then
          begin
            ParamByName(s_IN_REPORT_MODE).AsVariant := Null;
            case Report_Mode of
              0:
                begin
                  ParamByName(s_IN_REPORT_MODE).AsInteger := 3;
                end;
              1:
                begin
                  ParamByName(s_IN_REPORT_MODE).AsInteger := 3;
                end;
              2:
                begin
                  ParamByName(s_IN_REPORT_MODE).AsInteger := 1;
                end;
            else
              // foo
            end;
            DEBUGMessEnh(0, UnitName, ProcName, s_IN_REPORT_MODE + ' = (' +
              IntToStr(Report_Mode) + ')');
          end;
          // ------------
          if Assigned(Params.FindParam(s_IN_FILT_ODEUM)) then
          begin
            ParamByName(s_IN_FILT_ODEUM).AsVariant := Null;
            case Report_Mode of
              0:
                begin
                  Odeum_Kod := 0;
                  try
                    if dbcm_Zal.ItemIndex > -1 then
                      Odeum_Kod := Integer(dbcm_Zal.Items.Objects[dbcm_Zal.ItemIndex]);
                  except
                    Odeum_Kod := 0;
                  end;
                  ParamByName(s_IN_FILT_ODEUM).AsInteger := Odeum_Kod;
                end;
              1, 2:
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
          end;
          // ------------
          if Assigned(Params.FindParam(s_IN_FILT_DATE)) then
          begin
            ParamByName(s_IN_FILT_DATE).AsVariant := Null;
            case Report_Mode of
              0:
                begin
                  ParamByName(s_IN_FILT_DATE).AsDate := dtp_Date_Filt.Date;
                end;
              1, 2:
                begin
                  ParamByName(s_IN_FILT_DATE).AsDate := Cur_Date;
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
          if Assigned(Params.FindParam(s_IN_FILT_REPERT)) then
          begin
            ParamByName(s_IN_FILT_REPERT).AsInteger := Cur_Repert_Kod;
            DEBUGMessEnh(0, UnitName, ProcName, s_IN_FILT_REPERT + ' = (' +
              ParamByName(s_IN_FILT_REPERT).AsString + ')');
          end;
          // ------------
          if Assigned(Params.FindParam(s_IN_SESSION_ID)) then
          begin
            ParamByName(s_IN_SESSION_ID).AsInt64 := Global_Session_ID;
            DEBUGMessEnh(0, UnitName, ProcName, s_IN_SESSION_ID + ' = (' +
              IntToStr(Global_Session_ID) + ')');
          end;
          // ------------
          DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' +
            BoolYesNo[Transaction.Active]);
          Prepare;
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
          EnableControls;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, Name + '.CloseOpen failed.');
          end;
        end;
        DEBUGMessEnh(0, UnitName, ProcName, Name + '.RecordCount = ' +
          IntToStr(RecordCount));
        // SetDTStatus(2, IntToStr(RecordCount));
        DTStatusBarClick(Sender);
      end;
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
      2:
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
    Screen.Cursor := OldCursor;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_DRprt.bt_ShowReportClick(Sender: TObject);
const
  ProcName: string = 'ShowReport';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  frReport1.ShowReport;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_DRprt.FormClose(Sender: TObject; var Action: TCloseAction);
const
  ProcName: string = 'FormClose';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function Tfm_DRprt.SetDTStatus(PanelIndex: Integer; StatusText: string): Boolean;
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

procedure Tfm_DRprt.DTStatusBarClick(Sender: TObject);
begin
  if Assigned(dbgr_Data.DataSource) and
    Assigned(dbgr_Data.DataSource.DataSet) and
    dbgr_Data.DataSource.DataSet.Active then
  begin
    SetDTStatus(0, 'Dataset is active');
    SetDTStatus(2, IntToStr(dbgr_Data.DataSource.DataSet.RecordCount));
  end
  else
  begin
    SetDTStatus(0, 'Not active');
    SetDTStatus(2, 'unknown');
  end;
end;

procedure Tfm_DRprt.Activate_After_Once(Sender: TObject);
const
  ProcName: string = 'Activate_After_Once';
var
  i, indx: Integer;
begin
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

end.

