{-----------------------------------------------------------------------------
 Unit Name: ufRepert
 Author:    n0mad
 Version:   1.1.6.72
 Creation:  16.08.2003
 Purpose:   Edit Form (ds_Repert)
 History:
-----------------------------------------------------------------------------}
unit ufRepert;

interface

{$I kinode01.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Grids, DBGrids, ExtCtrls, Spin, StdCtrls, DBCtrls, Mask, Buttons,
  ExtDlgs, ufDted, ComCtrls, WcBitBtn;

type
  Tfm_Repert = class(Tfm_Dted)
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
    dbcm_Zal: TComboBox;
    dsrc_Lookup_Seans: TDataSource;
    bt_Refresh: TBitBtn;
    dsrc_Lookup_Film: TDataSource;
    dtp_Date_Filt: TDateTimePicker;
    lbl_Zal: TLabel;
    Label4: TLabel;
    dbcm_Seans: TDBLookupComboBox;
    bt_Seans: TWc_BitBtn;
    Label2: TLabel;
    dbcm_Film: TDBLookupComboBox;
    bt_Film: TWc_BitBtn;
    lbl_Tarif: TLabel;
    dbcm_Tariff: TDBLookupComboBox;
    bt_Tariff: TWc_BitBtn;
    dsrc_Lookup_Tariff: TDataSource;
    pn_Bottom: TPanel;
    pn_Close: TPanel;
    bt_Close: TBitBtn;
    sb_Up: TSpeedButton;
    sb_Down: TSpeedButton;
    sb_Today: TSpeedButton;
    cmb_FiltrateDate: TComboBox;
    cmb_FiltrateZal: TComboBox;
    bt_Film_Last: TWc_BitBtn;
    bt_Tariff_Last: TWc_BitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbcm_Date_Or_Zal_Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Repert_OnDataChange(Sender: TObject; Field: TField);
    procedure Repert_AfterInsert(DataSet: TDataSet);
    procedure Repert_BeforePost(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
    procedure bt_SeansClick(Sender: TObject);
    procedure bt_FilmClick(Sender: TObject);
    procedure bt_Film_LastClick(Sender: TObject);
    procedure bt_TariffClick(Sender: TObject);
    procedure bt_Tariff_LastClick(Sender: TObject);
    procedure sb_UpClick(Sender: TObject);
    procedure sb_DownClick(Sender: TObject);
    procedure sb_TodayClick(Sender: TObject);
    procedure Activate_After_Once(Sender: TObject);
  private
    { Private declarations }
    FNotYetActivated: Boolean;
    FSeansActive: Boolean;
    FFilmActive: Boolean;
    FTariffActive: Boolean;
    FOnDataChangeOldEv: TDataChangeEvent;
    FAfterInsertOldEv: TDataSetNotifyEvent;
    FBeforePostOldEv: TDataSetNotifyEvent;
  public
    { Public declarations }
  end;

procedure acRepertShowModal(v_Repert_Date: TDateTime; v_Repert_Odeum: Integer);

var
  fm_Repert: Tfm_Repert;
  pm_Repert_Date: TDateTime;
  pm_Repert_Odeum: Integer;

implementation

uses
  Bugger, udBase, ufSeans, ufFilm, uhCommon, urCommon, ufTariff, StrConsts, pFIBDataSet,
  ufCost;

{$R *.DFM}

const
  UnitName: string = 'ufRepert';

procedure acRepertShowModal(v_Repert_Date: TDateTime; v_Repert_Odeum: Integer);
const
  ProcName: string = 'acRepertShowModal';
begin
  // --------------------------------------------------------------------------
  // Репертуар кинотеатра
  // --------------------------------------------------------------------------
  DEBUGMessBrk(1, ')   >>> [' + UnitName + '::' + ProcName + '] >>>   (');
  // DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  try
    pm_Repert_Date := v_Repert_Date;
    pm_Repert_Odeum := v_Repert_Odeum;
    Application.CreateForm(Tfm_Repert, fm_Repert);
    DEBUGMessEnh(0, UnitName, ProcName, fm_Repert.Name + '.ShowModal');
    fm_Repert.ShowModal;
  finally
    fm_Repert.Free;
    fm_Repert := nil;
  end;
  // --------------------------------------------------------------------------
  // DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  DEBUGMessBrk(-1, ')   <<< [' + UnitName + '::' + ProcName + '] <<<   (');
end;

procedure Tfm_Repert.FormActivate(Sender: TObject);
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
    if Assigned(dbcm_Seans.ListSource) then
      if Assigned(dbcm_Seans.ListSource.DataSet) then
      begin
        dbcm_Seans.ListSource.DataSet.Active := true;
        dbcm_Seans.ListSource.DataSet.Last;
        dbcm_Seans.ListSource.DataSet.First;
      end;
    //
    if Assigned(dbcm_Film.ListSource) then
      if Assigned(dbcm_Film.ListSource.DataSet) then
      begin
        dbcm_Film.ListSource.DataSet.Active := true;
        dbcm_Film.ListSource.DataSet.Last;
        dbcm_Film.ListSource.DataSet.First;
      end;
    //
    if Assigned(dbcm_Tariff.ListSource) then
      if Assigned(dbcm_Tariff.ListSource.DataSet) then
      begin
        dbcm_Tariff.ListSource.DataSet.Active := true;
        dbcm_Tariff.ListSource.DataSet.Last;
        dbcm_Tariff.ListSource.DataSet.First;
      end;
  finally
    Screen.Cursor := OldCursor;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Repert.FormClose(Sender: TObject; var Action: TCloseAction);
const
  ProcName: string = 'FormClose';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  if Assigned(dbcm_Seans.ListSource) then
    if Assigned(dbcm_Seans.ListSource.DataSet) then
      dbcm_Seans.ListSource.DataSet.Active := FSeansActive;
  //
  if Assigned(dbcm_Film.ListSource) then
    if Assigned(dbcm_Film.ListSource.DataSet) then
      dbcm_Film.ListSource.DataSet.Active := FFilmActive;
  //
  if Assigned(dbcm_Tariff.ListSource) then
    if Assigned(dbcm_Tariff.ListSource.DataSet) then
      dbcm_Tariff.ListSource.DataSet.Active := FTariffActive;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Repert.dbcm_Date_Or_Zal_Change(Sender: TObject);
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
      // dm_Base.ds_Repert
      DisableControls;
      // chb_FiltrateZal.Enabled := false;
      // chb_FiltrateDate.Enabled := false;
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
          if Assigned(Params.FindParam(s_IN_FILT_REPERT_ODEUM)) then
            ParamByName(s_IN_FILT_REPERT_ODEUM).AsInteger := index;
          if Assigned(Params.FindParam(s_IN_FILT_REPERT_DATE)) then
            ParamByName(s_IN_FILT_REPERT_DATE).AsDate := dtp_Date_Filt.Date;
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
                  if Assigned(Params.FindParam(s_IN_FILT_REPERT_ODEUM)) then
                    ParamByName(s_IN_FILT_REPERT_ODEUM).AsInteger := -1;
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
      // chb_FiltrateZal.Enabled := true;
      // chb_FiltrateDate.Enabled := true;
      EnableControls;
    end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Repert.FormCreate(Sender: TObject);
const
  ProcName: string = 'FormCreate';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  FNotYetActivated := true;
  FSeansActive := false;
  FFilmActive := false;
  FTariffActive := false;
  // --------------------------------------------------------------------------
  if Assigned(dbcm_Seans.ListSource) then
    if Assigned(dbcm_Seans.ListSource.DataSet) then
      FSeansActive := dbcm_Seans.ListSource.DataSet.Active;
  // --------------------------------------------------------------------------
  if Assigned(dbcm_Film.ListSource) then
    if Assigned(dbcm_Film.ListSource.DataSet) then
      FFilmActive := dbcm_Film.ListSource.DataSet.Active;
  // --------------------------------------------------------------------------
  if Assigned(dbcm_Tariff.ListSource) then
    if Assigned(dbcm_Tariff.ListSource.DataSet) then
      FTariffActive := dbcm_Tariff.ListSource.DataSet.Active;
  // --------------------------------------------------------------------------
  if cmb_FiltrateDate.Items.Count > 0 then
    cmb_FiltrateDate.ItemIndex := 0;
  if cmb_FiltrateZal.Items.Count > 0 then
    cmb_FiltrateZal.ItemIndex := 0;
  // --------------------------------------------------------------------------
  dtp_Date_Filt.Date := pm_Repert_Date;
  // --------------------------------------------------------------------------
  FOnDataChangeOldEv := nil;
  FAfterInsertOldEv := nil;
  FBeforePostOldEv := nil;
  if Assigned(dbgr_Data.DataSource) then
    with dbgr_Data.DataSource do
    begin
      if Assigned(OnDataChange) then
        FOnDataChangeOldEv := OnDataChange;
      OnDataChange := Repert_OnDataChange;
      DEBUGMessEnh(0, UnitName, ProcName, 'DataSource events hooked.');
      if Assigned(DataSet) then
        with DataSet do
        begin
          // dm_Base.ds_Repert
          if Assigned(OnNewRecord) then
            FAfterInsertOldEv := AfterInsert;
          AfterInsert := Repert_AfterInsert;
          if Assigned(BeforePost) then
            FBeforePostOldEv := BeforePost;
          BeforePost := Repert_BeforePost;
          DEBUGMessEnh(0, UnitName, ProcName, 'DataSet events hooked.');
        end;
      Repert_OnDataChange(nil, nil);
    end;
  // --------------------------------------------------------------------------
  // dbcm_Film.DropDownWidth := (dbcm_Film.Width * 3) div 2;
  dbcm_Tariff.DropDownWidth := (dbcm_Tariff.Width * 2);
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Repert.Repert_OnDataChange(Sender: TObject; Field: TField);
const
  ProcName: string = 'Repert_OnDataChange';
var
  dsrc_Data_DS, dsrc_Lookup_DS: TpFIBDataSet;
  new_kod, old_kod, new_ver, old_ver: Variant;
begin
  // DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  bt_Film_Last.Enabled := false;
  bt_Tariff_Last.Enabled := false;
  if DatasetActive = 1 then
  begin
    if (dsrc_Data.Dataset is TpFIBDataSet) then
    begin
      old_kod := 0;
      old_ver := 0;
      new_kod := 0;
      new_ver := 0;
      // dm_Base.ds_Repert
      dsrc_Data_DS := (dsrc_Data.Dataset as TpFIBDataSet);
      if dsrc_Data_DS.State in [{dsEdit, dsInsert, }dsBrowse] then
      begin
        // --------------------------------------------------------------------------
        if Assigned(dsrc_Lookup_Film.Dataset) and (dsrc_Lookup_Film.Dataset is TpFIBDataSet) then
        begin
          // dm_Base.ds_Film
          dsrc_Lookup_DS := (dsrc_Lookup_Film.Dataset as TpFIBDataSet);
          if dsrc_Lookup_DS.Active and (dsrc_Lookup_DS.State in [dsBrowse])
            and Assigned(dsrc_Data_DS.FN(s_REPERT_FILM_KOD))
            and Assigned(dsrc_Data_DS.FN(s_REPERT_FILM_VER))
            and Assigned(dsrc_Lookup_DS.FN(s_FILM_KOD))
            and Assigned(dsrc_Lookup_DS.FN(s_FILM_VER)) then
          begin
            try
              old_kod := dsrc_Data_DS.FN(s_REPERT_FILM_KOD).AsVariant;
              old_ver := dsrc_Data_DS.FN(s_REPERT_FILM_VER).AsVariant;
              new_kod := dsrc_Lookup_DS.FN(s_FILM_KOD).AsVariant;
              new_ver := dsrc_Lookup_DS.FN(s_FILM_VER).AsVariant;
              if (Length(dbcm_Film.Text) > 0) and ((new_kod <> old_kod) or (new_ver <> old_ver))
                then
                bt_Film_Last.Enabled := true;
            finally
              old_kod := 0;
              old_ver := 0;
              new_kod := 0;
              new_ver := 0;
            end;
          end;
        end;
        // --------------------------------------------------------------------------
        if Assigned(dsrc_Lookup_Tariff.Dataset) and (dsrc_Lookup_Tariff.Dataset is TpFIBDataSet)
          then
        begin
          // dm_Base.ds_Tariff
          dsrc_Lookup_DS := (dsrc_Lookup_Tariff.Dataset as TpFIBDataSet);
          if dsrc_Lookup_DS.Active and (dsrc_Lookup_DS.State in [dsBrowse])
            and Assigned(dsrc_Data_DS.FN(s_REPERT_TARIFF_KOD))
            and Assigned(dsrc_Data_DS.FN(s_REPERT_TARIFF_VER))
            and Assigned(dsrc_Lookup_DS.FN(s_TARIFF_KOD))
            and Assigned(dsrc_Lookup_DS.FN(s_TARIFF_VER)) then
          begin
            try
              old_kod := dsrc_Data_DS.FN(s_REPERT_TARIFF_KOD).AsVariant;
              old_ver := dsrc_Data_DS.FN(s_REPERT_TARIFF_VER).AsVariant;
              new_kod := dsrc_Lookup_DS.FN(s_TARIFF_KOD).AsVariant;
              new_ver := dsrc_Lookup_DS.FN(s_TARIFF_VER).AsVariant;
              if (Length(dbcm_Tariff.Text) > 0) and ((new_kod <> old_kod) or (new_ver <> old_ver))
                then
                bt_Tariff_Last.Enabled := true;
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

procedure Tfm_Repert.Repert_AfterInsert(DataSet: TDataSet);
const
  ProcName: string = 'Repert_AfterInsert';
var
  index: integer;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  if Assigned(dsrc_Data.Dataset) and (dsrc_Data.Dataset is TpFIBDataSet) then
    with (dsrc_Data.Dataset as TpFIBDataSet) do
    begin
      // dm_Base.ds_Repert
      if Assigned(FN(s_REPERT_DATE)) then
        FN(s_REPERT_DATE).AsDateTime := dtp_Date_Filt.Date;
      if Assigned(FN(s_REPERT_ODEUM_KOD)) then
      begin
        try
          index := Integer(dbcm_Zal.Items.Objects[dbcm_Zal.ItemIndex]);
        except
          index := 0;
        end;
        FN(s_REPERT_ODEUM_KOD).AsInteger := index;
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

procedure Tfm_Repert.Repert_BeforePost(DataSet: TDataSet);
const
  ProcName: string = 'Repert_BeforePost';
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
      // dm_Base.ds_Repert
      if Assigned(FN(s_REPERT_ODEUM_KOD)) and Assigned(FN(s_REPERT_ODEUM_VER)) then
      begin
        try
          new_kod := FN(s_REPERT_ODEUM_KOD).NewValue;
          old_kod := FN(s_REPERT_ODEUM_KOD).OldValue;
          if new_kod <> old_kod then
            FN(s_REPERT_ODEUM_VER).AsVariant := Null;
        finally
          new_kod := 0;
          old_kod := 0;
        end;
      end;
      if Assigned(FN(s_REPERT_SEANS_KOD)) and Assigned(FN(s_REPERT_SEANS_VER)) then
      begin
        try
          new_kod := FN(s_REPERT_SEANS_KOD).NewValue;
          old_kod := FN(s_REPERT_SEANS_KOD).OldValue;
          if new_kod <> old_kod then
            FN(s_REPERT_SEANS_VER).AsVariant := Null;
        finally
          new_kod := 0;
          old_kod := 0;
        end;
      end;
      if Assigned(FN(s_REPERT_FILM_KOD)) and Assigned(FN(s_REPERT_FILM_VER)) then
      begin
        try
          new_kod := FN(s_REPERT_FILM_KOD).NewValue;
          old_kod := FN(s_REPERT_FILM_KOD).OldValue;
          if new_kod <> old_kod then
            FN(s_REPERT_FILM_VER).AsVariant := Null;
        finally
          new_kod := 0;
          old_kod := 0;
        end;
      end;
      if Assigned(FN(s_REPERT_TARIFF_KOD)) and Assigned(FN(s_REPERT_TARIFF_VER)) then
      begin
        try
          new_kod := FN(s_REPERT_TARIFF_KOD).NewValue;
          old_kod := FN(s_REPERT_TARIFF_KOD).OldValue;
          if new_kod <> old_kod then
            FN(s_REPERT_TARIFF_VER).AsVariant := Null;
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

procedure Tfm_Repert.FormDestroy(Sender: TObject);
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
          // dm_Base.ds_Repert
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

procedure Tfm_Repert.bt_SeansClick(Sender: TObject);
begin
  //
  acSeansShowModal(nil);
  FormActivate(nil);
end;

procedure Tfm_Repert.bt_FilmClick(Sender: TObject);
begin
  //
  acFilmShowModal(-1);
  FormActivate(nil);
end;

procedure Tfm_Repert.bt_Film_LastClick(Sender: TObject);
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
      // dm_Base.ds_Film
      if Assigned(FN(s_REPERT_FILM_KOD)) and Assigned(FN(s_REPERT_FILM_VER)) then
      begin
        try
          if State in [dsBrowse] then
            Edit;
          new_kod := FN(s_REPERT_FILM_KOD).NewValue;
          new_ver := FN(s_REPERT_FILM_VER).NewValue;
          old_kod := FN(s_REPERT_FILM_KOD).OldValue;
          old_ver := FN(s_REPERT_FILM_VER).OldValue;
          // if (new_kod <> old_kod) then
          FN(s_REPERT_FILM_VER).AsVariant := Null;
        finally
        end;
      end;
    end;
end;

procedure Tfm_Repert.bt_TariffClick(Sender: TObject);
const
  ProcName: string = 'bt_TariffClick';
var
  tmp_Repert_Tariff_Kod: Integer;
  // tmp_Repert_Tariff_Ver: Integer;
begin
  //
  tmp_Repert_Tariff_Kod := -1;
  // tmp_Repert_Tariff_Ver := -1;
  if Assigned(dsrc_Data.Dataset) and (dsrc_Data.Dataset is TpFIBDataSet) then
    with (dsrc_Data.Dataset as TpFIBDataSet) do
    begin
      // dm_Base.ds_Tariff
      if Assigned(FieldByName(s_REPERT_TARIFF_KOD))
        {and Assigned(FieldByName(s_REPERT_TARIFF_VER)) }then
      begin
        try
          if Active then
            if (State in [dsBrowse]) then
            begin
              tmp_Repert_Tariff_Kod := FieldByName(s_REPERT_TARIFF_KOD).AsInteger;
              // tmp_Repert_Tariff_Ver := FieldByName(s_REPERT_TARIFF_VER).AsInteger;
            end
            else if (State in [dsEdit, dsInsert]) then
            begin
              tmp_Repert_Tariff_Kod := FieldByName(s_REPERT_TARIFF_KOD).NewValue;
              // tmp_Repert_Tariff_Ver := FieldByName(s_REPERT_TARIFF_VER).NewValue;
            end;
        finally
          DEBUGMessEnh(0, UnitName, ProcName, s_REPERT_TARIFF_KOD + ' = '
            + IntToStr(tmp_Repert_Tariff_Kod));
        end;
      end;
    end; // with
  acCostShowModal(tmp_Repert_Tariff_Kod);
  FormActivate(nil);
end;

procedure Tfm_Repert.bt_Tariff_LastClick(Sender: TObject);
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
      // dm_Base.ds_Film
      if Assigned(FN(s_REPERT_TARIFF_KOD)) and Assigned(FN(s_REPERT_TARIFF_VER)) then
      begin
        try
          if State in [dsBrowse] then
            Edit;
          new_kod := FN(s_REPERT_TARIFF_KOD).NewValue;
          new_ver := FN(s_REPERT_TARIFF_VER).NewValue;
          old_kod := FN(s_REPERT_TARIFF_KOD).OldValue;
          old_ver := FN(s_REPERT_TARIFF_VER).OldValue;
          // if (new_kod <> old_kod) then
          FN(s_REPERT_TARIFF_VER).AsVariant := Null;
        finally
        end;
      end;
    end;
end;

procedure Tfm_Repert.sb_UpClick(Sender: TObject);
begin
  if dtp_Date_Filt.Enabled then
  begin
    dtp_Date_Filt.Date := dtp_Date_Filt.Date + 1;
    dtp_Date_Filt.OnChange(Self);
  end;
end;

procedure Tfm_Repert.sb_DownClick(Sender: TObject);
begin
  if dtp_Date_Filt.Enabled then
  begin
    dtp_Date_Filt.Date := dtp_Date_Filt.Date - 1;
    dtp_Date_Filt.OnChange(Self);
  end;
end;

procedure Tfm_Repert.sb_TodayClick(Sender: TObject);
begin
  if dtp_Date_Filt.Enabled then
  begin
    dtp_Date_Filt.Date := Now;
    dtp_Date_Filt.OnChange(Self);
  end;
end;

procedure Tfm_Repert.Activate_After_Once(Sender: TObject);
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

