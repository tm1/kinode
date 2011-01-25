{*************************************************************}
{            TExtScrollBox Component for Delphi 16/32         }
{ Version:   2.0                                              }
{ Author:    Aleksey Kuznetsov                                }
{ E-Mail:    info@utilmind.com                                }
{ Home Page: www.utilmind.com                                 }
{ Created:   June 11, 1997                                    }
{ Modified:  August 17, 1999                                  }
{ Legal:     Copyright (c) 1997-99, UtilMind Solutions        }
{*************************************************************}
{ Benefits of Extended ScrollBox:                             }
{  1. Thumb tracking property is always turned on (obsolete   }
{     in Delphi2 and higher).                                 }
{  2. You can hook Scrolling events - OnVScroll or OnHScroll. }
{*************************************************************}
{ If at occurrence of any questions regarding this            }
{ component, please visit our web site: www.utilmind.com      }
{*************************************************************}
unit ExtScroll;

interface

uses
  {$IFDEF WIN32} Windows, {$ELSE} WinTypes, WinProcs, {$ENDIF}
  Messages, Classes, Forms;

type
  TScrollEvent = procedure(var Message: TWMHScroll) of object;

  TExtScrollBox = class(TScrollBox)
  private
    FOnHScroll,
    FOnVScroll: TScrollEvent;

    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  published
    property OnHScroll: TScrollEvent read FOnHScroll write FOnHScroll;
    property OnVScroll: TScrollEvent read FOnVScroll write FOnVScroll;
  end;

procedure Register;

implementation

procedure TExtScrollBox.WMHScroll(var Message: TWMHScroll);
begin
  if Message.ScrollCode = sb_ThumbTrack then
    HorzScrollBar.Position := Message.Pos;
  if Assigned(FOnHScroll) then
    FOnHScroll(Message);
  inherited
end;

procedure TExtScrollBox.WMVScroll(var Message: TWMVScroll);
begin
  if Message.ScrollCode = sb_ThumbTrack then
    VertScrollBar.Position := Message.Pos;
  if Assigned(FOnVScroll) then
    FOnVScroll(Message);
  inherited
end;

procedure Register;
begin
  RegisterComponents('UtilMind', [TExtScrollBox]);
end;

end.
