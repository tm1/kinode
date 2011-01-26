{-----------------------------------------------------------------------------
 Unit Name: ufAbjnl
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  19.12.2004
 Purpose:   Edit Form (ds_Abjnl)
 History:
-----------------------------------------------------------------------------}
unit ufAbjnl;

interface

{$I kinode01.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Grids, DBGrids, ExtCtrls, Spin, StdCtrls, DBCtrls, Mask, Buttons,
  ExtDlgs, ufDted, ComCtrls, WcBitBtn;

type
  Tfm_Abjnl = class(Tfm_Dted)
    bt_AddRec: TBitBtn;
    bt_Cancel: TBitBtn;
    bt_DeleteRec: TBitBtn;
    bt_EditRec: TBitBtn;
    dbgr_Data: TDBGrid;
    dbtx_BASE_KOD: TDBText;
    dsrc_Data: TDataSource;
    lbl_1st: TLabel;
    lbl_Kod: TLabel;
    gb_Edit: TGroupBox;
    pn_Top: TPanel;
    bt_Refresh: TBitBtn;
    lbl_Zal: TLabel;
    dbcm_Zal: TComboBox;
    dsrc_Lookup_Price: TDataSource;
    dtp_Date_Filt: TDateTimePicker;
    lbl_Price: TLabel;
    dbcm_Price: TDBLookupComboBox;
    bt_Price: TWc_BitBtn;
    pn_Bottom: TPanel;
    pn_Close: TPanel;
    bt_Close: TBitBtn;
    sb_Up: TSpeedButton;
    sb_Down: TSpeedButton;
    sb_Today: TSpeedButton;
    cmb_FiltrateDate: TComboBox;
    cmb_FiltrateZal: TComboBox;
    bt_Price_Last: TWc_BitBtn;
    bt_Cheq: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbcm_Date_Or_Zal_Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Abjnl_OnDataChange(Sender: TObject; Field: TField);
    procedure Abjnl_AfterInsert(DataSet: TDataSet);
    procedure Abjnl_BeforePost(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
    procedure bt_PriceClick(Sender: TObject);
    procedure bt_Price_LastClick(Sender: TObject);
    procedure sb_UpClick(Sender: TObject);
    procedure sb_DownClick(Sender: TObject);
    procedure sb_TodayClick(Sender: TObject);
    procedure Activate_After_Once(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure bt_CheqClick(Sender: TObject);
  private
    { Private declarations }
    FNotYetActivated: Boolean;
    FPriceActive: Boolean;
    FOnDataChangeOldEv: TDataChangeEvent;
    FAfterInsertOldEv: TDataSetNotifyEvent;
    FBeforePostOldEv: TDataSetNotifyEvent;
  public
    { Public declarations }
  end;

procedure acAbjnlShowModal(v_Abjnl_Date: TDateTime; v_Abjnl_Odeum: Integer);

var
  fm_Abjnl: Tfm_Abjnl;
  pm_Abjnl_Date: TDateTime;
  pm_Abjnl_Odeum: Integer;

implementation

uses
  Bugger, udBase, ufSeans, ufPrice, uhCommon, urCommon, StrConsts, pFIBDataSet;

{$R *.DFM}

const
  UnitName: string = 'ufAbjnl';

procedure acAbjnlShowModal(v_Abjnl_Date: TDateTime; v_Abjnl_Odeum: Integer);
const
  ProcName: string = 'acAbjnlShowModal';
begin
  // --------------------------------------------------------------------------
  // Репертуар кинотеатра
  // --------------------------------------------------------------------------
  DEBUGMessBrk(1, ')   >>> [' + UnitName + '::' + ProcName + '] >>>   (');
  // DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  try
    pm_Abjnl_Date := v_Abjnl_Date;
    pm_Abjnl_Odeum := v_Abjnl_Odeum;
    Application.CreateForm(Tfm_Abjnl, fm_Abjnl);
    DEBUGMessEnh(0, UnitName, ProcName, fm_Abjnl.Name + '.ShowModal');
    fm_Abjnl.ShowModal;
  finally
    fm_Abjnl.Free;
    fm_Abjnl := nil;
  end;
  // --------------------------------------------------------------------------
  // DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  DEBUGMessBrk(-1, ')   <<< [' + UnitName + '::' + ProcName + '] <<<   (');
end;

procedure Tfm_Abjnl.FormActivate(Sender: TObject);
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
        {
        Comp := Self.FindComponent(s_Reposition_Name);
        if (Comp is TPanel) and (not (Comp.Tag and 1 = 1)) then
          if Assigned((Comp as TPanel).OnDblClick) then
          begin
            (Comp as TPanel).OnDblClick(nil);
          end;
        }
        Activate_After_Once(nil);
        FNotYetActivated := False;
      end
      else if Assigned(OnChange) then
        OnChange(Self);
    end;
    //
    if Assigned(dbcm_Price.ListSource) then
      if Assigned(dbcm_Price.ListSource.DataSet) then
      begin
        dbcm_Price.ListSource.DataSet.Active := true;
        dbcm_Price.ListSource.DataSet.Last;
        dbcm_Price.ListSource.DataSet.First;
        // dbcm_Price.DropDownWidth := 0;
        // dbcm_Price.DropDownWidth := dbcm_Price.Width + cmb_FiltrateDate.Width;
      end;
  finally
    Screen.Cursor := OldCursor;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Abjnl.FormClose(Sender: TObject; var Action: TCloseAction);
const
  ProcName: string = 'FormClose';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  if Assigned(dbcm_Price.ListSource) then
    if Assigned(dbcm_Price.ListSource.DataSet) then
      dbcm_Price.ListSource.DataSet.Active := FPriceActive;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Abjnl.dbcm_Date_Or_Zal_Change(Sender: TObject);
const
  ProcName: string = 'dbcm_Date_Or_Zal_Change';
var
  index: integer;
  OldCursor: TCursor;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  if Assigned(dsrc_Data.Dataset) and (dsrc_Data.Dataset is TpFIBDataSet) then
    with (dsrc_Data.Dataset as TpFIBDataSet) do
    begin
      // dm_Base.ds_Abjnl
      DisableControls;
      cmb_FiltrateDate.Enabled := false;
      cmb_FiltrateZal.Enabled := false;
      sb_Up.Enabled := false;
      sb_Down.Enabled := false;
      sb_Today.Enabled := false;
      index := 0;
      try
        if dbcm_Zal.ItemIndex > -1 then
          index := Integer(dbcm_Zal.Items.Objects[dbcm_Zal.ItemIndex]);
      except
        index := 0;
      end;
      OldCursor := Screen.Cursor;
      try
        Screen.Cursor := crSQLWait;
        try
          Close;
          // -----------------------------------------------------------
          if Assigned(Params.FindParam(s_IN_FILT_ODEUM)) then
            ParamByName(s_IN_FILT_ODEUM).AsInteger := index;
          if Assigned(Params.FindParam(s_IN_FILT_DATE)) then
            ParamByName(s_IN_FILT_DATE).AsDate := dtp_Date_Filt.Date;
          // -----------------------------------------------------------
          if Assigned(Params.FindParam(s_IN_FILT_MODE_ODEUM)) then
            case cmb_FiltrateZal.ItemIndex of
              0:
                ParamByName(s_IN_FILT_MODE_ODEUM).AsInteger := 0;
              1:
                ParamByName(s_IN_FILT_MODE_ODEUM).AsInteger := 1;
              2:
                begin
                  ParamByName(s_IN_FILT_MODE_ODEUM).AsInteger := 0;
                  if Assigned(Params.FindParam(s_IN_FILT_ODEUM)) then
                    ParamByName(s_IN_FILT_ODEUM).AsInteger := -1;
                end
            else
              ParamByName(s_IN_FILT_MODE_ODEUM).AsInteger := 0;
            end;
          if Assigned(Params.FindParam(s_IN_FILT_MODE_DATE)) then
            case cmb_FiltrateDate.ItemIndex of
              0: ParamByName(s_IN_FILT_MODE_DATE).AsInteger := 0;
              1: ParamByName(s_IN_FILT_MODE_DATE).AsInteger := 1;
            else
              ParamByName(s_IN_FILT_MODE_DATE).AsInteger := 0;
            end;
          // -----------------------------------------------------------
          Prepare;
          Open;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, 'Exception during dataset filtering.');
            ShowMessage('Не получается отфильтровать данные.'
              + c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF
              + E.Message + c_CRLF + c_Separator_20);
          end;
        end;
      finally
        Screen.Cursor := OldCursor;
      end;
      //    ShowMessage(SelectSQL.Text);
      //    Active := true;
      sb_Up.Enabled := true;
      sb_Down.Enabled := true;
      sb_Today.Enabled := true;
      cmb_FiltrateDate.Enabled := true;
      cmb_FiltrateZal.Enabled := true;
      EnableControls;
    end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Abjnl.FormCreate(Sender: TObject);
const
  ProcName: string = 'FormCreate';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  FNotYetActivated := true;
  FPriceActive := false;
  // --------------------------------------------------------------------------
  if Assigned(dbcm_Price.ListSource) then
    if Assigned(dbcm_Price.ListSource.DataSet) then
      FPriceActive := dbcm_Price.ListSource.DataSet.Active;
  // --------------------------------------------------------------------------
  if cmb_FiltrateDate.Items.Count > 0 then
    cmb_FiltrateDate.ItemIndex := 0;
  if cmb_FiltrateZal.Items.Count > 0 then
    cmb_FiltrateZal.ItemIndex := 0;
  // --------------------------------------------------------------------------
  dtp_Date_Filt.Date := pm_Abjnl_Date;
  // --------------------------------------------------------------------------
  FOnDataChangeOldEv := nil;
  FAfterInsertOldEv := nil;
  FBeforePostOldEv := nil;
  if Assigned(dbgr_Data.DataSource) then
    with dbgr_Data.DataSource do
    begin
      if Assigned(OnDataChange) then
        FOnDataChangeOldEv := OnDataChange;
      OnDataChange := Abjnl_OnDataChange;
      DEBUGMessEnh(0, UnitName, ProcName, 'DataSource events hooked.');
      if Assigned(DataSet) then
        with DataSet do
        begin
          // dm_Base.ds_Abjnl
          if Assigned(OnNewRecord) then
            FAfterInsertOldEv := AfterInsert;
          AfterInsert := Abjnl_AfterInsert;
          if Assigned(BeforePost) then
            FBeforePostOldEv := BeforePost;
          BeforePost := Abjnl_BeforePost;
          DEBUGMessEnh(0, UnitName, ProcName, 'DataSet events hooked.');
        end;
      Abjnl_OnDataChange(nil, nil);
    end;
  // --------------------------------------------------------------------------
  // dbcm_Price.DropDownWidth := 0;
  // dbcm_Price.DropDownWidth := dbcm_Price.Width + cmb_FiltrateDate.Width;
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Abjnl.Abjnl_OnDataChange(Sender: TObject; Field: TField);
const
  ProcName: string = 'Abjnl_OnDataChange';
var
  dsrc_Data_DS, dsrc_Lookup_DS: TpFIBDataSet;
  new_kod, old_kod, new_ver, old_ver: Variant;
begin
  // DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  bt_Price_Last.Enabled := false;
  if DatasetActive = 1 then
  begin
    if (dsrc_Data.Dataset is TpFIBDataSet) then
    begin
      old_kod := 0;
      old_ver := 0;
      new_kod := 0;
      new_ver := 0;
      // dm_Base.ds_Abjnl
      dsrc_Data_DS := (dsrc_Data.Dataset as TpFIBDataSet);
      if dsrc_Data_DS.State in [{dsEdit, dsInsert, }dsBrowse] then
      begin
        // --------------------------------------------------------------------------
        if Assigned(dsrc_Lookup_Price.Dataset) and (dsrc_Lookup_Price.Dataset is TpFIBDataSet) then
        begin
          // dm_Base.ds_Price
          dsrc_Lookup_DS := (dsrc_Lookup_Price.Dataset as TpFIBDataSet);
          if dsrc_Lookup_DS.Active and (dsrc_Lookup_DS.State in [dsBrowse])
            and Assigned(dsrc_Data_DS.FN(s_ABJNL_PRICE_KOD))
            and Assigned(dsrc_Data_DS.FN(s_ABJNL_PRICE_VER))
            and Assigned(dsrc_Lookup_DS.FN(s_PRICE_KOD))
            and Assigned(dsrc_Lookup_DS.FN(s_PRICE_VER)) then
          begin
            try
              old_kod := dsrc_Data_DS.FN(s_ABJNL_PRICE_KOD).AsVariant;
              old_ver := dsrc_Data_DS.FN(s_ABJNL_PRICE_VER).AsVariant;
              new_kod := dsrc_Lookup_DS.FN(s_Price_KOD).AsVariant;
              new_ver := dsrc_Lookup_DS.FN(s_Price_VER).AsVariant;
              if (Length(dbcm_Price.Text) > 0) and ((new_kod <> old_kod) or (new_ver <> old_ver))
                then
                bt_Price_Last.Enabled := true;
            finally
              old_kod := 0;
              old_ver := 0;
              new_kod := 0;
              new_ver := 0;
            end;
          end;
        end;
        // --------------------------------------------------------------------------
      end;
    end;
  end;
  // --------------------------------------------------------------------------
  if Assigned(FOnDataChangeOldEv) then
    FOnDataChangeOldEv(Sender, Field);
  // --------------------------------------------------------------------------
  // DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Abjnl.Abjnl_AfterInsert(DataSet: TDataSet);
const
  ProcName: string = 'Abjnl_AfterInsert';
var
  index: integer;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  if Assigned(dsrc_Data.Dataset) and (dsrc_Data.Dataset is TpFIBDataSet) then
    with (dsrc_Data.Dataset as TpFIBDataSet) do
    begin
      // dm_Base.ds_Abjnl
      if Assigned(FN(s_ABJNL_STATE)) then
        FN(s_ABJNL_STATE).AsInteger := 1;
      if Assigned(FN(s_ABJNL_SALE_DATE)) then
        FN(s_ABJNL_SALE_DATE).AsDateTime := dtp_Date_Filt.Date;
      if Assigned(FN(s_ABJNL_ODEUM_KOD)) then
      begin
        try
          index := Integer(dbcm_Zal.Items.Objects[dbcm_Zal.ItemIndex]);
        except
          index := 0;
        end;
        FN(s_ABJNL_ODEUM_KOD).AsInteger := index;
      end;
    end;
  if Assigned(FAfterInsertOldEv) then
  try
    FAfterInsertOldEv(DataSet);
  except
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Abjnl.Abjnl_BeforePost(DataSet: TDataSet);
const
  ProcName: string = 'Abjnl_BeforePost';
var
  new_kod, old_kod: Variant;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  new_kod := 0;
  old_kod := 0;
  if Assigned(dsrc_Data.Dataset) and (dsrc_Data.Dataset is TpFIBDataSet) then
    with (dsrc_Data.Dataset as TpFIBDataSet) do
    begin
      // dm_Base.ds_Abjnl
      if Assigned(FN(s_ABJNL_ODEUM_KOD)) and Assigned(FN(s_ABJNL_ODEUM_VER)) then
      begin
        try
          new_kod := FN(s_ABJNL_ODEUM_KOD).NewValue;
          old_kod := FN(s_ABJNL_ODEUM_KOD).OldValue;
          if new_kod <> old_kod then
            FN(s_ABJNL_ODEUM_VER).AsVariant := Null;
        finally
          new_kod := 0;
          old_kod := 0;
        end;
      end;
      if Assigned(FN(s_ABJNL_PRICE_KOD)) and Assigned(FN(s_ABJNL_PRICE_VER)) then
      begin
        try
          new_kod := FN(s_ABJNL_PRICE_KOD).NewValue;
          old_kod := FN(s_ABJNL_PRICE_KOD).OldValue;
          if new_kod <> old_kod then
            FN(s_ABJNL_PRICE_VER).AsVariant := Null;
        finally
          new_kod := 0;
          old_kod := 0;
        end;
      end;
    end;
  if Assigned(FBeforePostOldEv) then
  try
    FBeforePostOldEv(DataSet);
  except
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Abjnl.FormDestroy(Sender: TObject);
const
  ProcName: string = 'FormDestroy';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  if Assigned(dbgr_Data.DataSource) then
    with dbgr_Data.DataSource do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'DataSource events restored.');
      if Assigned(FOnDataChangeOldEv) then
        OnDataChange := FOnDataChangeOldEv
      else
        OnDataChange := nil;
      if Assigned(DataSet) then
        with DataSet do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'DataSet events restored.');
          // dm_Base.ds_Abjnl
          if Assigned(FBeforePostOldEv) then
            BeforePost := FBeforePostOldEv
          else
            BeforePost := nil;
          if Assigned(FAfterInsertOldEv) then
            AfterInsert := FAfterInsertOldEv
          else
            AfterInsert := nil;
        end;
    end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Abjnl.bt_PriceClick(Sender: TObject);
begin
  //
  acPriceShowModal(-1);
  FormActivate(nil);
end;

procedure Tfm_Abjnl.bt_Price_LastClick(Sender: TObject);
var
  new_kod, old_kod, new_ver, old_ver: Variant;
begin
  //
  new_kod := 0;
  new_ver := 0;
  old_kod := 0;
  old_ver := 0;
  if Assigned(dsrc_Data.Dataset) and (dsrc_Data.Dataset is TpFIBDataSet) then
    with (dsrc_Data.Dataset as TpFIBDataSet) do
    begin
      // dm_Base.ds_Price
      if Assigned(FN(s_ABJNL_PRICE_KOD)) and Assigned(FN(s_ABJNL_PRICE_VER)) then
      begin
        try
          if State in [dsBrowse] then
            Edit;
          new_kod := FN(s_ABJNL_PRICE_KOD).NewValue;
          new_ver := FN(s_ABJNL_PRICE_VER).NewValue;
          old_kod := FN(s_ABJNL_PRICE_KOD).OldValue;
          old_ver := FN(s_ABJNL_PRICE_VER).OldValue;
          // if (new_kod <> old_kod) then
          FN(s_ABJNL_PRICE_VER).AsVariant := Null;
        finally
        end;
      end;
    end;
end;

procedure Tfm_Abjnl.sb_UpClick(Sender: TObject);
begin
  if dtp_Date_Filt.Enabled then
  begin
    dtp_Date_Filt.Date := dtp_Date_Filt.Date + 1;
    dtp_Date_Filt.OnChange(Self);
  end;
end;

procedure Tfm_Abjnl.sb_DownClick(Sender: TObject);
begin
  if dtp_Date_Filt.Enabled then
  begin
    dtp_Date_Filt.Date := dtp_Date_Filt.Date - 1;
    dtp_Date_Filt.OnChange(Self);
  end;
end;

procedure Tfm_Abjnl.sb_TodayClick(Sender: TObject);
begin
  if dtp_Date_Filt.Enabled then
  begin
    dtp_Date_Filt.Date := Now;
    dtp_Date_Filt.OnChange(Self);
  end;
end;

procedure Tfm_Abjnl.Activate_After_Once(Sender: TObject);
const
  ProcName: string = 'Activate_After_Once';
begin
  // --------------------------------------------------------------------------
  dtp_Date_Filt.Date := pm_Abjnl_Date;
  with cmb_FiltrateDate do
  begin
    if Assigned(OnChange) then
      OnChange(Self);
    DEBUGMessEnh(0, UnitName, ProcName, Name + '.OnChange done.');
  end;
  // --------------------------------------------------------------------------
end;

procedure Tfm_Abjnl.FormResize(Sender: TObject);
begin
  {
  dbcm_Price.DropDownWidth := 0;
  if (Self.WindowState = wsMaximized) then
    dbcm_Price.DropDownWidth := dbcm_Price.Width + cmb_FiltrateDate.Width;
  }  
  // dbcm_Price.Update;
end;

procedure Tfm_Abjnl.bt_CheqClick(Sender: TObject);
begin
  //
  if Assigned(dsrc_Data.Dataset) and (dsrc_Data.Dataset is TpFIBDataSet) then
    with (dsrc_Data.Dataset as TpFIBDataSet) do
    begin
      // dm_Base.ds_Price
      if Assigned(FN(s_ABJNL_CHEQED)) then
      begin
        if (FN(s_ABJNL_CHEQED).AsInteger = 0) then
        try
          if State in [dsBrowse] then
            Edit;
          FN(s_ABJNL_CHEQED).AsInteger := 1;
        finally
        end;
      end;
    end;
end;

end.

