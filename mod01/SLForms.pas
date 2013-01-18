{-----------------------------------------------------------------------------
 Unit Name: SLForms
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  06.08.2003
 Purpose:   Forms with position and dimensions autosave
 History:
-----------------------------------------------------------------------------}
unit SLForms;

{$I kinode01.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FrmRstr, ActnList
{$IFNDEF No_XP_Menu}
  , XPMenu
{$ENDIF}
  ;

type
{$IFNDEF No_XP_Menu}
  TXPMenu_Wrap = class(TXPMenu)
  end;
{$ELSE}
  TXPMenu_Wrap = class(TAction)
  end;
{$ENDIF}
 
  TSLForm = class(TForm)
    SLFormRestorer: TFrmRstr;
    SLActionList: TActionList;
    SLFullScreen: TAction;
    SLXPMenu: TXPMenu_Wrap;
    procedure SLFullScreenExecute(Sender: TObject);
  private
    _WindowState: TWindowState;
    FFullScreen: Boolean;
    function GetFullScreen: Boolean;
    procedure SetFullScreen(const Value: Boolean);
  protected
    procedure Activate; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property FullScreen: Boolean read GetFullScreen write SetFullScreen default false;
  end;

implementation

{$R *.DFM}

const
  UnitName: string = 'SLForms';

procedure TSLForm.SLFullScreenExecute(Sender: TObject);
begin
  FullScreen := not FullScreen;
  SLFullScreen.Checked := FullScreen;
end;

function TSLForm.GetFullScreen: Boolean;
begin
  FFullScreen := (Self.WindowState = wsMaximized) and (Self.BorderStyle =
    bsNone);
  Result := FFullScreen;
end;

procedure TSLForm.SetFullScreen(const Value: Boolean);
var
  MousePoint: TPoint;
begin
  // -----------------------------------------------------------------------------
  if FFullScreen <> Value then
  begin
    FFullScreen := Value;
    GetCursorPos(MousePoint);
    MousePoint := ScreenToClient(MousePoint);
    if FFullScreen then
    begin
      // -----------------------------------------------------------------------------
      _WindowState := WindowState;
      if WindowState = wsMaximized then
        WindowState := wsNormal;
      BorderStyle := bsNone;
      WindowState := wsMaximized;
      // -----------------------------------------------------------------------------
    end
    else
    begin
      // -----------------------------------------------------------------------------
      WindowState := wsNormal;
      BorderStyle := bsSizeable;
      WindowState := _WindowState;
      // -----------------------------------------------------------------------------
    end;
    MousePoint := ClientToScreen(MousePoint);
    SetCursorPos(MousePoint.X, MousePoint.Y);
  end;
  // -----------------------------------------------------------------------------
end;

procedure TSLForm.Activate;
begin
  inherited;
 {$IFNDEF No_XP_Menu}
 if SLXPMenu.Tag = 0 then
  begin
    SLXPMenu.Tag := 1;
    SLXPMenu.Active := false;
    SLXPMenu.Active := true;
  end;
{$ENDIF}
end;

constructor TSLForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFNDEF No_XP_Menu}
   SLXPMenu := TXPMenu_Wrap.Create(Self);
   SLXPMenu.Active := false;
{$ENDIF}
end;

destructor TSLForm.Destroy;
begin
{$IFNDEF No_XP_Menu}
  try
    SLXPMenu.Active := false;
  finally
    SLXPMenu.Destroy;
  end;
{$ENDIF}
  inherited;
end;

end.

