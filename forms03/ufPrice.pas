{-----------------------------------------------------------------------------
 Unit Name: ufPrice
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  19.12.2004
 Purpose:   Edit Form (ds_Price)
 History:
-----------------------------------------------------------------------------}
unit ufPrice;

interface

{$I kinode01.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Grids, DBGrids, ExtCtrls, Spin, StdCtrls, DBCtrls, Mask, Buttons,
  ExtDlgs, ufDted, ComCtrls, WcBitBtn;

type
  Tfm_Price = class(Tfm_Dted)
    bt_AddRec1: TBitBtn;
    bt_Cancel: TBitBtn;
    bt_DeleteRec1: TBitBtn;
    bt_EditRec: TBitBtn;
    dbgr_Data: TDBGrid;
    dbtx_BASE_KOD: TDBText;
    dsrc_Data: TDataSource;
    lbl_Kod: TLabel;
    gb_Edit: TGroupBox;
    pn_Top: TPanel;
    lbl_Abonem: TLabel;
    bt_Refresh: TBitBtn;
    dbed_BASE_NAM: TDBEdit;
    lbl_Year: TLabel;
    bt_Abonem: TWc_BitBtn;
    dbed_Abonem: TDBEdit;
    pn_Bottom: TPanel;
    pn_Close: TPanel;
    bt_Close: TBitBtn;
    dbcb_Enabled: TDBCheckBox;
    sb_Up: TSpeedButton;
    sb_Down: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure bt_AbonemClick(Sender: TObject);
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

procedure acPriceShowModal(v_Abonem: Integer);

var
  fm_Price: Tfm_Price;
  pm_Abonem: Integer;

implementation

uses
  Bugger, udBase, uhCommon, urCommon, StrConsts;

{$R *.DFM}

const
  UnitName: string = 'ufPrice';

procedure acPriceShowModal(v_Abonem: Integer);
const
  ProcName: string = 'acPriceShowModal';
begin
  // --------------------------------------------------------------------------
  // Справочник тарифов
  // --------------------------------------------------------------------------
  DEBUGMessBrk(1, ')   >>> [' + UnitName + '::' + ProcName + '] >>>   (');
  // DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  try
    pm_Abonem := v_Abonem;
    Application.CreateForm(Tfm_Price, fm_Price);
    DEBUGMessEnh(0, UnitName, ProcName, fm_Price.Name + '.ShowModal');
    fm_Price.ShowModal;
  finally
    fm_Price.Free;
    fm_Price := nil;
  end;
  // --------------------------------------------------------------------------
  // DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  DEBUGMessBrk(-1, ')   <<< [' + UnitName + '::' + ProcName + '] <<<   (');
end;

procedure Tfm_Price.FormCreate(Sender: TObject);
begin
  FNotYetActivated := true;
end;

procedure Tfm_Price.FormActivate(Sender: TObject);
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
    with dm_Base do
    begin
      if FNotYetActivated then
      begin
        Activate_After_Once(nil);
        FNotYetActivated := False;
      end;
      {
      else if Assigned(OnChange) then
        OnChange(Self);
      }
    end;
  finally
    Screen.Cursor := OldCursor;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Price.bt_AbonemClick(Sender: TObject);
begin
  //
  // acAbonemShowModal(nil);
  FormActivate(nil);
end;

procedure Tfm_Price.sb_UpClick(Sender: TObject);
var
  num, step: Integer;
begin
  try
    num := StrToInt(dbed_BASE_NAM.Text);
    step := abs(sb_Up.Tag);
    num := num + step;
    with dm_Base.ds_Price do
      if CanModify and (not dbed_BASE_NAM.ReadOnly) then
      begin
        if not (State in [dsEdit]) then
          Edit;
        dbed_BASE_NAM.Text := IntToStr(num);
      end;
  except
  end;
end;

procedure Tfm_Price.sb_DownClick(Sender: TObject);
var
  num, step: Integer;
begin
  try
    num := StrToInt(dbed_BASE_NAM.Text);
    step := abs(sb_Up.Tag);
    num := num - step;
    with dm_Base.ds_Price do
      if CanModify and (not dbed_BASE_NAM.ReadOnly) then
      begin
        if not (State in [dsEdit]) then
          Edit;
        dbed_BASE_NAM.Text := IntToStr(num);
      end;
  except
  end;
end;

procedure Tfm_Price.UpdateEditMode(Freezed: boolean);
begin
  dbed_BASE_NAM.ReadOnly := Freezed;
  dbcb_Enabled.ReadOnly := Freezed;
  if dbed_BASE_NAM.ReadOnly then
    dbed_BASE_NAM.Color := clBtnFace
  else
    dbed_BASE_NAM.Color := clWindow;
  sb_Up.Enabled := not Freezed;
  sb_Down.Enabled := not Freezed;
end;

procedure Tfm_Price.Activate_After_Once(Sender: TObject);
const
  ProcName: string = 'Activate_After_Once';
begin
  // --------------------------------------------------------------------------
  {
  if Assigned(OnChange) then
    OnChange(Self);
  DEBUGMessEnh(0, UnitName, ProcName, Name + '.OnChange done.');
  }
  // --------------------------------------------------------------------------
end;

end.

