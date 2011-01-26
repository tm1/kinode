{-----------------------------------------------------------------------------
 Unit Name: ufFilm
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  30.12.2002
 Purpose:   Edit Form (ds_Film)
 History:
-----------------------------------------------------------------------------}
unit ufFilm;

interface

{$I kinode01.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Grids, DBGrids, ExtCtrls, Spin, StdCtrls, DBCtrls, Mask, Buttons,
  ExtDlgs, ufDted, WcBitBtn;

type
  Tfm_Film = class(Tfm_Dted)
    bt_AddRec: TBitBtn;
    bt_Cancel: TBitBtn;
    bt_DeleteRec: TBitBtn;
    bt_EditRec: TBitBtn;
    dbed_BASE_NAM: TDBEdit;
    dbgr_Data: TDBGrid;
    dbtx_BASE_KOD: TDBText;
    dsrc_Data: TDataSource;
    lbl_1st: TLabel;
    lbl_Kod: TLabel;
    gb_Edit: TGroupBox;
    pn_Top: TPanel;
    lbl_Genre: TLabel;
    bt_Genre: TWc_BitBtn;
    dbcm_Genre: TDBLookupComboBox;
    dsrc_Lookup: TDataSource;
    bt_Refresh: TBitBtn;
    dbed_Year: TDBEdit;
    lbl_Year: TLabel;
    dbed_Length: TDBEdit;
    lbl_Length: TLabel;
    dbme_Comment: TDBMemo;
    lbl_Comment: TLabel;
    pn_Bottom: TPanel;
    pn_Close: TPanel;
    bt_Close: TBitBtn;
    bt_Genre_Last: TWc_BitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Film_OnDataChange(Sender: TObject; Field: TField);
    procedure Film_OnNewRecord(DataSet: TDataSet);
    procedure Film_BeforePost(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
    procedure bt_GenreClick(Sender: TObject);
    procedure bt_Genre_LastClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Activate_After_Once(Sender: TObject);
  private
    { Private declarations }
    FGenreActive: Boolean;
    FOnNewRecordOldEv: TDataSetNotifyEvent;
    FBeforePostOldEv: TDataSetNotifyEvent;
    FOnDataChangeOldEv: TDataChangeEvent;
  public
    { Public declarations }
  end;

procedure acFilmShowModal(v_Film_Kod: Integer);

var
  fm_Film: Tfm_Film;
  pm_Film_Kod: Integer;

implementation

uses
  Bugger, udBase, ufGenre, urCommon, StrConsts, pFIBDataSet;

{$R *.DFM}

const
  UnitName: string = 'ufFilm';

procedure acFilmShowModal(v_Film_Kod: Integer);
const
  ProcName: string = 'acFilmShowModal';
begin
  // --------------------------------------------------------------------------
  // Справочник фильмов
  // --------------------------------------------------------------------------
  DEBUGMessBrk(1, ')   >>> [' + UnitName + '::' + ProcName + '] >>>   (');
  // DEBUGMessEnh(1, UnitName, ProcName, '->');
  try
    pm_Film_Kod := v_Film_Kod;
    Application.CreateForm(Tfm_Film, fm_Film);
    DEBUGMessEnh(0, UnitName, ProcName, fm_Film.Name + '.ShowModal');
    fm_Film.ShowModal;
  finally
    fm_Film.Free;
    fm_Film := nil;
  end;
  // --------------------------------------------------------------------------
  // DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  DEBUGMessBrk(-1, ')   <<< [' + UnitName + '::' + ProcName + '] <<<   (');
end;

procedure Tfm_Film.FormActivate(Sender: TObject);
const
  ProcName: string = 'FormActivate';
var
  OldCursor: TCursor;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  OldCursor := Screen.Cursor;
  try
    Screen.Cursor := crSQLWait;
    if Assigned(dbcm_Genre.ListSource) then
      if Assigned(dbcm_Genre.ListSource.DataSet) then
      begin
        dbcm_Genre.ListSource.DataSet.Close;
        dbcm_Genre.ListSource.DataSet.Open;
        dbcm_Genre.ListSource.DataSet.Last;
        dbcm_Genre.ListSource.DataSet.First;
      end;
  finally
    Screen.Cursor := OldCursor;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Film.FormCreate(Sender: TObject);
const
  ProcName: string = 'FormCreate';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  FGenreActive := false;
  if Assigned(dbcm_Genre.ListSource) then
    if Assigned(dbcm_Genre.ListSource.DataSet) then
      FGenreActive := dbcm_Genre.ListSource.DataSet.Active;
  // --------------------------------------------------------------------------
  FOnDataChangeOldEv := nil;
  FOnNewRecordOldEv := nil;
  FBeforePostOldEv := nil;
  if Assigned(dbgr_Data.DataSource) then
    with dbgr_Data.DataSource do
    begin
      if Assigned(OnDataChange) then
        FOnDataChangeOldEv := OnDataChange;
      OnDataChange := Film_OnDataChange;
      DEBUGMessEnh(0, UnitName, ProcName, 'DataSource events hooked.');
      if Assigned(DataSet) then
        with DataSet do
        begin
          // dm_Base.ds_Film
          if Assigned(OnNewRecord) then
            FOnNewRecordOldEv := OnNewRecord;
          OnNewRecord := Film_OnNewRecord;
          if Assigned(BeforePost) then
            FBeforePostOldEv := BeforePost;
          BeforePost := Film_BeforePost;
          DEBUGMessEnh(0, UnitName, ProcName, 'DataSet events hooked.');
        end;
      Film_OnDataChange(nil, nil);
    end;
  // --------------------------------------------------------------------------
  dbcm_Genre.DropDownWidth := (dbcm_Genre.Width * 3) div 2;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Film.Film_OnDataChange(Sender: TObject; Field: TField);
const
  ProcName: string = 'Film_OnDataChange';
var
  dsrc_Data_DS, dsrc_Lookup_DS: TpFIBDataSet;
  new_kod, old_kod, new_ver, old_ver: Variant;
begin
  // DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  bt_Genre_Last.Enabled := false;
  if DatasetActive = 1 then
  begin
    if (dsrc_Data.Dataset is TpFIBDataSet) then
    begin
      old_kod := 0;
      old_ver := 0;
      new_kod := 0;
      new_ver := 0;
      // dm_Base.ds_Film
      dsrc_Data_DS := (dsrc_Data.Dataset as TpFIBDataSet);
      if dsrc_Data_DS.State in [{dsEdit, dsInsert, }dsBrowse] then
      begin
        // --------------------------------------------------------------------------
        if Assigned(dsrc_Lookup.Dataset) and (dsrc_Lookup.Dataset is TpFIBDataSet) then
        begin
          // dm_Base.ds_Genre
          dsrc_Lookup_DS := (dsrc_Lookup.Dataset as TpFIBDataSet);
          if dsrc_Lookup_DS.Active and (dsrc_Lookup_DS.State in [dsBrowse])
            and Assigned(dsrc_Data_DS.FN(s_FILM_GENRE_KOD))
            and Assigned(dsrc_Data_DS.FN(s_FILM_GENRE_VER))
            and Assigned(dsrc_Lookup_DS.FN(s_GENRE_KOD))
            and Assigned(dsrc_Lookup_DS.FN(s_GENRE_VER)) then
          begin
            try
              old_kod := dsrc_Data_DS.FN(s_FILM_GENRE_KOD).AsVariant;
              old_ver := dsrc_Data_DS.FN(s_FILM_GENRE_VER).AsVariant;
              new_kod := dsrc_Lookup_DS.FN(s_GENRE_KOD).AsVariant;
              new_ver := dsrc_Lookup_DS.FN(s_GENRE_VER).AsVariant;
              if (Length(dbcm_Genre.Text) > 0) and ((new_kod <> old_kod) or (new_ver <> old_ver)) then
                bt_Genre_Last.Enabled := true;
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

procedure Tfm_Film.Film_OnNewRecord(DataSet: TDataSet);
const
  ProcName: string = 'Film_OnNewRecord';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  if Assigned(dsrc_Data.Dataset) and (dsrc_Data.Dataset is TpFIBDataSet) then
    with (dsrc_Data.Dataset as TpFIBDataSet) do
    begin
      // dm_Base.ds_Film
      if Assigned(FN(s_FILM_RELEASE)) then
      try
        FN(s_FILM_RELEASE).AsString := FormatDateTime('yyyy', Now);
      except
        FN(s_FILM_RELEASE).AsInteger := 1990;
      end;
      if Assigned(FN(s_FILM_SCREENTIME)) then
      begin
        FN(s_FILM_SCREENTIME).AsInteger := 96;
      end;
      if Assigned(FN(s_FILM_COMMENT)) then
      begin
        FN(s_FILM_COMMENT).AsString := 'Режиссер: ---' + c_CRLF +
          'В ролях: ---, ---, ---' + c_CRLF + 'Сценарий: ---';
      end;
    end;
  if Assigned(FOnNewRecordOldEv) then
  try
    FOnNewRecordOldEv(DataSet);
  except
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Film.Film_BeforePost(DataSet: TDataSet);
const
  ProcName: string = 'Film_BeforePost';
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
      // dm_Base.ds_Film
      if Assigned(FN(s_FILM_GENRE_KOD)) and Assigned(FN(s_FILM_GENRE_VER)) then
      begin
        try
          new_kod := FN(s_FILM_GENRE_KOD).NewValue;
          old_kod := FN(s_FILM_GENRE_KOD).OldValue;
          if (new_kod <> old_kod) then
            FN(s_FILM_GENRE_VER).AsVariant := Null;
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

procedure Tfm_Film.FormDestroy(Sender: TObject);
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
          // dm_Base.ds_Film
          if Assigned(FBeforePostOldEv) then
            BeforePost := FBeforePostOldEv
          else
            BeforePost := nil;
          if Assigned(FOnNewRecordOldEv) then
            OnNewRecord := FOnNewRecordOldEv
          else
            OnNewRecord := nil;
        end;
    end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Film.bt_GenreClick(Sender: TObject);
begin
  //
  acGenreShowModal(nil);
  FormActivate(nil);
end;

procedure Tfm_Film.bt_Genre_LastClick(Sender: TObject);
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
      if Assigned(FN(s_FILM_GENRE_KOD)) and Assigned(FN(s_FILM_GENRE_VER)) then
      begin
        try
          if State in [dsBrowse] then
            Edit;
          new_kod := FN(s_FILM_GENRE_KOD).NewValue;
          new_ver := FN(s_FILM_GENRE_VER).NewValue;
          old_kod := FN(s_FILM_GENRE_KOD).OldValue;
          old_ver := FN(s_FILM_GENRE_VER).OldValue;
          // if (new_kod <> old_kod) then
          FN(s_FILM_GENRE_VER).AsVariant := Null;
        finally
        end;
      end;
    end;
end;

procedure Tfm_Film.FormClose(Sender: TObject; var Action: TCloseAction);
const
  ProcName: string = 'FormClose';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  if Assigned(dbcm_Genre.ListSource) then
    if Assigned(dbcm_Genre.ListSource.DataSet) then
      dbcm_Genre.ListSource.DataSet.Active := FGenreActive;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Film.Activate_After_Once(Sender: TObject);
const
  ProcName: string = 'Activate_After_Once';
begin
  // --------------------------------------------------------------------------
  if pm_Film_Kod > -1 then
  begin
    if Assigned(dsrc_Data.Dataset) and (dsrc_Data.Dataset is TpFIBDataSet) then
      with (dsrc_Data.Dataset as TpFIBDataSet) do
        if Active and Assigned(FieldByName(s_FILM_KOD)) then
        begin
          try
            First;
            Locate(s_FILM_KOD, pm_Film_Kod, []);
          except
            on E: Exception do
            begin
              DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
              DEBUGMessEnh(0, UnitName, ProcName, Name + '.Locate failed.');
            end;
          end;
        end;
  end; // if
  // --------------------------------------------------------------------------
end;

end.

