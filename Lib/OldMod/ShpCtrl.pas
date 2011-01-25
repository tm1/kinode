{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      :
Author       : n0mad
Module       : ShpCtrl.pas
Version      :
Description  :
Creation     : 12.10.2002 9:01:12
Installation :

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit ShpCtrl;

{$DEFINE _def_UseForms}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  ExtCtrls,
  Math,
  Buttons,
  Imglist,
  ActnList;

type

  TInternalState = (siUp, siDisabled, siDown, siSelected);
  TTC_State = (scFree, scBroken, scReserved, scPrepared, scFixed, scFixedNoCash,
    scFixedCheq);
  {
  0 = scFree - 'Свободно',
  1 = scBroken - 'Сломано',
  2 = scReserved - 'Зарезервировано',
  3 = scPrepared - 'Помечено для действия',
  4 = scFixed - 'Продано',
  5 = scFixedNoCash - 'Продано за б/н',
  6 = scFixedCheq - 'Продано`'
  }

  TSpeedShapeControl = class(TGraphicControl)
  private
    FDragging: Boolean;
    FMouseInControl: Boolean;
    FTC_State: TTC_State;
    FOnChangeState: TNotifyEvent;
    procedure CMButtonPressed(var Message: TMessage); message CM_BUTTONPRESSED;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMLButtonDblClk(var Message: TWMLButtonDown); message WM_LBUTTONDBLCLK;
    procedure SetClickedColor(const Value: TColor);
    procedure SetFixedBrush(const Value: TBrush);
    procedure SetFixedFont(const Value: TFont);
    procedure SetFixedPen(const Value: TPen);
    procedure SetMargin(Value: Integer);
    procedure SetRegularBrush(const Value: TBrush);
    procedure SetRegularFont(const Value: TFont);
    procedure SetRegularPen(const Value: TPen);
    procedure SetReservedBrush(const Value: TBrush);
    procedure SetSelected(Value: Boolean);
    procedure SetSelectedBrush(const Value: TBrush);
    procedure SetSelectedFont(const Value: TFont);
    procedure SetSelectedPen(const Value: TPen);
    procedure SetShape(Value: TShapeType);
    procedure SetTrackBrush(const Value: TBrush);
    procedure SetTrackFont(const Value: TFont);
    procedure SetTrackPen(const Value: TPen);
    procedure UpdateTracking;
    function GetTracked: Boolean;
    procedure SetTC_State(const Value: TTC_State);
  protected
    FMargin: Integer;
    FState: TInternalState;
    FClickedColor: TColor;
    FFixedBrush: TBrush;
    FFixedFont: TFont;
    FFixedPen: TPen;
    FRegularBrush: TBrush;
    FRegularFont: TFont;
    FRegularPen: TPen;
    FReservedBrush: TBrush;
    FSelected: Boolean;
    FSelectedBrush: TBrush;
    FSelectedFont: TFont;
    FSelectedPen: TPen;
    FShape: TShapeType;
    FTrackBrush: TBrush;
    FTrackFont: TFont;
    FTrackPen: TPen;
    function Draw(const Client: TRect; const Offset: TPoint): TRect;
    function DrawShape(const Client: TRect; const Offset: TPoint): TRect;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    procedure DrawButtonText(TextBounds: TRect; ButtonText: string; BiDiFlags: LongInt); dynamic;
    procedure HandleShapeStateBefore(HotTracked: Boolean; const Client: TRect;
      const Offset: TPoint); dynamic;
    procedure HandleShapeStateAfter(HotTracked: Boolean; const Client: TRect;
      const Offset: TPoint); dynamic;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    property MouseInControl: Boolean read FMouseInControl;
    procedure ChangeState; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
    property Tracked: Boolean read GetTracked;
  published
    procedure StyleChanged(Sender: TObject);
    property Action;
    property Anchors;
    property BiDiMode;
    property Caption;
    property ClickedColor: TColor read FClickedColor write SetClickedColor
      default clLtGray;
    property Constraints;
    property Enabled;
    property Margin: Integer read FMargin write SetMargin default -1;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TC_State: TTC_State read FTC_State write SetTC_State default
      scFree;
    property FixedBrush: TBrush read FFixedBrush write SetFixedBrush;
    property FixedFont: TFont read FFixedFont write SetFixedFont;
    property FixedPen: TPen read FFixedPen write SetFixedPen;
    property RegularBrush: TBrush read FRegularBrush write SetRegularBrush;
    property RegularFont: TFont read FRegularFont write SetRegularFont;
    property RegularPen: TPen read FRegularPen write SetRegularPen;
    property ReservedBrush: TBrush read FReservedBrush write SetReservedBrush;
    property Selected: Boolean read FSelected write SetSelected default false;
    property SelectedBrush: TBrush read FSelectedBrush write SetSelectedBrush;
    property SelectedFont: TFont read FSelectedFont write SetSelectedFont;
    property SelectedPen: TPen read FSelectedPen write SetSelectedPen;
    property Shape: TShapeType read FShape write SetShape default stRoundRect;
    property TrackBrush: TBrush read FTrackBrush write SetTrackBrush;
    property TrackFont: TFont read FTrackFont write SetTrackFont;
    property TrackPen: TPen read FTrackPen write SetTrackPen;
    property Visible;
    property OnChangeState: TNotifyEvent read FOnChangeState write
      FOnChangeState;
  end;

  TSpeedShapeEx = class(TSpeedShapeControl)
  end;

  TTicketControl = class(TSpeedShapeControl)
  private
    FColumn: Byte;
    FRow: Byte;
    FTicket_Kod: Integer;
    FTicket_Repert: Integer;
    FTicket_Tarifpl: Byte;
    FTicket_DateTime: TDateTime;
    FTicket_Type: Byte;
    FTicket_Owner: Integer;
    FOnChangeTarifpl: TNotifyEvent;
    FUsedByNet: Boolean;
    FOnChangeUsedByNet: TNotifyEvent;
    procedure SetColumn(const Value: Byte);
    procedure SetRow(const Value: Byte);
    procedure SetTicket_Kod(const Value: Integer);
    procedure SetTicket_Repert(const Value: Integer);
    procedure SetTicket_Tarifpl(const Value: Byte);
    procedure SetTicket_DateTime(const Value: TDateTime);
    procedure SetTicket_Type(const Value: Byte);
    procedure SetTicket_Owner(const Value: Integer);
    procedure SetUsedByNet(const Value: Boolean);
  protected
    procedure DrawButtonText(TextBounds: TRect; ButtonText: string; BiDiFlags:
      LongInt); override;
    procedure ChangeState; override;
    procedure ChangeTarifpl; dynamic;
    procedure ChangeUsedByNet; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
  published
    property Row: Byte read FRow write SetRow default 0;
    property Column: Byte read FColumn write SetColumn default 0;
    property Ticket_Kod: Integer read FTicket_Kod write SetTicket_Kod default 0;
    property Ticket_Tarifpl: Byte read FTicket_Tarifpl write SetTicket_Tarifpl
      default 0;
    property Ticket_Repert: Integer read FTicket_Repert write SetTicket_Repert
      default 0;
    property Ticket_DateTime: TDateTime read FTicket_DateTime write
      SetTicket_DateTime;
    property Ticket_Type: Byte read FTicket_Type write SetTicket_Type default 0;
    property Ticket_Owner: Integer read FTicket_Owner write SetTicket_Owner
      default 0;
    property UsedByNet: Boolean read FUsedByNet write SetUsedByNet default
      false;
    property OnChangeTarifpl: TNotifyEvent read FOnChangeTarifpl write
      FOnChangeTarifpl;
    property OnChangeUsedByNet: TNotifyEvent read FOnChangeUsedByNet write
      FOnChangeUsedByNet;
  end;

  TEnumHS = (hsDisabled, hsHybrid, hsEnabled);

const
  s_clReserved: string = 'clReserved=';
  clReserved: TColor = 12582911;
  clTrackReserved: TColor = 16744512;
  s_HSettting: string = 'HSettting=';
  HSettting: TEnumHS = hsEnabled;
  s_Global_Row_Show: string = 'Global_Row_Show=';
  Global_Row_Show: boolean = true;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('n0mad Controls', [TSpeedShapeEx, TTicketControl]);
end;

{ TSpeedShapeControl }

constructor TSpeedShapeControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(0, 0, 30, 30);
  ControlStyle := [csCaptureMouse, csDoubleClicks];
  ParentFont := false;
  // -------------------------------------------
  FMargin := -1;
  FTC_State := scFree;
  FSelected := false;
  FState := siUp;
  FShape := stRoundRect;
  // -------------------------------------------
  FClickedColor := clLtGray;
  // -------------------------------------------
  FFixedBrush := TBrush.Create;
  FFixedBrush.Color := clDkGray;
  FFixedBrush.OnChange := StyleChanged;
  //
  FFixedFont := TFont.Create;
  FFixedFont.Assign(Self.Font);
  FFixedFont.Color := clLtGray;
  {  FFixedFont.Style := [fsBold];}
  FFixedFont.OnChange := StyleChanged;
  //
  FFixedPen := TPen.Create;
  FFixedPen.Color := clBlack;
  {  FFixedPen.Width := 2;}
  FFixedPen.OnChange := StyleChanged;
  // -------------------------------------------
  FRegularBrush := TBrush.Create;
  FRegularBrush.Color := clWhite;
  FRegularBrush.OnChange := StyleChanged;
  //
  FRegularFont := TFont.Create;
  FRegularFont.Assign(Self.Font);
  FRegularFont.Color := clBlack;
  {  FRegularFont.Style := [fsBold];}
  FRegularFont.OnChange := StyleChanged;
  //
  FRegularPen := TPen.Create;
  FRegularPen.Color := clBlack;
  {  FRegularPen.Width := 2;}
  FRegularPen.OnChange := StyleChanged;
  // -------------------------------------------
  FReservedBrush := TBrush.Create;
  FReservedBrush.Color := clReserved;
  FReservedBrush.OnChange := StyleChanged;
  // -------------------------------------------
  FSelectedBrush := TBrush.Create;
  FSelectedBrush.Color := clRed;
  FSelectedBrush.OnChange := StyleChanged;
  //
  FSelectedFont := TFont.Create;
  FSelectedFont.Assign(Self.Font);
  FSelectedFont.Color := clWhite;
  FSelectedFont.Style := [fsBold];
  FSelectedFont.OnChange := StyleChanged;
  //
  FSelectedPen := TPen.Create;
  FSelectedPen.Color := clBlack;
  FSelectedPen.Width := 2;
  FSelectedPen.OnChange := StyleChanged;
  // -------------------------------------------
  FTrackBrush := TBrush.Create;
  FTrackBrush.Color := clYellow;
  FTrackBrush.OnChange := StyleChanged;
  //
  FTrackFont := TFont.Create;
  FTrackFont.Assign(Self.Font);
  FTrackFont.Color := clWhite;
  FTrackFont.Style := [fsBold];
  FTrackFont.OnChange := StyleChanged;
  //
  FTrackPen := TPen.Create;
  FTrackPen.Color := clAqua; //clBlue;
  FTrackPen.Width := 2;
  FTrackPen.OnChange := StyleChanged;
  //
  FOnChangeState := nil;
end;

destructor TSpeedShapeControl.Destroy;
begin
  inherited Destroy;
  FFixedBrush.Free;
  FFixedFont.Free;
  FFixedPen.Free;
  // -------------------------------------------
  FRegularBrush.Free;
  FRegularFont.Free;
  FRegularPen.Free;
  // -------------------------------------------
  FReservedBrush.Free;
  // -------------------------------------------
  FSelectedBrush.Free;
  FSelectedFont.Free;
  FSelectedPen.Free;
  // -------------------------------------------
  FTrackBrush.Free;
  FTrackFont.Free;
  FTrackPen.Free;
end;

procedure TSpeedShapeControl.DrawButtonText(TextBounds: TRect; ButtonText:
  string; BiDiFlags: LongInt);
var
  //  ShiftTextBounds: TRect;
  X, Y, W, H, S, WT, HT: integer;
  ST: string;
begin
  with Canvas do
  begin
    {
        Pen.Width := 1;
        Pen.Color := clBlack;
        Brush.Style := bsClear;
        Brush.Color := clNavy;
        Rectangle(TextBounds);
    }
    X := TextBounds.Left + Pen.Width div 2;
    Y := TextBounds.Top + Pen.Width div 2;
    W := Abs(TextBounds.Right - TextBounds.Left) - Pen.Width + 1;
    H := Abs(TextBounds.Bottom - TextBounds.Top) - Pen.Width + 1;
    if Pen.Width = 0 then
    begin
      Dec(W);
      Dec(H);
    end;
    if W < H then
      S := W
    else
      S := H;
    if Self.Shape in [stSquare, stRoundSquare, stCircle] then
    begin
      Inc(X, (W - S) div 2);
      Inc(Y, (H - S) div 2);
      W := S;
      H := S;
    end;
    ST := ButtonText;
    WT := TextWidth(ST);
    HT := TextHeight(ST);
    WT := X + W div 2 - WT div 2;
    HT := Y + H div 2 - HT div 2;
    Brush.Style := bsClear;
    if FState = siDisabled then
    begin
      Font.Color := clBtnHighlight;
      TextOut(WT + 1, HT + 1, ST);
      Font.Color := clBtnShadow;
    end;
    TextOut(WT, HT, ST);
    {
        Brush.Style := bsClear;
        if FState = siDisabled then
        begin
          ShiftTextBounds.Left := TextBounds.Left + 1;
          ShiftTextBounds.Top := TextBounds.Top + 1;
          ShiftTextBounds.Right := TextBounds.Right + 1;
          ShiftTextBounds.Bottom := TextBounds.Bottom + 1;
          Font.Color := clBtnHighlight;
          DrawText(Handle, PChar(ButtonText), Length(ButtonText), ShiftTextBounds,
            DT_CENTER or DT_VCENTER or BiDiFlags);
          Font.Color := clBtnShadow;
        end;
        DrawText(Handle, PChar(ButtonText), Length(ButtonText), TextBounds,
          DT_CENTER or DT_VCENTER or BiDiFlags);
    }
  end;
end;

procedure TSpeedShapeControl.HandleShapeStateBefore(HotTracked: Boolean; const
  Client: TRect; const Offset: TPoint);
var
  SaveState: TTC_State;
begin
  //  TTC_State = (scFree, scBroken, scReserved, scPrepared, scFixed, scFixedNoCash, scFixedCheq);
  //  TEnumHS = (hsDisabled, hsHybrid, hsEnabled);
  SaveState := FTC_State;
  if (FTC_State in [scFixedCheq]) and (HSettting in [hsEnabled]) then
    FTC_State := scFree;
  if FTC_State in [scReserved, scPrepared, scFixed, scFixedNoCash, scFixedCheq] then
  begin
    if FTC_State in [scReserved] then
      Canvas.Brush.Assign(FReservedBrush)
    else
      Canvas.Brush.Assign(FFixedBrush);
    if FTC_State in [scPrepared] then
      Canvas.Font.Assign(FSelectedFont)
    else
      Canvas.Font.Assign(FFixedFont);
  end
  else if (FTC_State in [scFree]) then
  begin
    if Selected then
    begin
      Canvas.Brush.Assign(FSelectedBrush);
      Canvas.Font.Assign(FSelectedFont);
    end
    else // not Fixed and not Selected
    begin
      Canvas.Brush.Assign(FRegularBrush);
      Canvas.Font.Assign(FRegularFont);
    end;
  end
  else
  begin // scBroken
    Canvas.Brush.Assign(FRegularBrush);
    Canvas.Brush.Color := clBtnFace;
    Canvas.Font.Assign(FRegularFont);
    Canvas.Font.Color := clBtnText;
    Canvas.Font.Style := Canvas.Font.Style + [fsBold]
  end;
  //----------------------------------------
  if HotTracked then
  begin
    Canvas.Pen.Assign(FTrackPen);
    if Selected then
    begin
      if FTC_State in [scReserved] then
        Canvas.Pen.Color := clTrackReserved
      else
        Canvas.Pen.Color := FTrackBrush.Color;
    end
    else if FTC_State in [scFree] then
    begin
      Canvas.Brush.Color := FTrackBrush.Color;
    end;
    case FState of
      {
      siUp:
        begin
        end;
      }
      siDown:
        begin
          Canvas.Brush.Assign(FRegularBrush);
          Canvas.Brush.Color := FClickedColor;
          Canvas.Font.Assign(FRegularFont);
        end;
      siDisabled:
        begin
          Canvas.Brush.Assign(FRegularBrush);
          Canvas.Brush.Color := clBtnFace;
          Canvas.Font.Assign(FRegularFont);
          Canvas.Pen.Color := clBtnShadow;
        end;
      {
      siSelected:
        begin
        end;
      }
    end;
  end
  else // not HotTracked
  begin
    Canvas.Pen.Assign(FRegularPen);
    if FTC_State in [scPrepared] then
      Canvas.Pen.Color := FRegularBrush.Color
    else if (not (FTC_State in [scFree])) and Selected then
      Canvas.Pen.Color := FSelectedBrush.Color;
    case FState of
      {
      siUp:
        begin
        end;
      }
      siDown:
        begin
          Canvas.Brush.Assign(FRegularBrush);
          Canvas.Brush.Color := FClickedColor;
          Canvas.Font.Assign(FRegularFont);
          Canvas.Pen.Width := Canvas.Pen.Width + 1;
        end;
      siDisabled:
        begin
          Canvas.Brush.Assign(FRegularBrush);
          Canvas.Brush.Color := clBtnFace;
          Canvas.Font.Assign(FRegularFont);
          Canvas.Pen.Color := clBtnShadow;
          Canvas.Pen.Width := Canvas.Pen.Width + 1;
        end;
      siSelected:
        begin
          if not (FTC_State in [scFree]) then
            Canvas.Pen.Width := Canvas.Pen.Width + 1;
        end;
    end;
  end;
  FTC_State := SaveState;
end;

procedure TSpeedShapeControl.HandleShapeStateAfter(HotTracked: Boolean; const
  Client: TRect; const Offset: TPoint);
var
  wx, wy: integer;
begin
  //  TTC_State = (scFree, scBroken, scReserved, scPrepared, scFixed, scFixedNoCash, scFixedCheq);
  //  TEnumHS = (hsDisabled, hsHybrid, hsEnabled);
  if (FState <> siDisabled) then
  begin
    wx := Offset.x + Canvas.Pen.Width;
    wy := Offset.y + Canvas.Pen.Width;
    if (FTC_State in [scBroken]) then
    begin
      Canvas.Pen.Width := 2;
      Canvas.Pen.Color := clBtnShadow;
      Canvas.MoveTo(wx, wy);
      Canvas.LineTo(Width - wx, Height - wy);
      Canvas.MoveTo(Width - wx, wy);
      Canvas.LineTo(wx, Height - wy);
    end
    else if (FTC_State in [scFixedCheq]) and (HSettting in [hsHybrid]) then
    begin
      Canvas.Pen.Width := 0;
      Canvas.Brush.Style := bsClear;
      // Canvas.Brush.Color := clBtnShadow;
      Canvas.Brush.Color := FRegularBrush.Color;
      // Canvas.Brush.Color := clBtnFace;
      Canvas.Rectangle(wx, (3 * Height div 4) - wy, (Width div 4) + wx, Height -
        wy);
    end
    else if (FTC_State in [scReserved, scFixedNoCash]) then
    begin
      {
      Canvas.MoveTo(wx + Width div 6, (2 * Height div 3) - wy);
      Canvas.LineTo(wx + Width div 6, Height - wy);
      }
      {
      Canvas.MoveTo(wx, 2 * Height div 3 - wy);
      Canvas.LineTo(Width div 3 + wx, Height - wy);
      Canvas.MoveTo(wx, Height - wy);
      Canvas.LineTo(Width div 3 + wx, 2 * Height div 3 - wy);
      }
      {
      Canvas.MoveTo(wx, (2 * Height div 3) - wy);
      Canvas.LineTo((Width div 3) + wx, Height - wy);
      }
      Canvas.Pen.Width := 0;
      //Canvas.Brush.Style := bsClear;
      if (FTC_State in [scReserved]) then
        Canvas.Brush.Color := FFixedBrush.Color
      else
        Canvas.Brush.Color := FTrackBrush.Color;
      //Canvas.Brush.Color := clBtnFace;
      //Canvas.Brush.Color := clBtnShadow;
      Canvas.Rectangle(wx, (3 * Height div 4) - wy, (Width div 4) + wx, Height -
        wy);
    end;
  end;
end;

function TSpeedShapeControl.DrawShape(const Client: TRect; const Offset:
  TPoint): TRect;
var
  X, Y, W, H, S: Integer;
  SaveColor: TColor;
begin
  with Canvas do
  begin
    X := Client.Left + Pen.Width div 2;
    Y := Client.Top + Pen.Width div 2;
    W := (Client.Right - Client.Left) - Pen.Width + 1;
    H := (Client.Bottom - Client.Top) - Pen.Width + 1;
    if Pen.Width = 0 then
    begin
      Dec(W);
      Dec(H);
    end;
    if W < H then
      S := W
    else
      S := H;
    if FShape in [stSquare, stRoundSquare, stCircle] then
    begin
      Inc(X, (W - S) div 2);
      Inc(Y, (H - S) div 2);
      W := S;
      H := S;
    end;
    if FState = siDisabled then
    begin
      SaveColor := Canvas.Pen.Color;
      Canvas.Pen.Color := clBtnHighlight;
      case FShape of
        stRectangle, stSquare:
          Rectangle(X + 1, Y + 1, X + W + 1, Y + H + 1);
        stRoundRect, stRoundSquare:
          RoundRect(X + 1, Y + 1, X + W + 1, Y + H + 1, S div 4, S div 4);
        stCircle, stEllipse:
          Ellipse(X + 1, Y + 1, X + W + 1, Y + H + 1);
      end;
      Canvas.Pen.Color := SaveColor;
    end;
    case FShape of
      stRectangle, stSquare:
        Rectangle(X, Y, X + W, Y + H);
      stRoundRect, stRoundSquare:
        RoundRect(X, Y, X + W, Y + H, S div 4, S div 4);
      stCircle, stEllipse:
        Ellipse(X, Y, X + W, Y + H);
    end;
    Result.Left := X;
    Result.Top := Y;
    Result.Right := X + W;
    Result.Bottom := Y + H;
    if not Odd(Pen.Width) then
    begin
      Dec(Result.Left);
      Dec(Result.Top);
    end;
    InflateRect(Result, -Pen.Width div 2, -Pen.Width div 2);
  end;
end;

function TSpeedShapeControl.Draw(const Client: TRect; const Offset: TPoint):
  TRect;
begin
  Result := DrawShape(Client, Offset);
  DrawButtonText(Result, Caption, DrawTextBiDiModeFlags(0));
end;

procedure TSpeedShapeControl.Paint;
var
  PaintRect: TRect;
  Offset: TPoint;
  _Margin: Integer;
begin
  if not Enabled then
  begin
    FState := siDisabled;
    FDragging := false;
  end
  else if FState = siDisabled then
    if FSelected then
      FState := siSelected
    else
      FState := siUp;
  {  Canvas.Pen.Width := 1;
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Style := bsClear;
    Canvas.Brush.Color := clNavy;
    Canvas.Rectangle(0, 0, Width, Height);}
  PaintRect := Rect(0, 0, Width, Height);
  if FMargin >= 0 then
    _Margin := FMargin
  else
    _Margin := Trunc(Max(Width, Height) / 30) + 1;
  if (not GetTracked) or (FState = siDown) then
  begin
    InflateRect(PaintRect, -_Margin, -_Margin);
    Offset.X := _Margin;
    Offset.Y := _Margin;
    HandleShapeStateBefore(false, PaintRect, Offset);
  end
  else //
  begin
    Offset.X := 0;
    Offset.Y := 0;
    HandleShapeStateBefore(true, PaintRect, Offset);
  end;
  Draw(PaintRect, Offset);
  HandleShapeStateAfter(not ((not GetTracked) or (FState = siDown)), PaintRect,
    Offset);
end;

procedure TSpeedShapeControl.UpdateTracking;
var
  P: TPoint;
  Msg: TMessage;
begin
  if Enabled then
  begin
    GetCursorPos(P);
    FMouseInControl := not (FindDragTarget(P, true) = Self);
    if FMouseInControl then
      Perform(CM_MOUSELEAVE, 0, 0)
    else
    begin
      Perform(CM_MOUSEENTER, 0, 0);
      if (Parent <> nil) then
      begin
        Msg.Msg := CM_BUTTONPRESSED;
        Msg.WParam := 1;
        Msg.LParam := Longint(Self);
        Msg.Result := 0;
        Parent.Broadcast(Msg);
      end;
    end;
  end;
end;

procedure TSpeedShapeControl.Loaded;
var
  State: TButtonState;
begin
  inherited Loaded;
  if Enabled then
    State := bsUp
  else
    State := bsDisabled;
  if State = bsUp then {foo}
    ;
end;

procedure TSpeedShapeControl.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then
  begin
    {    if not FSelected then
        begin}
    FState := siDown;
    Invalidate;
    {    end;}
    FDragging := true;
  end;
end;

procedure TSpeedShapeControl.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewState: TInternalState;
begin
  inherited MouseMove(Shift, X, Y);
  if FDragging then
  begin
    if not FSelected then
      NewState := siUp
    else
      NewState := siSelected;
    if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then
      {if FSelected then NewState := siSelected else}NewState := siDown;
    if NewState <> FState then
    begin
      FState := NewState;
      Invalidate;
    end;
  end
  else if not FMouseInControl then
    UpdateTracking;
end;

procedure TSpeedShapeControl.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  DoClick: Boolean;
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FDragging then
  begin
    FDragging := false;
    DoClick := (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <=
      ClientHeight);
    if DoClick then
    begin
      SetSelected(not FSelected);
      if FSelected then
        Repaint;
    end
    else
    begin
      if FSelected then
        FState := siSelected;
      Repaint;
    end;
    if DoClick then
      Click;
    UpdateTracking;
  end;
end;

procedure TSpeedShapeControl.Click;
begin
  inherited Click;
end;

procedure TSpeedShapeControl.SetSelected(Value: Boolean);
begin
  if Value <> FSelected then
  begin
    FSelected := Value;
    if Value then
    begin
      if FState = siUp then
        Invalidate;
      FState := siSelected
    end
    else
    begin
      FState := siUp;
      Repaint;
    end;
  end;
end;

procedure TSpeedShapeControl.SetMargin(Value: Integer);
begin
  if (Value <> FMargin) and (Value >= -1) then
  begin
    FMargin := Value;
    Invalidate;
  end;
end;

procedure TSpeedShapeControl.WMLButtonDblClk(var Message: TWMLButtonDown);
begin
  inherited;
  if FSelected then
    DblClick;
end;

procedure TSpeedShapeControl.CMEnabledChanged(var Message: TMessage);
begin
  UpdateTracking;
  Repaint;
end;

procedure TSpeedShapeControl.CMButtonPressed(var Message: TMessage);
var
  Sender: TSpeedShapeControl;
begin
  if Message.WParam = 1 then
  begin
    Sender := TSpeedShapeControl(Message.LParam);
    if Sender <> Self then
    try
      if (Sender = nil) or (Sender.MouseInControl and FMouseInControl) then
      begin
        FMouseInControl := false;
        //          FState := bsUp;
        Invalidate;
      end;
    except
    end;
  end;
end;

procedure TSpeedShapeControl.CMDialogChar(var Message: TCMDialogChar);
begin
{$IFDEF def_UseForms}
  with Message do
    if IsAccel(CharCode, Caption) and Enabled and Visible and
      (Parent <> nil) and Parent.Showing then
    begin
      Click;
      Result := 1;
    end
    else
      inherited;
{$ENDIF}
end;

procedure TSpeedShapeControl.CMFontChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TSpeedShapeControl.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TSpeedShapeControl.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  { Don't draw a border if DragMode <> dmAutomatic since this button is meant to
    be used as a dock client. }
  if not FMouseInControl and Enabled and (DragMode <> dmAutomatic)
    and (GetCapture = 0) then
  begin
    FMouseInControl := true;
    Repaint;
  end;
end;

procedure TSpeedShapeControl.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FMouseInControl and Enabled and not FDragging then
  begin
    FMouseInControl := false;
    Invalidate;
  end;
end;

procedure TSpeedShapeControl.ActionChange(Sender: TObject; CheckDefaults:
  Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
end;

procedure TSpeedShapeControl.SetRegularBrush(const Value: TBrush);
begin
  FRegularBrush.Assign(Value);
end;

procedure TSpeedShapeControl.SetClickedColor(const Value: TColor);
begin
  if FClickedColor <> Value then
  begin
    FClickedColor := Value;
    Invalidate;
  end;
end;

procedure TSpeedShapeControl.SetSelectedFont(const Value: TFont);
begin
  FSelectedFont.Assign(Value);
end;

procedure TSpeedShapeControl.SetTrackBrush(const Value: TBrush);
begin
  FTrackBrush.Assign(Value);
end;

procedure TSpeedShapeControl.SetTrackPen(const Value: TPen);
begin
  FTrackPen.Assign(Value);
end;

procedure TSpeedShapeControl.SetRegularPen(const Value: TPen);
begin
  FRegularPen.Assign(Value);
end;

procedure TSpeedShapeControl.StyleChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TSpeedShapeControl.SetShape(Value: TShapeType);
begin
  if FShape <> Value then
  begin
    FShape := Value;
    Invalidate;
  end;
end;

procedure TSpeedShapeControl.SetRegularFont(const Value: TFont);
begin
  FRegularFont := Value;
end;

procedure TSpeedShapeControl.SetTrackFont(const Value: TFont);
begin
  FTrackFont := Value;
end;

procedure TSpeedShapeControl.SetFixedBrush(const Value: TBrush);
begin
  FFixedBrush := Value;
end;

procedure TSpeedShapeControl.SetFixedFont(const Value: TFont);
begin
  FFixedFont := Value;
end;

procedure TSpeedShapeControl.SetFixedPen(const Value: TPen);
begin
  FFixedPen := Value;
end;

procedure TSpeedShapeControl.SetSelectedBrush(const Value: TBrush);
begin
  FSelectedBrush := Value;
end;

procedure TSpeedShapeControl.SetSelectedPen(const Value: TPen);
begin
  FSelectedPen := Value;
end;

function TSpeedShapeControl.GetTracked: Boolean;
begin
  Result := (FMouseInControl and (FState <> siDisabled));
end;

procedure TSpeedShapeControl.SetTC_State(
  const Value: TTC_State);
begin
  if Value <> FTC_State then
  begin
    FTC_State := Value;
    ChangeState;
    Invalidate;
  end;
end;

procedure TSpeedShapeControl.ChangeState;
begin
  if Assigned(FOnChangeState) then
    FOnChangeState(Self);
end;

procedure TSpeedShapeControl.SetReservedBrush(const Value: TBrush);
begin
  FReservedBrush.Assign(Value);
end;

{ TTicketControl }

constructor TTicketControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRow := 0;
  FColumn := 0;
  FTicket_Kod := 0;
  FTicket_Repert := 0;
  FTicket_Tarifpl := 0;
  FTicket_DateTime := Now;
  FTicket_Type := 0;
  Ticket_Owner := 0;
  UsedByNet := false;
  //
  FOnChangeTarifpl := nil;
  FOnChangeUsedByNet := nil;
end;

destructor TTicketControl.Destroy;
begin
  inherited Destroy;
end;

procedure TTicketControl.DrawButtonText(TextBounds: TRect; ButtonText: string;
  BiDiFlags: Integer);
var
  Bounds: TRect;
  W, H: integer;
begin
  W := (TextBounds.Right - TextBounds.Left);
  H := (TextBounds.Bottom - TextBounds.Top);
  W := W div 3;
  if FShape in [stEllipse, stCircle] then
    H := H div 3
  else
    H := H div 2;
  if Global_Row_Show then
  begin
    Bounds.Left := TextBounds.Left;
    Bounds.Top := TextBounds.Top;
    Bounds.Right := TextBounds.Right - W;
    Bounds.Bottom := TextBounds.Bottom - H;
    inherited DrawButtonText(Bounds, IntToStr(FRow), BiDiFlags);
  end;
  Bounds.Left := TextBounds.Left + W;
  Bounds.Top := TextBounds.Top + H;
  Bounds.Right := TextBounds.Right;
  Bounds.Bottom := TextBounds.Bottom;
  inherited DrawButtonText(Bounds, IntToStr(FColumn), BiDiFlags);
end;

procedure TTicketControl.SetColumn(const Value: Byte);
begin
  if Value <> FColumn then
  begin
    FColumn := Value;
    Invalidate;
  end;
end;

procedure TTicketControl.SetRow(const Value: Byte);
begin
  if Value <> FRow then
  begin
    FRow := Value;
    Invalidate;
  end;
end;

procedure TTicketControl.SetTicket_Kod(const Value: Integer);
begin
  FTicket_Kod := Value;
end;

procedure TTicketControl.SetTicket_Tarifpl(const Value: Byte);
begin
  if FTicket_Tarifpl <> Value then
  begin
    FTicket_Tarifpl := Value;
    ChangeTarifpl;
    Invalidate;
  end;
end;

procedure TTicketControl.SetTicket_Repert(const Value: Integer);
begin
  FTicket_Repert := Value;
end;

procedure TTicketControl.SetTicket_DateTime(const Value: TDateTime);
begin
  FTicket_DateTime := Value;
end;

procedure TTicketControl.SetTicket_Type(const Value: Byte);
begin
  FTicket_Type := Value;
end;

procedure TTicketControl.SetTicket_Owner(const Value: Integer);
begin
  FTicket_Owner := Value;
end;

procedure TTicketControl.Click;
begin
  if (FTC_State in [scPrepared]) then
    SetSelected(not FSelected);
  inherited Click;
end;

procedure TTicketControl.ChangeState;
begin
  if FTC_State in [scFree] then
  begin
    {
        FTicket_Kod: Integer;
        FTicket_Repert: Integer;
        FTicket_Tarifpl: Byte;
        FTicket_DateTime: TDateTime;
        FTicket_Type: Byte;
        FTicket_Owner: Integer;
    }
    FTicket_Kod := 0;
    FTicket_Repert := 0;
    FTicket_Tarifpl := 0;
    FTicket_DateTime := Now;
    FTicket_Owner := 0;
  end;
  if FTC_State in [scReserved] then
  begin
    if FTicket_Owner = 0 then
    begin
      //
    end;
  end;
  if FTC_State in [scPrepared] then
  begin
    FSelected := true;
    FTicket_Kod := -1;
    if FTicket_Owner = 0 then
    begin
      FTicket_DateTime := Now;
    end;
  end;
  if FTC_State in [scFixed, scFixedNoCash, scFixedCheq] then
  begin
    if FTicket_Owner = 0 then
    begin
      //
    end;
  end;
  inherited ChangeState;
end;

procedure TTicketControl.ChangeTarifpl;
begin
  if Assigned(FOnChangeTarifpl) then
    FOnChangeTarifpl(Self);
end;

procedure TTicketControl.SetUsedByNet(const Value: Boolean);
begin
  if FUsedByNet <> Value then
  begin
    FUsedByNet := Value;
    ChangeUsedByNet;
    Invalidate;
  end;
end;

procedure TTicketControl.ChangeUsedByNet;
begin
  if Assigned(FOnChangeUsedByNet) then
    FOnChangeUsedByNet(Self);
end;

initialization
  length(s_clReserved + s_HSettting + s_Global_Row_Show);

end.

