unit FrmRstr;

{ Component to set forms position, measures and window state to values
  when form closed last time.
  Simply set "RegKey" value to the registry key in which the settings
  shall be stored.
  Tested with Delphi 5 but it should also work with D3 and D4.
  Freeware by n0mad <n0mad@pisem.net>

  History:
    version 0.1.0 (2004.xx.yy.01)
      Rewritten for TComponent.Loaded
    version 0.1.1 (2004.11.14.01)
      Disabled bsNone switching on boot due to AV on fsCreating
  }

interface

{$IFDEF TEST_MESSAGES_ON}
{$UNDEF TEST_MESSAGES_ON}
{$ENDIF}

// {$DEFINE TEST_MESSAGES_ON} This_Define_For_Testing_Only
{ This define enables messages for testing . Deactivate this define after test. }

uses
  Windows, Classes, Forms;

type
  TFrmRstr = class(TComponent)
  private
    FRegKey: string;
    FOwner: TForm;
    FOnActivateCalled: Boolean;
    FOnActivateHooked: Boolean;
    FOnActivateSave: TNotifyEvent;
    procedure SetRegKey(NewKey: string);
    procedure SaveFormCoordinates;
    procedure LoadFormCoordinates;
    procedure SetFormCoordinates;
    procedure CheckFormCoordinates(var _Left, _Top, _Width, _Height: Integer; Rect: TRect);
    procedure OwnerForm_Activate(Sender: TObject);
  private
    FOwnLeft, FOwnTop, FOwnWidth, FOwnHeight, FOwnMaximized: integer;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // procedure BeforeDestruction; override;
  published
    property RegKey: string read FRegKey write SetRegKey;
  end;

procedure Register;

implementation

uses
{$IFDEF TEST_MESSAGES_ON}
  Bugger,
  StrConsts,
  SysUtils,
  uTools,
{$ENDIF}
  Registry;

{$IFDEF TEST_MESSAGES_ON}
const
  UnitName: string = 'FrmRstr';
{$ENDIF}

resourcestring
  Form_Left = 'Left';
  Form_Top = 'Top';
  Form_Right = 'Right';
  Form_Bottom = 'Bottom';
  Form_Maximized = 'Maximized';

constructor TFrmRstr.Create(AOwner: TComponent);
{$IFDEF TEST_MESSAGES_ON}
const
  ProcName: string = 'Create';
var
  sOwnerName: string;
  FOnActivateCurrent: TNotifyEvent;
{$ENDIF}
begin
{$IFDEF TEST_MESSAGES_ON}
  if Assigned(AOwner) then
  begin
    if (AOwner is TComponent) then
      sOwnerName := AOwner.Name
    else
      sOwnerName := AOwner.ClassName;
  end
  else
    sOwnerName := '<nil>';
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, 'Before inherited Create(' + sOwnerName + ') ->');
{$ENDIF}
  inherited Create(AOwner);
{$IFDEF TEST_MESSAGES_ON}
  DEBUGMessEnh(0, UnitName, ProcName, 'After inherited Create(' + sOwnerName + ') <-');
{$ENDIF}
  FOwnLeft := -1;
  FOwnTop := -1;
  FOwnWidth := -1;
  FOwnHeight := -1;
  FOwnMaximized := -1;
  FRegKey := 'Software\MyCompany\MyApplication';
  FOwner := (Owner as TForm);
  FOnActivateSave := nil;
  FOnActivateCalled := false;
  FOnActivateHooked := false;
{$IFDEF TEST_MESSAGES_ON}
  if Assigned(FOwner) then
    if (FOwner is TForm) then
    begin
      FOnActivateSave := FOwner.OnActivate;
      // FOwner.OnActivate := OwnerForm_Activate;
      DEBUGMessEnh(0, UnitName, ProcName, 'Hook(1) installed for (' + sOwnerName + ')');
      DEBUGMessEnh(0, UnitName, ProcName, 'FOnActivateSave Address = [' +
        IntToHex1(Longword(@FOnActivateSave), 8) + ']');
      FOnActivateCurrent := FOwner.OnActivate;
      DEBUGMessEnh(0, UnitName, ProcName, 'OnActivate Address = [' +
        IntToHex1(Longword(@FOnActivateCurrent), 8) + ']');
    end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure TFrmRstr.Loaded;
{$IFDEF TEST_MESSAGES_ON}
const
  ProcName: string = 'Loaded';
var
  sOwnerName: string;
  FOnActivateCurrent: TNotifyEvent;
{$ENDIF}
begin
{$IFDEF TEST_MESSAGES_ON}
  if Assigned(FOwner) then
  begin
    if (FOwner is TComponent) then
      sOwnerName := FOwner.Name
    else
      sOwnerName := FOwner.ClassName;
  end
  else
    sOwnerName := '<nil>';
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, 'FOnActivateHooked = ' + BoolYesNo[FOnActivateHooked]);
{$ENDIF}
  if not FOnActivateHooked then
  begin
    if Assigned(FOwner) then
      if (FOwner is TForm) then
      begin
        FOnActivateSave := FOwner.OnActivate;
        FOwner.OnActivate := OwnerForm_Activate;
        FOnActivateHooked := true;
{$IFDEF TEST_MESSAGES_ON}
        DEBUGMessEnh(0, UnitName, ProcName, 'Hook(2) installed for (' + sOwnerName + ')');
        DEBUGMessEnh(0, UnitName, ProcName, 'FOnActivateSave Address = [' +
          IntToHex1(Longword(@FOnActivateSave), 8) + ']');
        FOnActivateCurrent := FOwner.OnActivate;
        DEBUGMessEnh(0, UnitName, ProcName, 'OnActivate Address = [' +
          IntToHex1(Longword(@FOnActivateCurrent), 8) + ']');
{$ENDIF}
      end;
{$IFDEF TEST_MESSAGES_ON}
    DEBUGMessEnh(0, UnitName, ProcName, 'LoadFormCoordinates for (' + sOwnerName + ')');
{$ENDIF}
    try
      LoadFormCoordinates;
    except
      // bad code
    end;
  end;
{$IFDEF TEST_MESSAGES_ON}
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

destructor TFrmRstr.Destroy;
{$IFDEF TEST_MESSAGES_ON}
const
  ProcName: string = 'Destroy';
var
  sOwnerName: string;
{$ENDIF}
begin
{$IFDEF TEST_MESSAGES_ON}
  if Assigned(FOwner) then
  begin
    if (FOwner is TComponent) then
      sOwnerName := FOwner.Name
    else
      sOwnerName := FOwner.ClassName;
  end
  else
    sOwnerName := '<nil>';
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, 'FOnActivateHooked = ' + BoolYesNo[FOnActivateHooked]);
{$ENDIF}
  if FOnActivateHooked and Assigned(FOnActivateSave) then
  begin
    FOwner.OnActivate := FOnActivateSave;
  end;
  FOnActivateSave := nil;
{$IFDEF TEST_MESSAGES_ON}
  DEBUGMessEnh(0, UnitName, ProcName, 'SaveFormCoordinates for (' + sOwnerName + ')');
{$ENDIF}
  SaveFormCoordinates;
{$IFDEF TEST_MESSAGES_ON}
  DEBUGMessEnh(0, UnitName, ProcName, 'Before inherited Destroy(' + sOwnerName + ')');
{$ENDIF}
  inherited Destroy;
{$IFDEF TEST_MESSAGES_ON}
  DEBUGMessEnh(0, UnitName, ProcName, 'After inherited Destroy(' + sOwnerName + ')');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure TFrmRstr.OwnerForm_Activate(Sender: TObject);
{$IFDEF TEST_MESSAGES_ON}
const
  ProcName: string = 'OwnerForm_Activate';
var
  sOwnerName: string;
{$ENDIF}
begin
{$IFDEF TEST_MESSAGES_ON}
  if Assigned(FOwner) then
  begin
    if (FOwner is TComponent) then
      sOwnerName := FOwner.Name
    else
      sOwnerName := FOwner.ClassName;
  end
  else
    sOwnerName := '<nil>';
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
{$ENDIF}
  if not FOnActivateCalled then
  begin
{$IFDEF TEST_MESSAGES_ON}
    DEBUGMessEnh(0, UnitName, ProcName, 'SetFormCoordinates for (' + sOwnerName + ')');
{$ENDIF}
    SetFormCoordinates;
  end;
{$IFDEF TEST_MESSAGES_ON}
  DEBUGMessEnh(0, UnitName, ProcName, 'FOnActivateSave Address = [' +
    IntToHex1(Longword(@FOnActivateSave), 8) + ']');
{$ENDIF}
  if Assigned(FOnActivateSave) then
  begin
    // FOwner.OnActivate := FOnActivateSave;
    // FOnActivateSave := nil;
    if not FOnActivateCalled then
    begin
      FOnActivateCalled := true;
{$IFDEF TEST_MESSAGES_ON}
      DEBUGMessEnh(0, UnitName, ProcName, 'Hook removed on first call for (' + sOwnerName + ')');
{$ENDIF}
    end;
{$IFDEF TEST_MESSAGES_ON}
    DEBUGMessEnh(0, UnitName, ProcName, 'Calling FOnActivateSave() for (' + sOwnerName + ')');
{$ENDIF}
    FOnActivateSave(FOwner);
  end;
{$IFDEF TEST_MESSAGES_ON}
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure TFrmRstr.SetRegKey(NewKey: string);
{$IFDEF TEST_MESSAGES_ON}
const
  ProcName: string = 'SetRegKey';
{$ENDIF}
begin
  if NewKey <> FRegKey then
    FRegKey := NewKey;
end;

procedure TFrmRstr.SaveFormCoordinates;
{$IFDEF TEST_MESSAGES_ON}
const
  ProcName: string = 'SaveFormCoordinates';
var
  sOwnerName: string;
{$ENDIF}
var
  Reg: TRegistry;
  TempRegKey: string;
  TempMaximized: integer;
begin
{$IFDEF TEST_MESSAGES_ON}
  if Assigned(FOwner) then
  begin
    if (FOwner is TComponent) then
      sOwnerName := FOwner.Name
    else
      sOwnerName := FOwner.ClassName;
  end
  else
    sOwnerName := '<nil>';
  DEBUGMessEnh(0, UnitName, ProcName, 'Start saving coords for (' + sOwnerName + ') ->');
{$ENDIF}
  Reg := TRegistry.Create;
  TempRegKey := FRegKey + '\' + FOwner.Name;
  Reg.Openkey(TempRegKey, true);
  TempMaximized := 0;
  if FOwner.WindowState = wsMaximized then
  begin
    TempMaximized := 1;
    if FOwner.BorderStyle = bsNone then
      TempMaximized := 2;
  end
  else
  begin
    // FOwner.WindowState := wsNormal;
    Reg.WriteInteger(Form_Left, FOwner.Left);
    Reg.WriteInteger(Form_Top, FOwner.Top);
    Reg.WriteInteger(Form_Right, FOwner.Left + FOwner.Width);
    Reg.WriteInteger(Form_Bottom, FOwner.Top + FOwner.Height);
  end;
  Reg.WriteInteger(Form_Maximized, TempMaximized);
  Reg.Free;
{$IFDEF TEST_MESSAGES_ON}
  DEBUGMessEnh(0, UnitName, ProcName, 'TempMaximized = (' + IntToStr(TempMaximized) + ')');
  DEBUGMessEnh(0, UnitName, ProcName, 'Finish saving coords for (' + sOwnerName + ') <-');
{$ENDIF}
end;

procedure TFrmRstr.LoadFormCoordinates;
{$IFDEF TEST_MESSAGES_ON}
const
  ProcName: string = 'LoadFormCoordinates';
var
  sOwnerName: string;
{$ENDIF}
var
  Reg: TRegistry;
  Rect: TRect;
  TempRegKey: string;
begin
{$IFDEF TEST_MESSAGES_ON}
  if Assigned(FOwner) then
  begin
    if (FOwner is TComponent) then
      sOwnerName := FOwner.Name
    else
      sOwnerName := FOwner.ClassName;
  end
  else
    sOwnerName := '<nil>';
  DEBUGMessEnh(0, UnitName, ProcName, 'Start loading coords for (' + sOwnerName + ') ->');
{$ENDIF}
  Reg := TRegistry.Create;
  try
    TempRegKey := FRegKey + '\' + FOwner.Name;
    Reg.Openkey(TempRegKey, false);
    FOwnLeft := FOwner.Left;
    FOwnTop := FOwner.Top;
    FOwnWidth := FOwner.Width;
    FOwnHeight := FOwner.Height;
    FOwnMaximized := -1;
    if Reg.ValueExists(Form_Left) then
    try
      FOwnLeft := Reg.ReadInteger(Form_Left);
    except
    end;
    if Reg.ValueExists(Form_Top) then
    try
      FOwnTop := Reg.ReadInteger(Form_Top);
    except
    end;
    if Reg.ValueExists(Form_Right) then
    try
      FOwnWidth := Reg.ReadInteger(Form_Right) - FOwnLeft;
    except
    end;
    if Reg.ValueExists(Form_Bottom) then
    try
      FOwnHeight := Reg.ReadInteger(Form_Bottom) - FOwnTop;
    except
    end;
    if Reg.ValueExists(Form_Maximized) then
    try
      FOwnMaximized := Reg.ReadInteger(Form_Maximized);
    except
    end;
    Rect.Left := 0;
    Rect.Top := 0;
    Rect.Right := Screen.Width - 1;
    Rect.Bottom := Screen.Height - 1;
    CheckFormCoordinates(FOwnLeft, FOwnTop, FOwnWidth, FOwnHeight, Rect);
    FOwner.WindowState := wsNormal;
    if FOwnMaximized = 2 then
      if false and (not FOwner.Showing)
        and (not (fsCreating in FOwner.FormState)) then
        begin
          // should never be called 
          FOwner.BorderStyle := bsNone;
        end;
  finally
    Reg.Free;
  end;
{$IFDEF TEST_MESSAGES_ON}
  DEBUGMessEnh(0, UnitName, ProcName, '_Maximized = (' + IntToStr(_Maximized) + ')');
  DEBUGMessEnh(0, UnitName, ProcName, 'Finish loading coords for (' + sOwnerName + ') <-');
{$ENDIF}
end;

procedure TFrmRstr.SetFormCoordinates;
{$IFDEF TEST_MESSAGES_ON}
const
  ProcName: string = 'SetFormCoordinates';
var
  sOwnerName: string;
{$ENDIF}
begin
{$IFDEF TEST_MESSAGES_ON}
  if Assigned(FOwner) then
  begin
    if (FOwner is TComponent) then
      sOwnerName := FOwner.Name
    else
      sOwnerName := FOwner.ClassName;
  end
  else
    sOwnerName := '<nil>';
  DEBUGMessEnh(0, UnitName, ProcName, 'Start setting coords for (' + sOwnerName + ') ->');
{$ENDIF}
  if FOwnMaximized < 0 then
    LoadFormCoordinates;
  FOwner.WindowState := wsNormal;
  case FOwnMaximized of
    0:
      begin
        // FOwner.WindowState := wsNormal;
        FOwner.SetBounds(FOwnLeft, FOwnTop, FOwnWidth, FOwnHeight);
      end;
    1, 2:
      begin
        if FOwnMaximized = 2 then
          if (not FOwner.Showing) then
            FOwner.BorderStyle := bsNone;
        FOwner.SetBounds(FOwnLeft, FOwnTop, FOwnWidth, FOwnHeight);
        FOwner.WindowState := wsMaximized;
      end;
  else
  end;
{$IFDEF TEST_MESSAGES_ON}
  DEBUGMessEnh(0, UnitName, ProcName, '_Maximized = (' + IntToStr(_Maximized) + ')');
  DEBUGMessEnh(0, UnitName, ProcName, 'Finish setting coords for (' + sOwnerName + ') <-');
{$ENDIF}
end;

procedure TFrmRstr.CheckFormCoordinates(var _Left, _Top, _Width,
  _Height: integer; Rect: TRect);
{$IFDEF TEST_MESSAGES_ON}
const
  ProcName: string = 'CheckFormCoordinates';
var
  sOwnerName: string;
{$ENDIF}
var
  tmp: integer;
begin
{$IFDEF TEST_MESSAGES_ON}
  if Assigned(FOwner) then
  begin
    if (FOwner is TComponent) then
      sOwnerName := FOwner.Name
    else
      sOwnerName := FOwner.ClassName;
  end
  else
    sOwnerName := '<nil>';
  DEBUGMessEnh(1, UnitName, ProcName, 'Start checking coords for (' + sOwnerName + ') ->');
  // --------------------------------------------------------------------------
{$ENDIF}
  if _Left < 0 then
    _Left := 0;
  if _Top < 0 then
    _Top := 0;
  // -----------------------------------------------------------------------------
  if (_Width > Rect.Right - Rect.Left + 1) then
    _Width := Rect.Right - Rect.Left + 1;
  if (_Height > Rect.Bottom - Rect.Top + 1) then
    _Height := Rect.Bottom - Rect.Top + 1;
  // -----------------------------------------------------------------------------
  if (_Width + _Left > Rect.Right - Rect.Left + 1) then
  begin
    tmp := (Rect.Right - Rect.Left + 1) - _Width;
    if tmp > 0 then
      _Left := (Rect.Right - Rect.Left + 1) - _Width
    else
      _Left := 0;
  end;
  if (_Width + _Left > Rect.Right - Rect.Left + 1) then
    _Width := (Rect.Right - Rect.Left + 1) - _Left;
  if (_Height + _Top > Rect.Bottom - Rect.Top + 1) then
  begin
    tmp := (Rect.Bottom - Rect.Top + 1) - _Height;
    if tmp > 0 then
      _Top := (Rect.Bottom - Rect.Top + 1) - _Height
    else
      _Top := 0;
  end;
  if (_Height + _Top > Rect.Bottom - Rect.Top + 1) then
    _Height := (Rect.Bottom - Rect.Top + 1) - _Top;
{$IFDEF TEST_MESSAGES_ON}
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, 'Finish checking coords for (' + sOwnerName + ') <-');
{$ENDIF}
end;

procedure Register;
{$IFDEF TEST_MESSAGES_ON}
const
  ProcName: string = 'Register';
{$ENDIF}
begin
  RegisterComponents('n0mad Controls', [TFrmRstr]);
end;

end.

