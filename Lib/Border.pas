{===============================================================}
{ UNIT        Border
  PROGRAMMER: Jürgen Sommer
  EMAIL:      webmaster@spiele-datenbank.de
  PURPOSE:    To enhance the normal TPanel with some graphical
              features like shaded corners and a new borderwidth
              property with which you can achieve some decent
              effects in your program.
  
  Please report bugs to webmaster@spiele-datenbank.de
  Every feedback is welcome :-)
                                                                }
{===============================================================}

unit Border;

interface

uses
  Dialogs,Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Graphics, Forms;

type

  TBorderDirection = (bdUp, bdDown);

  TBorder = class(TPanel)
  private
    { Private declarations }
    FMyBorderWidth:integer;
    FActive : boolean;
    FDefault : boolean;
    FShowFocusFrame : boolean;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FShowFrame,
    FShowInnerFrame : boolean;
    FBorderLight,
    FBorderDark : integer;
    FBorderDirection : TBorderdirection;
    FColBorderFrame,
    FColInnerFrame : TColor;
    FColDownTemp,
    FColFontHighlight,
    FColFontTemp,
    FColHighlight : TColor;
    FColBackup : Tcolor;
    FColFocusFrame : TColor;
    FButton : Boolean;
    FInMouse : Boolean;
    procedure SetFBorderdark(const Value: integer);
    procedure SetFBorderlight(const Value: integer);
    procedure SetFShowFrame(const Value: boolean);
    procedure SetFBorderDirection(const Value: TBorderdirection);
    procedure SetFShowInnerFrame(const Value: boolean);
    procedure WMLButtonDown (var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonUp (var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure Click;override;
    function GetBorderwidthNew: TBorderWidth;
    procedure SetBorderwidthNew(const Value: TBorderWidth);
    procedure SetFColBorderFrame(const Value: TColor);
    procedure SetFColInnerFrame(const Value: TColor);
    procedure SetFButton(const Value: Boolean);
  protected
    { Protected declarations }
    procedure OnLoaded;
  public
    { Public declarations }
    constructor create(AOwner:TComponent); override;
    procedure Paint; override;
  published
    { Published declarations }
    property ColFontHighlight : TColor
    	read FColFontHighlight write FColFontHighlight;
    property ColBorderFrame : TColor
    	read FColBorderFrame write SetFColBorderFrame;
    property BorderWidthNew : TBorderWidth
    	read GetBorderwidthNew write SetBorderwidthNew default 4;
    property BorderFrameShow : boolean
      read FShowFrame write SetFShowFrame default true;
    property BorderInnerFrameShow : boolean
      read FShowInnerFrame write SetFShowInnerFrame default false;
    property BorderLight : integer
      read FBorderlight write SetFBorderlight default 10;
    property BorderDark : integer
      read FBorderdark write SetFBorderdark default 10;
    property BorderDirection : TBorderdirection
      read FBorderDirection write SetFBorderDirection default bdUp;
    property Button : Boolean
      read FButton write SetFButton default false;
    property OnMouseEnter: TNotifyEvent
      read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent
      read FOnMouseLeave write FOnMouseLeave;
    property ColInnerFrame : TColor
      read FColInnerFrame write SetFColInnerFrame;
    property ColHighlight : TColor
      read FColHighlight write FColHighlight;
    property ColFocusFrame: TColor
    	read FColFocusFrame write FColFocusFrame;
    property ShowFocusFrame : boolean
    	read FShowFocusFrame write FShowFocusFrame;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Nostromo', [TBorder]);
end;

{-------------------------- BRIGHTEN --------------------------}
function brighten(col:TColor;wert:integer):TColor;
var rcol,gcol,bcol:integer;
begin
     col:=ColorToRGB(col);
     rcol:=GetRvalue(col);
     gcol:=GetGvalue(col);
     bcol:=GetBvalue(col);
     if rcol<254-wert then inc(rcol,wert) else rcol:=254;
     if gcol<254-wert then inc(gcol,wert) else gcol:=254;
     if bcol<254-wert then inc(bcol,wert) else bcol:=254;
     result:=RGB(rcol,gcol,bcol);
end;

{-------------------------- DARKEN --------------------------}
function darken(col:TColor;wert:integer):TColor;
var rcol,gcol,bcol:integer;
begin
     col:=ColorToRGB(col);
     rcol:=GetRvalue(col);
     gcol:=GetGvalue(col);
     bcol:=GetBvalue(col);
     if rcol>wert then dec(rcol,wert) else rcol:=0;
     if gcol>wert then dec(gcol,wert) else gcol:=0;
     if bcol>wert then dec(bcol,wert) else bcol:=0;
//     s:='00'+inttohex(rcol,2)+inttohex(gcol,2)+inttohex(bcol,2);
//     result:=StringtoColor(s);
     result:=RGB(rcol,gcol,bcol);
end;


{ TBorder }

constructor TBorder.create;
begin
  inherited;
  BevelOuter:=bvNone;
  FBorderlight:=10;
  FBorderDark:=10;
  FColInnerFrame:=clBlack;
  FColHighlight:=color;
  FColFocusFrame:=clWhite;
  FDefault:=false;
  FShowFrame:=true;
  FColFontTemp:=Font.Color;
  FMyBorderWidth:=4;
  caption:='';
end;

procedure TBorder.OnLoaded;
begin
	FColBackup := color;
  FActive:=false;
end;


procedure TBorder.Paint;
var i:integer;
    C : TColor;
begin
  inherited;
try
  C := Color;
  with canvas do
  begin
    // LEFT + TOP
    if FMyBorderWidth>0 then
    for i:=FMyBorderWidth downto 0 do
    begin
      if FBorderDirection=bdUp then
        C:=Brighten(C,FBorderLight)
      else
        C:=Darken(C,FBorderDark);
      pen.color:=C;
      moveto(0+i,height-i);
      lineto(0+i,0+i);
      lineto(width,0+i);
    end;

    // RIGHT + BOTTOM
    C := Color;
    if FMyBorderWidth>0 then
    for i:=FMyBorderWidth downto 0 do
    begin
      if FBorderDirection=bdUp then
        C:=Darken(C,FBorderdark)
      else
        C:=Brighten(C,FBorderLight);
      pen.color:=C;
      moveto(width-i-1,0+i);
      lineto(width-i-1,height-i-1);
      lineto(0+i,height-i-1);
    end;
  end;

  if FShowFrame then
  with Canvas do
  begin
    pen.color:=FColBorderFrame;
    moveto(0,0);
    lineto(width-1,0);
    lineto(width-1,height-1);
    lineto(0,height-1);
    lineto(0,0);
  end;

  if FShowInnerFrame then
  with canvas do
  begin
    pen.color:=FColInnerFrame;
    moveto(0+FMyBorderWidth-1, 0+FMyBorderWidth-1);
    lineto(width-FMyBorderWidth,0+FMyBorderWidth-1);
    lineto(width-FMyBorderWidth, height-FMyBorderWidth);
    lineto(0+FMyBorderWidth-1, height-FMyBorderWidth);
    lineto(0+FMyBorderWidth-1, 0+FMyBorderWidth-1);
  end;

  if (FActive) AND (Button) AND (ShowFocusFrame) then
  with canvas do
  begin
		pen.color:=FColFocusFrame;
    pen.width:=3;
    moveto(0,0);
    lineto(width-1,0);
    lineto(width-1,height-1);
    lineto(0,height-1);
    lineto(0,0);
    pen.width:=1;
  end;
except
end;
end;

procedure TBorder.SetFBorderdark(const Value: integer);
begin
  FBorderdark := Value;
  Repaint;
end;

procedure TBorder.SetFBorderDirection(const Value: TBorderdirection);
begin
	if FButton then exit;
  FBorderDirection := Value;
  Repaint;
end;

procedure TBorder.SetFBorderlight(const Value: integer);
begin
  FBorderlight := Value;
  Repaint;
end;

procedure TBorder.SetFShowFrame(const Value: boolean);
begin
  FShowFrame := Value;
  Repaint;
end;

procedure TBorder.SetFShowInnerFrame(const Value: boolean);
begin
  FShowInnerFrame := Value;
  Repaint;
end;

procedure TBorder.WMLButtonDown (var Message: TWMLButtonDown);
begin
  inherited;
  if Button AND (BorderDirection<>bdDown) then
  begin
  	FColDownTemp:=Color;
    Color:=Darken(Color,20);
    FBorderDirection:=bdDown;
    Repaint;
  end;
end;

procedure TBorder.WMLButtonUp (var Message: TWMLButtonUp);
begin
  inherited;
  if Button AND (BorderDirection<>bdUp) then
  begin
  	Color:=FColDownTemp;
    FBorderDirection:=bdUp;
    if NOT FInMouse then color:=FColBackup;
    Repaint;
  end;
end;

procedure TBorder.CMMouseEnter(var Message: TMessage);
const
  BS_MASK = $000F;
begin
  inherited;
  FInMouse:=true;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
  if Button then
  begin
//		FActive:=true;
		FColFontTemp:=Font.Color;
    Font.Color:=FColFontHighlight;
    FColBackup:=color;
    color:=FColHighlight;
    Repaint;
  end;
end;

procedure TBorder.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FInMouse:=false;
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
  if Button AND (BorderDirection<>bdDown) then
  begin
//		FActive:=false;
    Font.Color:=FColFontTemp;
    color:=FColBackup;
    Repaint;
  end;
end;


procedure TBorder.CMDialogKey(var Message: TCMDialogKey);
begin
  with Message do
    if  (((CharCode = VK_RETURN) and FActive) or
    		((CharCode = VK_SPACE) and FActive) or
      ((CharCode = VK_ESCAPE))) and
      (KeyDataToShiftState(Message.KeyData) = []) and CanFocus then
    begin
    	if Button then
      begin
      	FColBackup:=color;
        color:=FColHighlight;
        Borderdirection:=bdDown;
        Repaint;
      end;
      Click;
      Result := 1;
    	if Button then
      begin
        color:=FColBackup;
        Borderdirection:=bdUp;
        Repaint;
      end;
    end else
      inherited;
end;

procedure TBorder.CMFocusChanged(var Message: TCMFocusChanged);
begin
  with Message do
    if Sender is TBorder then
    begin
      FActive := Sender = Self;
    end else
    begin
//    FActive := FDefault;
			FActive:=false;
    end;

  //  SetButtonStyle(FActive);
	Repaint;
  inherited;
end;


procedure TBorder.Click;
const
  BS_MASK = $000F;
begin
  inherited;

end;




function TBorder.GetBorderwidthNew: TBorderWidth;
begin
	Result:=FMyBorderWidth;
end;

procedure TBorder.SetBorderwidthNew(const Value: TBorderWidth);
begin
	FMyBorderWidth:=Value;
  BorderWidth:=Value;
end;

procedure TBorder.SetFColBorderFrame(const Value: TColor);
begin
  FColBorderFrame := Value;
  Repaint;
end;

procedure TBorder.SetFColInnerFrame(const Value: TColor);
begin
  FColInnerFrame := Value;
  Repaint;
end;

procedure TBorder.SetFButton(const Value: Boolean);
begin
	if Value then
  begin
  	FBorderDirection:=bdUp;
    Repaint;
  end;
  FButton := Value;
end;

end.
