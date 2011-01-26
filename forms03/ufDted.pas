{-----------------------------------------------------------------------------
 Unit Name: ufDted
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  30.12.2002
 Purpose:   Edit Form (ds_...)
 History:
-----------------------------------------------------------------------------}
unit ufDted;

interface

{$I kinode01.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Grids, DBGrids, ExtCtrls, Spin, StdCtrls, DBCtrls, Mask, Buttons,
  ExtDlgs, pFIBDataSet, SLForms, ActnList, ImgList, ComCtrls;

resourcestring
  // -------------------------------------------------------------------------
  Mess_OnAppend_1 =
    'Добавлять можно только в режиме просмотра (не редактирования).';
  Mess_OnDelete_1 =
    'Удалять можно только в режиме просмотра (не редактирования).';
  Mess_OnDelete_2 = 'Точно хотите удалить ? Потом будет поздно ...';
  Mess_OnPost_1 =
    'Сохранять изменения можно только после редактирования или добавления.';
  Mess_OnCancel_1 =
    'Отменять изменения можно только после редактирования или добавления.';
  Mess_OnEdit_1 =
    'Изменять можно только в режиме редактирования или добавления.';
  Mess_OnClose_1 =
    'Сначала перейдите из режима редактирования или добавления в режим просмотра.';
  Mess_OnClose_2 = 'Сохранить сделанные изменения на сервере?';
  Mess_OnRefresh_1 = 'Подтвердить сделанные изменения и обновить данные?';
  // -------------------------------------------------------------------------
  s_AddRec_Name = 'bt_AddRec';
  s_Cancel_Name = 'bt_Cancel';
  s_Close_Name = 'bt_Close';
  s_DeleteRec_Name = 'bt_DeleteRec';
  s_EditRec_Name = 'bt_EditRec';
  s_Refresh_Name = 'bt_Refresh';
  s_Reposition_Name = 'pn_Bottom';
  s_dbgr_Data_Name = 'dbgr_Data';
  s_dbtx_BASE_KOD = 'dbtx_BASE_KOD';
  s_dbed_BASE_NAM_Name = 'dbed_BASE_NAM';

type
  Tfm_Dted = class(TSLForm)
    DTActionList: TActionList;
    DTRefresh: TAction;
    DTAddRec: TAction;
    DTDeleteRec: TAction;
    DTEditRec: TAction;
    DTCancel: TAction;
    DTExit: TAction;
    DTImageList: TImageList;
    DTAltExit: TAction;
    DTStatusBar: TStatusBar;
    procedure bt_AddRecClick(Sender: TObject);
    procedure bt_CancelClick(Sender: TObject);
    procedure bt_CloseClick(Sender: TObject);
    procedure bt_DeleteRecClick(Sender: TObject);
    procedure bt_EditRecClick(Sender: TObject);
    procedure bt_RefreshClick(Sender: TObject);
    procedure dbgr_DataDblClick(Sender: TObject);
    procedure dbgr_DataKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgr_DataKeyPress(Sender: TObject; var Key: Char);
    procedure dsrc_DataDataChange(Sender: TObject; Field: TField);
    procedure dsrc_DataStateChange(Sender: TObject);
    procedure dbed_DataKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbed_KeyPress(Sender: TObject; var Key: Char);
    procedure fm_Activate(Sender: TObject);
    procedure fm_CloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure fm_KeyPress(Sender: TObject; var Key: Char);
    procedure fm_Create_After;
    procedure fm_Destroy_Before;
    procedure fm_OnMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure DTAddRecExecute(Sender: TObject);
    procedure DTDeleteRecExecute(Sender: TObject);
    procedure DTEditRecExecute(Sender: TObject);
    procedure DTCancelExecute(Sender: TObject);
    procedure DTStatusBarClick(Sender: TObject);
  private
    { Private declarations }
    FFirstTimeActivated: Boolean;
    dbgr_Data: TDBGrid;
    FDatasetActiveState: Boolean;
    FOnStateChangeSave: TNotifyEvent;
    FOnDataChangeSave: TDataChangeEvent;
    FDatasetEditEnabled: boolean;
    FOnActivateSave: TNotifyEvent;
    FOnCloseQuerySave: TCloseQueryEvent;
    FOnKeyPressSave: TKeyPressEvent;
    FOnMouseWheelSave: TMouseWheelEvent;
    function GetDatasetActive: integer;
    procedure SetDatasetEditEnabled(const Value: boolean);
  protected
    procedure DoCreate; override;
    procedure DoDestroy; override;
  public
    { Public declarations }
    function SetDTStatus(PanelIndex: Integer; StatusText: string): Boolean;
    property DatasetActive: integer read GetDatasetActive;
    property DatasetEditEnabled: boolean read FDatasetEditEnabled write
      SetDatasetEditEnabled default true;
  end;

var
  fm_Dted: Tfm_Dted;

implementation

uses
  Bugger, StrConsts, urCommon, uTools;

{$R *.DFM}

const
  UnitName: string = 'ufDted';

procedure ConvertCoords(C1, C2: TControl; P1: TPoint; var P2: TPoint);
begin
  p2 := p1;
  if (c1 is TControl) then
    p2 := (c1 as TControl).ClientToScreen(p1);
  if (c2 is TControl) then
    p2 := (c2 as TControl).ScreenToClient(p2);
end;

function Tfm_Dted.GetDatasetActive: integer;
begin
  Result := -1;
  if Assigned(dbgr_Data) then
  begin
    Result := -2;
    if Assigned(dbgr_Data.DataSource) then
    begin
      Result := -3;
      if Assigned(dbgr_Data.DataSource.DataSet) then
      begin
        Result := 0;
        if dbgr_Data.DataSource.DataSet.Active then
          Result := 1;
      end;
    end;
  end;
end;

procedure Tfm_Dted.SetDatasetEditEnabled(const Value: boolean);
begin
  if FDatasetEditEnabled <> Value then
  begin
    FDatasetEditEnabled := Value;
  end;
end;

procedure Tfm_Dted.bt_AddRecClick(Sender: TObject);
const
  ProcName: string = 'bt_AddRecClick';
begin
  if DatasetActive = 1 then
  begin
    if dbgr_Data.DataSource.DataSet.State in [dsBrowse] then
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'DataSet.Insert - (' +
        dbgr_Data.DataSource.DataSet.Name + ')');
      dbgr_DataDblClick(nil);
      try
        dbgr_Data.DataSource.DataSet.Insert;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Error inserting record.');
          ShowMessage('Не получается вставить запись. Попробуйте еще разок.' +
            c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF +
            E.Message + c_CRLF + c_Separator_20);
        end;
      end;
    end
    else
      ShowMessage(Mess_OnAppend_1);
  end;
end;

procedure Tfm_Dted.bt_CancelClick(Sender: TObject);
const
  ProcName: string = 'bt_CancelClick';
begin
  if DatasetActive = 1 then
  begin
    if dbgr_Data.DataSource.DataSet.State in [dsEdit, dsInsert] then
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'DataSet.Cancel - (' +
        dbgr_Data.DataSource.DataSet.Name + ')');
      try
        dbgr_Data.DataSource.DataSet.Cancel;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Error canceling changes.');
          ShowMessage('Не получается отменить изменения. Попробуйте еще разок.'
            + c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF
            + E.Message + c_CRLF + c_Separator_20);
        end;
      end;
      if Assigned(dbgr_Data) then
        if dbgr_Data.Enabled then
          dbgr_Data.SetFocus;
    end
    else
      ShowMessage(Mess_OnCancel_1);
  end;
end;

procedure Tfm_Dted.bt_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure Tfm_Dted.bt_DeleteRecClick(Sender: TObject);
const
  ProcName: string = 'bt_DeleteRecClick';
begin
  if DatasetActive = 1 then
  begin
    if dbgr_Data.DataSource.DataSet.State in [dsBrowse] then
    begin
      if MessageDlg(Mess_OnDelete_2, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'DataSet.Delete - (' +
          dbgr_Data.DataSource.DataSet.Name + ')');
        try
          dbgr_Data.DataSource.DataSet.Delete;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, 'Error deleting record.');
            ShowMessage('Не получается удалить запись. Наверное она где-то используется.'
              + c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF
              + E.Message + c_CRLF + c_Separator_20);
          end;
        end;
      end;
    end
    else
      ShowMessage(Mess_OnDelete_1);
  end;
end;

procedure Tfm_Dted.bt_EditRecClick(Sender: TObject);
const
  ProcName: string = 'bt_EditRecClick';
begin
  if DatasetActive = 1 then
  begin
    if dbgr_Data.DataSource.DataSet.State in [dsEdit, dsInsert] then
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'DataSet.Post - (' +
        dbgr_Data.DataSource.DataSet.Name + ')');
      try
        dbgr_Data.DataSource.DataSet.Post;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Error posting changes.');
          ShowMessage('Не получается сохранить измененную запись. Попробуйте еще разок.'
            + c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF
            + E.Message + c_CRLF + c_Separator_20);
        end;
      end;
      if Assigned(dbgr_Data) then
        if dbgr_Data.Enabled then
          dbgr_Data.SetFocus;
    end
    else
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'DataSet.Edit - (' +
        dbgr_Data.DataSource.DataSet.Name + ')');
      try
        dbgr_Data.DataSource.DataSet.Edit;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Error going to edit mode.');
          ShowMessage('Не получается изменить запись. Попробуйте еще разок.' +
            c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF +
            E.Message + c_CRLF + c_Separator_20);
        end;
      end;
      dbgr_DataDblClick(nil);
    end;
  end;
end;

procedure Tfm_Dted.bt_RefreshClick(Sender: TObject);
const
  ProcName: string = 'bt_RefreshClick';
var
  Comp: TComponent;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  Comp := Self.FindComponent(s_Refresh_Name);
  if Assigned(Comp) then
    if (Comp is TButton) then
    begin
      (Comp as TButton).Enabled := false;
    end;
  //
  try
    if DatasetActive = 1 then
    begin
      if dbgr_Data.DataSource.DataSet.State in [dsEdit, dsInsert] then
        if MessageDlg(Mess_OnRefresh_1, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'DataSet.Post - (' +
            dbgr_Data.DataSource.DataSet.Name + ')');
          try
            dbgr_Data.DataSource.DataSet.Post;
          except
            on E: Exception do
            begin
              DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
              DEBUGMessEnh(0, UnitName, ProcName, 'Error posting changes.');
              ShowMessage('Не получается сохранить измененную запись. Попробуйте еще разок.'
                + c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF
                + E.Message + c_CRLF + c_Separator_20);
            end;
          end;
        end
        else
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'DataSet.Cancel - (' +
            dbgr_Data.DataSource.DataSet.Name + ')');
          try
            dbgr_Data.DataSource.DataSet.Cancel;
          except
            on E: Exception do
            begin
              DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
              DEBUGMessEnh(0, UnitName, ProcName, 'Error canceling changes.');
              ShowMessage('Не получается отменить изменения. Попробуйте еще разок.'
                + c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF
                + E.Message + c_CRLF + c_Separator_20);
            end;
          end;
        end;
      // dbgr_Data.DataSource.DataSet.Refresh;
    end;
    {
    if Assigned(FOnActivateSave) then
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Calling FOnActivateSave at [' +
        IntToHex1(Longword(@FOnActivateSave), 8) + ']');
      FOnActivateSave(Sender);
    end
    else
    }
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Calling fm_Activate()');
      fm_Activate(Sender);
    end;
  finally
    if Assigned(Comp) then
      if (Comp is TButton) then
      begin
        (Comp as TButton).Enabled := true;
      end;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Dted.dbgr_DataDblClick(Sender: TObject);
var
  Comp: TComponent;
begin
  Comp := Self.FindComponent(s_dbed_BASE_NAM_Name);
  if Assigned(Comp) then
    if (Comp is TWinControl) then
    begin
      if (Comp as TWinControl).Enabled then
        (Comp as TWinControl).SetFocus;
    end;
end;

procedure Tfm_Dted.dbgr_DataKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Comp: TComponent;
begin
  //
  case Key of
    VK_INSERT, VK_ADD:
      begin
        // bt_AddRecClick(nil);
        Comp := Self.FindComponent(s_AddRec_Name);
        if Assigned(Comp) then
          if (Comp is TButton) then
          begin
            (Comp as TButton).Click;
          end;
      end;
    VK_RETURN:
      begin
        Key := 0;
        dbgr_DataDblClick(nil);
      end;
    VK_DELETE, VK_SUBTRACT:
      begin
        // bt_DeleteRecClick(nil);
        Comp := Self.FindComponent(s_DeleteRec_Name);
        if Assigned(Comp) then
          if (Comp is TButton) then
          begin
            (Comp as TButton).Click;
          end;
      end;
  else
  end;
end;

procedure Tfm_Dted.dbgr_DataKeyPress(Sender: TObject; var Key: Char);
var
  Comp: TComponent;
begin
  //
  if Key = #27 then
  begin
    Key := #0;
    //
    Comp := Self.FindComponent(s_Close_Name);
    if Assigned(Comp) then
      if (Comp is TButton) then
        if (Comp as TButton).Enabled then
          (Comp as TButton).SetFocus;
  end;
end;

procedure Tfm_Dted.dsrc_DataDataChange(Sender: TObject; Field: TField);
const
  ProcName: string = 'dsrc_DataStateChange';
begin
  if (DatasetActive in [0, 1]) then
    SetDTStatus(2, IntToStr(dbgr_Data.DataSource.DataSet.RecordCount))
  else
    SetDTStatus(2, 'unknown');
  if Assigned(FOnDataChangeSave) then
    FOnDataChangeSave(Sender, Field);
end;

procedure Tfm_Dted.dsrc_DataStateChange(Sender: TObject);
const
  ProcName: string = 'dsrc_DataStateChange';
  {
  Value	        Meaning
  ----------------------------------------------------------------------
  dsInactive	Dataset is closed, so its data is unavailable.
  dsBrowse	Data can be viewed, but not changed. This is the default state of an open dataset.
  dsEdit	Active record can be modified.
  dsInsert	The active record is a newly inserted buffer that has not been posted. This record can be modified and then either posted or discarded.
  dsSetKey	TTable and TClientDataSet only. Record searching is enabled, or a SetRange operation is under way. A restricted set of data can be viewed, and no data can be edited or inserted.
  dsCalcFields	An OnCalcFields event is in progress. Noncalculated fields cannot be edited, and new records cannot be inserted.
  dsFilter	An OnFilterRecord event is in progress. A restricted set of data can be viewed. No data can edited or inserted.
  dsNewValue	Temporary state used internally to indicate that a field component’s NewValue property is being accessed.
  dsOldValue	Temporary state used internally to indicate that a field component’s OldValue property is being accessed.
  dsCurValue	Temporary state used internally to indicate that a field component’s CurValue property is being accessed.
  dsBlockRead	Data-aware controls are not updated and events are not triggered when the cursor moves (Next is called).
  dsInternalCalc	Temporary state used internally to indicate that values need to be calculated for a field that has a FieldKind of fkInternalCalc.
  dsOpening	DataSet is in the process of opening but has not finished. This state occurs when the dataset is opened for asynchronous fetching.
  }
  {
  ds_States: array[TDatasetState] of string =
  (
    'Неактивно [dsInactive]',
    'Просмотр [dsBrowse]',
    'Редактирование [dsEdit]',
    'Вставка [dsInsert]',
    '[dsSetKey]',
    '[dsCalcFields]',
    'Фильтруется... [dsFilter]',
    '[dsNewValue]',
    '[dsOldValue]',
    '[dsCurValue]',
    '[dsBlockRead]',
    '[dsInternalCalc]',
    'Открывается... [dsOpening]'
    );
  }
var
  bt_AddRec, bt_DeleteRec, bt_EditRec, bt_Cancel, dbtx_BASE_KOD: TComponent;
begin
  bt_AddRec := Self.FindComponent(s_AddRec_Name);
  bt_DeleteRec := Self.FindComponent(s_DeleteRec_Name);
  bt_EditRec := Self.FindComponent(s_EditRec_Name);
  bt_Cancel := Self.FindComponent(s_Cancel_Name);
  dbtx_BASE_KOD := Self.FindComponent(s_dbtx_BASE_KOD);
  if DatasetActive = 1 then
  begin
    DEBUGMessEnh(0, UnitName, ProcName, 'Name = (' +
      dbgr_Data.DataSource.DataSet.Name + '), State = (' +
      ds_States[dbgr_Data.DataSource.DataSet.State] + ')');
    SetDTStatus(0, ds_States[dbgr_Data.DataSource.DataSet.State]);
    SetDTStatus(2, IntToStr(dbgr_Data.DataSource.DataSet.RecordCount));
    if dbgr_Data.DataSource.DataSet.State in [dsEdit, dsInsert, dsBrowse] then
    begin
      try
        if Assigned(dbtx_BASE_KOD) then
          if (dbtx_BASE_KOD is TDBText) then
            if Assigned((dbtx_BASE_KOD as TDBText).Field) then
              DEBUGMessEnh(0, UnitName, ProcName, 'Field = (' +
                (dbtx_BASE_KOD as TDBText).DataField + '), Value = [' +
                (dbtx_BASE_KOD as TDBText).Field.AsString + ']');
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Reading BASE_KOD control failed.');
        end;
      end;
    end;
    if dbgr_Data.DataSource.DataSet.State in [dsEdit, dsInsert] then
    begin
      if Assigned(bt_AddRec) then
        if (bt_AddRec is TButton) then
          (bt_AddRec as TButton).Enabled := false;
      if Assigned(bt_DeleteRec) then
        if (bt_DeleteRec is TButton) then
          (bt_DeleteRec as TButton).Enabled := false;
      if Assigned(bt_EditRec) then
        if (bt_EditRec is TButton) then
          (bt_EditRec as TButton).Enabled := true;
      if Assigned(bt_Cancel) then
        if (bt_Cancel is TButton) then
          (bt_Cancel as TButton).Enabled := true;
    end
    else
    begin
      if Assigned(bt_AddRec) then
        if (bt_AddRec is TButton) then
          (bt_AddRec as TButton).Enabled := true;
      if Assigned(bt_DeleteRec) then
        if (bt_DeleteRec is TButton) then
          (bt_DeleteRec as TButton).Enabled := true;
      if Assigned(bt_EditRec) then
        if (bt_EditRec is TButton) then
          (bt_EditRec as TButton).Enabled := false;
      if Assigned(bt_Cancel) then
        if (bt_Cancel is TButton) then
          (bt_Cancel as TButton).Enabled := false;
    end;
  end
  else
  begin
    if Assigned(bt_AddRec) then
      if (bt_AddRec is TButton) then
        (bt_AddRec as TButton).Enabled := false;
    if Assigned(bt_DeleteRec) then
      if (bt_DeleteRec is TButton) then
        (bt_DeleteRec as TButton).Enabled := false;
    if Assigned(bt_EditRec) then
      if (bt_EditRec is TButton) then
        (bt_EditRec as TButton).Enabled := false;
    if Assigned(bt_Cancel) then
      if (bt_Cancel is TButton) then
        (bt_Cancel as TButton).Enabled := false;
  end;
  //
  if Assigned(FOnStateChangeSave) then
    FOnStateChangeSave(Sender);
end;

procedure Tfm_Dted.dbed_DataKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Comp: TComponent;
begin
  //
  case Key of
    VK_RETURN:
      begin
        Key := 0;
        //
        Comp := Self.FindComponent(s_EditRec_Name);
        if Assigned(Comp) then
          if (Comp is TButton) then
            if (Comp as TButton).Enabled then
              (Comp as TButton).SetFocus;
      end;
  else
  end;
end;

procedure Tfm_Dted.dbed_KeyPress(Sender: TObject; var Key: Char);
var
  Comp: TComponent;
begin
  if Key = #27 then
  begin
    Key := #0;
    //
    Comp := Self.FindComponent(s_Cancel_Name);
    if Assigned(Comp) then
      if (Comp is TButton) then
        if (Comp as TButton).Enabled then
          (Comp as TButton).SetFocus
        else if Assigned(dbgr_Data) then
          if dbgr_Data.Enabled then
            dbgr_Data.SetFocus;
  end;
end;

procedure Tfm_Dted.fm_Activate(Sender: TObject);
const
  ProcName: string = 'fm_Activate';
var
  OldCursor: TCursor;
  Comp: TComponent;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  if Assigned(FOnActivateSave) then
  begin
    DEBUGMessEnh(0, UnitName, ProcName, 'Calling FOnActivateSave at [' +
      IntToHex1(Longword(@FOnActivateSave), 8) + ']');
    FOnActivateSave(Sender);
  end;
  Update;
  OldCursor := Screen.Cursor;
  try
    if ((DatasetActive = 1) and (not (Self.Tag and 1 = 1))) then
    try
      DEBUGMessEnh(0, UnitName, ProcName, 'Closing dataset...');
      Screen.Cursor := crSQLWait;
      dbgr_Data.DataSource.DataSet.Active := false;
      Screen.Cursor := OldCursor;
    except
      on E: Exception do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
        DEBUGMessEnh(0, UnitName, ProcName, 'Exception during dataset closing.');
        ShowMessage('Не получается закрыть данные.'
          + c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF
          + E.Message + c_CRLF + c_Separator_20);
      end;
    end
    else
      DEBUGMessEnh(0, UnitName, ProcName, 'Dataset close skipped.');
    if (DatasetActive = 0) and (not (Self.Tag and 2 = 2)) then
    try
      DEBUGMessEnh(0, UnitName, ProcName, 'Opening dataset...');
      Screen.Cursor := crSQLWait;
      dbgr_Data.DataSource.DataSet.Active := true;
      Screen.Cursor := OldCursor;
    except
      on E: Exception do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
        DEBUGMessEnh(0, UnitName, ProcName, 'Exception during dataset opening.');
        ShowMessage('Не получается открыть данные.'
          + c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF
          + E.Message + c_CRLF + c_Separator_20);
      end;
      // dbgr_Data.DataSource.DataSet.Active := false;
    end
    else
      DEBUGMessEnh(0, UnitName, ProcName, 'Dataset open skipped.');
  finally
    Screen.Cursor := OldCursor;
  end;
  if Assigned(dbgr_Data) then
    if dbgr_Data.Enabled then
      dbgr_Data.SetFocus;
  //
  if FFirstTimeActivated then
  begin
    Comp := Self.FindComponent(s_Reposition_Name);
    if (Comp is TPanel) and (not (Comp.Tag and 1 = 1)) then
      if Assigned((Comp as TPanel).OnDblClick) then
      begin
        (Comp as TPanel).OnDblClick(nil);
      end;
    FFirstTimeActivated := False;
  end;
  //
  dsrc_DataStateChange(Self);
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Dted.fm_CloseQuery(Sender: TObject; var CanClose: Boolean);
const
  ProcName: string = 'fm_CloseQuery';
begin
  CanClose := true;
  if DatasetActive = 1 then
  begin
    if dbgr_Data.DataSource.DataSet.State in [dsBrowse] then
    begin
      {
        if (not (dbgr_Data.DataSource.DataSet as TpFIBDataset).AutoCommit) then
        begin
          if MessageDlg(Mess_OnClose_2, mtConfirmation, [mbYes,mbNo], 0) = mrYes then
            DataFinishWork(dbgr_Data.DataSource.DataSet, true)
          else
            DataFinishWork(dbgr_Data.DataSource.DataSet, false);
        end;
      }
    end
    else
    begin
      ShowMessage(Mess_OnClose_1);
      CanClose := false;
    end;
  end;
  if Assigned(FOnCloseQuerySave) then
    FOnCloseQuerySave(Sender, CanClose);
  DEBUGMessEnh(0, UnitName, ProcName, 'CanClose = ' + BoolYesNo[CanClose]);
end;

procedure Tfm_Dted.fm_KeyPress(Sender: TObject; var Key: Char);
begin
  if Assigned(FOnKeyPressSave) then
    FOnKeyPressSave(Sender, Key);
end;

procedure Tfm_Dted.fm_Create_After;
const
  ProcName: string = 'fm_Create_After';
var
  Comp: TComponent;
  i: integer;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  FFirstTimeActivated := True;
  FDatasetActiveState := (DatasetActive = 1);
  //
  FOnActivateSave := Self.OnActivate;
  Self.OnActivate := fm_Activate;
  //
  FOnCloseQuerySave := Self.OnCloseQuery;
  Self.OnCloseQuery := fm_CloseQuery;
  //
  FOnKeyPressSave := Self.OnKeyPress;
  Self.OnKeyPress := fm_KeyPress;
  KeyPreview := true;
  //
  FOnMouseWheelSave := Self.OnMouseWheel;
  Self.OnMouseWheel := fm_OnMouseWheel;
  //
  Comp := Self.FindComponent(s_AddRec_Name);
  if Assigned(Comp) then
    if (Comp is TButton) and (not (Comp.Tag and 1 = 1)) then
    begin
      (Comp as TButton).OnClick := bt_AddRecClick;
      (Comp as TButton).Default := false;
      (Comp as TButton).Cancel := false;
    end;
  //
  Comp := Self.FindComponent(s_Cancel_Name);
  if Assigned(Comp) then
    if (Comp is TButton) and (not (Comp.Tag and 1 = 1)) then
    begin
      (Comp as TButton).OnClick := bt_CancelClick;
      (Comp as TButton).Default := false;
      (Comp as TButton).Cancel := false;
    end;
  //
  Comp := Self.FindComponent(s_Close_Name);
  if Assigned(Comp) then
    if (Comp is TButton) and (not (Comp.Tag and 1 = 1)) then
    begin
      (Comp as TButton).OnClick := bt_CloseClick;
      (Comp as TButton).Default := false;
      (Comp as TButton).Cancel := false;
    end;
  //
  Comp := Self.FindComponent(s_DeleteRec_Name);
  if Assigned(Comp) then
    if (Comp is TButton) and (not (Comp.Tag and 1 = 1)) then
    begin
      (Comp as TButton).OnClick := bt_DeleteRecClick;
      (Comp as TButton).Default := false;
      (Comp as TButton).Cancel := false;
    end;
  //
  Comp := Self.FindComponent(s_EditRec_Name);
  if Assigned(Comp) then
    if (Comp is TButton) and (not (Comp.Tag and 1 = 1)) then
    begin
      (Comp as TButton).OnClick := bt_EditRecClick;
      (Comp as TButton).Default := false;
      (Comp as TButton).Cancel := false;
    end;
  //
  Comp := Self.FindComponent(s_Refresh_Name);
  if Assigned(Comp) then
    if (Comp is TButton) and (not (Comp.Tag and 1 = 1)) then
    begin
      (Comp as TButton).OnClick := bt_RefreshClick;
      (Comp as TButton).Default := false;
      (Comp as TButton).Cancel := false;
    end;
  //
  dbgr_Data := nil;
  FOnStateChangeSave := nil;
  FOnDataChangeSave := nil;
  Comp := Self.FindComponent(s_dbgr_Data_Name);
  if Assigned(Comp) then
    if (Comp is TDBGrid) then
    begin
      dbgr_Data := (Comp as TDBGrid);
      dbgr_Data.OnDblClick := dbgr_DataDblClick;
      dbgr_Data.OnKeyDown := dbgr_DataKeyDown;
      dbgr_Data.OnKeyPress := dbgr_DataKeyPress;
      DEBUGMessEnh(0, UnitName, ProcName, 'dbgr_Data events hooked.');
      if Assigned(dbgr_Data.DataSource) then
        with dbgr_Data.DataSource do
        begin
          FOnStateChangeSave := OnStateChange;
          OnStateChange := dsrc_DataStateChange;
          FOnDataChangeSave := OnDataChange;
          OnDataChange := dsrc_DataDataChange;
          DEBUGMessEnh(0, UnitName, ProcName, 'DataSource events hooked.');
          if Assigned(DataSet) then
            DEBUGMessEnh(0, UnitName, ProcName, 'DataSet = ' + DataSet.Name);
        end;
    end;
  //
  for i := 0 to Self.ComponentCount - 1 do
  begin
    Comp := Self.Components[i];
    if (Comp is TDBEdit) then
    begin
      (Comp as TDBEdit).OnKeyDown := dbed_DataKeyDown;
      (Comp as TDBEdit).OnKeyPress := dbed_KeyPress;
    end;
    if (Comp is TDBImage) then
      (Comp as TDBImage).OnKeyPress := dbed_KeyPress;
    if (Comp is TDBLookupComboBox) then
      (Comp as TDBLookupComboBox).OnKeyPress := dbed_KeyPress;
    if (Comp is TDBMemo) then
      (Comp as TDBMemo).OnKeyPress := dbed_KeyPress;
  end;
  //
  DTStatusBar.Align := alBottom;
  DTStatusBar.Top := Self.Height;
  DTStatusBar.Visible := true;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Dted.fm_Destroy_Before;
const
  ProcName: string = 'fm_Destroy_Before';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  if Assigned(FOnActivateSave) then
    Self.OnActivate := FOnActivateSave;
  //
  if Assigned(FOnCloseQuerySave) then
    Self.OnCloseQuery := FOnCloseQuerySave;
  //
  if Assigned(FOnKeyPressSave) then
    Self.OnKeyPress := FOnKeyPressSave;
  //
  if Assigned(FOnMouseWheelSave) then
    Self.OnMouseWheel := FOnMouseWheelSave;
  //
  if Assigned(dbgr_Data) then
    if Assigned(dbgr_Data.DataSource) then
    begin
      if Assigned(FOnStateChangeSave) then
        dbgr_Data.DataSource.OnStateChange := FOnStateChangeSave;
      if Assigned(FOnDataChangeSave) then
        dbgr_Data.DataSource.OnDataChange := FOnDataChangeSave;
      if (DatasetActive in [0, 1]) then
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'DatasetActiveState = ' +
          BoolYesNo[FDatasetActiveState]);
        dbgr_Data.DataSource.DataSet.Active := FDatasetActiveState;
      end;
    end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Dted.DoCreate;
begin
  inherited;
  fm_Create_After;
end;

procedure Tfm_Dted.DoDestroy;
begin
  fm_Destroy_Before;
  inherited;
end;

procedure Tfm_Dted.DTAddRecExecute(Sender: TObject);
var
  Comp: TComponent;
begin
  // bt_AddRecClick(nil);
  Comp := Self.FindComponent(s_AddRec_Name);
  if Assigned(Comp) then
    if (Comp is TButton) then
    begin
      (Comp as TButton).Click;
    end;
end;

procedure Tfm_Dted.DTDeleteRecExecute(Sender: TObject);
var
  Comp: TComponent;
begin
  // bt_DeleteRecClick(nil);
  Comp := Self.FindComponent(s_DeleteRec_Name);
  if Assigned(Comp) then
    if (Comp is TButton) then
    begin
      (Comp as TButton).Click;
    end;
end;

procedure Tfm_Dted.DTEditRecExecute(Sender: TObject);
var
  Comp: TComponent;
begin
  // bt_EditRecClick(nil);
  Comp := Self.FindComponent(s_EditRec_Name);
  if Assigned(Comp) then
    if (Comp is TButton) then
    begin
      (Comp as TButton).Click;
    end;
end;

procedure Tfm_Dted.DTCancelExecute(Sender: TObject);
var
  Comp: TComponent;
begin
  // bt_CancelClick(nil);
  Comp := Self.FindComponent(s_Cancel_Name);
  if Assigned(Comp) then
    if (Comp is TButton) then
    begin
      (Comp as TButton).Click;
    end;
end;

function Tfm_Dted.SetDTStatus(PanelIndex: Integer; StatusText: string): Boolean;
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

procedure Tfm_Dted.DTStatusBarClick(Sender: TObject);
begin
  if (DatasetActive in [0, 1]) then
    SetDTStatus(2, IntToStr(dbgr_Data.DataSource.DataSet.RecordCount))
  else
    SetDTStatus(2, 'unknown');
end;

procedure Tfm_Dted.fm_OnMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
const
  VertWheelPoints: Integer = 32;
  HorzWheelPoints: Integer = 24;
var
  LocalPos: TPoint;
  HotControl: TControl;
  ParentWinControl: TWinControl;
begin
  // Caption := 'X = ' + IntToStr(MousePos.x) + ', Y = ' + IntToStr(MousePos.y);
  HotControl := nil;
  // -----------------------------------------------
  if (dbgr_Data.Parent is TWinControl) then
  begin
    ParentWinControl := dbgr_Data.Parent;
    ConvertCoords(nil, dbgr_Data.Parent, MousePos, LocalPos);
    // Caption := Caption + '; LX = ' + IntToStr(LocalPos.x) + ', LY = ' + IntToStr(LocalPos.y);
    HotControl := ParentWinControl.ControlAtPos(LocalPos, false, true);
    {
    if (HotControl is TControl) then
      Caption := Caption + '; Name = ' + HotControl.Name;
    }
  end;
  // -----------------------------------------------
  if ((HotControl is TCustomGrid) and (HotControl = dbgr_Data)) then
  begin
    if (DatasetActive in [0, 1]) then
    begin
      // SetDTStatus(3, 'Scrolling vertical...');
      if Sign(WheelDelta) < 0 then
        dbgr_Data.DataSource.DataSet.Next
      else
        dbgr_Data.DataSource.DataSet.Prior;
      Handled := true;
    end;
  end
  else if ((HotControl is TScrollingWinControl) and (
    (HotControl.Name = 'pn_Bottom') or (HotControl.Name = 'gb_Edit')
    )) then
  begin
    // SetDTStatus(3, 'Scrolling horizontal...');
    (HotControl as TScrollingWinControl).HorzScrollBar.Position :=
      (HotControl as TScrollingWinControl).HorzScrollBar.Position -
      Sign(WheelDelta) * HorzWheelPoints;
  end
  else if Assigned(FOnKeyPressSave) then
    FOnMouseWheelSave(Sender, Shift, WheelDelta, MousePos, Handled);
end;

end.

