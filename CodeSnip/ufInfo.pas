{-----------------------------------------------------------------------------
 Unit Name: ufInfo
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  12.10.2002
 Purpose:   Info Form
 History:
-----------------------------------------------------------------------------}
unit ufInfo;

interface

{$I kinode01.inc}

uses
  Forms, SLForms, Classes, Controls, ExtCtrls, ComCtrls, StdCtrls, Buttons, Graphics, ImgList;

type
  Tfm_Info = class(TSLForm)
    pnInfo: TPanel;
    lv_Info: TListView;
    sbarInfo: TStatusBar;
    iml_Ticket_Icons: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CycleMinMax(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FRunOneTime: Boolean;
    FInitDone: Boolean;
    MinSized: boolean;
    procedure LoadTicketInfo(vFoo: Boolean);
    procedure UpdateTicketInfo(vFoo: Boolean);
    procedure FreeTicketInfo(vFoo: Boolean);
  public
    { Public declarations }
  end;

procedure UpdateInfoView(vFoo: Boolean);

var
  fm_Info: Tfm_Info;

implementation

uses
  Bugger, SysUtils, uhTicket {, ufMain};

{$R *.DFM}

const
  UnitName: string = 'ufInfo';

procedure UpdateInfoView(vFoo: Boolean);
begin
  if Assigned(fm_Info) then
  try
    fm_Info.UpdateTicketInfo(vFoo);
  except
  end;
end;

procedure Tfm_Info.LoadTicketInfo(vFoo: Boolean);
const
  ProcName: string = 'LoadTicketInfo';
var
  lc: TListColumn;
  tnt: TListItem;
  i, j, img_idx: Integer;
  bm: TBitmap;
begin
{$IFDEF Debug_Level_5}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  // We must use OnActivate event
  // --------------------------------------------------------------------------
  iml_Ticket_Icons.Clear;
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(0, UnitName, ProcName, 'Preparing to clear Items. Count = ' +
    IntToStr(lv_Info.Items.Count));
{$ENDIF}
  {
  for i := 0 to lv_Info.Items.Count - 1 do
  begin
    DEBUGMessEnh(0, UnitName, ProcName, 'SubItems[' + IntToStr(i) + '].Clear - ' +
      lv_Info.Items[i].Caption);
    lv_Info.Items[i].SubItems.Clear;
    lv_Info.Items[i].Caption := '=' + lv_Info.Items[i].Caption + '=';
  end;
  }
  lv_Info.Items.Clear;
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(0, UnitName, ProcName, 'Cleared Items. Count = ' +
    IntToStr(lv_Info.Items.Count));
{$ENDIF}
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(0, UnitName, ProcName, 'Preparing to clear Columns. Count = ' +
    IntToStr(lv_Info.Columns.Count));
{$ENDIF}
  lv_Info.Columns.Clear;
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(0, UnitName, ProcName, 'Cleared Columns. Count = ' +
    IntToStr(lv_Info.Columns.Count));
{$ENDIF}
  // --------------------------------------------------------------------------
  //  Fill columns list
  // --------------------------------------------------------------------------
  try
    lc := lv_Info.Columns.Add;
    lc.Alignment := taLeftJustify;
    lc.Caption := 'Тип билета';
    lc.Width := 170;
  except
  end;
  // --------------------------------------------------------------------------
  try
    lc := lv_Info.Columns.Add;
    lc.Alignment := taRightJustify;
    lc.Caption := 'Цена';
    lc.Width := 40;
  except
  end;
  // --------------------------------------------------------------------------
  try
    lc := lv_Info.Columns.Add;
    lc.Alignment := taRightJustify;
    // lc.Caption := 'Количество';
    lc.Caption := 'Кол-во';
    lc.Width := 40;
  except
  end;
  // --------------------------------------------------------------------------
  try
    lc := lv_Info.Columns.Add;
    lc.Alignment := taRightJustify;
    lc.Caption := 'Сумма';
    lc.Width := 60;
  except
  end;
  // --------------------------------------------------------------------------
  try
    lc := lv_Info.Columns.Add;
    lc.Alignment := taLeftJustify;
    lc.Caption := '#';
    lc.Width := 22;
  except
  end;
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(0, UnitName, ProcName, 'Added Columns. Count = ' +
    IntToStr(lv_Info.Columns.Count));
{$ENDIF}
  (*
  // --------------------------------------------------------------------------
  //  Fill 3 dummy items at top of list
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(0, UnitName, ProcName, 'Adding Items. Count = ' +
    IntToStr(lv_Info.Items.Count));
{$ENDIF}
  try
    tnt := lv_Info.Items.Add;
    tnt.Caption := 'Итого на продажу';
    tnt.Data := Pointer(vInfo_Special_Base - vInfo_Special_Sale);
    tnt.ImageIndex := -1;
    for j := 1 to lv_Info.Columns.Count - 1 do
    begin
      tnt.SubItems.Add('< ' + IntToStr(j) + ' >');
    end;
  except
  end;
  // --------------------------------------------------------------------------
  bm := TBitmap.Create;
  with bm do
  try
    Width := iml_Ticket_Icons.Width;
    Height := iml_Ticket_Icons.Height;
    Canvas.Pen.Style := psSolid;
    Transparent := true;
    TransparentMode := tmFixed;
    TransparentColor := clBtnFace;
    Canvas.Brush.Color := TransparentColor;
    Canvas.Pen.Color := TransparentColor;
    Canvas.Rectangle(0, 0, Width, Height);
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Color := clRed; // ssSelect.SelectBrush.Color;
    Canvas.Rectangle(0, 2, Width, Height - 2);
    Canvas.Pen.Color := clWhite; // ssSelect.SelectFont.Color;
    Canvas.Brush.Style := bsClear;
    // Canvas.Rectangle(6, 4, Width - 6, Height - 4);
    // Canvas.Rectangle(2, 4, Width div 3 + 2, Height div 3 + 2);
    Canvas.Rectangle(2 * Width div 3, 2 * Height div 3 - 2, Width - 2, Height - 4);
    img_idx := iml_Ticket_Icons.Add(bm, nil);
  finally
  end;
  try
    tnt := lv_Info.Items.Add;
    tnt.Caption := 'Помеченные места';
    tnt.Data := Pointer(vInfo_Special_Base - vInfo_Special_Selected);
    tnt.ImageIndex := img_idx;
    for j := 1 to lv_Info.Columns.Count - 1 do
    begin
      tnt.SubItems.Add('< ' + IntToStr(j) + ' >');
    end;
  except
  end;
  // --------------------------------------------------------------------------
  bm := TBitmap.Create;
  with bm do
  try
    Width := iml_Ticket_Icons.Width;
    Height := iml_Ticket_Icons.Height;
    Canvas.Pen.Style := psSolid;
    Transparent := true;
    TransparentMode := tmFixed;
    TransparentColor := clBtnFace;
    Canvas.Brush.Color := TransparentColor;
    Canvas.Pen.Color := TransparentColor;
    Canvas.Rectangle(0, 0, Width, Height);
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Color := clWhite; // ssSelect.RegularBrush.Color;
    Canvas.Rectangle(0, 2, Width, Height - 2);
    Canvas.Pen.Color := clBlack; // ssSelect.RegularFont.Color;
    Canvas.Brush.Style := bsClear;
    // Canvas.Rectangle(6, 4, Width - 6, Height - 4);
    // Canvas.Rectangle(2, 4, Width div 3 + 2, Height div 3 + 2);
    Canvas.Rectangle(2 * Width div 3, 2 * Height div 3 - 2, Width - 2, Height - 4);
    img_idx := iml_Ticket_Icons.Add(bm, nil);
  finally
  end;
  try
    tnt := lv_Info.Items.Add;
    tnt.Caption := 'Свободные места';
    tnt.Data := Pointer(vInfo_Special_Base - vInfo_Special_Free);
    tnt.ImageIndex := img_idx;
    for j := 1 to lv_Info.Columns.Count - 1 do
    begin
      tnt.SubItems.Add('< ' + IntToStr(j) + ' >');
    end;
  except
  end;
  // --------------------------------------------------------------------------
  try
    tnt := lv_Info.Items.Add;
    tnt.Caption := StringOfChar('-', 40);
    tnt.Data := Pointer(vInfo_Special_Base - vInfo_Special_Delim);
    tnt.ImageIndex := -1;
    for j := 1 to lv_Info.Columns.Count - 1 do
    begin
      tnt.SubItems.Add('---');
    end;
  except
  end;
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(0, UnitName, ProcName, 'Added Items. Count = ' +
    IntToStr(lv_Info.Items.Count));
{$ENDIF}
  *)
  // --------------------------------------------------------------------------
  //  Fill other items of list
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(0, UnitName, ProcName, 'Iterating vInfo from ' +
    IntToStr(Low(vInfo)) + ' to ' + IntToStr(High(vInfo)));
{$ENDIF}
  for i := Low(vInfo) to High(vInfo) do
  begin
    bm := TBitmap.Create;
    with bm do
    try
      Width := iml_Ticket_Icons.Width;
      Height := iml_Ticket_Icons.Height;
      Canvas.Pen.Style := psSolid;
      Transparent := true;
      TransparentMode := tmFixed;
      TransparentColor := clBtnFace;
      Canvas.Brush.Color := TransparentColor;
      Canvas.Pen.Color := TransparentColor;
      Canvas.Rectangle(0, 0, Width, Height);
      Canvas.Pen.Color := clBlack;
      if (vInfo[i].irSpecial = (vInfo_Special_Base - vInfo_Special_Delim)) then
      begin
        Canvas.Brush.Color := TransparentColor;
      end
      else
      begin
        Canvas.Brush.Color := vInfo[i].irBgColor;
      end; // if
      Canvas.Rectangle(0, 2, Width, Height - 2);
      if (vInfo[i].irSpecial = (vInfo_Special_Base - vInfo_Special_Delim)) then
      begin
        Canvas.Pen.Color := TransparentColor;
      end
      else
      begin
        Canvas.Pen.Color := vInfo[i].irFontColor;
      end; // if
      Canvas.Brush.Style := bsClear;
      // Canvas.Rectangle(6, 4, Width - 6, Height - 4);
      // Canvas.Rectangle(2, 4, Width div 3 + 2, Height div 3 + 2);
      Canvas.Rectangle(2 * Width div 3, 2 * Height div 3 - 2, Width - 2, Height - 4);
      img_idx := iml_Ticket_Icons.Add(bm, nil);
    finally
    end;
    try
      tnt := lv_Info.Items.Add;
      tnt.Caption := vInfo[i].irName;
      tnt.Data := Pointer(vInfo[i].irKod);
      if (vInfo[i].irSpecial = (vInfo_Special_Base - vInfo_Special_Delim)) then
      begin
        tnt.ImageIndex := -1;
        vInfo[i].irLvIdx := -1;
      end
      else
      begin
        tnt.ImageIndex := img_idx;
        vInfo[i].irLvIdx := tnt.Index;
      end; // if
      for j := 1 to lv_Info.Columns.Count - 1 do
      begin
        tnt.SubItems.Add('---');
      end;
    except
    end;
  end;
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(0, UnitName, ProcName, 'Added Items in cycle. Count = ' +
    IntToStr(lv_Info.Items.Count));
{$ENDIF}
  (*
  // --------------------------------------------------------------------------
  //  Fill 3 dummy items at bottom of list
  // --------------------------------------------------------------------------
  try
    tnt := lv_Info.Items.Add;
    tnt.Caption := StringOfChar('-', 40);
    tnt.Data := Pointer(vInfo_Special_Base - vInfo_Special_Delim);
    tnt.ImageIndex := -1;
    for j := 1 to lv_Info.Columns.Count - 1 do
    begin
      tnt.SubItems.Add('---');
    end;
  except
  end;
  // --------------------------------------------------------------------------
  try
    tnt := lv_Info.Items.Add;
    tnt.Caption := 'Итого по брони';
    tnt.Data := Pointer(vInfo_Special_Base - vInfo_Special_Reserved);
    tnt.ImageIndex := -1;
    for j := 1 to lv_Info.Columns.Count - 1 do
    begin
      tnt.SubItems.Add('< ' + IntToStr(j) + ' >');
    end;
  except
  end;
  // --------------------------------------------------------------------------
  try
    tnt := lv_Info.Items.Add;
    tnt.Caption := 'Итого по постерминалу';
    tnt.Data := Pointer(vInfo_Special_Base - vInfo_Special_Credit);
    tnt.ImageIndex := -1;
    for j := 1 to lv_Info.Columns.Count - 1 do
    begin
      tnt.SubItems.Add('< ' + IntToStr(j) + ' >');
    end;
  except
  end;
  // --------------------------------------------------------------------------
  try
    tnt := lv_Info.Items.Add;
    tnt.Caption := 'Итого по всем';
    tnt.Data := Pointer(vInfo_Special_Base - vInfo_Special_Total);
    tnt.ImageIndex := -1;
    for j := 1 to lv_Info.Columns.Count - 1 do
    begin
      tnt.SubItems.Add('< ' + IntToStr(j) + ' >');
    end;
  except
  end;
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(0, UnitName, ProcName, 'Added Items. Count = ' +
    IntToStr(lv_Info.Items.Count));
{$ENDIF}
  *)
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_5}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Info.UpdateTicketInfo(vFoo: Boolean);
const
  ProcName: string = 'LoadTicketInfo';
var
  tnt: TListItem;
  i, item_idx, sub_idx: Integer;
  chk_sum, str_sum: string;
begin
{$IFDEF Debug_Level_5}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  if FInitDone then
  begin
{$IFDEF Debug_Level_6}
    DEBUGMessEnh(0, UnitName, ProcName, 'Iterating vInfo from ' +
      IntToStr(Low(vInfo)) + ' to ' + IntToStr(High(vInfo)));
{$ENDIF}
    try
      lv_Info.Items.BeginUpdate;
      for i := Low(vInfo) to High(vInfo) do
      begin
        if (vInfo[i].irSpecial = vInfo_Special_Base - vInfo_Special_Delim) then
        begin
          // skip
        end
        else
        begin
          // --------------------------------------------------------------------------
          item_idx := vInfo[i].irLvIdx;
          if (0 <= item_idx) and (item_idx < lv_Info.Items.Count) then
          try
            tnt := lv_Info.Items[item_idx];
            chk_sum := '---';
            if vInfo[i].irSpecial > vInfo_Special_Base then
              if ((vInfo[i].irSumCash + vInfo[i].irSumCredit) <>
                (vInfo[i].irCost * (vInfo[i].irCountCash + vInfo[i].irCountCredit))) then
                chk_sum := '*'
              else
                chk_sum := '';
            if (vInfo[i].irSumCash = -1) and (vInfo[i].irSpecial < vInfo_Special_Base) then
              str_sum := '---'
            else
              str_sum := IntToStr(vInfo[i].irSumCash + vInfo[i].irSumCredit);
{$IFDEF Debug_Level_6}
            // tnt.Caption := tnt.Caption + '+';
            DEBUGMessEnh(0, UnitName, ProcName, 'Caption = ' + tnt.Caption + ', Sum ' + str_sum);
{$ENDIF}
            // --------------------------------------------------------------------------
            // Цена
            // --------------------------------------------------------------------------
            sub_idx := 0;
            if (sub_idx < tnt.SubItems.Count) then
            begin
              if (vInfo[i].irSpecial > vInfo_Special_Base) then
                if (vInfo[i].irCost = 0) then
                  tnt.SubItems[sub_idx] := ''
                else
                  tnt.SubItems[sub_idx] := IntToStr(vInfo[i].irCost);
            end;
            // --------------------------------------------------------------------------
            // Кол-во
            // --------------------------------------------------------------------------
            sub_idx := 1;
            if (sub_idx < tnt.SubItems.Count) then
            begin
              tnt.SubItems[sub_idx] := IntToStr(vInfo[i].irCountCash + vInfo[i].irCountCredit);
            end;
            // --------------------------------------------------------------------------
            // Сумма
            // --------------------------------------------------------------------------
            sub_idx := 2;
            if (sub_idx < tnt.SubItems.Count) then
            begin
              if (str_sum = '0') then
              begin
                if (vInfo[i].irCountCash + vInfo[i].irCountCredit = 0) then
                  tnt.SubItems[sub_idx] := ''
                else
                  tnt.SubItems[sub_idx] := '+';
              end
              else
                tnt.SubItems[sub_idx] := str_sum;
            end;
            sub_idx := 3;
            if (sub_idx < tnt.SubItems.Count) then
            begin
              tnt.SubItems[sub_idx] := chk_sum;
            end;
          except
            // todo: do anything here
          end;
          // --------------------------------------------------------------------------
        end; // if (vInfo[i].irSpecial = vInfo_Special_Base - vInfo_Special_Delim) then
      end; // for
    finally
      lv_Info.Items.EndUpdate;
    end;
  end;
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_5}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tfm_Info.FreeTicketInfo(vFoo: Boolean);
begin
  // --------------------------------------------------------------------------
  // --------------------------------------------------------------------------
end;

procedure Tfm_Info.FormCreate(Sender: TObject);
begin
  // --------------------------------------------------------------------------
  WindowState := wsNormal;
  FRunOneTime := true;
  FInitDone := false;
  MinSized := false;
  // --------------------------------------------------------------------------
end;

procedure Tfm_Info.FormActivate(Sender: TObject);
begin
  if FRunOneTime then
  begin
    LoadTicketInfo(True);
    FRunOneTime := false;
    FInitDone := true;
  end;
  UpdateTicketInfo(True);
end;

procedure Tfm_Info.CycleMinMax(Sender: TObject);
begin
  MinSized := not MinSized;
  if MinSized then
  begin
    Height := Constraints.MaxHeight;
    sbarInfo.Panels[0].Text := 'MAXI';
  end
  else
  begin
    Height := Constraints.MinHeight;
    sbarInfo.Panels[0].Text := 'MINI';
  end;
end;

procedure Tfm_Info.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  Action := caHide;
  {
  if Assigned(fm_Main) then
    if Assigned(fm_Main.acInfo) then
      fm_Main.acInfo.Checked := false;
  }
end;

procedure Tfm_Info.FormDestroy(Sender: TObject);
begin
  // --------------------------------------------------------------------------
  FreeTicketInfo(True);
  // --------------------------------------------------------------------------
end;

end.

