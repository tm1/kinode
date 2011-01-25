//
//TScrollPanel v1.0 - combines TPanel and TScrollBox capabilities
//Written by Andrew Anoshkin '1998
//
unit ScPanel;

interface

{$IFNDEF VER80}
 {$IFNDEF VER90}
  {$IFNDEF VER93}
    {$DEFINE A_D3} { Delphi 3.0 or higher }
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TCustomScrollPanel = class(TScrollingWinControl)
  private
    //TCustomControl
    FCanvas: TCanvas;

    //TCustomPanel
    FBevelInner: TPanelBevel;
    FBevelOuter: TPanelBevel;
    FBevelWidth: TBevelWidth;
    FBorderWidth: TBorderWidth;
    FBorderStyle: TBorderStyle;
    FFullRepaint: Boolean;
    FLocked: Boolean;
    FOnResize: TNotifyEvent;
    FAlignment: TAlignment;

    //TCustomControl
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;

    //TCustomPanel    
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CMIsToolControl(var Message: TMessage); message CM_ISTOOLCONTROL;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure SetAlignment(Value: TAlignment);
    procedure SetBevelInner(Value: TPanelBevel);
    procedure SetBevelOuter(Value: TPanelBevel);
    procedure SetBevelWidth(Value: TBevelWidth);
    procedure SetBorderWidth(Value: TBorderWidth);
    procedure SetBorderStyle(Value: TBorderStyle);
  protected
    //TCustomControl
    procedure Paint; virtual;
    procedure PaintWindow(DC: HDC); override;
    property  Canvas: TCanvas read FCanvas;
    //TCustomPanel
    procedure CreateParams(var Params: TCreateParams); override;
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure Resize; dynamic;
    //TCustomPanel
    property Alignment: TAlignment read FAlignment write SetAlignment default taCenter;
    property BevelInner: TPanelBevel read FBevelInner write SetBevelInner default bvNone;
    property BevelOuter: TPanelBevel read FBevelOuter write SetBevelOuter default bvRaised;
    property BevelWidth: TBevelWidth read FBevelWidth write SetBevelWidth default 1;
    property BorderWidth: TBorderWidth read FBorderWidth write SetBorderWidth default 0;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsNone;
    property Color default clBtnFace;
    property FullRepaint: Boolean read FFullRepaint write FFullRepaint default True;
    property Locked: Boolean read FLocked write FLocked default False;
    property ParentColor default False;
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    //TScrollingWinControl
    property AutoScroll;
  end;


  TScrollPanel = class(TCustomScrollPanel)
  published
    property Align;
    property Alignment;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle;
    property DragCursor;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Caption;
    property Color;
    property Ctl3D;
    property Font;
    property Locked;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;
  end;


procedure Register;

implementation


constructor TCustomScrollPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  //TCustomControl
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;

  //TCustomPanel
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csOpaque, csDoubleClicks, csReplicatable];
  Width := 185;
  Height := 41;
  FAlignment := taCenter;
  BevelOuter := bvRaised;
  BevelWidth := 1;
  FBorderStyle := bsNone;
  Color := clBtnFace;
  FFullRepaint := True;
end;


destructor TCustomScrollPanel.Destroy;
begin
  //TCustomControl
  FCanvas.Free;
  inherited Destroy;
end;


procedure TCustomScrollPanel.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of Longint = (0, WS_BORDER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or BorderStyles[FBorderStyle];
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;


//
//From TCustomControl
//
procedure TCustomScrollPanel.WMPaint(var Message: TWMPaint);
begin
  PaintHandler(Message);
end;


//
//From TCustomControl
//
procedure TCustomScrollPanel.PaintWindow(DC: HDC);
begin
{$IFDEF A_D3}
  FCanvas.Lock;
{$ENDIF}
  try
    FCanvas.Handle := DC;
    try
      Paint;
    finally
      FCanvas.Handle := 0;
    end;
  finally
{$IFDEF A_D3}
    FCanvas.Unlock;
{$ENDIF}
  end;
end;


procedure TCustomScrollPanel.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;


procedure TCustomScrollPanel.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls and (FBorderStyle = bsSingle) then RecreateWnd;
  inherited;
end;


procedure TCustomScrollPanel.CMIsToolControl(var Message: TMessage);
begin
  if not FLocked then Message.Result := 1;
end;


procedure TCustomScrollPanel.Resize;
begin
  if Assigned(FOnResize) then FOnResize(Self);
end;


procedure TCustomScrollPanel.WMWindowPosChanged(var Message: TWMWindowPosChanged);
var
  BevelPixels: Integer;
  Rect, NewRect: TRect;
begin
  if FullRepaint or (Caption <> '') then
    Invalidate
  else
  begin
    BevelPixels := BorderWidth;
    if BevelInner <> bvNone then Inc(BevelPixels, BevelWidth);
    if BevelOuter <> bvNone then Inc(BevelPixels, BevelWidth);
    if BevelPixels > 0 then
    begin
      Rect.Right := Width;
      Rect.Bottom := Height;
      NewRect.Right  := Message.WindowPos^.cx;
      NewRect.Bottom := Message.WindowPos^.cy;
      if Message.WindowPos^.cx <> Rect.Right then
      begin
        Rect.Top := 0;
        Rect.Left := Rect.Right - BevelPixels - 1;
        InvalidateRect(Handle, @Rect, True);
        NewRect.Top := 0;
        NewRect.Left  := NewRect.Right - BevelPixels - 1;
        InvalidateRect(Handle, @NewRect, True);
      end;
      if Message.WindowPos^.cy <> Rect.Bottom then
      begin
        Rect.Left := 0;
        Rect.Top := Rect.Bottom - BevelPixels - 1;
        InvalidateRect(Handle, @Rect, True);
        NewRect.Left := 0;
        NewRect.Top := NewRect.Bottom - BevelPixels - 1;
        InvalidateRect(Handle, @NewRect, True);
      end;
    end;
  end;
  inherited;
  if not (csLoading in ComponentState) then Resize;
end;


procedure TCustomScrollPanel.AlignControls(AControl: TControl; var Rect: TRect);
var
  BevelSize: Integer;
begin
  BevelSize := BorderWidth;
  if BevelOuter <> bvNone then Inc(BevelSize, BevelWidth);
  if BevelInner <> bvNone then Inc(BevelSize, BevelWidth);
  InflateRect(Rect, -BevelSize, -BevelSize);
  inherited AlignControls(AControl, Rect);
end;


procedure TCustomScrollPanel.Paint;
var
  Rect: TRect;
  TopColor, BottomColor: TColor;
  FontHeight: Integer;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);

  procedure AdjustColors(Bevel: TPanelBevel);
  begin
    TopColor := clBtnHighlight;
    if Bevel = bvLowered then TopColor := clBtnShadow;
    BottomColor := clBtnShadow;
    if Bevel = bvLowered then BottomColor := clBtnHighlight;
  end;

begin
  Rect := GetClientRect;
  if BevelOuter <> bvNone then
  begin
    AdjustColors(BevelOuter);
    Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
  end;
  Frame3D(Canvas, Rect, Color, Color, BorderWidth);
  if BevelInner <> bvNone then
  begin
    AdjustColors(BevelInner);
    Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
  end;
  with Canvas do
  begin
    Brush.Color := Color;
    FillRect(Rect);
    Brush.Style := bsClear;
    Font := Self.Font;
    FontHeight := TextHeight('W');
    with Rect do
    begin
      Top := ((Bottom + Top) - FontHeight) div 2;
      Bottom := Top + FontHeight;
    end;
    //DrawText(Handle, PChar(Caption), -1, Rect, (DT_EXPANDTABS or
      //DT_VCENTER) or Alignments[FAlignment]);
  end;
end;


procedure TCustomScrollPanel.SetAlignment(Value: TAlignment);
begin
  FAlignment := Value;
  Invalidate;
end;


procedure TCustomScrollPanel.SetBevelInner(Value: TPanelBevel);
begin
  FBevelInner := Value;
  Realign;
  Invalidate;
end;


procedure TCustomScrollPanel.SetBevelOuter(Value: TPanelBevel);
begin
  FBevelOuter := Value;
  Realign;
  Invalidate;
end;


procedure TCustomScrollPanel.SetBevelWidth(Value: TBevelWidth);
begin
  FBevelWidth := Value;
  Realign;
  Invalidate;
end;


procedure TCustomScrollPanel.SetBorderWidth(Value: TBorderWidth);
begin
  FBorderWidth := Value;
  Realign;
  Invalidate;
end;


procedure TCustomScrollPanel.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;



procedure Register;
begin
  RegisterComponents('AA', [TScrollPanel]);
end;

end.
