{-----------------------------------------------------------------------------
 Unit Name: ufSeans
 Author:    n0mad
 Version:   1.1.6.67
 Creation:  30.12.2002
 Purpose:   Edit Form (ds_Seans)
 History:
-----------------------------------------------------------------------------}
unit ufSeans;

interface

{$I kinode01.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Grids, DBGrids, ExtCtrls, Spin, StdCtrls, DBCtrls, Mask, Buttons,
  ExtDlgs, ufDted;

type
  Tfm_Seans = class(Tfm_Dted)
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
    dbed_Minute: TDBEdit;
    lbl_Minute: TLabel;
    lbl_Time: TLabel;
    dbed_Time: TDBEdit;
    pn_Bottom: TPanel;
    pn_Close: TPanel;
    bt_Close: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure acSeansShowModal(Sender: TObject);

var
  fm_Seans: Tfm_Seans;

implementation

uses
  Bugger, udBase;

{$R *.DFM}

const
  UnitName: string = 'ufSeans';

procedure acSeansShowModal(Sender: TObject);
const
  ProcName: string = 'acSeansShowModal';
begin
  // --------------------------------------------------------------------------
  // Справочник сеансов
  // --------------------------------------------------------------------------
  DEBUGMessBrk(1, ')   >>> [' + UnitName + '::' + ProcName + '] >>>   (');
  // DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  try
    Application.CreateForm(Tfm_Seans, fm_Seans);
    DEBUGMessEnh(0, UnitName, ProcName, fm_Seans.Name + '.ShowModal');
    fm_Seans.ShowModal;
  finally
    fm_Seans.Free;
    fm_Seans := nil;
  end;
  // --------------------------------------------------------------------------
  // DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  DEBUGMessBrk(-1, ')   <<< [' + UnitName + '::' + ProcName + '] <<<   (');
end;

end.
