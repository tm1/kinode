{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Program      :
Author       : n0mad
Module       : ShpCtrl2.pas
Version      : 2004.12.06.01
Description  : Speed and Shape Based 4 (0.0.6)
Creation     : 07.10.2004 2:27:51
Installation :

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit ShpCtrl2;

{$DEFINE def_UseForms}

{$IFDEF def_UseForms}
//{$UNDEF def_UseForms}
{$ENDIF}

{$DEFINE def_Test_ShpCtrl2}

{$IFDEF def_Test_ShpCtrl2}
{$UNDEF def_Test_ShpCtrl2}
{$ENDIF}

{$DEFINE def_Rus_Eng}

{$IFDEF def_Rus_Eng}
{$UNDEF def_Rus_Eng}
{$ENDIF}

interface

uses
{$IFDEF def_Test_ShpCtrl2}
  Bugger,
{$ENDIF}
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  ExtCtrls,
  Math,
  Buttons,
{$IFDEF def_UseForms}
  Forms,
{$ENDIF}
  Imglist,
  ActnList,
  StrConsts;

const
  SX_RANGESELECT = CM_BASE + 1001;
  SX_COMMAND = CM_BASE + 1101;
  clLtYellow = TColor($0077FFFF);
  clDkYellow = TColor($00AAFFFF);
  clDkOrange = TColor($0000AAFF);
  clLtBrown = TColor($007799DD);
  clLtBlue = TColor($00CE9E73);
  clTrackReserved: TColor = 16744512;

type

  TSXRangeSelectMsg = packed record
    Msg: Cardinal;
    Cmd: Integer;
    RangeRect: PRect;
    Result: Longint;
  end;

  TOperAction = (oaUnknown, oaReserve, oaSale, oaActualize, oaModify, oaFree, oaRestore,
    oaSelect, oaCancel);
  TOperActionEx = (oxUnknown, oxReserve, oxSale, oxActualize, oxModify, oxFree, oxRestore,
    oxSelect, oxCancel, oxPrepare);
  TSaleForm = (sfNotPaid, sfCash, sfCredit, sfCariboo, sfWapiti);

  PSXInfo = ^TSXInfo;

  TSXInfo = record
    Action: Integer;
    case Integer of
      0: (Left, Top, Right, Bottom: Integer);
      1: (TopLeft, BottomRight: TPoint);
      2: (Rsv2_1, Rsv2_2, Rsv2_3, Rsv2_4: Integer);
      3: (Rsv3_1, Rsv3_2, Rsv3_3, Rsv3_4: Integer);
      4: (Rsv4_1, Rsv4_2, Rsv4_3, Rsv4_4: Integer);
      5: (Rsv5_1, Rsv5_2, Rsv5_3, Rsv5_4: Integer);
      6: (Rsv6_1, Rsv6_2, Rsv6_3, Rsv6_4: Integer);
      7: (Rsv7_1, Rsv7_2, Rsv7_3, Rsv7_4: Integer);
      8: (Rsv8_1, Rsv8_2, Rsv8_3, Rsv8_4: Integer);
      9: (vTicketKod, vTicketVer: Integer; Rsv9_3, Rsv9_4: Integer);
  end;

  TSXCommandMsg = packed record
    Msg: Cardinal;
    Cmd: Integer;
    Info: PSXInfo;
    Result: Longint;
  end;

  TInternalState = (siUp, siDisabled, siDown);

  Triplean = (trUnknown, trNo, trYes);

  TTicketState = (tsFree, tsBroken, tsPrepared, tsReserved, tsRealized);
  {
  0 = tsFree - 'Свободно',
  1 = tsBroken - 'Сломано',
  3 = tsPrepared - 'Подготовлено',
  4 = tsReserved - 'Зарезервировано',
  4 = tsRealized - 'Продано'
  }

  TSeatExSelectEvent = procedure(Sender: TObject; const MultipleAction: Boolean;
    var DoCtrlSelect: Boolean) of object;
  TSelectRangeEvent = procedure(Sender: TObject; RangeRect: TRect) of object;

  {
  TSeatExReserveEvent = procedure(Sender: TObject; var DoCtrlReserve: Boolean) of object;
  TSeatExFreeEvent = procedure(Sender: TObject; var DoCtrlFree: Boolean) of object;
  }
  TSeatExCmdEvent = procedure(Sender: TObject; const CmdEx: TOperActionEx;
    var DoCtrlChange: Boolean) of object;

  TSeatExHintUpdateEvent = procedure(Sender: TObject; var HintText: string) of object;

  TGetTicketPropsEvent = procedure(Sender: TObject; const TicketKod, TicketVer: integer;
    var TicketName: string; var TicketBgColor, TicketFontColor: TColor) of object;

  TGetOdeumPropsEvent = procedure(Sender: TObject; const OdeumKod, OdeumVer: integer;
    var OdeumName, OdeumPrefix, OdeumComment, CinemaName: string;
    var OdeumCapacity: Integer; var CinemaLogo, OdeumLogo: TBitmap) of object;

  TSpeedShapeControlEx = class(TGraphicControl)
  private
    FDragging: Boolean;
    FMouseInControl: Boolean;
    FState: TInternalState;
    FMargin: Integer;
    FShape: TShapeType;
    FRegularBrush: TBrush;
    FRegularFont: TFont;
    FRegularPen: TPen;
    FTrackBrush: TBrush;
    FTrackFont: TFont;
    FTrackPen: TPen;
    FClickedColor: TColor;
    procedure CMButtonPressed(var Message: TMessage); message CM_BUTTONPRESSED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMLButtonDblClk(var Message: TWMLButtonDown); message WM_LBUTTONDBLCLK;
    procedure WMContextMenu(var Message: TWMContextMenu); message WM_CONTEXTMENU;
    procedure UpdateTracking;
    procedure SetMargin(const Value: Integer);
    procedure SetShape(const Value: TShapeType);
    function GetTracked: Boolean;
    procedure SetClickedColor(const Value: TColor);
    procedure SetRegularBrush(const Value: TBrush);
    procedure SetRegularFont(const Value: TFont);
    procedure SetRegularPen(const Value: TPen);
    procedure SetTrackBrush(const Value: TBrush);
    procedure SetTrackFont(const Value: TFont);
    procedure SetTrackPen(const Value: TPen);
  protected
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    function Draw(const Client: TRect; const Offset: TPoint): TRect; dynamic;
    function DrawShape(const Client: TRect; const Offset: TPoint): TRect;
    procedure DrawButtonText(TextBounds: TRect; const ButtonText: string;
      BiDiFlags: LongInt); dynamic;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure HandleShapeStateBefore(HotTracked: Boolean; const Client: TRect;
      const Offset: TPoint); dynamic;
    procedure HandleShapeStateAfter(HotTracked: Boolean; const Client: TRect;
      const Offset: TPoint); dynamic;
    property MouseInControl: Boolean read FMouseInControl;
    procedure StyleChanged(Sender: TObject);
    property Margin: Integer read FMargin write SetMargin default -1;
    property Shape: TShapeType read FShape write SetShape default stRoundRect;
    property ClickedColor: TColor read FClickedColor write SetClickedColor default clLtGray;
    property RegularBrush: TBrush read FRegularBrush write SetRegularBrush;
    property RegularFont: TFont read FRegularFont write SetRegularFont;
    property RegularPen: TPen read FRegularPen write SetRegularPen;
    property TrackBrush: TBrush read FTrackBrush write SetTrackBrush;
    property TrackFont: TFont read FTrackFont write SetTrackFont;
    property TrackPen: TPen read FTrackPen write SetTrackPen;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
    property Tracked: Boolean read GetTracked;
  end;

  TSpeedShapeBtnEx = class(TSpeedShapeControlEx)
  private
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Action;
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property Enabled;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Caption;
    property Margin;
    property Shape;
    property ClickedColor;
    property RegularBrush;
    property RegularFont;
    property RegularPen;
    property TrackBrush;
    property TrackFont;
    property TrackPen;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TCustomSeatEx = class(TSpeedShapeControlEx)
  private
    FSelected: Boolean;
    FSelectingRange: Boolean;
    FLockStamp: TDateTime;
    FSeatColumn: Integer;
    FSeatRow: Integer;
    FSeatColumnShow: Boolean;
    FSeatRowShow: Boolean;
    FSelectBrush: TBrush;
    FSelectFont: TFont;
    FSelectPen: TPen;
    FHandleLeftClick: Boolean;
    FHandleHintUpdate: Boolean;
    FForeign: Triplean;
    FCurrent: Triplean;
    FOccupyBrushColor: TColor;
    FOccupyFontColor: TColor;
    FOccupyPenColor: TColor;
    FTrackSelPenColor: TColor;
    FTrackCurPenColor: TColor;
    FOnSeatExSelect: TSeatExSelectEvent;
    FOnSeatExHintUpdate: TSeatExHintUpdateEvent;
    procedure SetForeign(const Value: Triplean);
    procedure SetCurrent(const Value: Triplean);
    procedure SetSelected(const Value: Boolean);
    procedure SetLockStamp(const Value: TDateTime);
    procedure SetSeatColumn(const Value: Integer);
    procedure SetSeatRow(const Value: Integer);
    procedure SetSeatColumnShow(const Value: Boolean);
    procedure SetSeatRowShow(const Value: Boolean);
    procedure SetSelectBrush(const Value: TBrush);
    procedure SetSelectFont(const Value: TFont);
    procedure SetSelectPen(const Value: TPen);
    procedure CMButtonPressed(var Message: TMessage); message CM_BUTTONPRESSED;
    procedure SXRangeSelect(var Message: TSXRangeSelectMsg); message SX_RANGESELECT;
    procedure SetHandleLeftClick(const Value: Boolean);
    procedure SetHandleHintUpdate(const Value: Boolean);
    procedure SetOccupyBrushColor(const Value: TColor);
    procedure SetOccupyFontColor(const Value: TColor);
    procedure SetOccupyPenColor(const Value: TColor);
    procedure SetTrackSelPenColor(const Value: TColor);
    procedure SetTrackCurPenColor(const Value: TColor);
  protected
    function SelectAction: Boolean; dynamic;
    function DoSelect(const SelectControl: Boolean): Boolean; dynamic;
    procedure DoHintUpdate;
    procedure DefaultHintUpdate(var HintText: string); dynamic;
    function Draw(const Client: TRect; const Offset: TPoint): TRect; override;
    procedure HandleShapeStateBefore(HotTracked: Boolean; const Client: TRect;
      const Offset: TPoint); override;
    procedure Loaded; override;
    property OnSeatExSelect: TSeatExSelectEvent read FOnSeatExSelect write FOnSeatExSelect;
    property HandleLeftClick: Boolean read FHandleLeftClick write SetHandleLeftClick
      default True;
    property OnSeatExHintUpdate: TSeatExHintUpdateEvent read FOnSeatExHintUpdate
      write FOnSeatExHintUpdate;
    property HandleHintUpdate: Boolean read FHandleHintUpdate write SetHandleHintUpdate
      default True;
    property Foreign: Triplean read FForeign write SetForeign default trUnknown;
    property Current: Triplean read FCurrent write SetCurrent default trUnknown;
    property OccupyBrushColor: TColor read FOccupyBrushColor write SetOccupyBrushColor
      default clDkOrange;
    property OccupyFontColor: TColor read FOccupyFontColor write SetOccupyFontColor
      default clWhite;
    property OccupyPenColor: TColor read FOccupyPenColor write SetOccupyPenColor
      default clLime; // clBlue;
    property Selected: Boolean read FSelected write SetSelected default False;
    property LockStamp: TDateTime read FLockStamp write SetLockStamp;
    property SelectBrush: TBrush read FSelectBrush write SetSelectBrush;
    property SelectFont: TFont read FSelectFont write SetSelectFont;
    property SelectPen: TPen read FSelectPen write SetSelectPen;
    property TrackSelPenColor: TColor read FTrackSelPenColor write SetTrackSelPenColor
      default clBlue;
    property TrackCurPenColor: TColor read FTrackCurPenColor write SetTrackCurPenColor
      default clNavy;
    property SeatColumn: Integer read FSeatColumn write SetSeatColumn default 0;
    property SeatRow: Integer read FSeatRow write SetSeatRow default 0;
    property SeatColumnShow: Boolean read FSeatColumnShow write SetSeatColumnShow default True;
    property SeatRowShow: Boolean read FSeatRowShow write SetSeatRowShow default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
  published
    property Cursor default crHandPoint;
  end;

  TReasonType = Integer;
  TSessionType = Int64;
  TSerialStrType = string[40];

  TSeatEx = class(TCustomSeatEx)
  private
    FSeatState: TTicketState;
    FTicketKod: Integer;
    FTicketVer: Integer;
    FTicketName: string;
    FPrepareFontColor: TColor;
    FPreparePenColor: TColor;
    FReserveBrushColor: TColor;
    FReserveFontColor: TColor;
    FRealizeBrushColor: TColor;
    FRealizeFontColor: TColor;
    FOnGetTicketProps: TGetTicketPropsEvent;
    FPrintCount: Integer;
    FCheqed: Boolean;
    FLastAction: TOperAction;
    FSaleCost: Integer;
    FSaleForm: TSaleForm;
    FSaleStamp: TDateTime;
    FModStamp: TDateTime;
    FRepertKod: Integer;
    FRepertVer: Integer;
    FReason: Integer;
    FSerialStr: TSerialStrType;
    FSessionUid: Int64;
    FUserName: string;
    FUserHost: string;
    FUserUid: Integer;
    {
    FOnSeatExReserve: TSeatExReserveEvent;
    FOnSeatExFree: TSeatExFreeEvent;
    }
    FOnSeatExCmd: TSeatExCmdEvent;
    procedure SetSeatState(const Value: TTicketState);
    procedure SetTicketKod(const Value: Integer);
    procedure SetTicketVer(const Value: Integer);
    procedure SetTicketName(const Value: string);
    procedure SetPrepareFontColor(const Value: TColor);
    procedure SetPreparePenColor(const Value: TColor);
    procedure SetReserveBrushColor(const Value: TColor);
    procedure SetReserveFontColor(const Value: TColor);
    procedure SetRealizeBrushColor(const Value: TColor);
    procedure SetRealizeFontColor(const Value: TColor);
    procedure SetPrintCount(const Value: Integer);
    function GetPrinted: Boolean;
    procedure SetCheqed(const Value: Boolean);
    procedure SetLastAction(const Value: TOperAction);
    procedure SetSaleCost(const Value: Integer);
    procedure SetSaleForm(const Value: TSaleForm);
    procedure SetSaleStamp(const Value: TDateTime);
    procedure SetModStamp(const Value: TDateTime);
    procedure SetRepertKod(const Value: Integer);
    procedure SetRepertVer(const Value: Integer);
    procedure SetReason(const Value: TReasonType);
    procedure SetSerialStr(const Value: TSerialStrType);
    procedure SetSessionUid(const Value: TSessionType);
    procedure SetUserUid(const Value: Integer);
    procedure SetUserName(const Value: string);
    procedure SetUserHost(const Value: string);
    procedure SXCommand(var Message: TSXCommandMsg); message SX_COMMAND;
  protected
    function SelectAction: Boolean; override;
    function DoCmdReserve: Boolean;
    function DoCmdFree: Boolean;
    function DoCmdRestore: Boolean;
    procedure DefaultHintUpdate(var HintText: string); override;
    procedure HandleShapeStateBefore(HotTracked: Boolean; const Client: TRect;
      const Offset: TPoint); override;
    procedure HandleShapeStateAfter(HotTracked: Boolean; const Client: TRect;
      const Offset: TPoint); override;
    procedure GetTicketProps; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ResetToDefault(NewState: TTicketState); dynamic;
    property Foreign;
    property Current;
    property Selected;
    property LockStamp;
    property SeatState: TTicketState read FSeatState write SetSeatState;
    property TicketKod: Integer read FTicketKod write SetTicketKod default 0;
    property TicketVer: Integer read FTicketVer write SetTicketVer default 0;
    property TicketName: string read FTicketName write SetTicketName;
    property Printed: Boolean read GetPrinted;
    property PrintCount: Integer read FPrintCount write SetPrintCount;
    property Cheqed: Boolean read FCheqed write SetCheqed default False;
    property LastAction: TOperAction read FLastAction write SetLastAction default oaUnknown;
    property SaleCost: Integer read FSaleCost write SetSaleCost default 0;
    property SaleForm: TSaleForm read FSaleForm write SetSaleForm default sfNotPaid;
    property SaleStamp: TDateTime read FSaleStamp write SetSaleStamp;
    property ModStamp: TDateTime read FModStamp write SetModStamp;
    property RepertKod: Integer read FRepertKod write SetRepertKod default 0;
    property RepertVer: Integer read FRepertVer write SetRepertVer default 0;
    property Reason: TReasonType read FReason write SetReason;
    property SerialStr: TSerialStrType read FSerialStr write SetSerialStr;
    property SessionUid: TSessionType read FSessionUid write SetSessionUid default -1;
    property UserUid: Integer read FUserUid write SetUserUid default -1;
    property UserName: string read FUserName write SetUserName;
    property UserHost: string read FUserHost write SetUserHost;
    // property Cheqed: Boolean;
  published
    property Action;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property Enabled;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Margin;
    property Shape;
    property ClickedColor;
    property RegularBrush;
    property RegularFont;
    property RegularPen;
    property TrackBrush;
    property TrackFont;
    property TrackPen;
    property HandleLeftClick;
    property HandleHintUpdate;
    property OccupyBrushColor;
    property OccupyFontColor;
    property OccupyPenColor;
    property SelectBrush;
    property SelectFont;
    property SelectPen;
    property PreparePenColor: TColor read FPreparePenColor write SetPreparePenColor
      default clWhite;
    property PrepareFontColor: TColor read FPrepareFontColor write SetPrepareFontColor
      default clWhite;
    property ReserveBrushColor: TColor read FReserveBrushColor write SetReserveBrushColor
      default clDkYellow;
    property ReserveFontColor: TColor read FReserveFontColor write SetReserveFontColor
      default clBlue;
    property RealizeBrushColor: TColor read FRealizeBrushColor write SetRealizeBrushColor
      default clGray;
    property RealizeFontColor: TColor read FRealizeFontColor write SetRealizeFontColor
      default clBlack;
    property SeatColumn;
    property SeatRow;
    property SeatColumnShow;
    property SeatRowShow;
    property Visible;
    property OnSeatExSelect;
    {
    property OnSeatExReserve: TSeatExReserveEvent read FOnSeatExReserve write FOnSeatExReserve;
    property OnSeatExFree: TSeatExFreeEvent read FOnSeatExFree write FOnSeatExFree;
    }
    property OnSeatExCmd: TSeatExCmdEvent read FOnSeatExCmd write FOnSeatExCmd;
    property OnGetTicketProps: TGetTicketPropsEvent read FOnGetTicketProps write FOnGetTicketProps;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TCustomOdeumPanel = class(TCustomPanel)
  private
    FSavedBrushStyle: TBrushStyle;
    FSavedPenColor: TColor;
    FSavedPenMode: TPenMode;
    FSavedPenStyle: TPenStyle;
    FSavedPenWidth: Integer;
    X1, Y1, X2, Y2: Integer;
    FSavedShowHint: Boolean;
    FSelecting: Boolean;
    FCapturing: Boolean;
    FSendingMessage: Boolean;
    FOrigin, FMovePt: TPoint;
    FRangeRect: TRect;
    FRangeEdgePen: TPen;
    FOnSelectRangeBefore: TSelectRangeEvent;
    FOnSelectRangeAfter: TSelectRangeEvent;
    procedure SetRangeEdgePen(const Value: TPen);
  protected
    property Caption;
    procedure Loaded; override;
    procedure StyleChanged(Sender: TObject);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure WMCaptureChanged(var Message: TMessage); message WM_CAPTURECHANGED;
    procedure StartRangeSelect(X, Y: Integer);
    procedure ProcessRangeSelect(X, Y: Integer);
    procedure EndRangeSelect(X, Y: Integer);
    procedure ResetRange(X, Y: Integer);
    procedure SelectRangeBefore(RangeRect: TRect);
    procedure SelectRangeAfter(RangeRect: TRect);
    procedure DoSelectRange;
    property RangeEdgePen: TPen read FRangeEdgePen write SetRangeEdgePen;
    property OnSelectRangeBefore: TSelectRangeEvent read FOnSelectRangeBefore
      write FOnSelectRangeBefore;
    property OnSelectRangeAfter: TSelectRangeEvent read FOnSelectRangeAfter
      write FOnSelectRangeAfter;
  public
    property Canvas;
    property DockManager;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TOdeumPanel = class(TCustomOdeumPanel)
  private
    FOdeumKod: Integer;
    FOdeumVer: Integer;
    FOdeumComment: string;
    FOdeumName: string;
    FOdeumCapacity: Integer;
    FOdeumPrefix: string;
    FCinemaName: string;
    FOdeumLogo: TBitmap;
    FCinemaLogo: TBitmap;
    FAutoHint: Boolean;
    FMapMode: Boolean;
    FOnGetOdeumProps: TGetOdeumPropsEvent;
    procedure SetOdeumKod(const Value: Integer);
    procedure SetOdeumVer(const Value: Integer);
    procedure SetOdeumComment(const Value: string);
    procedure SetOdeumName(const Value: string);
    procedure SetOdeumCapacity(const Value: Integer);
    procedure SetOdeumPrefix(const Value: string);
    procedure SetOdeumLogo(const Value: TBitmap);
    procedure SetCinemaLogo(const Value: TBitmap);
    procedure SetAutoHint(const Value: Boolean);
    procedure SetMapMode(const Value: Boolean);
    procedure FormatCaption;
    procedure SetCinemaName(const Value: string);
  protected
    procedure DoAutoHint; dynamic;
    procedure DoMapMode; dynamic;
    procedure GetOdeumProps; dynamic;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Caption;
    property OdeumKod: Integer read FOdeumKod write SetOdeumKod;
    property OdeumVer: Integer read FOdeumVer write SetOdeumVer;
    property OdeumName: string read FOdeumName write SetOdeumName;
    property OdeumPrefix: string read FOdeumPrefix write SetOdeumPrefix;
    property CinemaName: string read FCinemaName write SetCinemaName;
    property OdeumCapacity: Integer read FOdeumCapacity write SetOdeumCapacity;
    property OdeumLogo: TBitmap read FOdeumLogo write SetOdeumLogo;
    property CinemaLogo: TBitmap read FCinemaLogo write SetCinemaLogo;
    property OdeumComment: string read FOdeumComment write SetOdeumComment;
  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderWidth;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Font;
    property Locked;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RangeEdgePen;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property AutoHint: Boolean read FAutoHint write SetAutoHint default True;
    property MapMode: Boolean read FMapMode write SetMapMode default False;
    property OnGetOdeumProps: TGetOdeumPropsEvent read FOnGetOdeumProps write FOnGetOdeumProps;
    property OnSelectRangeBefore;
    property OnSelectRangeAfter;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

function EllipsifyText(AsPath: Boolean; const Text: string; const Canvas: TCanvas;
  MaxWidth: Integer): string;

const
  s_Const_Section_Start: string = #13#10'***Const_Section_Start***'#13#10;
  // -------------------------------------------
{$IFDEF def_Rus_Eng}
  c_Triplean: array[Triplean] of string =
  ('Неизвестно (Unknown)', 'Нет (No)', 'Да (Yes)');
  c_TicketState: array[TTicketState] of string =
  ('Свободно (Free)', 'Сломано (Broken)', 'Подготовлено (Prepared)',
    'Зарезервировано (Reserved)', 'Продано (Realized)');
  c_OperActionDesc: array[TOperAction] of string =
  ('Неопределено (Unknown) [ - ]', 'Reserve (Бронь) [ R ]',
    'Sale (Продажа) [ P ]', 'Actualize (Продажа брони) [ A ]', 'Modify (Изменение) [ M ]',
    'Free (Снятие брони) [ J ]', 'Restore (Возврат) [ F ]',
    'Select (Выделение) [ S ]', 'Cancel (Отмена) [ C ]');
  c_SfToStr: array[TSaleForm] of string =
  ('0 - Not paid (Неоплачено)', '1 - Cash (Наличные)', '2 - Credit (Кредитка)',
    '3 - Cariboo (Карибу)', '4 - Wapiti (Вапити)');
{$ELSE}
  c_Triplean: array[Triplean] of string =
  ('Неизвестно', 'Нет', 'Да');
  c_TicketState: array[TTicketState] of string =
  ('Свободно', 'Сломано', 'Подготовлено',
    'Зарезервировано', 'Продано');
  c_OperActionDesc: array[TOperAction] of string =
  ('Неопределено [ - ]', 'Бронь [ R ]', 'Продажа [ P ]', 'Продажа брони [ A ]', 'Изменение [ M ]',
    'Снятие брони [ J ]', 'Возврат [ F ]', 'Выделение [ S ]', 'Отмена [ C ]');
  c_SfToStr: array[TSaleForm] of string =
  ('0 - Неоплачено', '1 - Наличные', '2 - Кредитка',
    '3 - Карибу', '4 - Вапити');
{$ENDIF}
  // -------------------------------------------
  c_OperActionPfx: array[TOperAction] of Char =
  ('-', 'R', 'P', 'A', 'M', 'J', 'F', 'S', 'C');
  c_Int2OperAction: array[100..108] of TOperAction =
  (oaUnknown, oaReserve, oaSale, oaActualize, oaModify, oaFree, oaRestore, oaSelect, oaCancel);
  c_OperAction2Int: array[TOperAction] of Integer =
  (100, 101, 102, 103, 104, 105, 106, 107, 108);
  // -------------------------------------------
  c_Int2OperActionEx: array[200..209] of TOperActionEx =
  (oxUnknown, oxReserve, oxSale, oxActualize, oxModify, oxFree, oxRestore, oxSelect, oxCancel,
    oxPrepare);
  c_OperActionEx2Int: array[TOperActionEx] of Integer =
  (200, 201, 202, 203, 204, 205, 206, 207, 208, 209);
  // -------------------------------------------
  c_IntToSf: array[0..4] of TSaleForm =
  (sfNotPaid, sfCash, sfCredit, sfCariboo, sfWapiti);
  c_SfToInt: array[TSaleForm] of Integer =
  (0, 1, 2, 3, 4);
  // -------------------------------------------
  c_Lim: string = '  :  ';
  // -------------------------------------------
  s_Global_Column_Show: string = 'GlobalColumnShow=';
  GlobalColumnShow: Boolean = True;
  s_Global_Row_Show: string = 'GlobalRowShow=';
  GlobalRowShow: Boolean = True;
  // -------------------------------------------
  s_Global_Canceled_Show: string = 'GlobalCanceledShow=';
  GlobalSeatCanceledShow: Boolean = True;
  s_Global_Freed_Show: string = 'GlobalFreedShow=';
  GlobalSeatFreedShow: Boolean = True;
  s_Global_Restored_Show: string = 'GlobalRestoredShow=';
  GlobalSeatRestoredShow: Boolean = True;
  s_Global_Cheqed_Show: string = 'GlobalCheqedShow=';
  GlobalSeatCheqedShow: Boolean = False;
  // -------------------------------------------
  s_Const_Section_End: string = #13#10'+++Const_Section_End+++'#13#10;

procedure Register;

procedure RepaintSeatExCtrls(Parent: TWinControl);
procedure SelectRangeForExCtrls(Parent: TWinControl; const Rect: TRect);
procedure DoCommandForExCtrls(Parent: TWinControl; const SXInfo: TSXInfo);

implementation

const

  MouseButtonDesc: array[TMouseButton] of string =
  ('mbLeft', 'mbRight', 'mbMiddle');

  BooleanDesc: array[Boolean] of string =
  ('-F', '+T');

{$IFDEF WIN32}

  {Win32 version}

function EllipsifyText(AsPath: Boolean; const Text: string;
  const Canvas: TCanvas; MaxWidth: Integer): string;
var
  TempPChar: PChar;
  TempRect: TRect;
  Params: UINT;
begin
  // Alocate mem for PChar
  GetMem(TempPChar, Length(Text) + 1);
  try
    // Copy Text into PChar
    TempPChar := StrPCopy(TempPChar, Text);
    // Create Rectangle to Store PChar
    TempRect := Rect(0, 0, MaxWidth, High(Integer));
    // Set Params depending wether it's a path or not
    if AsPath then
      Params := DT_PATH_ELLIPSIS
    else
      Params := DT_END_ELLIPSIS;
    // Tell it to Modify the PChar, and do not draw to the canvas
    Params := Params + DT_MODIFYSTRING + DT_CALCRECT;
    // Ellipsify the string based on availble space to draw in
    DrawTextEx(Canvas.Handle, TempPChar, -1, TempRect, Params, nil);
    // Copy the modified PChar into the result
    Result := StrPas(TempPChar);
  finally
    // Free Memory from PChar
    FreeMem(TempPChar, Length(Text) + 1);
  end;
end;

{$ELSE}

  {Win16 version}

function EllipsifyText(AsPath: Boolean; const Text: string;
  const Canvas: TCanvas; MaxWidth: Integer): string;

  procedure CutFirstDirectory(var S: string);
  var
    Root: Boolean;
    P: Integer;
  begin
    if S = '' then
      exit;
    if S = '\' then
      S := ''
    else
    begin
      if S[1] = '\' then
      begin
        Root := True;
        Delete(S, 1, 1);
      end
      else
        Root := False;
      if S[1] = '.' then
        Delete(S, 1, 4);
      P := Pos('\', S);
      if P <> 0 then
      begin
        Delete(S, 1, P);
        S := '...\' + S;
      end
      else
        S := '';
      if Root then
        S := '\' + S;
    end;
  end;

  function MinimizeName(const Filename: string; const Canvas: TCanvas;
    MaxLen: Integer): string;
  var
    Drive: string;
    Dir: string;
    Name: string;
  begin
    Result := FileName;
    Dir := ExtractFilePath(Result);
    Name := ExtractFileName(Result);

    if (Length(Dir) >= 2) and (Dir[2] = ':') then
    begin
      Drive := Copy(Dir, 1, 2);
      Delete(Dir, 1, 2);
    end
    else
      Drive := '';
    while ((Dir <> '') or (Drive <> '')) and (Canvas.TextWidth(Result) > MaxLen) do
    begin
      if Dir = '\...\' then
      begin
        Drive := '';
        Dir := '...\';
      end
      else if Dir = '' then
        Drive := ''
      else
        CutFirstDirectory(Dir);
      Result := Drive + Dir + Name;
    end;
  end;
var
  Temp: string;
  AvgChar: Integer;
  TLen,
    Index: Integer;
  Metrics: TTextMetric;
begin
  try
    if AsPath then
    begin
      Result := MinimizeName(Text, Canvas, MaxWidth);
    end
    else
    begin
      Temp := Text;
      if (Temp <> '') and (Canvas.TextWidth(Temp) > MaxWidth) then
      begin
        GetTextMetrics(Canvas.Handle, Metrics);
        AvgChar := Metrics.tmAveCharWidth;
        if (AvgChar * 3) < MaxWidth then
        begin
          Index := (MaxWidth div AvgChar) - 1;
          Temp := Copy(Text, 1, Index);
          if Canvas.TextWidth(Temp + '...') > MaxWidth then
          begin
            repeat
              dec(Index);
              SetLength(Temp, Index);
            until (Canvas.TextWidth(Temp + '...') < MaxWidth) or (Index < 1);
            { delete chars }
          end
          else
          begin
            TLen := Length(Text);
            repeat
              inc(Index);
              Temp := Copy(Text, 1, Index);
            until (Canvas.TextWidth(Temp + '...') > MaxWidth) or (Index >= TLen);
            SetLength(Temp, Index - 1);
          end;
          Temp := Temp + '...';
        end
        else
          Temp := '.';
      end;
      Result := Temp;
    end;
  except
    Result := '';
  end;
end;
{$ENDIF}

procedure Register;
begin
  RegisterComponents('n0mad Controls', [TSpeedShapeBtnEx, TSeatEx, TOdeumPanel]);
end;

procedure RepaintSeatExCtrls(Parent: TWinControl);
var
  Msg: TMessage;
  i: Integer;
  ChildControl: TControl;
begin
  if (Parent <> nil) then
  begin
    Msg.Msg := CM_BUTTONPRESSED;
    Msg.WParam := 2;
    Msg.LParam := 0;
    Msg.Result := 0;
    try
      Parent.Broadcast(Msg);
    except
    end;
    for i := 0 to Parent.ControlCount - 1 do
    begin
      ChildControl := Parent.Controls[i];
      if (ChildControl is TWinControl) then
        RepaintSeatExCtrls(ChildControl as TWinControl);
    end;
  end;
end;

procedure SelectRangeForExCtrls(Parent: TWinControl; const Rect: TRect);
var
  Msg: TSXRangeSelectMsg;
begin
  if (Parent <> nil) then
  begin
    Msg.Msg := SX_RANGESELECT;
    Msg.Cmd := 1;
    Msg.RangeRect := @Rect;
    Msg.Result := 0;
    try
      Parent.Broadcast(Msg);
    except
    end;
  end;
end;

procedure DoCommandForExCtrls(Parent: TWinControl; const SXInfo: TSXInfo);
var
  Msg: TSXCommandMsg;
begin
  if (Parent <> nil) then
  begin
    Msg.Msg := SX_COMMAND;
    Msg.Cmd := 1;
    Msg.Info := @SXInfo;
    Msg.Result := 0;
    try
      Parent.Broadcast(Msg);
    except
    end;
  end;
end;

{ TSpeedShapeControlEx }

constructor TSpeedShapeControlEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // -------------------------------------------
  SetBounds(0, 0, 30, 30);
  ControlStyle := [csCaptureMouse, csDoubleClicks];
  ParentFont := False;
  // -------------------------------------------
  FState := siUp;
  FMargin := -1;
  FShape := stRoundRect;
  // -------------------------------------------
  FClickedColor := clLtGray;
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
  FTrackBrush := TBrush.Create;
  FTrackBrush.Color := clLtYellow;
  FTrackBrush.OnChange := StyleChanged;
  //
  FTrackFont := TFont.Create;
  FTrackFont.Assign(Self.Font);
  FTrackFont.Color := clNavy;
  FTrackFont.Style := [fsBold];
  FTrackFont.OnChange := StyleChanged;
  //
  FTrackPen := TPen.Create;
  FTrackPen.Color := clAqua; //clBlue;
  FTrackPen.Width := 2;
  FTrackPen.OnChange := StyleChanged;
  // -------------------------------------------
end;

destructor TSpeedShapeControlEx.Destroy;
begin
  // -------------------------------------------
  FRegularBrush.Free;
  FRegularFont.Free;
  FRegularPen.Free;
  // -------------------------------------------
  FTrackBrush.Free;
  FTrackFont.Free;
  FTrackPen.Free;
  // -------------------------------------------
  inherited Destroy;
end;

procedure TSpeedShapeControlEx.CMButtonPressed(var Message: TMessage);
var
  Sender: TSpeedShapeControlEx;
begin
  if Message.WParam = 1 then
  begin
    Sender := TSpeedShapeControlEx(Message.LParam);
    if (Sender <> Self) then
    try
      if (Sender = nil) or (Sender.MouseInControl and FMouseInControl) then
      begin
        FMouseInControl := False;
        // FState := bsUp;
        Invalidate;
      end;
    except
    end;
  end;
end;

procedure TSpeedShapeControlEx.CMEnabledChanged(var Message: TMessage);
begin
  UpdateTracking;
  Repaint;
end;

procedure TSpeedShapeControlEx.CMFontChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TSpeedShapeControlEx.CMMouseEnter(var Message: TMessage);
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

procedure TSpeedShapeControlEx.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FMouseInControl and Enabled and not FDragging then
  begin
    FMouseInControl := False;
    Invalidate;
  end;
end;

procedure TSpeedShapeControlEx.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;

procedure TSpeedShapeControlEx.WMLButtonDblClk(var Message: TWMLButtonDown);
begin
  inherited;
  if FState = siDown then
    DblClick;
end;

procedure TSpeedShapeControlEx.UpdateTracking;
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

procedure TSpeedShapeControlEx.SetMargin(const Value: Integer);
begin
  if (Value <> FMargin) and (Value >= -1) then
  begin
    FMargin := Value;
    Invalidate;
  end;
end;

procedure TSpeedShapeControlEx.SetShape(const Value: TShapeType);
begin
  if FShape <> Value then
  begin
    FShape := Value;
    Invalidate;
  end;
end;

procedure TSpeedShapeControlEx.Click;
begin
  inherited Click;
end;

function TSpeedShapeControlEx.GetTracked: Boolean;
begin
  Result := (FMouseInControl and (FState <> siDisabled));
end;

procedure TSpeedShapeControlEx.ActionChange(Sender: TObject;
  CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
end;

function TSpeedShapeControlEx.Draw(const Client: TRect;
  const Offset: TPoint): TRect;
begin
  Result := DrawShape(Client, Offset);
  DrawButtonText(Result, Caption, DrawTextBiDiModeFlags(0) or DT_END_ELLIPSIS);
end;

function TSpeedShapeControlEx.DrawShape(const Client: TRect; const Offset: TPoint): TRect;
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
    InflateRect(Result, (0 - Offset.x - Pen.Width) div 2 - 1, (0 - Offset.y - Pen.Width) div 2 - 1);
  end;
end;

procedure TSpeedShapeControlEx.DrawButtonText(TextBounds: TRect; const ButtonText: string;
  BiDiFlags: LongInt);
var
  ShiftTextBounds: TRect;
  TextBiDiFlags: Longint;
  // X, Y, W, H, S, WT, HT: Integer;
  // ST: string;
begin
  with Canvas do
  begin
    {}
    Pen.Width := 1;
    Pen.Color := clRed;
    Brush.Style := bsClear;
    Brush.Color := clLtGray;
    if BiDiFlags = -1 then
      Rectangle(TextBounds);
    Pen.Color := clBlack;
    {}
    {
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
    }
    {}
    TextBiDiFlags := DT_SINGLELINE or DT_CENTER or DT_VCENTER or BiDiFlags;
    Brush.Style := bsClear;
    if FState = siDisabled then
    begin
      ShiftTextBounds.Left := TextBounds.Left + 1;
      ShiftTextBounds.Top := TextBounds.Top + 1;
      ShiftTextBounds.Right := TextBounds.Right + 1;
      ShiftTextBounds.Bottom := TextBounds.Bottom + 1;
      Font.Color := clBtnHighlight;
      DrawText(Handle, PChar(ButtonText), Length(ButtonText), ShiftTextBounds, TextBiDiFlags);
      Font.Color := clBtnShadow;
    end;
    DrawText(Handle, PChar(ButtonText), Length(ButtonText), TextBounds, TextBiDiFlags);
    {}
  end;
end;

procedure TSpeedShapeControlEx.Loaded;
var
  State: TButtonState;
begin
  inherited Loaded;
  if Enabled then
    State := bsUp
  else
    State := bsDisabled;
  if State = bsUp then
    {foo};
end;

procedure TSpeedShapeControlEx.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then
  begin
    {
    if not FSelected then
    begin
    }
    FState := siDown;
    Invalidate;
    {
    end;
    }
    FDragging := True;
  end;
end;

procedure TSpeedShapeControlEx.MouseMove(Shift: TShiftState;
  X, Y: Integer);
var
  NewState: TInternalState;
begin
  inherited MouseMove(Shift, X, Y);
  if FDragging then
  begin
    NewState := siUp;
    if (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight) then
      NewState := siDown;
    if NewState <> FState then
    begin
      FState := NewState;
      Invalidate;
    end;
  end
  else if not FMouseInControl then
    UpdateTracking;
end;

procedure TSpeedShapeControlEx.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  DoClick: Boolean;
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FDragging then
  begin
    FDragging := False;
    DoClick := (X >= 0) and (X < ClientWidth) and (Y >= 0) and (Y <= ClientHeight);
    FState := siUp;
    if DoClick then
      Click;
    Repaint;
    UpdateTracking;
  end;
end;

procedure TSpeedShapeControlEx.Paint;
var
  PaintRect: TRect;
  Offset: TPoint;
  _Margin: Integer;
begin
  if not Enabled then
  begin
    FState := siDisabled;
    FDragging := False;
  end
  else if FState = siDisabled then
    FState := siUp;
  {
  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := clBlack;
  Canvas.Brush.Style := bsClear;
  Canvas.Brush.Color := clNavy;
  Canvas.Rectangle(0, 0, Width, Height);
  }
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
    HandleShapeStateBefore(False, PaintRect, Offset);
  end
  else //
  begin
    Offset.X := 0;
    Offset.Y := 0;
    HandleShapeStateBefore(True, PaintRect, Offset);
  end;
  Draw(PaintRect, Offset);
  HandleShapeStateAfter(not ((not GetTracked) or (FState = siDown)), PaintRect, Offset);
end;

procedure TSpeedShapeControlEx.StyleChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TSpeedShapeControlEx.HandleShapeStateBefore(HotTracked: Boolean;
  const Client: TRect; const Offset: TPoint);
begin
  //----------------------------------------
  Canvas.Brush.Assign(FRegularBrush);
  Canvas.Font.Assign(FRegularFont);
  Canvas.Pen.Assign(FRegularPen);
  //----------------------------------------
  if HotTracked then
  begin
    Canvas.Pen.Assign(FTrackPen);
    Canvas.Brush.Color := FTrackBrush.Color;
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
    end;
  end
  else // not HotTracked
  begin
    //----------------------------------------
    Canvas.Pen.Assign(FRegularPen);
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
    end;
  end;
  //----------------------------------------
end;

procedure TSpeedShapeControlEx.HandleShapeStateAfter(HotTracked: Boolean;
  const Client: TRect; const Offset: TPoint);
begin
  {foo}
end;

procedure TSpeedShapeControlEx.SetClickedColor(const Value: TColor);
begin
  if FClickedColor <> Value then
  begin
    FClickedColor := Value;
    Invalidate;
  end;
end;

procedure TSpeedShapeControlEx.SetRegularBrush(const Value: TBrush);
begin
  FRegularBrush.Assign(Value);
end;

procedure TSpeedShapeControlEx.SetRegularFont(const Value: TFont);
begin
  FRegularFont := Value;
end;

procedure TSpeedShapeControlEx.SetRegularPen(const Value: TPen);
begin
  FRegularPen.Assign(Value);
end;

procedure TSpeedShapeControlEx.SetTrackBrush(const Value: TBrush);
begin
  FTrackBrush.Assign(Value);
end;

procedure TSpeedShapeControlEx.SetTrackFont(const Value: TFont);
begin
  FTrackFont := Value;
end;

procedure TSpeedShapeControlEx.SetTrackPen(const Value: TPen);
begin
  FTrackPen.Assign(Value);
end;

procedure TSpeedShapeControlEx.WMContextMenu(var Message: TWMContextMenu);
begin
  inherited;
  UpdateTracking;
end;

{ TSpeedShapeBtnEx }

constructor TSpeedShapeBtnEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // -------------------------------------------
  SetBounds(0, 0, 220, 80);
  FRegularBrush.Color := clScrollBar;
  FRegularFont.Color := clCaptionText;
  FRegularFont.Color := clCaptionText;
  FTrackBrush.Color := clLtBlue;
  FTrackFont.Color := clBlue;
  FTrackPen.Color := clNavy;
  // -------------------------------------------
end;

procedure TSpeedShapeBtnEx.CMDialogChar(var Message: TCMDialogChar);
begin
{$IFDEF def_UseForms}
  with Message do
    if IsAccel(CharCode, Caption) and Enabled and Visible and
      (Parent <> nil) and Parent.Showing then
    begin
      Click;
      Repaint;
      Result := 1;
    end
    else
      inherited;
{$ENDIF}
end;

{ TCustomSeatEx }

constructor TCustomSeatEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // -------------------------------------------
  FSelectingRange := False;
  FSelected := False;
  FForeign := trUnknown;
  FCurrent := trUnknown;
  FSeatColumn := 0;
  FSeatRow := 0;
  FSeatColumnShow := True;
  FSeatRowShow := True;
  FHandleLeftClick := True;
  FHandleHintUpdate := True;
  // -------------------------------------------
  FOccupyBrushColor := clDkOrange;
  FOccupyFontColor := clWhite;
  FOccupyPenColor := clLime; // clBlue;
  FTrackSelPenColor := clBlue;
  FTrackCurPenColor := clNavy;
  // -------------------------------------------
  FSelectBrush := TBrush.Create;
  FSelectBrush.Color := clRed;
  FSelectBrush.OnChange := StyleChanged;
  //
  FSelectFont := TFont.Create;
  FSelectFont.Assign(Self.Font);
  FSelectFont.Color := clWhite;
  FSelectFont.Style := [fsBold];
  FSelectFont.OnChange := StyleChanged;
  //
  FSelectPen := TPen.Create;
  FSelectPen.Color := clYellow;
  FSelectPen.Width := 2;
  FSelectPen.OnChange := StyleChanged;
  // -------------------------------------------
  Cursor := crHandPoint;
  // -------------------------------------------
end;

destructor TCustomSeatEx.Destroy;
begin
  // -------------------------------------------
  FSelectBrush.Free;
  FSelectFont.Free;
  FSelectPen.Free;
  // -------------------------------------------
  inherited Destroy;
end;

function TCustomSeatEx.Draw(const Client: TRect; const Offset: TPoint): TRect;
var
  TextBounds: TRect;
  W, H: integer;
begin
  Result := DrawShape(Client, Offset);
  W := (Result.Right - Result.Left);
  H := (Result.Bottom - Result.Top);
  W := W div 3;
  if FShape in [stEllipse, stCircle] then
    H := H div 3
  else
    H := H div 2;
  if GlobalRowShow and SeatRowShow then
  begin
    TextBounds.Left := Result.Left;
    TextBounds.Top := Result.Top;
    TextBounds.Right := Result.Right - W;
    TextBounds.Bottom := Result.Bottom - H;
    inherited DrawButtonText(TextBounds, IntToStr(FSeatRow), DrawTextBiDiModeFlags(0));
  end;
  if GlobalColumnShow and SeatColumnShow then
  begin
    TextBounds.Left := Result.Left + W;
    TextBounds.Top := Result.Top + H;
    TextBounds.Right := Result.Right;
    TextBounds.Bottom := Result.Bottom;
    inherited DrawButtonText(TextBounds, IntToStr(FSeatColumn), DrawTextBiDiModeFlags(0));
  end;
end;

procedure TCustomSeatEx.SetForeign(const Value: Triplean);
begin
  if Value <> FForeign then
  begin
    FForeign := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TCustomSeatEx.SetCurrent(const Value: Triplean);
begin
  if Value <> FCurrent then
  begin
    FCurrent := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TCustomSeatEx.SetSelected(const Value: Boolean);
begin
  if Value <> FSelected then
  begin
    FSelected := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TCustomSeatEx.SetLockStamp(const Value: TDateTime);
begin
  if FLockStamp <> Value then
  begin
    FLockStamp := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TCustomSeatEx.SetSeatColumn(const Value: Integer);
begin
  if Value <> FSeatColumn then
  begin
    FSeatColumn := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TCustomSeatEx.SetSeatRow(const Value: Integer);
begin
  if Value <> FSeatRow then
  begin
    FSeatRow := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TCustomSeatEx.SetSeatColumnShow(const Value: Boolean);
begin
  if Value <> FSeatColumnShow then
  begin
    FSeatColumnShow := Value;
    Invalidate;
  end;
end;

procedure TCustomSeatEx.SetSeatRowShow(const Value: Boolean);
begin
  if Value <> FSeatRowShow then
  begin
    FSeatRowShow := Value;
    Invalidate;
  end;
end;

procedure TCustomSeatEx.SetSelectBrush(const Value: TBrush);
begin
  FSelectBrush.Assign(Value);
end;

procedure TCustomSeatEx.SetSelectFont(const Value: TFont);
begin
  FSelectFont := Value;
end;

procedure TCustomSeatEx.SetSelectPen(const Value: TPen);
begin
  FSelectPen.Assign(Value);
end;

procedure TCustomSeatEx.HandleShapeStateBefore(HotTracked: Boolean;
  const Client: TRect; const Offset: TPoint);
begin
  // inherited HandleShapeStateBefore(HotTracked, Client, Offset);
  //----------------------------------------
  if FSelected then
  begin
    if not (Foreign in [trNo]) then
    begin
      Canvas.Brush.Assign(FSelectBrush);
      Canvas.Brush.Color := FOccupyBrushColor;
      Canvas.Font.Assign(FSelectFont);
      Canvas.Font.Color := FOccupyFontColor;
      Canvas.Pen.Assign(FSelectPen);
      Canvas.Pen.Color := FOccupyPenColor;
    end
    else
    begin
      Canvas.Brush.Assign(FSelectBrush);
      Canvas.Font.Assign(FSelectFont);
      Canvas.Pen.Assign(FSelectPen);
    end;
  end
  else // not FSelected
  begin
    Canvas.Brush.Assign(FRegularBrush);
    Canvas.Font.Assign(FRegularFont);
    Canvas.Pen.Assign(FRegularPen);
  end;
  //----------------------------------------
  if HotTracked then
  begin
    Canvas.Pen.Assign(FTrackPen);
    if not (Foreign in [trNo]) then
    begin
      Canvas.Pen.Color := FOccupyPenColor;
      Canvas.Brush.Color := FOccupyBrushColor;
    end;
    Canvas.Brush.Color := FTrackBrush.Color;
    case FState of
      siUp:
        begin
          if FSelected then
          begin
            Canvas.Brush.Assign(FSelectBrush);
            if not (Foreign in [trNo]) then
            begin
              Canvas.Brush.Color := FOccupyBrushColor;
            end;
          end
        end;
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
    end;
  end
  else // not HotTracked
  begin
    //----------------------------------------
    Canvas.Pen.Assign(FRegularPen);
    case FState of
      siUp:
        begin
          if FSelected then
          begin
            Canvas.Pen.Width := Canvas.Pen.Width + 1;
          end;
        end;
      siDown:
        begin
          Canvas.Brush.Assign(FRegularBrush);
          Canvas.Brush.Color := FClickedColor;
          Canvas.Font.Assign(FRegularFont);
          if FSelected then
          begin
            Canvas.Font.Color := FSelectFont.Color;
          end;
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
    end;
  end;
  //----------------------------------------
end;

procedure TCustomSeatEx.CMButtonPressed(var Message: TMessage);
begin
  inherited;
  if Message.WParam = 2 then
    if (FSeatColumnShow or FSeatRowShow) then
      Invalidate;
end;

procedure TCustomSeatEx.SXRangeSelect(var Message: TSXRangeSelectMsg);
var
  RangeLeft, RangeTop, RangeRight, RangeBottom, SelfRight, SelfBottom: Integer;
begin
  if Message.Cmd = 1 then
    if Enabled then
      with Message do
      try
        RangeLeft := Min(RangeRect^.Left, RangeRect^.Right);
        RangeTop := Min(RangeRect^.Top, RangeRect^.Bottom);
        RangeRight := Max(RangeRect^.Left, RangeRect^.Right);
        RangeBottom := Max(RangeRect^.Top, RangeRect^.Bottom);
        SelfRight := Left + Height;
        SelfBottom := Top + Width;
        if ((((RangeLeft > Left) and (RangeLeft < SelfRight))
          or ((RangeLeft < Left) and (RangeRight > SelfRight))
          or ((RangeRight > Left) and (RangeRight < SelfRight))
          ) and (
          ((RangeTop > Top) and (RangeTop < SelfBottom))
          or ((RangeTop < Top) and (RangeBottom > SelfBottom))
          or ((RangeBottom > Top) and (RangeBottom < SelfBottom)))) then
        begin
          FSelectingRange := True;
          Click;
          // Repaint;
          FSelectingRange := False;
        end;
      except
      end;
end;

procedure TCustomSeatEx.Click;
begin
  if FHandleLeftClick and SelectAction then
    if DoSelect(not Selected) then
    begin
      Selected := not Selected;
      if Selected then
        Foreign := trNo;
    end;
  inherited Click;
end;

function TCustomSeatEx.DoSelect(const SelectControl: Boolean): Boolean;
begin
  if Assigned(FOnSeatExSelect) then
  begin
    Result := SelectControl;
    FOnSeatExSelect(Self, FSelectingRange, Result)
  end
  else
    Result := True;
end;

procedure TCustomSeatEx.DoHintUpdate;
var
  FHintText: string;
begin
  if FHandleHintUpdate then
  begin
    FHintText := Hint;
    if Assigned(FOnSeatExHintUpdate) then
    begin
      FOnSeatExHintUpdate(Self, FHintText);
    end
    else
    begin
      DefaultHintUpdate(FHintText);
    end;
    Hint := FHintText;
  end;
end;

procedure TCustomSeatEx.DefaultHintUpdate(var HintText: string);
begin
{$IFDEF def_Rus_Eng}
  HintText := 'Ряд (Row)' + c_Lim + IntToStr(FSeatRow) + c_CRLF
    + 'Место (Column)' + c_Lim + IntToStr(FSeatColumn) + c_CRLF
    + c_Separator_20 + c_CRLF
    + 'Выделено (Selected)' + c_Lim + c_Boolean[FSelected] + c_CRLF
    + 'Когда (When)' + c_Lim + DateTimeToStr(FLockStamp) + c_CRLF
    + 'Чужое (Foreign)' + c_Lim + c_Triplean[FForeign];
{$ELSE}
  HintText := 'Ряд' + c_Lim + IntToStr(FSeatRow) + c_CRLF
    + 'Место' + c_Lim + IntToStr(FSeatColumn) + c_CRLF
    + c_Separator_20 + c_CRLF
    + 'Выделено' + c_Lim + c_Boolean[FSelected] + c_CRLF
    + 'Когда' + c_Lim + DateTimeToStr(FLockStamp) + c_CRLF
    + 'Чужое' + c_Lim + c_Triplean[FForeign];
{$ENDIF}
end;

procedure TCustomSeatEx.SetHandleLeftClick(const Value: Boolean);
begin
  if Value <> FHandleLeftClick then
  begin
    FHandleLeftClick := Value;
    // Invalidate;
  end;
end;

procedure TCustomSeatEx.SetHandleHintUpdate(const Value: Boolean);
begin
  if Value <> FHandleHintUpdate then
  begin
    FHandleHintUpdate := Value;
    // Invalidate;
  end;
end;

procedure TCustomSeatEx.SetOccupyBrushColor(const Value: TColor);
begin
  if FOccupyBrushColor <> Value then
  begin
    FOccupyBrushColor := Value;
    Invalidate;
  end;
end;

procedure TCustomSeatEx.SetOccupyFontColor(const Value: TColor);
begin
  if FOccupyFontColor <> Value then
  begin
    FOccupyFontColor := Value;
    Invalidate;
  end;
end;

procedure TCustomSeatEx.SetOccupyPenColor(const Value: TColor);
begin
  if FOccupyPenColor <> Value then
  begin
    FOccupyPenColor := Value;
    Invalidate;
  end;
end;

procedure TCustomSeatEx.SetTrackSelPenColor(const Value: TColor);
begin
  if FTrackSelPenColor <> Value then
  begin
    FTrackSelPenColor := Value;
    Invalidate;
  end;
end;

procedure TCustomSeatEx.SetTrackCurPenColor(const Value: TColor);
begin
  if FTrackCurPenColor <> Value then
  begin
    FTrackCurPenColor := Value;
    Invalidate;
  end;
end;

function TCustomSeatEx.SelectAction: Boolean;
begin
  Result := True;
end;

procedure TCustomSeatEx.Loaded;
begin
  inherited;
  FSelectingRange := False;
  DoHintUpdate;
end;

{ TSeatEx }

constructor TSeatEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //----------------------------------------
  FSeatState := tsFree;
  FTicketKod := 0;
  FTicketVer := 0;
  FTicketName := '';
  FPrintCount := 0;
  FCheqed := False;
  FLastAction := oaUnknown;
  FSaleCost := 0;
  // FSaleStamp := 0;
  FRepertKod := 0;
  FRepertVer := 0;
  FReason := 0;
  FSerialStr := '';
  FSessionUid := -1;
  FUserUid := -1;
  FUserName := '';
  FUserHost := '';
  // -------------------------------------------
  FPrepareFontColor := clWhite;
  FPreparePenColor := clWhite;
  FReserveBrushColor := clDkYellow;
  FRealizeBrushColor := clGray;
  FRealizeFontColor := clBlack;
  // -------------------------------------------
end;

destructor TSeatEx.Destroy;
begin
  inherited Destroy;
end;

procedure TSeatEx.ResetToDefault(NewState: TTicketState);
begin
  //----------------------------------------
  FSeatState := NewState;
  FForeign := trUnknown;
  FCurrent := trUnknown;
  FSelected := False;
  // -------------------------------------------
  FTicketKod := 0;
  FTicketVer := 0;
  FTicketName := '';
  FPrintCount := 0;
  FCheqed := False;
  FLastAction := oaUnknown;
  FLockStamp := Now;
  FSaleCost := 0;
  // FSaleStamp := TDateTime(0.0);
  FSaleStamp := Now;
  FModStamp := Now;
  FRepertKod := 0;
  FRepertVer := 0;
  FReason := 0;
  FSerialStr := '';
  FSessionUid := -1;
  FUserUid := -1;
  FUserName := '';
  FUserHost := '';
  // -------------------------------------------
  case NewState of
    tsFree, tsBroken:
      begin
        FRealizeBrushColor := clGray;
        FRealizeFontColor := clBlack;
      end;
    // -------------------------------------------
    {
    tsPrepared, tsReserved, tsRealized:
    begin
    end;
    }
    // -------------------------------------------
  else
  end;
  //----------------------------------------
  Invalidate;
end;

procedure TSeatEx.SetSeatState(const Value: TTicketState);
begin
  if FSeatState <> Value then
  begin
    FSeatState := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetTicketKod(const Value: Integer);
begin
  if FTicketKod <> Value then
  begin
    FTicketKod := Value;
    GetTicketProps;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetTicketVer(const Value: Integer);
begin
  if FTicketVer <> Value then
  begin
    FTicketVer := Value;
    GetTicketProps;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetTicketName(const Value: string);
begin
  if FTicketName <> Value then
  begin
    FTicketName := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

function TSeatEx.GetPrinted: Boolean;
begin
  Result := (FPrintCount > 0);
end;

procedure TSeatEx.SetPrintCount(const Value: Integer);
begin
  if FPrintCount <> Value then
  begin
    FPrintCount := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetCheqed(const Value: Boolean);
begin
  if FCheqed <> Value then
  begin
    FCheqed := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetLastAction(const Value: TOperAction);
begin
  if FLastAction <> Value then
  begin
    FLastAction := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetSaleCost(const Value: Integer);
begin
  if FSaleCost <> Value then
  begin
    FSaleCost := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetSaleForm(const Value: TSaleForm);
begin
  if FSaleForm <> Value then
  begin
    FSaleForm := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetSaleStamp(const Value: TDateTime);
begin
  if FSaleStamp <> Value then
  begin
    FSaleStamp := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetModStamp(const Value: TDateTime);
begin
  if FModStamp <> Value then
  begin
    FModStamp := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetRepertKod(const Value: Integer);
begin
  if FRepertKod <> Value then
  begin
    FRepertKod := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetRepertVer(const Value: Integer);
begin
  if FRepertVer <> Value then
  begin
    FRepertVer := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetReason(const Value: TReasonType);
begin
  if FReason <> Value then
  begin
    FReason := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetSerialStr(const Value: TSerialStrType);
begin
  if FSerialStr <> Value then
  begin
    FSerialStr := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetSessionUid(const Value: TSessionType);
begin
  if FSessionUid <> Value then
  begin
    FSessionUid := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetUserUid(const Value: Integer);
begin
  if FUserUid <> Value then
  begin
    FUserUid := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetUserName(const Value: string);
begin
  if FUserName <> Value then
  begin
    FUserName := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetUserHost(const Value: string);
begin
  if FUserHost <> Value then
  begin
    FUserHost := Value;
    DoHintUpdate;
    Invalidate;
  end;
end;

procedure TSeatEx.SetPrepareFontColor(const Value: TColor);
begin
  if FPrepareFontColor <> Value then
  begin
    FPrepareFontColor := Value;
    Invalidate;
  end;
end;

procedure TSeatEx.SetPreparePenColor(const Value: TColor);
begin
  if FPreparePenColor <> Value then
  begin
    FPreparePenColor := Value;
    Invalidate;
  end;
end;

procedure TSeatEx.SetReserveBrushColor(const Value: TColor);
begin
  if FReserveBrushColor <> Value then
  begin
    FReserveBrushColor := Value;
    Invalidate;
  end;
end;

procedure TSeatEx.SetReserveFontColor(const Value: TColor);
begin
  if FReserveFontColor <> Value then
  begin
    FReserveFontColor := Value;
    Invalidate;
  end;
end;

procedure TSeatEx.SetRealizeBrushColor(const Value: TColor);
begin
  if FRealizeBrushColor <> Value then
  begin
    FRealizeBrushColor := Value;
    Invalidate;
  end;
end;

procedure TSeatEx.SetRealizeFontColor(const Value: TColor);
begin
  if FRealizeFontColor <> Value then
  begin
    FRealizeFontColor := Value;
    Invalidate;
  end;
end;

function TSeatEx.SelectAction: Boolean;
var
  SaveState: TTicketState;
begin
  Result := False;
  //----------------------------------------
  SaveState := FSeatState;
  //----------------------------------------
  if (Foreign in [trUnknown, trNo]) then
  begin
    case SaveState of
      tsFree, tsBroken:
        begin
          Result := True;
        end;
      tsReserved, tsRealized:
        begin
          Result := True;
        end;
    else
      // nothing
    end;
  end
  else if (Foreign in [trYes]) then
  begin
    case SaveState of
      tsFree, tsBroken:
        begin
          if (not Selected) then
            Result := True;
        end;
      tsReserved, tsRealized:
        begin
          if (not Selected) then
            Result := True;
        end;
    else
      // nothing
    end;
  end;
end;

function TSeatEx.DoCmdReserve: Boolean;
begin
  // if Assigned(FOnSeatExReserve) then
  if Assigned(FOnSeatExCmd) then
  begin
    Result := True;
    // FOnSeatExReserve(Self, Result)
    FOnSeatExCmd(Self, oxReserve, Result)
  end
  else
    Result := True;
end;

function TSeatEx.DoCmdFree: Boolean;
begin
  // if Assigned(FOnSeatExFree) then
  if Assigned(FOnSeatExCmd) then
  begin
    Result := True;
    // FOnSeatExFree(Self, Result)
    FOnSeatExCmd(Self, oxFree, Result)
  end
  else
    Result := True;
end;

function TSeatEx.DoCmdRestore: Boolean;
begin
  // if Assigned(FOnSeatExRestore) then
  if Assigned(FOnSeatExCmd) then
  begin
    Result := True;
    // FOnSeatExRestore(Self, Result)
    FOnSeatExCmd(Self, oxRestore, Result)
  end
  else
    Result := True;
end;

procedure TSeatEx.DefaultHintUpdate(var HintText: string);
var
  SaveState: TTicketState;
begin
  inherited DefaultHintUpdate(HintText);
  if Enabled then
  begin
{$IFDEF def_Rus_Eng}
    HintText := HintText + c_CRLF
      + c_Separator_20 + c_CRLF
      + 'Состояние (SeatState)' + c_Lim + c_TicketState[FSeatState] + c_CRLF
      + 'Произведено (Last action)' + c_Lim + c_OperActionDesc[FLastAction] + c_CRLF
      + 'Когда (When)' + c_Lim + DateTimeToStr(FSaleStamp);
{$ELSE}
    HintText := HintText + c_CRLF
      + c_Separator_20 + c_CRLF
      + 'Состояние' + c_Lim + c_TicketState[FSeatState] + c_CRLF
      + 'Произведено' + c_Lim + c_OperActionDesc[FLastAction] + c_CRLF
      + 'Когда' + c_Lim + DateTimeToStr(FSaleStamp);
{$ENDIF}
    //----------------------------------------
    SaveState := FSeatState;
    //----------------------------------------
    if (FSessionUid > -1) or (FUserUid > -1) or (Length(FUserName) > 0) then
    begin
{$IFDEF def_Rus_Eng}
      HintText := HintText + c_CRLF
        + c_Separator_20 + c_CRLF
        + 'Пользователь (User)' + c_Lim + FUserName + ' [ ' + IntToStr(FUserUid) + ' ]' + c_CRLF
        + 'Хост (Host)' + c_Lim + FUserHost + c_CRLF
        + 'Код сессии (SessionUid)' + c_Lim + IntToStr(FSessionUid);
{$ELSE}
      HintText := HintText + c_CRLF
        + c_Separator_20 + c_CRLF
        + 'Пользователь' + c_Lim + FUserName + ' [ ' + IntToStr(FUserUid) + ' ]' + c_CRLF
        + 'Хост' + c_Lim + FUserHost + c_CRLF
        + 'Код сессии' + c_Lim + IntToStr(FSessionUid);
{$ENDIF}
      if ((SaveState in [tsPrepared, tsReserved, tsRealized])
        or (FLastAction in [oaUnknown, oaReserve, oaSale,
        oaActualize, oaModify, oaFree, oaRestore])) then
      begin
{$IFDEF def_Rus_Eng}
        HintText := HintText + c_CRLF
          + c_Separator_20 + c_CRLF
          + 'Тип билета (Kod)' + c_Lim + '[ ' + IntToStr(FTicketKod)
          + ', ' + IntToStr(FTicketVer) + ' ]' + c_CRLF
          + 'Название (Name)' + c_Lim + c_Quote + FTicketName + c_Quote + c_CRLF
          + 'Цена (Cost)' + c_Lim + IntToStr(FSaleCost) + c_Space + c_Valuta + c_CRLF
          + 'Тип продажи (Pay form)' + c_Lim + c_SfToStr[FSaleForm] + c_CRLF
          + c_Separator_20 + c_CRLF
          + 'Распечатано (Printed)' + c_Lim + IntToStr(FPrintCount) + c_CRLF
          + 'Проведено (Cheqed)' + c_Lim + c_Boolean[FCheqed] + c_CRLF
          + 'Когда (When)' + c_Lim + DateTimeToStr(FModStamp) + c_CRLF
          + c_Separator_20 + c_CRLF
          + 'Серия (Serial)' + c_Lim + FSerialStr;
{$ELSE}
        HintText := HintText + c_CRLF
          + c_Separator_20 + c_CRLF
          + 'Тип билета' + c_Lim + '[ ' + IntToStr(FTicketKod)
          + ', ' + IntToStr(FTicketVer) + ' ]' + c_CRLF
          + 'Название' + c_Lim + c_Quote + FTicketName + c_Quote + c_CRLF
          + 'Цена' + c_Lim + IntToStr(FSaleCost) + c_Space + c_Valuta + c_CRLF
          + 'Тип продажи' + c_Lim + c_SfToStr[FSaleForm] + c_CRLF
          + c_Separator_20 + c_CRLF
          + 'Распечатано' + c_Lim + IntToStr(FPrintCount) + c_CRLF
          + 'Проведено' + c_Lim + c_Boolean[FCheqed] + c_CRLF
          + 'Когда' + c_Lim + DateTimeToStr(FModStamp) + c_CRLF
          + c_Separator_20 + c_CRLF
          + 'Серия' + c_Lim + FSerialStr;
        {
        FRepertKod := 0;
        FRepertVer := 0;
        }
{$ENDIF}
        if FLastAction in [oaUnknown, oaRestore] then
        begin
{$IFDEF def_Rus_Eng}
          HintText := HintText + c_CRLF
            + c_Separator_20 + c_CRLF
            + 'Код возврата (Reason)' + c_Lim + IntToStr(FReason);
{$ELSE}
          HintText := HintText + c_CRLF
            + c_Separator_20 + c_CRLF
            + 'Код возврата' + c_Lim + IntToStr(FReason);
{$ENDIF}
        end;
      end;
    end; // if (FSessionUid > -1)
  end;
end;

procedure TSeatEx.HandleShapeStateBefore(HotTracked: Boolean;
  const Client: TRect; const Offset: TPoint);
var
  SaveState: TTicketState;
begin
  // inherited HandleShapeStateBefore(HotTracked, Client, Offset);
  //----------------------------------------
  SaveState := FSeatState;
  //----------------------------------------
  case SaveState of
    tsFree, tsBroken: // === === === === === === === ===
      begin
        Canvas.Font.Assign(FRegularFont);
        if not Selected then
        begin
          if not HotTracked then
          begin
            Canvas.Brush.Assign(FRegularBrush);
            Canvas.Pen.Assign(FRegularPen);
            if (Foreign in [trNo]) then
            begin
              // Canvas.Pen.Width := Canvas.Pen.Width + 1;
              if (Current in [trYes]) then
              begin
                Canvas.Pen.Color := FTrackSelPenColor;
              end
              else
              begin
                Canvas.Pen.Color := FTrackCurPenColor;
              end;
            end;
          end
          else // HotTracked
          begin
            Canvas.Brush.Assign(FTrackBrush);
            Canvas.Pen.Assign(FTrackPen);
          end;
        end
        else // Selected
        begin
          if not HotTracked then
          begin
            Canvas.Brush.Assign(FSelectBrush);
            Canvas.Pen.Assign(FRegularPen);
            if (Foreign in [trYes]) then
            begin
              Canvas.Brush.Color := FOccupyBrushColor;
            end;
          end
          else // HotTracked
          begin
            Canvas.Brush.Assign(FTrackBrush);
            Canvas.Pen.Assign(FTrackPen);
            if (Foreign in [trYes]) then
            begin
              Canvas.Brush.Color := FOccupyBrushColor;
              Canvas.Pen.Color := FOccupyPenColor;
            end
            else
            begin
              Canvas.Brush.Color := FSelectBrush.Color;
              Canvas.Pen.Color := FSelectPen.Color;
            end;
          end;
        end;
      end;
    {
    tsBroken: // === === === === === === === ===
      begin
      end;
    }
    tsPrepared: // === === === === === === === ===
      begin
        Canvas.Font.Assign(FRegularFont);
        Canvas.Font.Color := FPrepareFontColor;
        if not Selected then
        begin
          if not HotTracked then
          begin
            Canvas.Brush.Assign(FRegularBrush);
            Canvas.Brush.Color := FRealizeBrushColor;
            Canvas.Pen.Assign(FRegularPen);
          end
          else // HotTracked
          begin
            Canvas.Brush.Assign(FTrackBrush);
            Canvas.Brush.Color := FRealizeBrushColor;
            Canvas.Pen.Assign(FTrackPen);
          end;
          Canvas.Pen.Color := FPreparePenColor;
        end
        else // Selected
        begin
          if not HotTracked then
          begin
            Canvas.Brush.Assign(FSelectBrush);
            Canvas.Brush.Color := FRealizeBrushColor;
            Canvas.Pen.Assign(FRegularPen);
          end
          else // HotTracked
          begin
            Canvas.Brush.Assign(FTrackBrush);
            Canvas.Brush.Color := FRealizeBrushColor;
            Canvas.Pen.Assign(FTrackPen);
          end;
          Canvas.Pen.Color := FPreparePenColor;
        end;
      end;
    tsReserved: // === === === === === === === ===
      begin
        Canvas.Font.Assign(FRegularFont);
        Canvas.Font.Color := FReserveFontColor;
        if not Selected then
        begin
          if not HotTracked then
          begin
            Canvas.Brush.Assign(FRegularBrush);
            Canvas.Brush.Color := FReserveBrushColor;
            Canvas.Pen.Assign(FRegularPen);
            if (Foreign in [trNo]) then
            begin
              // Canvas.Pen.Width := Canvas.Pen.Width + 1;
              if (Current in [trYes]) then
              begin
                Canvas.Pen.Color := FTrackSelPenColor;
              end
              else
              begin
                Canvas.Pen.Color := FTrackCurPenColor;
              end;
            end;
          end
          else // HotTracked
          begin
            Canvas.Brush.Assign(FTrackBrush);
            Canvas.Brush.Color := FReserveBrushColor;
            Canvas.Pen.Assign(FTrackPen);
          end;
        end
        else // Selected
        begin
          if not HotTracked then
          begin
            Canvas.Brush.Assign(FSelectBrush);
            Canvas.Brush.Color := FReserveBrushColor;
            Canvas.Pen.Assign(FSelectPen);
            if (Foreign in [trYes]) then
            begin
              Canvas.Pen.Color := FOccupyBrushColor;
            end
            else
            begin
              Canvas.Pen.Color := FSelectBrush.Color;
            end;
          end
          else // HotTracked
          begin
            Canvas.Brush.Assign(FTrackBrush);
            Canvas.Brush.Color := FReserveBrushColor;
            Canvas.Pen.Assign(FTrackPen);
            if (Foreign in [trYes]) then
            begin
              Canvas.Pen.Color := FOccupyPenColor;
            end
            else
            begin
              Canvas.Pen.Color := FSelectPen.Color;
            end;
          end;
        end;
      end;
    tsRealized: // === === === === === === === ===
      begin
        Canvas.Font.Assign(FRegularFont);
        Canvas.Font.Color := FRealizeFontColor;
        if not Selected then
        begin
          if not HotTracked then
          begin
            Canvas.Brush.Assign(FRegularBrush);
            Canvas.Brush.Color := FRealizeBrushColor;
            Canvas.Pen.Assign(FRegularPen);
            if (Foreign in [trNo]) then
            begin
              // Canvas.Pen.Width := Canvas.Pen.Width + 1;
              if (Current in [trYes]) then
              begin
                Canvas.Pen.Color := FTrackSelPenColor;
              end
              else
              begin
                Canvas.Pen.Color := FTrackCurPenColor;
              end;
            end;
          end
          else // HotTracked
          begin
            Canvas.Brush.Assign(FTrackBrush);
            Canvas.Brush.Color := FRealizeBrushColor;
            Canvas.Pen.Assign(FTrackPen);
          end;
        end
        else // Selected
        begin
          if not HotTracked then
          begin
            Canvas.Brush.Assign(FSelectBrush);
            Canvas.Brush.Color := FRealizeBrushColor;
            Canvas.Pen.Assign(FSelectPen);
            if (Foreign in [trYes]) then
            begin
              Canvas.Pen.Color := FOccupyBrushColor;
            end
            else
            begin
              Canvas.Pen.Color := FSelectBrush.Color;
            end;
          end
          else // HotTracked
          begin
            Canvas.Brush.Assign(FTrackBrush);
            Canvas.Brush.Color := FRealizeBrushColor;
            Canvas.Pen.Assign(FTrackPen);
            if (Foreign in [trYes]) then
            begin
              Canvas.Pen.Color := FOccupyPenColor;
            end
            else
            begin
              Canvas.Pen.Color := FSelectPen.Color;
            end;
          end;
        end;
      end;
  end; // === === === === === === === ===
  case FState of
    siUp:
      begin
      end;
    siDown:
      begin
        // Canvas.Brush.Assign(FRegularBrush);
        Canvas.Brush.Color := FClickedColor;
        Canvas.Font.Assign(FRegularFont);
        if FSelected then
        begin
          Canvas.Font.Color := FSelectFont.Color;
        end;
        // Canvas.Pen.Width := Canvas.Pen.Width + 1;
      end;
    siDisabled:
      begin
        Canvas.Brush.Assign(FRegularBrush);
        // Canvas.Brush.Color := clBtnFace;
        Canvas.Font.Assign(FRegularFont);
        Canvas.Pen.Assign(FRegularPen);
        Canvas.Pen.Color := clBtnShadow;
        Canvas.Pen.Width := Canvas.Pen.Width + 1;
      end;
  end;
  //----------------------------------------
end;

procedure TSeatEx.HandleShapeStateAfter(HotTracked: Boolean;
  const Client: TRect; const Offset: TPoint);
var
  SaveState: TTicketState;
  wx, wy, bx, by: integer;
  // TextBounds: TRect;
  SaveBrushColor: TColor;
  SaveBrushStyle: TBrushStyle;
  SavePenColor: TColor;
  SavePenWidth: Integer;
  SavePenStyle: TPenStyle;
  // SavePenMode: TPenMode;
begin
  // inherited HandleShapeStateAfter(HotTracked, Client, Offset);
  //----------------------------------------
  SaveState := FSeatState;
  //----------------------------------------
  SaveBrushColor := Canvas.Brush.Color;
  SaveBrushStyle := Canvas.Brush.Style;
  SavePenColor := Canvas.Pen.Color;
  SavePenWidth := Canvas.Pen.Width;
  SavePenStyle := Canvas.Pen.Style;
  // SavePenMode := Canvas.Pen.Mode;
  //----------------------------------------
  //  SaveState = (tsFree, tsBroken, tsPrepared, tsReserved, tsRealized);
  if (FState <> siDisabled) then
  begin
    wx := Offset.x + Canvas.Pen.Width + 1;
    wy := Offset.y + Canvas.Pen.Width + 1;
    bx := Width - wx - 1;
    by := Height - wy - 1;
    if (SaveState in [tsBroken]) then
    begin
      Canvas.Pen.Width := 2;
      Canvas.Pen.Color := clBtnShadow;
      {
      // Back Diagonal
      Canvas.MoveTo(wx, wy);
      Canvas.LineTo(bx, by);
      }
      // Forward Diagonal
      Canvas.MoveTo(bx, wy);
      Canvas.LineTo(wx, by);
    end
    else if (SaveState in [tsFree]) then
    begin
      case FLastAction of
        oaUnknown:
          if (Foreign <> trUnknown) then
          begin
            // Canvas.Pen.Width := 2;
            // Canvas.Pen.Color := clBtnShadow;
            // Forward Diagonal in TopLeft Corner
            {
            Canvas.MoveTo(wx + Width div 5, wy);
            Canvas.LineTo(wx, wy + Height div 5);
            // Canvas.Rectangle(wx, wy, wx + bx div 5, wy + by div 5);
            }
            Canvas.MoveTo(wx + bx div 5, wy);
            Canvas.LineTo(wx, wy + by div 5);
          end;
        oaCancel:
          if GlobalSeatCanceledShow then
          begin
            {
            // Canvas.Pen.Width := 2;
            // Canvas.Pen.Color := clBtnShadow;
            // Forward Diagonal in BottomRight Corner
            Canvas.MoveTo(bx - Width div 5, by);
            Canvas.LineTo(bx, by - Height div 5);
            }
            case Foreign of
              trNo:
                case Current of
                  trYes:
                    Canvas.Pen.Color := FSelectBrush.Color;
                  trNo:
                    Canvas.Pen.Color := FTrackSelPenColor;
                end;
              trYes:
                Canvas.Pen.Color := FOccupyBrushColor;
            end;
            // Back Diagonal in BottomLeft Corner
            {
            Canvas.MoveTo(wx + Width div 5, by);
            Canvas.LineTo(wx, by - Height div 5);
            Canvas.LineTo(wx, by);
            Canvas.LineTo(wx + Width div 5, by);
            }
            Canvas.MoveTo(wx + Width div 5, by);
            Canvas.LineTo(wx, by);
            Canvas.LineTo(wx, by - Height div 5);
          end;
        oaFree:
          if GlobalSeatFreedShow then
          begin
            Canvas.Brush.Style := bsSolid;
            Canvas.Brush.Color := FRealizeBrushColor;
            Canvas.Pen.Width := 1;
            Canvas.Pen.Style := psSolid;
            Canvas.Pen.Color := FReserveBrushColor;
            // Canvas.Pen.Mode := pmNotCopy;
            Canvas.Rectangle(wx, (3 * Height div 4) - wy,
              wx + Width div 4, Height - wy);
          end;
        oaRestore:
          if GlobalSeatRestoredShow then
          begin
            {
            TextBounds.Left := 0;
            TextBounds.Top := wy + (2 * Width) div 3;
            TextBounds.Right := wx + bx div 4;
            TextBounds.Bottom := Width;
            }
            Canvas.Brush.Style := bsSolid;
            Canvas.Brush.Color := FRealizeBrushColor;
            Canvas.Pen.Width := 1;
            // Canvas.Pen.Style := psClear;
            // Canvas.Pen.Color := not (Canvas.Brush.Color);
            case Foreign of
              trNo:
                case Current of
                  trYes:
                    Canvas.Pen.Color := FSelectBrush.Color;
                  trNo:
                    Canvas.Pen.Color := FTrackSelPenColor;
                end;
              trYes:
                Canvas.Pen.Color := FOccupyBrushColor;
            end;
            // Canvas.Pen.Mode := pmNotCopy;
            {
            Canvas.Rectangle(wx, (3 * Height div 4) - wy,
              wx + Width div 4, Height - wy);
            }
            // Back Diagonal in BottomLeft Corner
            {
            Canvas.MoveTo(wx + Width div 4, by);
            Canvas.LineTo(wx, by - Height div 4);
            Canvas.LineTo(wx, by);
            Canvas.LineTo(wx + Width div 4, by);
            }
            Canvas.Polygon([Point(wx + Width div 3, by),
              Point(wx, by - Height div 3), Point(wx, by)]);
            {
            Canvas.Rectangle(TextBounds);
            // Canvas.Font.Assign(FRegularFont);
            Canvas.Font.Style := [];
            // Font.Height = -Font.Size * Font.PixelsPerInch / 72
            // Font.Size = -Font.Height * 72 / Font.PixelsPerInch
            Canvas.Font.Height := -(TextBounds.Bottom - TextBounds.Top);
            inherited DrawButtonText(TextBounds, c_OperActionPfx[FLastAction],
              DrawTextBiDiModeFlags(0));
            }
          end;
      else
        // oaReserve, oaSale, oaActualize, oaSelect
      end;
    end
    else if (SaveState in [tsReserved]) then
    begin
      {
      // Vertical line in corner
      Canvas.MoveTo(wx + Width div 6, (2 * Height div 3) - wy);
      Canvas.LineTo(wx + Width div 6, Height - wy);
      }
      {
      // DiagCross in corner
      Canvas.MoveTo(wx, 2 * Height div 3 - wy);
      Canvas.LineTo(Width div 3 + wx, Height - wy);
      Canvas.MoveTo(wx, Height - wy);
      Canvas.LineTo(Width div 3 + wx, 2 * Height div 3 - wy);
      }
      {
      // Slash in corner
      Canvas.MoveTo(wx, (2 * Height div 3) - wy);
      Canvas.LineTo((Width div 3) + wx, Height - wy);
      }
      // Rect in corner
      Canvas.Brush.Color := FRealizeBrushColor;
      Canvas.Pen.Width := 1;
      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Color := not (Canvas.Brush.Color);
      // Canvas.Pen.Mode := pmXor;
      Canvas.Rectangle(wx, (3 * Height div 4) - wy,
        wx + Width div 4, Height - wy);
    end
    else if (SaveState in [tsRealized]) then
    begin
      case SaleForm of
        sfNotPaid:
          begin
          end;
        sfCash:
          begin
            // Rect in corner
            Canvas.Brush.Color := FPreparePenColor;
            Canvas.Brush.Style := bsClear;
            Canvas.Pen.Width := 1;
            Canvas.Pen.Style := psClear;
            Canvas.Pen.Color := not (Canvas.Brush.Color);
            if GlobalSeatCheqedShow and (not Cheqed) then
            begin
              Canvas.Pen.Style := psSolid;
              Canvas.Pen.Color := clRed;
              Canvas.Brush.Color := clWhite;
              Canvas.Brush.Style := bsSolid;
            end;
            // Canvas.Pen.Mode := pmXor;
          end;
        sfCredit:
          begin
            // Rect in corner
            Canvas.Brush.Color := FReserveBrushColor;
            Canvas.Pen.Width := 1;
            Canvas.Pen.Style := psSolid;
            Canvas.Pen.Color := FRealizeFontColor;
            // Canvas.Pen.Mode := pmXor;
          end;
      else
        // Rect in corner
        Canvas.Brush.Color := FReserveBrushColor;
        Canvas.Pen.Width := 1;
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Color := not (Canvas.Brush.Color);
        // Canvas.Pen.Mode := pmXor;
      end; // case
      Canvas.Rectangle(wx, (3 * Height div 4) - wy,
        wx + Width div 4, Height - wy);
    end;
  end;
  //----------------------------------------
  Canvas.Brush.Color := SaveBrushColor;
  Canvas.Brush.Style := SaveBrushStyle;
  Canvas.Pen.Color := SavePenColor;
  Canvas.Pen.Width := SavePenWidth;
  Canvas.Pen.Style := SavePenStyle;
  // Canvas.Pen.Mode := SavePenMode;
  //----------------------------------------
end;

procedure TSeatEx.GetTicketProps;
var
  Nam: string;
  BgColor, FontColor: TColor;
begin
  if Assigned(FOnGetTicketProps) then
  begin
    FOnGetTicketProps(Self, FTicketKod, FTicketVer, Nam, BgColor, FontColor);
    TicketName := Nam;
    RealizeBrushColor := BgColor;
    RealizeFontColor := FontColor;
  end;
end;

procedure TSeatEx.SXCommand(var Message: TSXCommandMsg);
var
  i: Integer;
  a: TOperActionEx;
begin
  if Message.Cmd = 1 then
    if Enabled then
      with Message do
      try
        i := Info^.Action;
        if (Low(c_Int2OperActionEx) <= i) and (High(c_Int2OperActionEx) >= i) then
        begin
          a := c_Int2OperActionEx[i];
          case a of
            oxReserve:
              begin
                if (Foreign = trNo) and (SeatState in [tsPrepared]) and DoCmdReserve then
                begin
                  Selected := False;
                  Foreign := trNo;
                  SeatState := tsReserved;
                end;
              end; // oxReserve
            oxSale:
              begin
              end; // oxSale
            oxActualize:
              begin
              end; // oxActualize
            oxFree:
              begin
                if (Foreign = trNo) and Selected and (SeatState in [tsReserved]) then
                  if DoCmdFree then
                  begin
                    Selected := False;
                    Foreign := trNo;
                    SeatState := tsFree;
                  end;
              end; // oxFree
            oxRestore:
              begin
                if (Foreign = trNo) and Selected and (SeatState in [tsRealized]) then
                  if DoCmdRestore then
                  begin
                    Selected := False;
                    Foreign := trNo;
                    SeatState := tsFree;
                  end;
              end; // oxRestore
            oxSelect:
              begin
              end; // oxSelect
            oxCancel:
              begin
              end; // oxCancel
            oxPrepare:
              begin
                {
                0 = tsFree - 'Свободно',
                1 = tsBroken - 'Сломано',
                3 = tsPrepared - 'Подготовлено',
                4 = tsReserved - 'Зарезервировано',
                4 = tsRealized - 'Продано'
                }
                if (Foreign = trNo) and Selected then
                begin
                  case SeatState of
                    tsFree:
                      begin
                        TicketKod := Info^.vTicketKod;
                        TicketVer := Info^.vTicketVer;
                        SeatState := tsPrepared;
                      end;
                    tsReserved:
                      begin
                        if (TicketVer > 0) then
                        begin
                          TicketKod := Info^.vTicketKod;
                          TicketVer := Info^.vTicketVer;
                        end;
                        // SeatState := tsReprepared;
                      end;
                  else // case
                  end; // case
                  // todo: Get latest SaleCost value
                end; // if
              end; // oxPrepare
          end;
        end;
      except
      end;
end;

{ TCustomOdeumPanel }

constructor TCustomOdeumPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // -------------------------------------------
  if (Parent is TControl) then
    FSavedShowHint := Parent.ShowHint
  else
    FSavedShowHint := False;
  // -------------------------------------------
  ResetRange(0, 0);
  FSelecting := False;
  FCapturing := False;
  FSendingMessage := False;
  // -------------------------------------------
  FRangeEdgePen := TPen.Create;
  FRangeEdgePen.Color := clRed;
  FRangeEdgePen.Width := 2;
  FRangeEdgePen.Style := psDash;
  FRangeEdgePen.OnChange := StyleChanged;
  // -------------------------------------------
end;

destructor TCustomOdeumPanel.Destroy;
begin
  // -------------------------------------------
  FRangeEdgePen.Free;
  // -------------------------------------------
  inherited Destroy;
end;

procedure TCustomOdeumPanel.SetRangeEdgePen(const Value: TPen);
begin
  FRangeEdgePen.Assign(Value);
end;

procedure TCustomOdeumPanel.Loaded;
begin
  inherited Loaded;
  FSendingMessage := False;
  ResetRange(0, 0);
end;

procedure TCustomOdeumPanel.StyleChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TCustomOdeumPanel.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
{$IFDEF def_Test_ShpCtrl2}
  // -------------------------------------------
  DEBUGMessEnh(0, '', '"MouseDown"', format('(%4d, %4d), S=[%2s], C=[%2s], %-10s',
    [X, Y, BooleanDesc[FSelecting], BooleanDesc[FCapturing], MouseButtonDesc[Button]]));
  // -------------------------------------------
{$ENDIF}
  if FSendingMessage then
  begin
{$IFDEF def_Test_ShpCtrl2}
    DEBUGMessEnh(0, '', 'MouseDown ignored');
{$ENDIF}
    Exit;
  end;
  if (Button = mbLeft) and (not FSendingMessage) then
  begin
    StartRangeSelect(X, Y);
    FSelecting := True;
    SetCapture(Self.Handle);
  end
  else
  begin
    if FSelecting then
    begin
      if (X1 <> X2) or (Y1 <> Y2) then
      begin
        // FCanceling := True;
        EndRangeSelect(X, Y);
        ResetRange(X, Y);
      end;
      FSelecting := False;
    end
    else
      inherited MouseDown(Button, Shift, X, Y);
  end;
end;

procedure TCustomOdeumPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
{$IFDEF def_Test_ShpCtrl2}
  // -------------------------------------------
  DEBUGMessEnh(0, '', 'MouseMove', format('(%4d, %4d), S=[%2s], C=[%2s]',
    [X, Y, BooleanDesc[FSelecting], BooleanDesc[FCapturing]]));
  // -------------------------------------------
{$ENDIF}
  if FSendingMessage then
  begin
{$IFDEF def_Test_ShpCtrl2}
    DEBUGMessEnh(0, '', 'MouseMove ignored');
{$ENDIF}
    Exit;
  end;
  inherited MouseMove(Shift, X, Y);
  if FSelecting then
  begin
    if FCapturing then
      ProcessRangeSelect(X, Y)
    else
    begin
      FSelecting := False;
      ReleaseCapture;
      FCapturing := False;
    end;
  end;
end;

procedure TCustomOdeumPanel.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
{$IFDEF def_Test_ShpCtrl2}
  // -------------------------------------------
  DEBUGMessEnh(0, '', '"MouseUp"  ', format('(%4d, %4d), S=[%2s], C=[%2s], %-10s',
    [X, Y, BooleanDesc[FSelecting], BooleanDesc[FCapturing], MouseButtonDesc[Button]]));
  // -------------------------------------------
{$ENDIF}
  if FSendingMessage then
  begin
{$IFDEF def_Test_ShpCtrl2}
    DEBUGMessEnh(0, '', 'MouseUp ignored');
{$ENDIF}
    Exit;
  end;
  if FSelecting then
  begin
    ReleaseCapture;
    FSelecting := False;
    EndRangeSelect(X, Y);
    if (Button = mbLeft) then
    begin
      DoSelectRange;
    end;
    ResetRange(X, Y);
  end
  else
    inherited MouseUp(Button, Shift, X, Y);
end;

procedure TCustomOdeumPanel.WMCaptureChanged(var Message: TMessage);
begin
{$IFDEF def_Test_ShpCtrl2}
  // -------------------------------------------
  DEBUGMessEnh(0, '', '"CaptureChanged"',
    format('Rect(%4d, %4d, %4d, %4d), S=[%2s], C=[%2s], Self=(%.8x), hwnd=(%.8x)',
    [X1, Y1, X2, Y2, BooleanDesc[FSelecting], BooleanDesc[FCapturing], Self.Handle,
    Message.LParam]));
  // -------------------------------------------
{$ENDIF}
  if FSendingMessage then
  begin
{$IFDEF def_Test_ShpCtrl2}
    DEBUGMessEnh(0, '', 'CaptureChanged ignored');
{$ENDIF}
    Exit;
  end;
  inherited;
  if FSelecting then
  begin
    FCapturing := (Self.Handle = hwnd(Message.LParam));
    if not FCapturing then
    begin
      EndRangeSelect(X2, Y2);
      // ResetRange(X2, Y2);
    end;
  end
  else
    FCapturing := False;
end;

procedure TCustomOdeumPanel.StartRangeSelect(X, Y: Integer);
begin
{$IFDEF def_Test_ShpCtrl2}
  // -------------------------------------------
  DEBUGMessEnh(1, '', '', '');
  DEBUGMessEnh(0, '', 'StartRangeSelect',
    format('Point(%4d, %4d), S=[%2s], C=[%2s]',
    [X, Y, BooleanDesc[FSelecting], BooleanDesc[FCapturing]]));
  DEBUGMessEnh(-1, '', '', '');
  // -------------------------------------------
{$ENDIF}
  // -------------------------------------------
  if (Parent is TControl) then
  begin
    FSavedShowHint := Parent.ShowHint;
    Parent.ShowHint := False;
  end;
  // -------------------------------------------
  Canvas.MoveTo(X, Y);
  ResetRange(X, Y);
{$IFDEF def_UseForms}
  Screen.Cursor := crCross;
{$ENDIF}
end;

procedure TCustomOdeumPanel.ProcessRangeSelect(X, Y: Integer);
begin
{$IFDEF def_Test_ShpCtrl2}
  // -------------------------------------------
  DEBUGMessEnh(1, '', '', '');
  DEBUGMessEnh(0, '', 'ProcessRangeSelect',
    format('Rect(%4d, %4d, %4d, %4d), Point(%4d, %4d), S=[%2s], C=[%2s]',
    [X1, Y1, X2, Y2, X, Y, BooleanDesc[FSelecting], BooleanDesc[FCapturing]]));
  DEBUGMessEnh(-1, '', '', '');
  // -------------------------------------------
{$ENDIF}
  with Canvas do
  begin
    FSavedBrushStyle := Brush.Style;
    FSavedPenColor := Pen.Color;
    FSavedPenMode := Pen.Mode;
    FSavedPenStyle := Pen.Style;
    FSavedPenWidth := Pen.Width;
    // -------------------------------------------
    Brush.Style := bsClear;
    // Brush.Style := bsDiagCross;
    Pen.Assign(FRangeEdgePen);
    if Pen.Style = psClear then
      Pen.Style := psDash;
    Pen.Mode := pmXor;
    Rectangle(X1, Y1, X2, Y2);
    X2 := X;
    Y2 := Y;
    Rectangle(X1, Y1, X2, Y2);
    // -------------------------------------------
    Brush.Style := FSavedBrushStyle;
    Pen.Color := FSavedPenColor;
    Pen.Mode := FSavedPenMode;
    Pen.Style := FSavedPenStyle;
    Pen.Width := FSavedPenWidth;
  end;
end;

procedure TCustomOdeumPanel.EndRangeSelect(X, Y: Integer);
begin
{$IFDEF def_Test_ShpCtrl2}
  // -------------------------------------------
  DEBUGMessEnh(1, '', '', '');
  DEBUGMessEnh(0, '', 'EndRangeSelect',
    format('Rect(%4d, %4d, %4d, %4d), Point(%4d, %4d), S=[%2s], C=[%2s]',
    [X1, Y1, X2, Y2, X, Y, BooleanDesc[FSelecting], BooleanDesc[FCapturing]]));
  DEBUGMessEnh(-1, '', '', '');
  // -------------------------------------------
{$ENDIF}
  if FSelecting then
  begin
    with Canvas do
    begin
      FSavedBrushStyle := Brush.Style;
      FSavedPenColor := Pen.Color;
      FSavedPenMode := Pen.Mode;
      FSavedPenStyle := Pen.Style;
      FSavedPenWidth := Pen.Width;
      // -------------------------------------------
      Brush.Style := bsClear;
      // Brush.Style := bsDiagCross;
      Pen.Assign(FRangeEdgePen);
      if Pen.Style = psClear then
        Pen.Style := psDash;
      Pen.Mode := pmXor;
      Rectangle(X1, Y1, X2, Y2);
      X2 := X;
      Y2 := Y;
      // -------------------------------------------
      Brush.Style := FSavedBrushStyle;
      Pen.Color := FSavedPenColor;
      Pen.Mode := FSavedPenMode;
      Pen.Style := FSavedPenStyle;
      Pen.Width := FSavedPenWidth;
      // -------------------------------------------
    end;
  end;
  if (Parent is TControl) then
  begin
    Parent.ShowHint := FSavedShowHint;
  end;
{$IFDEF def_UseForms}
  if (Screen.Cursor = crCross) then
    Screen.Cursor := Self.Cursor;
{$ENDIF}
end;

procedure TCustomOdeumPanel.ResetRange(X, Y: Integer);
begin
{$IFDEF def_Test_ShpCtrl2}
  // -------------------------------------------
  DEBUGMessEnh(1, '', '', '');
  DEBUGMessEnh(0, '', 'ResetRange',
    format('Point(%4d, %4d), S=[%2s], C=[%2s]',
    [X, Y, BooleanDesc[FSelecting], BooleanDesc[FCapturing]]));
  DEBUGMessEnh(-1, '', '', '');
  // -------------------------------------------
{$ENDIF}
  // Canvas.MoveTo(X, Y);
  FOrigin := Point(X, Y);
  FMovePt := FOrigin;
  X1 := X;
  Y1 := Y;
  X2 := X;
  Y2 := Y;
end;

procedure TCustomOdeumPanel.SelectRangeBefore(RangeRect: TRect);
begin
  if Assigned(FOnSelectRangeBefore) then
    FOnSelectRangeBefore(Self, RangeRect);
end;

procedure TCustomOdeumPanel.SelectRangeAfter(RangeRect: TRect);
begin
  if Assigned(FOnSelectRangeAfter) then
    FOnSelectRangeAfter(Self, RangeRect);
end;

procedure TCustomOdeumPanel.DoSelectRange;
var
  Msg: TSXRangeSelectMsg;
  SavedCursor: TCursor;
begin
{$IFDEF def_Test_ShpCtrl2}
  DEBUGMessEnh(1, '', '', '');
  DEBUGMessEnh(0, '', 'SendSelectMsg',
    format('Rect(%4d, %4d, %4d, %4d), S=[%2s], C=[%2s]',
    [X1, Y1, X2, Y2, BooleanDesc[FSelecting], BooleanDesc[FCapturing]]));
{$ENDIF}
  if FSendingMessage then
  begin
{$IFDEF def_Test_ShpCtrl2}
    DEBUGMessEnh(0, '', 'SendSelectMsg ignored');
{$ENDIF}
  end
  else
  begin
    SelectRangeBefore(Rect(X1, Y1, X2, Y2));
    SavedCursor := Screen.Cursor;
    try
      Screen.Cursor := crAppStart;
      FSendingMessage := True;
      FRangeRect := Rect(X1, Y1, X2, Y2);
      Msg.Msg := SX_RANGESELECT;
      Msg.Cmd := 1;
      Msg.RangeRect := @FRangeRect;
      Msg.Result := 0;
      Self.Broadcast(Msg);
    finally
      FSendingMessage := False;
      Screen.Cursor := SavedCursor;
    end;
    SelectRangeAfter(Rect(X1, Y1, X2, Y2));
  end;
{$IFDEF def_Test_ShpCtrl2}
  DEBUGMessEnh(-1, '', '', '');
{$ENDIF}
end;

{ TOdeumPanel }

constructor TOdeumPanel.Create(AOwner: TComponent);
begin
  inherited;
  // -------------------------------------------
  FOdeumKod := 0;
  FOdeumVer := 0;
  FOdeumComment := '';
  FOdeumName := '';
  FOdeumCapacity := 0;
  FOdeumPrefix := '';
  FCinemaName := '';
  FAutoHint := True;
  FormatCaption;
  // -------------------------------------------
  FOdeumLogo := TBitmap.Create;
  FOdeumLogo.Height := 16;
  FOdeumLogo.Width := 16;
  FOdeumLogo.OnChange := StyleChanged;
  // -------------------------------------------
  FCinemaLogo := TBitmap.Create;
  FCinemaLogo.Height := 16;
  FCinemaLogo.Width := 16;
  FCinemaLogo.OnChange := StyleChanged;
  // -------------------------------------------
end;

destructor TOdeumPanel.Destroy;
begin
  // -------------------------------------------
  FCinemaLogo.Free;
  FOdeumLogo.Free;
  // -------------------------------------------
  inherited;
end;

procedure TOdeumPanel.SetOdeumKod(const Value: Integer);
begin
  if Value <> FOdeumKod then
  begin
    FOdeumKod := Value;
    GetOdeumProps;
    FormatCaption;
    Invalidate;
  end;
end;

procedure TOdeumPanel.SetOdeumVer(const Value: Integer);
begin
  if Value <> FOdeumVer then
  begin
    FOdeumVer := Value;
    GetOdeumProps;
    FormatCaption;
    Invalidate;
  end;
end;

procedure TOdeumPanel.SetOdeumComment(const Value: string);
begin
  if Value <> FOdeumComment then
  begin
    FOdeumComment := Value;
    Invalidate;
  end;
end;

procedure TOdeumPanel.SetOdeumName(const Value: string);
begin
  if Value <> FOdeumName then
  begin
    FOdeumName := Value;
    FormatCaption;
    Invalidate;
  end;
end;

procedure TOdeumPanel.SetOdeumCapacity(const Value: Integer);
begin
  if Value <> FOdeumCapacity then
  begin
    FOdeumCapacity := Value;
    FormatCaption;
    Invalidate;
  end;
end;

procedure TOdeumPanel.SetOdeumPrefix(const Value: string);
begin
  if Value <> FOdeumPrefix then
  begin
    FOdeumPrefix := Value;
    FormatCaption;
    Invalidate;
  end;
end;

procedure TOdeumPanel.SetCinemaName(const Value: string);
begin
  if Value <> FCinemaName then
  begin
    FCinemaName := Value;
    FormatCaption;
    Invalidate;
  end;
end;

procedure TOdeumPanel.SetOdeumLogo(const Value: TBitmap);
begin
  FOdeumLogo.Assign(Value);
  Invalidate;
end;

procedure TOdeumPanel.SetCinemaLogo(const Value: TBitmap);
begin
  FCinemaLogo.Assign(Value);
  Invalidate;
end;

procedure TOdeumPanel.SetAutoHint(const Value: Boolean);
begin
  if Value <> FAutoHint then
  begin
    FAutoHint := Value;
    DoAutoHint;
  end;
end;

procedure TOdeumPanel.SetMapMode(const Value: Boolean);
begin
  if Value <> FMapMode then
  begin
    FMapMode := Value;
    DoMapMode;
  end;
end;

procedure TOdeumPanel.DoMapMode;
begin
  // foo
end;

procedure TOdeumPanel.FormatCaption;
begin
  Caption := Format('-= %2s - [%d,%d] - %s - %s (%d) =-',
    [FOdeumPrefix, FOdeumKod, FOdeumVer, FCinemaName, FOdeumName, FOdeumCapacity]);
  DoAutoHint;
end;

procedure TOdeumPanel.DoAutoHint;
begin
  if FAutoHint then
  begin
{$IFDEF def_Rus_Eng}
    Hint := 'Код зала (Kod)' + c_Lim + '[ ' + IntToStr(FOdeumKod)
      + ', ' + IntToStr(FOdeumVer) + ' ]' + c_CRLF
      + 'Префикс зала (Prefix)' + c_Lim + FOdeumPrefix + c_CRLF
      + 'Название (Name)' + c_Lim + c_Quote + FCinemaName + ' - ' + FOdeumName + c_Quote;
{$ELSE}
    Hint := 'Код зала' + c_Lim + '[ ' + IntToStr(FOdeumKod)
      + ', ' + IntToStr(FOdeumVer) + ' ]' + c_CRLF
      + 'Префикс зала' + c_Lim + FOdeumPrefix + c_CRLF
      + 'Название' + c_Lim + c_Quote + FCinemaName + ' - ' + FOdeumName + c_Quote;
{$ENDIF}
    if (Length(FOdeumComment) > 0) then
    begin
      Hint := Hint + c_CRLF
        + c_Separator_20 + c_CRLF
        + FOdeumComment;
    end;
  end;
end;

procedure TOdeumPanel.GetOdeumProps;
var
  _OdeumNam, _Prefix, _Comment, _CinemaNam: string;
  _Capacity: Integer;
  _Logo1: TBitmap;
  _Logo2: TBitmap;
begin
  if Assigned(FOnGetOdeumProps) then
  begin
    _Logo1 := TBitmap.Create;
    try
      _Logo2 := TBitmap.Create;
      try
        FOnGetOdeumProps(Self, FOdeumKod, FOdeumVer, _OdeumNam, _Prefix,
          _Comment, _CinemaNam, _Capacity, _Logo1, _Logo2);
        FOdeumName := _OdeumNam;
        FOdeumPrefix := _Prefix;
        FOdeumComment := _Comment;
        FOdeumCapacity := _Capacity;
        FCinemaName := _CinemaNam;
        FCinemaLogo.Assign(_Logo1);
        FOdeumLogo.Assign(_Logo2);
        FormatCaption;
        Invalidate;
      finally
        _Logo2.Free;
      end;
    finally
      _Logo1.Free;
    end;
  end;
end;

procedure TOdeumPanel.Loaded;
begin
  inherited Loaded;
  DoAutoHint;
end;

end.

