{-----------------------------------------------------------------------------
 Unit Name: ufTariff
 Author:    n0mad
 Version:   1.1.7.94
 Creation:  30.12.2002
 Purpose:   Edit Form (ds_Tariff)
 History:
-----------------------------------------------------------------------------}
unit ufTariff;

interface

{$I kinode01.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Grids, DBGrids, ExtCtrls, Spin, StdCtrls, DBCtrls, Mask, Buttons,
  ExtDlgs, ufDted;

type
  Tfm_Tariff = class(Tfm_Dted)
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
    bt_Refresh: TBitBtn;
    dbme_Comment: TDBMemo;
    lbl_Comment: TLabel;
    pn_Bottom: TPanel;
    pn_Close: TPanel;
    bt_Close: TBitBtn;
    dbed_BASE_COST: TDBEdit;
    lbl_2nd: TLabel;
    dbcb_Freezed: TDBCheckBox;
    bt_Find: TBitBtn;
    procedure Activate_After_Once(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure acTariffShowModal(v_Tariff_Kod: Integer);

var
  fm_Tariff: Tfm_Tariff;
  pm_Tariff_Kod: Integer;

implementation

uses
  Bugger, udBase, pFIBDataSet, urCommon;

{$R *.DFM}

const
  UnitName: string = 'ufTariff';

procedure acTariffShowModal(v_Tariff_Kod: Integer);
const
  ProcName: string = 'acTariffShowModal';
begin
  // --------------------------------------------------------------------------
  // Тарифные планы
  // --------------------------------------------------------------------------
  DEBUGMessBrk(1, ')   >>> [' + UnitName + '::' + ProcName + '] >>>   (');
  // DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  try
    pm_Tariff_Kod := v_Tariff_Kod;
    Application.CreateForm(Tfm_Tariff, fm_Tariff);
    DEBUGMessEnh(0, UnitName, ProcName, fm_Tariff.Name + '.ShowModal');
    fm_Tariff.ShowModal;
  finally
    fm_Tariff.Free;
    fm_Tariff := nil;
  end;
  // --------------------------------------------------------------------------
  // DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  DEBUGMessBrk(-1, ')   <<< [' + UnitName + '::' + ProcName + '] <<<   (');
end;

procedure Tfm_Tariff.Activate_After_Once(Sender: TObject);
const
  ProcName: string = 'Activate_After_Once';
begin
  // --------------------------------------------------------------------------
  if pm_Tariff_Kod > -1 then
  begin
    if Assigned(dsrc_Data.Dataset) and (dsrc_Data.Dataset is TpFIBDataSet) then
      with (dsrc_Data.Dataset as TpFIBDataSet) do
        if Active and Assigned(FieldByName(s_TARIFF_KOD)) then
        begin
          try
            First;
            if Locate(s_TARIFF_KOD, pm_Tariff_Kod, []) then
              DEBUGMessEnh(0, UnitName, ProcName, Name + '.Locate done.');
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

procedure Tfm_Tariff.FormCreate(Sender: TObject);
begin
  //

end;

end.

