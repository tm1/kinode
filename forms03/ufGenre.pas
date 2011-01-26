{-----------------------------------------------------------------------------
 Unit Name: ufGenre
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  30.12.2002
 Purpose:   Edit Form (ds_Genre)
 History:
-----------------------------------------------------------------------------}
unit ufGenre;

interface

{$I kinode01.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Grids, DBGrids, ExtCtrls, Spin, StdCtrls, DBCtrls, Mask, Buttons,
  ExtDlgs, ufDted;

type
  Tfm_Genre = class(Tfm_Dted)
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
    pn_Bottom: TPanel;
    pn_Close: TPanel;
    bt_Close: TBitBtn;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure acGenreShowModal(Sender: TObject);

var
  fm_Genre: Tfm_Genre;

implementation

uses
  bugger, udBase;

{$R *.DFM}

const
  UnitName: string = 'ufGenre';

procedure acGenreShowModal(Sender: TObject);
const
  ProcName: string = 'acGenreShowModal';
begin
  // --------------------------------------------------------------------------
  // Справочник жанров
  // --------------------------------------------------------------------------
  DEBUGMessBrk(1, ')   >>> [' + UnitName + '::' + ProcName + '] >>>   (');
  // DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  try
    Application.CreateForm(Tfm_Genre, fm_Genre);
    DEBUGMessEnh(0, UnitName, ProcName, fm_Genre.Name + '.ShowModal');
    fm_Genre.ShowModal;
  finally
    fm_Genre.Free;
    fm_Genre := nil;
  end;
  // --------------------------------------------------------------------------
  // DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  DEBUGMessBrk(-1, ')   <<< [' + UnitName + '::' + ProcName + '] <<<   (');
end;

procedure Tfm_Genre.FormActivate(Sender: TObject);
const
  ProcName: string = 'FormActivate';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  while DTStatusBar.Panels.Count < 5 do
    DTStatusBar.Panels.Add;
  SetDTStatus(3, IntToStr(dm_Base.Changelog_Max_Value));
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

end.

