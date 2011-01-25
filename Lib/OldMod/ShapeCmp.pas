unit ShapeCmp;

interface

{$DEFINE def_ShapeControl}

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
{$IFDEF def_ShapeControl}
  Forms,
{$ENDIF}
  ExtCtrls,
  Math,
  Buttons,
  Imglist,
  ActnList;

type

  TWCBitBtn = class(TBitBtn)
  protected
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TButtonState = (bsUp, bsDisabled, bsDown, bsExclusive);

{$IFDEF def_ShapeControl}
  TCustomShapeControl = class(TShape)
  private
    FSelected: boolean;
    FHotTracked: boolean;
    FFont: TFont;
    FSelBrush: TBrush;
    FSelFont: TFont;
    FSelPen: TPen;
    FTrackBrush: TBrush;
    FTrackFont: TFont;
    FTrackPen: TPen;
    FMouseInControl: Boolean;
    procedure SetSelected(Value: boolean);
    procedure SetHotTracked(const Value: boolean);
    procedure SetFont(const Value: TFont);
    procedure SetSelBrush(Value: TBrush);
    procedure SetSelFont(const Value: TFont);
    procedure SetSelPen(Value: TPen);
    procedure SetTrackBrush(const Value: TBrush);
    procedure SetTrackFont(const Value: TFont);
    procedure SetTrackPen(const Value: TPen);
    procedure UpdateTracking;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property MouseInControl: Boolean read FMouseInControl;
  published
    property Selected: boolean read FSelected write SetSelected default False;
    property HotTracked: boolean read FHotTracked write SetHotTracked default False;
    procedure StyleChanged(Sender: TObject);
    property Font: TFont read FFont write SetFont;
    property SelBrush: TBrush read FSelBrush write SetSelBrush;
    property SelFont: TFont read FSelFont write SetSelFont;
    property SelPen: TPen read FSelPen write SetSelPen;
    property TrackBrush: TBrush read FTrackBrush write SetTrackBrush;
    property TrackFont: TFont read FTrackFont write SetTrackFont;
    property TrackPen: TPen read FTrackPen write SetTrackPen;
  end;

  TShapeCell = class(TCustomShapeControl)
  private
    FRow: Byte;
    FColumn: Byte;
    procedure SetRow(Value: Byte);
    procedure SetColumn(Value: Byte);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Row: Byte read FRow write SetRow default 0;
    property Column: Byte read FColumn write SetColumn default 0;
  end;

  TShapePanel = class(TCustomShapeControl)
  private
    FCaption: string;
    procedure SetCaption(const Value: string);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption: string read FCaption write SetCaption;
  end;
{$ENDIF}

  TSpeedControl = class(TGraphicControl)
  private
    FDown: Boolean;
    FDragging: Boolean;
    FFixed: Boolean;
    FMargin: Integer;
    FMouseInControl: Boolean;
    FBrush: TBrush;
    FPen: TPen;
    FDownColor: TColor;
    FDownFont: TFont;
    FClickedColor: TColor;
    FTrackBrush: TBrush;
    FTrackPen: TPen;
    FShape: TShapeType;
    FFixedColor: TColor;
    procedure UpdateExclusive;
    procedure SetDown(Value: Boolean);
    procedure SetFixed(Value: Boolean);
    procedure SetMargin(Value: Integer);
    procedure SetShape(Value: TShapeType);
    procedure UpdateTracking;
    procedure WMLButtonDblClk(var Message: TWMLButtonDown); message WM_LBUTTONDBLCLK;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMButtonPressed(var Message: TMessage); message CM_BUTTONPRESSED;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
//    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure SetBrush(const Value: TBrush);
    procedure SetClickedColor(const Value: TColor);
    procedure SetDownColor(const Value: TColor);
    procedure SetDownFont(const Value: TFont);
    procedure SetTrackBrush(const Value: TBrush);
    procedure SetTrackPen(const Value: TPen);
    procedure SetPen(const Value: TPen);
    procedure SetFixedColor(const Value: TColor);
  protected
    FState: TButtonState;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure DrawButtonText(TextBounds: TRect; ButtonText: string; BiDiFlags: LongInt); dynamic;
    function DrawShape(const Client: TRect; const Offset: TPoint): TRect;
    function Draw(const Client: TRect; const Offset: TPoint): TRect;
    procedure Paint; override;
    property MouseInControl: Boolean read FMouseInControl;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
  published
    property Action;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property Down: Boolean read FDown write SetDown default False;
    property Caption;
    property Enabled;
    property Margin: Integer read FMargin write SetMargin default -1;
    property ParentFont;
    property ParentShowHint;
    property ParentBiDiMode;
    property PopupMenu;
    property ShowHint;
    property Fixed: Boolean read FFixed write SetFixed default False;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    procedure StyleChanged(Sender: TObject);
    property Brush: TBrush read FBrush write SetBrush;
    property Pen: TPen read FPen write SetPen;
    property TrackBrush: TBrush read FTrackBrush write SetTrackBrush;
    property TrackPen: TPen read FTrackPen write SetTrackPen;
    property DownColor: TColor read FDownColor write SetDownColor default clRed;
    property DownFont: TFont read FDownFont write SetDownFont;
    property ClickedColor: TColor read FClickedColor write SetClickedColor default clLtGray;
    property Shape: TShapeType read FShape write SetShape default stRoundRect;
    property FixedColor: TColor read FFixedColor write SetFixedColor default clLime;
  end;

  TSpeedPanel = class(TSpeedControl)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
  published
  end;

  TSpeedShape = class(TSpeedControl)
  private
    FColumn: Byte;
    FRow: Byte;
    FTicket_Kod: Byte;
    FTicket_Repert: Byte;
    FTicket_Tarifpl: Byte;
    FTicket_DateTime: TDateTime;
    FTicket_State: Byte;
    procedure SetColumn(const Value: Byte);
    procedure SetRow(const Value: Byte);
    procedure SetTicket_Kod(const Value: Byte);
    procedure SetTicket_Repert(const Value: Byte);
    procedure SetTicket_Tarifpl(const Value: Byte);
    procedure SetTicket_DateTime(const Value: TDateTime);
    procedure SetTicket_State(const Value: Byte);
  protected
    procedure DrawButtonText(TextBounds: TRect; ButtonText: string; BiDiFlags: LongInt); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Row: Byte read FRow write SetRow default 0;
    property Column: Byte read FColumn write SetColumn default 0;
    property Ticket_Kod: Byte read FTicket_Kod write SetTicket_Kod default 0;
    property Ticket_Tarifpl: Byte read FTicket_Tarifpl write SetTicket_Tarifpl default 0;
    property Ticket_Repert: Byte read FTicket_Repert write SetTicket_Repert default 0;
    property Ticket_DateTime: TDateTime read FTicket_DateTime write SetTicket_DateTime;
    property Ticket_State: Byte read FTicket_State write SetTicket_State default 0;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('n0mad Controls', [
  {$IFDEF def_ShapeControl}
  TShapeCell, TShapePanel,
  {$ENDIF}
  TSpeedShape, TSpeedPanel,
  TWCBitBtn
  ]);
end;

{$IFDEF def_ShapeControl}
{ TCustomShapeControl }

constructor TCustomShapeControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(0, 0, 32, 32);
  FSelected := false;
  FHotTracked := false;

  FFont := TFont.Create;
  FFont.OnChange := StyleChanged;
  
  FSelBrush := TBrush.Create;
  FSelBrush.Color := clRed;
  FSelBrush.OnChange := StyleChanged;

  FSelFont := TFont.Create;
  FSelFont.Color := clWhite;
  FSelFont.OnChange := StyleChanged;
  
  FSelPen := TPen.Create;
  FSelPen.Color := clBlack;
  FSelPen.OnChange := StyleChanged;
  
  FTrackBrush := TBrush.Create;
  FTrackBrush.Color := clYellow;
  FTrackBrush.OnChange := StyleChanged;

  FTrackFont := TFont.Create;
  FTrackFont.Color := clBlack;
  FTrackFont.OnChange := StyleChanged;

  FTrackPen := TPen.Create;
  FTrackPen.Color := clBlue;
  FTrackPen.Width := 2;
  FTrackPen.OnChange := StyleChanged;
end;

destructor TCustomShapeControl.Destroy;
begin
  FFont.Free;
  FSelBrush.Free;
  FSelFont.Free;
  FSelPen.Free;
  FTrackBrush.Free;
  FTrackFont.Free;
  FTrackPen.Free;
  inherited Destroy;
end;

procedure TCustomShapeControl.Paint;
var
  X, Y, W, H, S: Integer;
begin
  with Canvas do
  begin
    if FSelected then
    begin
      if FHotTracked and FMouseInControl then
      begin
        Brush.Assign(FSelBrush);
        Font.Assign(FTrackFont);
        Pen.Assign(FTrackPen);
      end
      else
      begin
        Brush.Assign(FSelBrush);
        Font.Assign(FSelFont);
        Pen.Assign(FSelPen);
      end;
    end
    else
    begin
      if FHotTracked and FMouseInControl then
      begin
        Brush.Assign(FTrackBrush);
        Font.Assign(FTrackFont);
        Pen.Assign(FTrackPen);
      end
      else
      begin
        inherited Paint;
        Font.Assign(FFont);
      end;
    end;
    X := Pen.Width div 2;
    Y := X;
    W := Width - Pen.Width + 1;
    H := Height - Pen.Width + 1;
    if Pen.Width = 0 then
    begin
      Dec(W);
      Dec(H);
    end;
    if W < H then S := W else S := H;
    if Self.Shape in [stSquare, stRoundSquare, stCircle] then
    begin
      Inc(X, (W - S) div 2);
      Inc(Y, (H - S) div 2);
      W := S;
      H := S;
    end;
    if FSelected or (FHotTracked and FMouseInControl)then
      case Self.Shape of
        stRectangle, stSquare:
          Rectangle(X, Y, X + W, Y + H);
        stRoundRect, stRoundSquare:
          RoundRect(X, Y, X + W, Y + H, S div 4, S div 4);
        stCircle, stEllipse:
          Ellipse(X, Y, X + W, Y + H);
      end;
  end;
end;

procedure TCustomShapeControl.StyleChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TCustomShapeControl.SetSelected(Value: boolean);
begin
  if Value <> FSelected then
  begin
    FSelected := Value;
    Invalidate;
  end;
end;

procedure TCustomShapeControl.SetHotTracked(const Value: boolean);
begin
  if Value <> FHotTracked then
  begin
    FHotTracked := Value;
    Invalidate;
  end;
end;

procedure TCustomShapeControl.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TCustomShapeControl.SetSelPen(Value: TPen);
begin
  FSelBrush.Assign(Value);
end;

procedure TCustomShapeControl.SetSelBrush(Value: TBrush);
begin
  FSelBrush.Assign(Value);
end;

procedure TCustomShapeControl.SetSelFont(const Value: TFont);
begin
  FSelFont.Assign(Value);
end;

procedure TCustomShapeControl.SetTrackBrush(const Value: TBrush);
begin
  FTrackBrush.Assign(Value);
end;

procedure TCustomShapeControl.SetTrackFont(const Value: TFont);
begin
  FTrackFont.Assign(Value);
end;

procedure TCustomShapeControl.SetTrackPen(const Value: TPen);
begin
  FTrackPen.Assign(Value);
end;

procedure TCustomShapeControl.UpdateTracking;
var
  P: TPoint;
begin
  if FHotTracked then
  begin
    if Enabled then
    begin
      GetCursorPos(P);
      FMouseInControl := not (FindDragTarget(P, True) = Self);
      if FMouseInControl then
        Perform(CM_MOUSELEAVE, 0, 0)
      else
        Perform(CM_MOUSEENTER, 0, 0);
    end;
  end;
end;

procedure TCustomShapeControl.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  { Don't draw a border if DragMode <> dmAutomatic since this button is meant to 
    be used as a dock client. }
  if FHotTracked and not FMouseInControl and Enabled and (DragMode <> dmAutomatic) 
    and (GetCapture = 0) then
  begin
    FMouseInControl := True;
    Repaint;
  end;
end;

procedure TCustomShapeControl.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FHotTracked and FMouseInControl and Enabled then
  begin
    FMouseInControl := False;
    Invalidate;
  end;
end;

procedure TCustomShapeControl.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then
  begin
    Invalidate;
  end;
end;
    
procedure TCustomShapeControl.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  if not FMouseInControl then
    UpdateTracking;
end;
    
procedure TCustomShapeControl.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
end;

{ TShapeCell }

constructor TShapeCell.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRow := 0;
  FColumn := 0;
end;

destructor TShapeCell.Destroy;
begin
  inherited Destroy;
end;

procedure TShapeCell.Paint;
var
  X, Y, W, H, S, WT, HT: integer;
  ST: string;
begin
  inherited Paint;
  with Canvas do
  begin
    X := Pen.Width div 2;
    Y := X;
    W := Width - Pen.Width + 1;
    H := Height - Pen.Width + 1;
    if Pen.Width = 0 then
    begin
      Dec(W);
      Dec(H);
    end;
    if W < H then S := W else S := H;
    if Self.Shape in [stSquare, stRoundSquare, stCircle] then
    begin
      Inc(X, (W - S) div 2);
      Inc(Y, (H - S) div 2);
      W := S;
      H := S;
    end;
    ST := IntToStr(FRow);
    WT := TextWidth(ST);
    HT := TextHeight(ST);
    WT := X + W div 4 - WT div 2;
    HT := Y + H div 4 - HT div 2;
    TextOut(WT, HT, ST);
    ST := IntToStr(FColumn);
    WT := TextWidth(ST);
    HT := TextHeight(ST);
    WT := X + 3 * W div 4 - WT div 2 - 1;
    HT := Y + 3 * H div 4 - HT div 2 - 1;
    TextOut(WT, HT, ST);
  end;
end;

procedure TShapeCell.SetColumn(Value: Byte);
begin
  if Value <> FColumn then
  begin
    FColumn := Value;
    Invalidate;
  end;
end;

procedure TShapeCell.SetRow(Value: Byte);
begin
  if Value <> FRow then
  begin
    FRow := Value;
    Invalidate;
  end;
end;

{ TShapePanel }

constructor TShapePanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaption := '';
  FHotTracked := true;

  Self.Brush.Color := clBtnFace;
  FFont.Color := clWindowText;
  Self.Pen.Color := clBtnShadow;

  FSelBrush.Color := cl3DLight;
  FSelFont.Color := cl3DDkShadow;
  FSelPen.Color := cl3DDkShadow;
  
  FTrackBrush.Color := clBtnShadow;
  FTrackFont.Color := clWindowText;
  FTrackPen.Color := clWindowText;
end;

destructor TShapePanel.Destroy;
begin
  inherited Destroy;
end;

procedure TShapePanel.Paint;
var
  X, Y, W, H, S, WT, HT: integer;
  ST: string;
begin
  inherited Paint;
  with Canvas do
  begin
    X := Pen.Width div 2;
    Y := X;
    W := Width - Pen.Width + 1;
    H := Height - Pen.Width + 1;
    if Pen.Width = 0 then
    begin
      Dec(W);
      Dec(H);
    end;
    if W < H then S := W else S := H;
    if Self.Shape in [stSquare, stRoundSquare, stCircle] then
    begin
      Inc(X, (W - S) div 2);
      Inc(Y, (H - S) div 2);
      W := S;
      H := S;
    end;
    ST := FCaption;
    WT := TextWidth(ST);
    HT := TextHeight(ST);
    WT := X + W div 2 - WT div 2;
    HT := Y + H div 2 - HT div 2;
    TextOut(WT, HT, ST);
  end;
end;

procedure TShapePanel.SetCaption(const Value: string);
begin
  if Value <> FCaption then
  begin
    FCaption := Value;
    Invalidate;
  end;
end;
{$ENDIF}

{ TSpeedControl }

constructor TSpeedControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(0, 0, 30, 30);
  ControlStyle := [csCaptureMouse, csDoubleClicks];
  ParentFont := True;
  Color := clBlack;
  FMargin := -1;
  FFixed := False;

  Self.Font.OnChange := StyleChanged;
  FShape := stRoundRect;

  FBrush := TBrush.Create;
  FBrush.Color := clWhite;
  FBrush.OnChange := StyleChanged;
  FPen := TPen.Create;
  FPen.Color := clBlack;
//  FPen.Width := 2;
  FPen.OnChange := StyleChanged;

  FDownColor := clRed;
  FDownFont := TFont.Create;
  FDownFont.Assign(Self.Font);
  FDownFont.Color := clWhite;
  FDownFont.Style := [fsBold];
  FDownFont.OnChange := StyleChanged;

  FClickedColor := clLtGray;

  FTrackBrush := TBrush.Create;
  FTrackBrush.Color := clYellow;
  FTrackBrush.OnChange := StyleChanged;
  FTrackPen := TPen.Create;
  FTrackPen.Color := clBlue;
  FTrackPen.OnChange := StyleChanged;

  FixedColor := clLime;
end;

destructor TSpeedControl.Destroy;
begin
  inherited Destroy;
  FBrush.Free;
  FPen.Free;
  FDownFont.Free;
  FTrackBrush.Free;
  FTrackPen.Free;
end;
    
procedure TSpeedControl.DrawButtonText(TextBounds: TRect; ButtonText: string; BiDiFlags: LongInt);
begin
  with Canvas do
  begin
    Brush.Style := bsClear;
    if FState = bsDisabled then
    begin
      OffsetRect(TextBounds, 1, 1);
      Font.Color := clBtnHighlight;
      DrawText(Handle, PChar(ButtonText), Length(ButtonText), TextBounds,
        DT_CENTER or DT_VCENTER or BiDiFlags or DT_SINGLELINE);
      OffsetRect(TextBounds, -1, -1);
      Font.Color := clBtnShadow;
      DrawText(Handle, PChar(ButtonText), Length(ButtonText), TextBounds,
        DT_CENTER or DT_VCENTER or BiDiFlags);
    end else
      DrawText(Handle, PChar(ButtonText), Length(ButtonText), TextBounds,
        DT_CENTER or DT_VCENTER or BiDiFlags or DT_SINGLELINE);
  end;
end;

function TSpeedControl.DrawShape(const Client: TRect; const Offset: TPoint): TRect;
var
  X, Y, W, H, S: Integer;
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
    if W < H then S := W else S := H;
    if FShape in [stSquare, stRoundSquare, stCircle] then
    begin
      Inc(X, (W - S) div 2);
      Inc(Y, (H - S) div 2);
      W := S;
      H := S;
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
    InflateRect(Result, - Pen.Width div 2, - Pen.Width div 2);
  end;
end;

function TSpeedControl.Draw(const Client: TRect; const Offset: TPoint): TRect;
begin
  Result := DrawShape(Client, Offset);
  DrawButtonText(Result, Caption, DrawTextBiDiModeFlags(0));
end;

procedure TSpeedControl.Paint;
var
  PaintRect: TRect;
  Offset: TPoint;
  _Margin: Integer;
begin
  if not Enabled then
  begin
    FState := bsDisabled;
    FDragging := False;
  end
  else
    if FState = bsDisabled then
      if FDown then
        FState := bsExclusive
      else
        FState := bsUp;
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
  if (not (FMouseInControl and (FState <> bsDisabled))) or (FState = bsDown) then
  begin
    InflateRect(PaintRect, - _Margin, - _Margin);
    Offset.X := _Margin;
    Offset.Y := _Margin;
    Canvas.Pen.Assign(FPen);
    case FState of
      bsUp:
      begin
        Canvas.Brush.Assign(FBrush);
        if Fixed then
          Canvas.Brush.Color := FixedColor;
        Canvas.Font.Assign(Self.Font);
      end;
      bsDown:
      begin
        Canvas.Brush.Assign(FBrush);
        Canvas.Brush.Color := FClickedColor;
//        Canvas.Font.Assign(FDownFont);
      end;
      bsDisabled:
      begin
        Canvas.Brush.Assign(FBrush);
        Canvas.Brush.Color := FClickedColor;
        Canvas.Font.Assign(FDownFont);
      end;
      bsExclusive:
      begin
        Canvas.Brush.Assign(FBrush);
        Canvas.Font.Assign(FDownFont);
        if Fixed then
        begin
          Canvas.Pen.Color := FDownColor;
          Canvas.Pen.Width := Canvas.Pen.Width + 1;
          Canvas.Brush.Color := FixedColor;
        end
        else
          Canvas.Brush.Color := FDownColor;
      end;
    end;
  end
  else
  begin
    Offset.X := 0;
    Offset.Y := 0;
    Canvas.Pen.Assign(FTrackPen);
    case FState of
      bsUp:
      begin
        Canvas.Brush.Assign(FTrackBrush);
        if Fixed then
          Canvas.Brush.Color := FixedColor;
        Canvas.Font.Assign(Self.Font);
      end;
      bsDown, bsDisabled:
      begin
        Canvas.Brush.Assign(FBrush);
        Canvas.Pen.Width := Canvas.Pen.Width + 1;
        Canvas.Brush.Color := FClickedColor;
        Canvas.Font.Assign(FDownFont);
      end;
      bsExclusive:
      begin
        Canvas.Brush.Assign(FBrush);
        Canvas.Font.Assign(FDownFont);
        Canvas.Pen.Color := FTrackBrush.Color;
        Canvas.Pen.Width := Canvas.Pen.Width + 1;
        if Fixed then
          Canvas.Brush.Color := FixedColor
        else
          Canvas.Brush.Color := FDownColor;
      end;
    end;
  end;
  Draw(PaintRect, Offset);
end;

procedure TSpeedControl.UpdateTracking;
var
  P: TPoint;
  Msg: TMessage;
begin
  if Enabled then
    begin
      GetCursorPos(P);
      FMouseInControl := not (FindDragTarget(P, True) = Self);
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

procedure TSpeedControl.Loaded;
var
  State: TButtonState;
begin
  inherited Loaded;
  if Enabled then
    State := bsUp
  else
    State := bsDisabled;
  if State = bsUp then {foo};
end;
    
procedure TSpeedControl.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then
  begin
{    if not FDown then
    begin}
      FState := bsDown;
      Invalidate;
{    end;}
    FDragging := True;
  end;
end;
    
procedure TSpeedControl.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewState: TButtonState;
begin
  inherited MouseMove(Shift, X, Y);
  if FDragging then
  begin
    if not FDown then NewState := bsUp
    else NewState := bsExclusive;
    if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then
      {if FDown then NewState := bsExclusive else} NewState := bsDown;
    if NewState <> FState then
    begin
      FState := NewState;
      Invalidate;
    end;
  end
  else if not FMouseInControl then
    UpdateTracking;
end;
    
procedure TSpeedControl.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  DoClick: Boolean;
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FDragging then
  begin
    FDragging := False;
    DoClick := (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight);
    if DoClick then
    begin
      SetDown(not FDown);
      if FDown then Repaint;
    end
    else
    begin
      if FDown then FState := bsExclusive;
      Repaint;
    end;
    if DoClick then Click;
    UpdateTracking;
  end;
end;
    
procedure TSpeedControl.Click;
begin
  inherited Click;
end;
    
{pfunction TSpeedControl.GetPalette: HPALETTE;
begin
  Result := Glyph.Palette;
end;}

procedure TSpeedControl.UpdateExclusive;
{pvar
  Msg: TMessage;}
begin
{p  if (FGroupIndex <> 0) and (Parent <> nil) then
  begin
    Msg.Msg := CM_BUTTONPRESSED;
    Msg.WParam := FGroupIndex;
    Msg.LParam := Longint(Self);
    Msg.Result := 0;
    Parent.Broadcast(Msg);
  end;}
end;
    
procedure TSpeedControl.SetDown(Value: Boolean);
begin
  if Value <> FDown then
  begin
    FDown := Value;
    if Value then
    begin
      if FState = bsUp then Invalidate;
      FState := bsExclusive
    end
    else
    begin
      FState := bsUp;
      Repaint;
    end;
    if Value then UpdateExclusive;
  end;
end;
    
procedure TSpeedControl.SetMargin(Value: Integer);
begin
  if (Value <> FMargin) and (Value >= -1) then
  begin
    FMargin := Value;
    Invalidate;
  end;
end;
    
procedure TSpeedControl.SetFixed(Value: Boolean);
begin
  if Value <> FFixed then
  begin
    FFixed := Value;
    Invalidate;
  end;
end;

procedure TSpeedControl.WMLButtonDblClk(var Message: TWMLButtonDown);
begin
  inherited;
  if FDown then DblClick;
end;
    
procedure TSpeedControl.CMEnabledChanged(var Message: TMessage);
{const
  NewState: array[Boolean] of TButtonState = (bsDisabled, bsUp);}
begin
  UpdateTracking;
  Repaint;
end;
    
procedure TSpeedControl.CMButtonPressed(var Message: TMessage);
var
  Sender: TSpeedControl;
begin
  if Message.WParam = 1 then
  begin
    Sender := TSpeedControl(Message.LParam);
    if Sender <> Self then
    begin
      if Sender.MouseInControl and FMouseInControl then
      begin
        FMouseInControl := False;
//        FState := bsUp;
        Invalidate;
      end;
    end;
  end;
end;
    
procedure TSpeedControl.CMDialogChar(var Message: TCMDialogChar);
begin
{$IFDEF def_ShapeControl}
  with Message do
    if IsAccel(CharCode, Caption) and Enabled and Visible and
      (Parent <> nil) and Parent.Showing then
    begin
      Click;
      Result := 1;
    end else
      inherited;
{$ENDIF}      
end;
    
procedure TSpeedControl.CMFontChanged(var Message: TMessage);
begin
  Invalidate;
end;
    
procedure TSpeedControl.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;
    
{pprocedure TSpeedControl.CMSysColorChange(var Message: TMessage);
begin
  with TButtonGlyph(FGlyph) do
  begin
    Invalidate;
    CreateButtonGlyph(FState);
  end;
end;}
    
procedure TSpeedControl.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  { Don't draw a border if DragMode <> dmAutomatic since this button is meant to 
    be used as a dock client. }
  if not FMouseInControl and Enabled and (DragMode <> dmAutomatic) 
    and (GetCapture = 0) then
  begin
    FMouseInControl := True;
    Repaint;
  end;
end;

procedure TSpeedControl.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FMouseInControl and Enabled and not FDragging then
  begin
    FMouseInControl := False;
    Invalidate;
  end;
end;

procedure TSpeedControl.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
end;

procedure TSpeedControl.SetBrush(const Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TSpeedControl.SetClickedColor(const Value: TColor);
begin
  if FClickedColor <> Value then
  begin
    FClickedColor := Value;
    Invalidate;
  end;
end;

procedure TSpeedControl.SetDownColor(const Value: TColor);
begin
  if FDownColor <> Value then
  begin
    FDownColor := Value;
    Invalidate;
  end;
end;

procedure TSpeedControl.SetDownFont(const Value: TFont);
begin
  FDownFont.Assign(Value);
end;

procedure TSpeedControl.SetTrackBrush(const Value: TBrush);
begin
  FTrackBrush.Assign(Value);
end;

procedure TSpeedControl.SetTrackPen(const Value: TPen);
begin
  FTrackPen.Assign(Value);
end;

procedure TSpeedControl.SetPen(const Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TSpeedControl.StyleChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TSpeedControl.SetShape(Value: TShapeType);
begin
  if FShape <> Value then
  begin
    FShape := Value;
    Invalidate;
  end;
end;

procedure TSpeedControl.SetFixedColor(const Value: TColor);
begin
  if FFixedColor <> Value then
  begin
    FFixedColor := Value;
    Invalidate;
  end;
end;

{ TSpeedShape }

constructor TSpeedShape.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRow := 0;
  FColumn := 0;
  FTicket_Kod := 0;
  FTicket_Repert := 0;
  FTicket_Tarifpl := 0;
  FTicket_DateTime := Now;
  FTicket_State := 0;
end;

destructor TSpeedShape.Destroy;
begin
  inherited Destroy;
end;

procedure TSpeedShape.DrawButtonText(TextBounds: TRect; ButtonText: string;
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
  Bounds.Left := TextBounds.Left;
  Bounds.Top := TextBounds.Top;
  Bounds.Right := TextBounds.Right - W;
  Bounds.Bottom := TextBounds.Bottom - H;
  inherited DrawButtonText(Bounds, IntToStr(FRow), BiDiFlags);
  Bounds.Left := TextBounds.Left + W;
  Bounds.Top := TextBounds.Top + H;
  Bounds.Right := TextBounds.Right;
  Bounds.Bottom := TextBounds.Bottom;
  inherited DrawButtonText(Bounds, IntToStr(FColumn), BiDiFlags);
end;

procedure TSpeedShape.SetColumn(const Value: Byte);
begin
  if Value <> FColumn then
  begin
    FColumn := Value;
    Invalidate;
  end;
end;

procedure TSpeedShape.SetRow(const Value: Byte);
begin
  if Value <> FRow then
  begin
    FRow := Value;
    Invalidate;
  end;
end;

procedure TSpeedShape.SetTicket_Kod(const Value: Byte);
begin
  FTicket_Kod := Value;
end;

procedure TSpeedShape.SetTicket_Tarifpl(const Value: Byte);
begin
  FTicket_Tarifpl := Value;
end;

procedure TSpeedShape.SetTicket_Repert(const Value: Byte);
begin
  FTicket_Repert := Value;
end;

procedure TSpeedShape.SetTicket_DateTime(const Value: TDateTime);
begin
  FTicket_DateTime := Value;
end;

procedure TSpeedShape.SetTicket_State(const Value: Byte);
begin
  FTicket_State := Value;
end;

{ TSpeedPanel }

constructor TSpeedPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.Caption := 'Control';
  Self.Brush.Color := clBtnFace;
  Self.Font.Color := clWindowText;
  Self.Pen.Color := clBtnShadow;
  Self.FixedColor := cl3DLight;
  Self.DownColor := clBtnHighlight;
  Self.DownFont.Color := cl3DDkShadow;
  Self.TrackBrush.Color := clBtnShadow;
  Self.TrackPen.Color := clWindowText;
end;

destructor TSpeedPanel.Destroy;
begin
  inherited Destroy;
end;

procedure TSpeedPanel.Click;
begin
  if Self.Down then
    Self.Down := false;
  inherited Click;
end;

{ TWCBitBtn }

constructor TWCBitBtn.Create(AOwner: TComponent);
begin
  inherited;
  Caption := '';
end;

procedure TWCBitBtn.ActionChange(Sender: TObject; CheckDefaults: Boolean);

  procedure CopyImage(ImageList: TCustomImageList; Index: Integer);
  begin
    with Glyph do
    begin
      Width := ImageList.Width;
      Height := ImageList.Height;
      Canvas.Brush.Color := clFuchsia;//! for lack of a better color
      Canvas.FillRect(Rect(0,0, Width, Height));
      ImageList.Draw(Canvas, 0, 0, Index);
    end;
  end;

begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      { Copy image from action's imagelist }
      if (ActionList <> nil) and (ActionList.Images <> nil) and
        (ImageIndex >= 0) and (ImageIndex < ActionList.Images.Count) then
        CopyImage(ActionList.Images, ImageIndex);
      Self.Caption := '';
    end;
end;

end.

