{-----------------------------------------------------------------------------
 Unit Name: ufCost
 Author:    n0mad
 Version:   1.1.6.72
 Creation:  30.12.2002
 Purpose:   Edit Form (ds_Cost)
 History:
-----------------------------------------------------------------------------}
unit ufCost;

interface

{$I kinode01.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Grids, DBGrids, ExtCtrls, Spin, StdCtrls, DBCtrls, Mask, Buttons,
  ExtDlgs, ufDted, ComCtrls, WcBitBtn;

type
  Tfm_Cost = class(Tfm_Dted)
    bt_AddRec1: TBitBtn;
    bt_Cancel: TBitBtn;
    bt_DeleteRec1: TBitBtn;
    bt_EditRec: TBitBtn;
    dbgr_Data: TDBGrid;
    dbtx_BASE_KOD: TDBText;
    dsrc_Data: TDataSource;
    lbl_1st: TLabel;
    lbl_Kod: TLabel;
    gb_Edit: TGroupBox;
    pn_Top: TPanel;
    lbl_Tariff: TLabel;
    bt_Tariff: TWc_BitBtn;
    dbcm_Tariff: TComboBox;
    bt_Refresh: TBitBtn;
    dbed_BASE_NAM: TDBEdit;
    lbl_Year: TLabel;
    bt_Ticket: TWc_BitBtn;
    dbed_Ticket: TDBEdit;
    pn_Bottom: TPanel;
    pn_Close: TPanel;
    bt_Close: TBitBtn;
    bt_CreateTariffVersion: TBitBtn;
    dbcb_Enabled: TDBCheckBox;
    sb_Up: TSpeedButton;
    sb_Down: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dbcm_TariffChange(Sender: TObject);
    procedure bt_TariffClick(Sender: TObject);
    procedure bt_TicketClick(Sender: TObject);
    procedure bt_CreateTariffVersionClick(Sender: TObject);
    procedure sb_UpClick(Sender: TObject);
    procedure sb_DownClick(Sender: TObject);
    procedure Activate_After_Once(Sender: TObject);
    {
    procedure bt_AddToRatesListClick(Sender: TObject);
    }
  private
    { Private declarations }
    FNotYetActivated: Boolean;
  public
    { Public declarations }
    procedure UpdateEditMode(Freezed: boolean);
  end;

procedure acCostShowModal(v_Repert_Tariff: Integer);

var
  fm_Cost: Tfm_Cost;
  pm_Repert_Tariff: Integer;

implementation

uses
  Bugger, udBase, ufTariff, uhCommon, urCommon, StrConsts, uhTariff;

{$R *.DFM}

const
  UnitName: string = 'ufCost';

procedure acCostShowModal(v_Repert_Tariff: Integer);
const
  ProcName: string = 'acCostShowModal';
begin
  // --------------------------------------------------------------------------
  // Справочник тарифов
  // --------------------------------------------------------------------------
  DEBUGMessBrk(1, ')   >>> [' + UnitName + '::' + ProcName + '] >>>   (');
  // DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  try
    pm_Repert_Tariff := v_Repert_Tariff;
    Application.CreateForm(Tfm_Cost, fm_Cost);
    DEBUGMessEnh(0, UnitName, ProcName, fm_Cost.Name + '.ShowModal');
    fm_Cost.ShowModal;
  finally
    fm_Cost.Free;
    fm_Cost := nil;
  end;
  // --------------------------------------------------------------------------
  // DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  DEBUGMessBrk(-1, ')   <<< [' + UnitName + '::' + ProcName + '] <<<   (');
end;

procedure Tfm_Cost.FormCreate(Sender: TObject);
begin
  FNotYetActivated := true;
end;

procedure Tfm_Cost.FormActivate(Sender: TObject);
const
  ProcName: string = 'FormActivate';
var
  OldCursor: TCursor;
  Old_Tariff_Indx: Integer;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  OldCursor := Screen.Cursor;
  try
    Screen.Cursor := crSQLWait;
    with dbcm_Tariff, dm_Base do
    begin
      Old_Tariff_Indx := ItemIndex;
      if (Old_Tariff_Indx < 0) then
        Old_Tariff_Indx := 0;
      ds_Tariff.Close;
      ds_Tariff.Prepare;
      ds_Tariff.Open;
      Combo_Load_Tariff(ds_Tariff, Items);
      if Items.Count > 0 then
        ItemIndex := 0;
      if Old_Tariff_Indx < Items.Count then
        ItemIndex := Old_Tariff_Indx;
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
  finally
    Screen.Cursor := OldCursor;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Cost.dbcm_TariffChange(Sender: TObject);
var
  index: integer;
  s1, s2, s3: string;
  i_Base_Cost: Integer;
  b_Freezed: Boolean;
begin
  //
  index := 0;
  with dm_Base.ds_Cost do
  begin
    try
      if dbcm_Tariff.ItemIndex > -1 then
        index := Integer(dbcm_Tariff.Items.Objects[dbcm_Tariff.ItemIndex]);
    except
      index := 0;
    end;
    DisableControls;
    try
      Close;
      if Assigned(Params.FindParam(s_IN_FILT_TARIFF_KOD)) then
        ParamByName(s_IN_FILT_TARIFF_KOD).AsInteger := index;
      Prepare;
      Open;
      if Get_Tariff_Desc(Index, s1, s2, s3, i_Base_Cost, b_Freezed) = 1 then
      begin
        UpdateEditMode(b_Freezed);
      end
      else
        UpdateEditMode(false);
    finally
      EnableControls;
    end;
  end;
end;

procedure Tfm_Cost.bt_TariffClick(Sender: TObject);
begin
  //
  acTariffShowModal(-1);
  FormActivate(nil);
end;

procedure Tfm_Cost.bt_TicketClick(Sender: TObject);
begin
  //
  // acTicketShowModal(nil);
  FormActivate(nil);
end;

procedure Tfm_Cost.bt_CreateTariffVersionClick(Sender: TObject);
const
  ProcName: string = 'bt_CreateTariffVersionClick';
var
  int_Tariff_Kod, int_Tariff_Ver: integer;
  tError_Kod: Integer;
  tError_Text: string;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  if dbcm_Tariff.ItemIndex > -1 then
  begin
    int_Tariff_Kod := Integer(dbcm_Tariff.Items.Objects[dbcm_Tariff.ItemIndex]);
    DEBUGMessEnh(0, UnitName, ProcName, 'int_Tariff_Kod = ' + IntToStr(int_Tariff_Kod));
    int_Tariff_Ver := -2;
    if CreateTariffVersion(int_Tariff_Kod, int_Tariff_Ver, tError_Kod, tError_Text) then
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'int_Tariff_Ver = ' + IntToStr(int_Tariff_Ver));
      dbcm_TariffChange(nil);
    end
    else
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Tariff version create failure.');
      MessageBox(0, PChar('---   Tariff version create failure   ---' + c_CRLF +
        'Вроде бы все правильно, но создать версию не получается.'
        + c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF
        + 'Код ошибки = ' + IntToStr(tError_Kod) + ';' + c_CRLF + tError_Text),
        'Data update error', MB_ICONERROR);
    end;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Cost.sb_UpClick(Sender: TObject);
var
  num, step: Integer;
begin
  try
    num := StrToInt(dbed_BASE_NAM.Text);
    step := abs(sb_Up.Tag);
    num := num + step;
    with dm_Base.ds_Cost do
      if CanModify and (not dbed_BASE_NAM.ReadOnly) then
      begin
        if not (State in [dsEdit]) then
          Edit;
        dbed_BASE_NAM.Text := IntToStr(num);
      end;
  except
  end;
end;

procedure Tfm_Cost.sb_DownClick(Sender: TObject);
var
  num, step: Integer;
begin
  try
    num := StrToInt(dbed_BASE_NAM.Text);
    step := abs(sb_Up.Tag);
    num := num - step;
    with dm_Base.ds_Cost do
      if CanModify and (not dbed_BASE_NAM.ReadOnly) then
      begin
        if not (State in [dsEdit]) then
          Edit;
        dbed_BASE_NAM.Text := IntToStr(num);
      end;
  except
  end;
end;

procedure Tfm_Cost.UpdateEditMode(Freezed: boolean);
begin
  bt_CreateTariffVersion.Enabled := Freezed;
  dbed_BASE_NAM.ReadOnly := Freezed;
  dbcb_Enabled.ReadOnly := Freezed;
  if dbed_BASE_NAM.ReadOnly then
    dbed_BASE_NAM.Color := clBtnFace
  else
    dbed_BASE_NAM.Color := clWindow;
  sb_Up.Enabled := not Freezed;
  sb_Down.Enabled := not Freezed;
end;

procedure Tfm_Cost.Activate_After_Once(Sender: TObject);
const
  ProcName: string = 'Activate_After_Once';
var
  i, indx: Integer;
begin
  // --------------------------------------------------------------------------
  with dbcm_Tariff do
    if Items.Count > 0 then
    begin
      indx := 0;
      if ItemIndex > -1 then
        indx := ItemIndex;
      if pm_Repert_Tariff > 0 then
      try
        for i := 0 to Items.Count - 1 do
        begin
          if pm_Repert_Tariff = Integer(Items.Objects[i]) then
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

