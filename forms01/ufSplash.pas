{-----------------------------------------------------------------------------
 Unit Name: ufSplash
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  01.03.2004
 Purpose:   Splash screen
 History:
-----------------------------------------------------------------------------}
unit ufSplash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Gauges, ExtCtrls, jpeg, StdCtrls, Menus, SLForms;

type
  Tfm_Splash = class(TSLForm)
    // FormRestorer: TFrmRstr;
    pn_Splash: TPanel;
    im_Splash: TImage;
    gg_LoadProgress: TGauge;
    lb_LoadTitle: TLabel;
    lb_ProgramTitle: TLabel;
    lb_ProgramTitleShadow: TLabel;
    bv_LoadTitle: TBevel;
    bv_ProgramTitle: TBevel;
    mm_Load: TMemo;
    tmr_Splash: TTimer;
    bt_Exit: TButton;
    procedure tmr_SplashTimer(Sender: TObject);
    procedure bt_ExitClick(Sender: TObject);
    procedure mm_LoadKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FormInit;
    procedure FormClean(SetBorder: boolean);
    procedure AddToLog(Str: string; Upd, Line: Boolean);
    procedure ScrollMemo(ToEnd: boolean);
    procedure SetProgress(Progress: integer);
    procedure SetTimer(TimeInterval: integer; EnableTimer: boolean);
  end;

procedure AddToLog2(Str: string; Upd, Line: Boolean);

var
  fm_Splash: Tfm_Splash;

implementation

uses
  Bugger;

const
  UnitName: string = 'ufSplash';

{$R *.DFM}

procedure AddToLog2(Str: string; Upd, Line: Boolean);
begin
  if Assigned(fm_Splash) then
  try
    fm_Splash.AddToLog(Str, Upd, Line);
  except
  end;
end;

procedure Tfm_Splash.FormInit;
begin
  tmr_Splash.Enabled := false;
  tmr_Splash.OnTimer := tmr_SplashTimer;
  if BorderStyle <> bsNone then
    BorderStyle := bsNone;
  if FormStyle <> fsNormal then
    FormStyle := fsNormal; // fsStayOnTop;
  if Position <> poDesktopCenter then
    Position := poDesktopCenter;
  if WindowState <> wsNormal then
    WindowState := wsNormal;
  gg_LoadProgress.MinValue := 0;
  gg_LoadProgress.MaxValue := 100;
  gg_LoadProgress.Progress := 0;
end;

procedure Tfm_Splash.FormClean(SetBorder: boolean);
begin
  Caption := 'About...';
  if SetBorder then
    if BorderStyle <> bsDialog then
      BorderStyle := bsDialog;
  if FormStyle <> fsNormal then
    FormStyle := fsNormal;
  if Position <> poDesktopCenter then
    Position := poDesktopCenter;
  if WindowState <> wsNormal then
    WindowState := wsNormal;
  bv_LoadTitle.Visible := false;
  lb_LoadTitle.Visible := false;
  gg_LoadProgress.Visible := false;
  mm_Load.Height := pn_Splash.ClientHeight - mm_Load.Top - 20;
  mm_Load.ScrollBars := ssBoth;
end;

procedure Tfm_Splash.AddToLog(Str: string; Upd, Line: Boolean);
const
  LineLen: integer = 80;
  SpaceLen: integer = 3;
  Divider: char = '~';
var
  Str_Line: string;
  Str_Space: string;
  Div_Len: integer;
begin
  if Line then
  begin
    Div_Len := (LineLen - Length(Str)) div 2 - SpaceLen;
    if (Div_Len > 0) then
      Str_Line := StringOfChar(Divider, Div_Len)
    else
      Str_Line := '';
    if (LineLen div 2 > SpaceLen) then
      Str_Space := StringOfChar(' ', SpaceLen)
    else
      Str_Space := ' ';
    Str_Line := Str_Line + Str_Space + Str + Str_Space + Str_Line;
    mm_Load.Lines.Add(Str_Line);
  end
  else
    mm_Load.Lines.Add(Str);
  if Upd then
    Self.Update;
end;

procedure Tfm_Splash.ScrollMemo(ToEnd: boolean);
begin
  mm_Load.SetFocus;
  if ToEnd then
  begin
    mm_Load.SelStart := Length(mm_Load.Text) - 1;
    mm_Load.SelLength := 0;
  end
  else
  begin
    mm_Load.SelStart := 0;
    mm_Load.SelLength := 0;
  end;
end;

procedure Tfm_Splash.SetProgress(Progress: integer);
begin
  gg_LoadProgress.Progress := Progress;
end;

procedure Tfm_Splash.SetTimer(TimeInterval: integer; EnableTimer: boolean);
begin
  if TimeInterval > 0 then
  begin
    tmr_Splash.Enabled := false;
    tmr_Splash.Interval := TimeInterval;
  end;
  tmr_Splash.Enabled := EnableTimer;
end;

procedure Tfm_Splash.tmr_SplashTimer(Sender: TObject);
begin
  if FindWindow('Tfm_Main', nil) <> 0 then
  begin
    SetTimer(15000, false);
    Visible := false;
    FormClean(false);
    Close;
  end;
end;

procedure Tfm_Splash.bt_ExitClick(Sender: TObject);
begin
  if Self.Visible and (not gg_LoadProgress.Visible) then
    tmr_SplashTimer(Self);
end;

procedure Tfm_Splash.mm_LoadKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    bt_ExitClick(Self);
end;

procedure Tfm_Splash.FormActivate(Sender: TObject);
begin
  mm_Load.SetFocus;
end;

procedure Tfm_Splash.FormCreate(Sender: TObject);
begin
  // FormRestorer := TFrmRstr.Create(fm_Splash);
  // if Assigned(FormRestorer) and (FormRestorer is TFrmRstr) then
  //  FormRestorer.RegKey := 'Software\Home(R)\KinoDe\1.2.8';
end;

procedure Tfm_Splash.FormDestroy(Sender: TObject);
begin
  // FormRestorer.Destroy;
end;

{$IFDEF DEBUG_Module_Start_Finish}
initialization
  DEBUGMess(0, UnitName + '.Init');
{$ENDIF}

{$IFDEF DEBUG_Module_Start_Finish}
finalization
  DEBUGMess(0, UnitName + '.Final');
{$ENDIF}

end.

