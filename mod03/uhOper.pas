{-----------------------------------------------------------------------------
 Unit Name: uhOper
 Author:    n0mad
 Version:   1.1.7.93
 Creation:  06.08.2003
 Purpose:   Operations module
 History:
-----------------------------------------------------------------------------}
unit uhOper;

interface

{$I kinode01.inc}

uses
  Classes, Controls, Graphics, Gauges, ShpCtrl2;

type
  // --------------------------------------------------------------------------
  TicketRec = record
    Kod: Integer;
    Name: string;
    BgColor: TColor;
    FontColor: TColor;
    ClassKod: Integer;
    PrintLabel: string;
    ClassName: string;
    bPrint: Boolean;
    bFree: Boolean;
    bInvited: Boolean;
    bGroup: Boolean;
    bVipCard: Boolean;
    bVipByName: Boolean;
    bSeason: Boolean;
    bSerial: Boolean;
    MenuOrder: Integer;
  end;
  {
  *  TICKET_KOD INTEGER,
  *  TICKET_VER INTEGER,
  *  TICKET_NAM VARCHAR(80),
  *  TICKET_CLASS INTEGER,
  *  CLASS_NAM VARCHAR(40),
  *  CLASS_TO_PRINT SMALLINT,
  *  CLASS_FOR_FREE SMALLINT,
  *  CLASS_INVITED_GUEST SMALLINT,
  *  CLASS_GROUP_VISIT SMALLINT,
  *  CLASS_VIP_CARD SMALLINT,
  *  CLASS_VIP_BYNAME SMALLINT,
  *  CLASS_SEASON_TICKET SMALLINT,
    TICKET_CALCUL1 CHAR(1),
    TICKET_CONST1 INTEGER,
  *  TICKET_LABEL VARCHAR(40),
  *  TICKET_SERIALIZE SMALLINT,
  *  TICKET_BGCOLOR INTEGER,
  *  TICKET_FNTCOLOR INTEGER,
  *  TICKET_MENU_ORDER INTEGER,
    TICKET_FREEZED SMALLINT)
  }
  // --------------------------------------------------------------------------
  // ClassKod: 0; PrintLabel: ''; ClassName: '';
  // bPrint: true; bFree: false; bInvited: false; bGroup: false; bVipCard: false;
  // bVipByName: false; bSeason: false; bSerial: true;
  // TOperActionTodo = (otRefresh, otClear);
  // --------------------------------------------------------------------------
  TSaleType = (pxCash, pxPosterminal, pxCheq);

const
  // --------------------------------------------------------------------------
  c_TicketState: array[TTicketState] of string =
  ('tsFree', 'tsBroken', 'tsPrepared',
    'tsReserved', 'tsRealized');
  // --------------------------------------------------------------------------
  c_TicketProps: array[0..20] of TicketRec =
  (
    (Kod: 0; Name: 'Unknown'; BgColor: clGray; FontColor: clBlack;
    ClassKod: 0; PrintLabel: 'unknown ticket'; ClassName: 'unknown class';
    bPrint: true; bFree: false; bInvited: false; bGroup: false; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 1; Name: 'Взрослый'; BgColor: 8741955; FontColor: clBlack;
    ClassKod: 1; PrintLabel: ''; ClassName: 'Обычный билет для продажи';
    bPrint: true; bFree: false; bInvited: false; bGroup: false; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 2; Name: 'Студенческий/Пенсионный'; BgColor: 32768; FontColor: clBlack;
    ClassKod: 1; PrintLabel: 'Студенч./Пенсион.'; ClassName: '';
    bPrint: true; bFree: false; bInvited: false; bGroup: false; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 3; Name: 'Школьный'; BgColor: 49152; FontColor: clBlack;
    ClassKod: 1; PrintLabel: 'Детский билет'; ClassName: '';
    bPrint: true; bFree: false; bInvited: false; bGroup: false; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 4; Name: 'Скидка 10%'; BgColor: 11842650; FontColor: clBlack;
    ClassKod: 1; PrintLabel: ''; ClassName: 'Обычный билет для продажи';
    bPrint: true; bFree: false; bInvited: false; bGroup: false; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 5; Name: 'Скидка 20%'; BgColor: 10516560; FontColor: clBlack;
    ClassKod: 1; PrintLabel: ''; ClassName: 'Обычный билет для продажи';
    bPrint: true; bFree: false; bInvited: false; bGroup: false; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 6; Name: 'Скидка 30%'; BgColor: 32896; FontColor: clBlack;
    ClassKod: 1; PrintLabel: ''; ClassName: 'Обычный билет для продажи';
    bPrint: true; bFree: false; bInvited: false; bGroup: false; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 7; Name: 'Скидка 40%'; BgColor: 9737290; FontColor: clBlack;
    ClassKod: 1; PrintLabel: ''; ClassName: 'Обычный билет для продажи';
    bPrint: true; bFree: false; bInvited: false; bGroup: false; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 8; Name: 'Скидка 50%'; BgColor: 9737290; FontColor: clBlack;
    ClassKod: 1; PrintLabel: ''; ClassName: 'Обычный билет для продажи';
    bPrint: true; bFree: false; bInvited: false; bGroup: false; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 9; Name: 'Скидка специальная'; BgColor: 9737290; FontColor: clBlack;
    ClassKod: 1; PrintLabel: ''; ClassName: 'Обычный билет для продажи';
    bPrint: true; bFree: false; bInvited: false; bGroup: false; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 10; Name: 'Скидка групповая 1'; BgColor: 8743794; FontColor: clBlack;
    ClassKod: 2; PrintLabel: 'Групповой'; ClassName: 'Групповой билет';
    bPrint: true; bFree: false; bInvited: false; bGroup: true; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 11; Name: 'Скидка групповая 2'; BgColor: 6861623; FontColor: clBlack;
    ClassKod: 2; PrintLabel: 'Групповой'; ClassName: 'Групповой билет';
    bPrint: true; bFree: false; bInvited: false; bGroup: true; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 12; Name: 'Скидка групповая 3'; BgColor: 6861623; FontColor: clBlack;
    ClassKod: 2; PrintLabel: 'Групповой'; ClassName: 'Групповой билет';
    bPrint: true; bFree: false; bInvited: false; bGroup: true; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 13; Name: 'Скидка групповая 4'; BgColor: 6861623; FontColor: clBlack;
    ClassKod: 2; PrintLabel: 'Групповой'; ClassName: 'Групповой билет';
    bPrint: true; bFree: false; bInvited: false; bGroup: true; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 14; Name: 'Пригласительный'; BgColor: 12320864; FontColor: clBlack;
    ClassKod: 3; PrintLabel: 'Пригласительный'; ClassName: 'Пригласительный';
    bPrint: true; bFree: true; bInvited: true; bGroup: false; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 15; Name: 'Пригласительный на руках'; BgColor: 16727197; FontColor: clBlack;
    ClassKod: 4; PrintLabel: 'Пригласительный'; ClassName: 'Пригласительный на руках';
    bPrint: false; bFree: true; bInvited: true; bGroup: false; bVipCard: false;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 16; Name: 'VIP карточка (именная)'; BgColor: 30840; FontColor: clBlack;
    ClassKod: 5; PrintLabel: 'VIP карточка'; ClassName: 'VIP карточка (именная)';
    bPrint: true; bFree: true; bInvited: false; bGroup: false; bVipCard: true;
    bVipByName: true; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 17; Name: 'VIP карточка (купленная)'; BgColor: 30840; FontColor: clBlack;
    ClassKod: 6; PrintLabel: 'VIP карточка'; ClassName: 'VIP карточка (купленная)';
    bPrint: true; bFree: true; bInvited: false; bGroup: false; bVipCard: true;
    bVipByName: false; bSeason: false; bSerial: true; MenuOrder: 0),
    (Kod: 18; Name: 'Взрослый абонемент'; BgColor: 16746692; FontColor: clBlack;
    ClassKod: 7; PrintLabel: ''; ClassName: 'Абонемент';
    bPrint: false; bFree: true; bInvited: false; bGroup: false; bVipCard: false;
    bVipByName: false; bSeason: true; bSerial: true; MenuOrder: 0),
    (Kod: 19; Name: 'Студенческий абонемент'; BgColor: 16711808; FontColor: clBlack;
    ClassKod: 7; PrintLabel: ''; ClassName: 'Абонемент';
    bPrint: false; bFree: true; bInvited: false; bGroup: false; bVipCard: false;
    bVipByName: false; bSeason: true; bSerial: true; MenuOrder: 0),
    (Kod: 20; Name: 'Школьный абонемент'; BgColor: 13289984; FontColor: clBlack;
    ClassKod: 7; PrintLabel: ''; ClassName: 'Абонемент';
    bPrint: false; bFree: true; bInvited: false; bGroup: false; bVipCard: false;
    bVipByName: false; bSeason: true; bSerial: true; MenuOrder: 0)
    );
  // --------------------------------------------------------------------------
  PstToStr: array[TSaleType] of string =
  ('pxCash', 'pxPosterminal', 'pxCheq');
  PstToInt: array[TSaleType] of Integer =
  (1, 2, 1);
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
function SetProgressParams(vProgressBar: TGauge; vMin, vMax: Integer): Boolean;
function SetProgressPosition(vProgressBar: TGauge; vPosition: Integer): Boolean;
function SetProgressPercent(vProgressBar: TGauge; vPercentDone: Integer): Boolean;
// --------------------------------------------------------------------------
procedure Change_Ticket_Desc(i_Ticket_Kod: Integer; var c_Ticket_BGCOLOR,
  c_Ticket_FNTCOLOR: TColor);
// --------------------------------------------------------------------------
function Reload_TC(i_Repert_Film: Integer): Boolean;
// --------------------------------------------------------------------------
// Загрузка всех билетов
// --------------------------------------------------------------------------
procedure Load_All_TC(Repert_Film: Integer; ProgressBar: TGauge);
// --------------------------------------------------------------------------
procedure Refresh_TC_Hint(ssT: TSeatEx); // ready partially
// --------------------------------------------------------------------------
function Get_Repert_Props(
  i_REPERT_KOD: integer;
  var d_REPERT_DATE: TDate;
  var i_REPERT_ZAL: Integer;
  var str_ZAL_DESC: string;
  var i_REPERT_SEANS: Integer;
  var str_SEANS_TIME: string;
  var i_REPERT_FILM: Integer;
  var str_FILM_NAM, str_FILM_DESC: string;
  var i_REPERT_TARIFF: Integer;
  var str_TARIFF_DESC, str_TARIFF_COMMENT, str_REPERT_DESC: string
  ): integer; // ready
// --------------------------------------------------------------------------
procedure PX_Sale(ProgressBar: TGauge; Pst: TSaleType; bCheq: Boolean; AddPrintCount: Integer);
// --------------------------------------------------------------------------

implementation

uses
  Bugger, Extctrls, SysUtils, udBase, urCommon, uhMain, strConsts, uTools,
  FIBDataset, uhBase, Dialogs, uhPrint, uhImport;

const
  UnitName: string = 'uhMain';

function SetProgressParams(vProgressBar: TGauge; vMin, vMax: Integer): Boolean;
begin
  Result := false;
  if Assigned(vProgressBar) then
  try
    vProgressBar.MinValue := vMin;
    vProgressBar.MaxValue := vMax;
    Result := true;
  except
  end;
end;

function SetProgressPosition(vProgressBar: TGauge; vPosition: Integer): Boolean;
begin
  Result := false;
  if Assigned(vProgressBar) then
  try
    vProgressBar.Progress := vPosition;
    Result := true;
  except
  end;
end;

function SetProgressPercent(vProgressBar: TGauge; vPercentDone: Integer): Boolean;
begin
  Result := false;
  if Assigned(vProgressBar) then
  try
    vProgressBar.Progress := (vPercentDone *
      (vProgressBar.MaxValue - vProgressBar.MinValue)) div 100;
    Result := true;
  except
  end;
end;

procedure Change_Ticket_Desc(i_Ticket_Kod: Integer; var c_Ticket_BGCOLOR,
  c_Ticket_FNTCOLOR: TColor);
const
  ProcName: string = 'Change_Ticket_Desc';
begin
  // --------------------------------------------------------------------------
  // Загрузка цветов фона и шрифта
  // --------------------------------------------------------------------------
  c_Ticket_BGCOLOR := clDkGray;
  c_Ticket_FNTCOLOR := clLtGray;
  with dm_Base.ds_Ticket do
  begin
    if (not Active)
      or (Active and (ParamByName(s_IN_FILT_MODE).AsInteger <> 1)) then
    begin
{$IFDEF Debug_Level_6}
      DEBUGMessEnh(0, UnitName, ProcName, 'Reopen for ' + s_IN_FILT_MODE + ' = 1 and '
        + s_IN_FILT_PARAM1 + ' = 0');
{$ENDIF}
      try
        Close;
        if Assigned(Params.FindParam(s_IN_FILT_MODE)) then
          ParamByName(s_IN_FILT_MODE).AsInteger := 1;
        if Assigned(Params.FindParam(s_IN_FILT_PARAM1)) then
          ParamByName(s_IN_FILT_PARAM1).AsInteger := 0;
        Prepare;
        Open;
        First;
        Last;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Reopening for (' + Name + ') is failed.');
        end;
      end;
{$IFDEF Debug_Level_6}
      DEBUGMessEnh(0, UnitName, ProcName, Name + '.Active = ' + BoolYesNo[Active]
        + ', RecordCount = (' + IntToStr(RecordCount) + ')');
{$ENDIF}
    end;
    if Active then
    begin
      First;
      if Locate(s_TICKET_KOD, i_Ticket_Kod, []) then
      begin
        c_Ticket_BGCOLOR := FieldByName(s_TICKET_BGCOLOR).AsInteger;
        c_Ticket_FNTCOLOR := FieldByName(s_TICKET_FNTCOLOR).AsInteger;
      end
      else if i_Ticket_Kod > 0 then
        DEBUGMessEnh(0, UnitName, ProcName, 'Error - not found Kod = (' +
          IntToStr(i_Ticket_Kod) + ').');
    end
    else
      DEBUGMessEnh(0, UnitName, ProcName, 'Error - ' + Name +
        ' is not active.');
  end;
end;

function Get_Repert_Props(
  i_REPERT_KOD: integer;
  var d_REPERT_DATE: TDate;
  var i_REPERT_ZAL: Integer;
  var str_ZAL_DESC: string;
  var i_REPERT_SEANS: Integer;
  var str_SEANS_TIME: string;
  var i_REPERT_FILM: Integer;
  var str_FILM_NAM, str_FILM_DESC: string;
  var i_REPERT_TARIFF: Integer;
  var str_TARIFF_DESC, str_TARIFF_COMMENT, str_REPERT_DESC: string
  ): integer; // ready
const
  ProcName: string = 'Get_Film_Props';
begin
  {
  select
    REP.REPERT_KOD,
    REP.REPERT_DATE,
    REP.REPERT_ZAL,
    REP.ZAL_DESC,
    REP.REPERT_SEANS,
    REP.SEANS_TIME,
    REP.REPERT_FILM,
    REP.FILM_NAM,
    REP.FILM_DESC,
    REP.REPERT_TARIFF,
    REP.TARIFF_DESC,
    REP.TARIFF_COMMENT,
    REP.SESSION_ID
  from
    REPERT REP
  where
    (
    ((:IN_FILT_REPERT_ZAL = 0) or (REPERT_ZAL = :IN_FILT_REPERT_ZAL))
    and
    (REPERT_DATE = :IN_FILT_REPERT_DATE)
    )
  order by
    REPERT_ZAL,
    SEANS_TIME
  }
  d_REPERT_DATE := Now;
  i_REPERT_ZAL := 0;
  str_ZAL_DESC := '';
  i_REPERT_SEANS := 0;
  str_SEANS_TIME := '';
  i_REPERT_FILM := 0;
  str_FILM_NAM := '';
  str_FILM_DESC := '';
  i_REPERT_TARIFF := 0;
  str_TARIFF_DESC := '';
  str_TARIFF_COMMENT := '';
  str_REPERT_DESC := '';
  //
  Result := 0;
  with dm_Base.ds_Repert do
  begin
    if (not Active) then
    begin
      try
        Close;
        Prepare;
        Open;
        First;
        Last;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Reopening for (' + Name + ') is failed.');
        end;
      end;
{$IFDEF Debug_Level_6}
      DEBUGMessEnh(0, UnitName, ProcName, Name + '.Active = ' + BoolYesNo[Active]
        + ', RecordCount = (' + IntToStr(RecordCount) + ')');
{$ENDIF}
    end;
    if Active then
    begin
      First;
      if Locate(s_REPERT_KOD, i_REPERT_KOD, []) then
      begin
        d_REPERT_DATE := Now;
        i_REPERT_ZAL := FieldByName(s_REPERT_ODEUM_KOD).AsInteger;
        str_ZAL_DESC := FieldByName(s_ODEUM_DESC).AsString;
        i_REPERT_SEANS := FieldByName(s_REPERT_SEANS_KOD).AsInteger;
        str_SEANS_TIME := FieldByName(s_SEANS_TIME).AsString;
        i_REPERT_FILM := FieldByName(s_REPERT_FILM_KOD).AsInteger;
        str_FILM_NAM := FieldByName(s_FILM_NAM).AsString;
        str_FILM_DESC := FieldByName(s_FILM_DESC).AsString;
        i_REPERT_TARIFF := FieldByName(s_REPERT_TARIFF_KOD).AsInteger;
        str_TARIFF_DESC := FieldByName(s_TARIFF_DESC).AsString;
        str_TARIFF_COMMENT := '' {FieldByName(s_TARIFF_COMMENT).AsString};
        str_REPERT_DESC := FieldByName(s_REPERT_DESC).AsString;
        Result := 1;
      end;
    end;
  end;
end;

function Get_Film_Props(
  i_FILM_KOD: integer;
  var str_FILM_NAM, str_FILM_DESC: string;
  var i_FILM_GENRE: integer;
  var str_GENRE_NAM, str_FILM_PRODUCED_YEAR: string;
  var i_FILM_LENGTH: integer;
  var str_FILM_COMMENT: string): integer; // ready
const
  ProcName: string = 'Get_Film_Props';
begin
  {
  SELECT
      FIL.FILM_KOD,
      FIL.FILM_NAM,
      FIL.FILM_DESC,
      FIL.FILM_GENRE,
      FIL.GENRE_NAM,
      FIL.FILM_PRODUCED_YEAR,
      FIL.FILM_LENGTH,
      FIL.FILM_COMMENT,
      FIL.FILM_USE_COUNT,
      FIL.FILM_LAST_ACCESS,
      FIL.FILM_TAG,
      FIL.USERID
  FROM
      FILM_VIEW FIL
  }
  str_FILM_NAM := '';
  str_FILM_DESC := '';
  i_FILM_GENRE := 0;
  str_GENRE_NAM := '';
  str_FILM_PRODUCED_YEAR := '';
  i_FILM_LENGTH := 0;
  str_FILM_COMMENT := '';
  //
  Result := 0;
  with dm_Base.ds_Film do
  begin
    if (not Active) then
    begin
      try
        Close;
        Prepare;
        Open;
        First;
        Last;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Reopening for (' + Name + ') is failed.');
        end;
      end;
{$IFDEF Debug_Level_6}
      DEBUGMessEnh(0, UnitName, ProcName, Name + '.Active = ' + BoolYesNo[Active]
        + ', RecordCount = (' + IntToStr(RecordCount) + ')');
{$ENDIF}
    end;
    if Active then
    begin
      First;
      if Locate(s_FILM_KOD, i_FILM_KOD, []) then
      begin
        str_FILM_NAM := FieldByName(s_FILM_NAM).AsString;
        str_FILM_DESC := FieldByName(s_FILM_DESC).AsString;
        i_FILM_GENRE := FieldByName(s_FILM_GENRE_KOD).AsInteger;
        str_GENRE_NAM := FieldByName(s_GENRE_NAM).AsString;
        str_FILM_PRODUCED_YEAR := FieldByName(s_FILM_RELEASE).AsString;
        i_FILM_LENGTH := FieldByName(s_FILM_SCREENTIME).AsInteger;
        str_FILM_COMMENT := FieldByName(s_FILM_COMMENT).AsString;
        Result := 1;
      end;
    end;
  end;
end;

function Get_Ticket_Type_Info(const TicketKod: Integer;
  var _TICKET_LABEL, _CLASS_NAM: string; var _CLASS_TO_PRINT, _CLASS_FOR_FREE,
  _CLASS_INVITED_GUEST, _CLASS_GROUP_VISIT, _CLASS_VIP_CARD, _CLASS_VIP_BYNAME,
  _CLASS_SEASON_TICKET, _TICKET_SERIALIZE: Boolean): Boolean;
const
  ProcName: string = 'Get_Ticket_Type_Info';
begin
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  Result := true;
  if (TicketKod >= Low(c_TicketProps)) and (TicketKod <= High(c_TicketProps)) then
  begin
    // TicketName := c_TicketProps[TicketKod].Name;
    // TicketBgColor := c_TicketProps[TicketKod].BgColor;
    // TicketFontColor := c_TicketProps[TicketKod].FontColor;
    _TICKET_LABEL := c_TicketProps[TicketKod].PrintLabel;
    _CLASS_NAM := c_TicketProps[TicketKod].ClassName;
    _CLASS_TO_PRINT := c_TicketProps[TicketKod].bPrint;
    _CLASS_FOR_FREE := c_TicketProps[TicketKod].bFree;
    _CLASS_INVITED_GUEST := c_TicketProps[TicketKod].bInvited;
    _CLASS_GROUP_VISIT := c_TicketProps[TicketKod].bGroup;
    _CLASS_VIP_CARD := c_TicketProps[TicketKod].bVipCard;
    _CLASS_VIP_BYNAME := c_TicketProps[TicketKod].bVipByName;
    _CLASS_SEASON_TICKET := c_TicketProps[TicketKod].bSeason;
    _TICKET_SERIALIZE := c_TicketProps[TicketKod].bSerial;
  end
  else
  begin
    // TicketName := 'Undefined';
    // TicketBgColor := clLtGray;
    // TicketFontColor := clDkGray;
    _TICKET_LABEL := 'super ticket';
    _CLASS_NAM := 'unknown ticket';
    _CLASS_TO_PRINT := true;
    _CLASS_FOR_FREE := false;
    _CLASS_INVITED_GUEST := false;
    _CLASS_GROUP_VISIT := false;
    _CLASS_VIP_CARD := false;
    _CLASS_VIP_BYNAME := false;
    _CLASS_SEASON_TICKET := false;
    _TICKET_SERIALIZE := false;
{$IFDEF Debug_Level_5}
    DEBUGMessEnh(0, UnitName, ProcName, 'Error: Unknown ticket type.');
{$ENDIF}
  end;
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

function Get_Repert_Info(const RepertKod: Integer;
  _bmp_CinemaLogo, _bmp_OdeumLogo: TBitmap;
  var _str_Zal_Nam, _str_Zal_Prefix: string; var _dtFilm_Date: TDateTime;
  var _strFilm_Name, _strSeans_Time: string): Boolean;
const
  ProcName: string = 'Get_Repert_Info';
var
  Cur_Odeum: TOdeumPanel;
begin
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  Result := false;
  // Cur_Odeum := nil;
  if (Cur_Panel_Cntr is TOdeumPanel) and (Cur_Repert_Kod = RepertKod) then
  begin
    Cur_Odeum := (Cur_Panel_Cntr as TOdeumPanel);
    if Assigned(Cur_Odeum.CinemaLogo)
      and Assigned(Cur_Odeum.OdeumLogo)
      and Assigned(_bmp_CinemaLogo)
      and Assigned(_bmp_OdeumLogo) then
    begin
      _bmp_CinemaLogo.Assign(Cur_Odeum.CinemaLogo);
      _bmp_OdeumLogo.Assign(Cur_Odeum.OdeumLogo);
      _str_Zal_Nam := Cur_Odeum.CinemaName + ' - ' + Cur_Odeum.OdeumName;
      _str_Zal_Prefix := Cur_Odeum.OdeumPrefix;
      _dtFilm_Date := Cur_Date;
      _strFilm_Name := Cur_Film_Nam;
      _strSeans_Time := Cur_Seans_Time;
      Result := true;
    end
    else
    begin
{$IFDEF Debug_Level_5}
      DEBUGMessEnh(0, UnitName, ProcName, 'Error: No logo bitmaps assigned.');
{$ENDIF}
    end;
  end
  else
  begin
{$IFDEF Debug_Level_5}
    DEBUGMessEnh(0, UnitName, ProcName, 'Error: Repert is not current.');
{$ENDIF}
  end;
{$IFDEF Debug_Level_6}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Refresh_TC_Hint(ssT: TSeatEx); // ready partially
const
  ProcName: string = 'Refresh_TC_Hint';
begin
  // --------------------------------------------------------------------------
  // Обновление подсказки
  // --------------------------------------------------------------------------
  if Assigned(ssT) then
    with ssT do
    begin
      (*
      // if ssT.Ticket_Kod > 0 then
      begin
        Get_Film_Props(i_OPER_FILM,
          str_FILM_NAM, str_FILM_DESC,
          i_FILM_GENRE,
          str_GENRE_NAM, str_FILM_PRODUCED_YEAR,
          i_FILM_LENGTH,
          str_FILM_COMMENT,
          i_FILM_TAG);
      end;
      *)
      {
      Hint :=
        'Выделено === ' + BoolYesNo[Selected] + c_CRLF +
        'Состояние == ' + SpShSt_Array[TC_State] + c_CRLF +
        'Пригласил == ' + FixFmt(OperData.fOper_Misc_Inviter, 10, ' ') +
        c_CRLF +
        'Группа ===== ' + FixFmt(OperData.fOper_Misc_Group, 10, ' ') + c_CRLF +
        'Карточка === ' + FixFmt(OperData.fOper_Misc_Card, 10, ' ') + c_CRLF +
        'Сериал ===== ' + OperData.fOper_Misc_Serial + c_CRLF +
        'Сумма ====== ' + FixFmt(OperData.fOper_Sum, 6, ' ') + ' тенге' + c_CRLF
        + c_CRLF +
        'Код ======== ' + FixFmt(TicketKod, 10, ' ') + c_CRLF +
        'РядМесто === ' + FixFmt(Row, 2, '0') + ',' + FixFmt(Column, 2, '0') +
        c_CRLF +
        'Тип билета = [' + FixFmt(TicketType, 10, ' ') + '] ' +
        OperData.fTicket_Nam + c_CRLF +
        'Фильм ====== [' + FixFmt(OperData.fOper_Repert_Film, 10, ' ') + '] - '
        + Cur_Film_Nam + c_CRLF +
        'Этот фильм = ' + BoolYesNo[OperData.fOper_Repert_Film = Cur_Film_Kod] +
        c_CRLF +
        'Время1 ===== ' + DateTimeToStr(TimeStamp1) + c_CRLF +
        'Время2 ===== ' + DateTimeToStr(TimeStamp2) + c_CRLF +
        c_CRLF +
        'Тип сл. ==== ' + IntToStr(OperData.fOper_State_Ch) + c_CRLF +
        'Польз. ===== ' + OperData.fDbuser_Nam + c_CRLF +
        'Хост ======= ' + OperData.fSession_Host + c_CRLF +
        'Сессия ===== ' + IntToStr(OperData.fOper_Session) + c_CRLF;
      // Get_Film_Props
      if ((OperData.fOper_Session = 0)
        or (OperData.fOper_Session = Global_Session_ID)
        (*scFree, scPrepared*)
        or (TC_State in [scBroken, scReserved, scFixed, scFixedNoCash,
        scFixedCheq])) then
        Shape := stRoundRect
      else
        Shape := stEllipse;
      }
    end;
end;

function Refresh_TC_State(
  ssTxz: TSeatEx;
  pd_OPER_KOD: Integer; // Код операции уникальный
  pd_OPER_VER: Integer; // Версия операции
  pd_OPER_STATE: Integer; // Статус операции
  pd_OPER_SELECTED: Boolean; // Выделено
  pd_OPER_ACTION: TOperAction; // Последнее действие
  // pd_OPER_PRINTED: Boolean; // Напечатано или нет
  pd_OPER_PRINT_COUNT: Integer; // Сколько раз напечатано
  pd_OPER_CHEQED: Boolean; // Проведено или нет
  pd_OPER_PLACE_ROW: Integer; // Ряд
  pd_OPER_PLACE_COL: Integer; // Место
  pd_OPER_LOCK_STAMP: TDateTime; // Время выделения
  pd_OPER_COST_VALUE: Integer; // Цена
  pd_OPER_SALE_FORM: TSaleForm; // Тип продажи
  pd_OPER_SALE_STAMP: TDateTime; // Время операции
  pd_OPER_MOD_STAMP: TDateTime; // Время изменения
  pd_OPER_REPERT_KOD: Integer; // Код репертуара
  pd_OPER_REPERT_VER: Integer; // Версия репертуара
  pd_OPER_TICKET_KOD: Integer; // Код типа билета
  pd_OPER_TICKET_VER: Integer; // Версия типа билета
  pd_OPER_SEAT_KOD: Integer; // Код места
  pd_OPER_SEAT_VER: Integer; // Версия места
  pd_OPER_MISC_REASON: Integer; // Код причины возврата
  pd_OPER_MISC_SERIAL: string; // Сериийный номер
  pd_SESSION_ID: Int64; // Код сессии
  pd_DBUSER_ID: Integer; // Код пользователя
  pd_DBUSER_NAM: string; // Имя пользователя
  pd_SESSION_HOST: string // Хост пользователя
  ): Boolean;
const
  ProcName: string = 'Refresh_TC_State';
begin
  Result := false;
  // --------------------------------------------------------------------------
  // Загрузка билета из запроса и обновление состояния
  // --------------------------------------------------------------------------
  if Assigned(ssTxz) then
    if (ssTxz.SeatRow = pd_OPER_PLACE_ROW)
      and (ssTxz.SeatColumn = pd_OPER_PLACE_COL) then
    begin
      // ssTxz.MoveKod := pd_OPER_KOD; // Код операции уникальный
      // ssTxz.MoveVer := pd_OPER_VER; // Версия операции
      if pd_OPER_STATE = 0 then
        ssTxz.SeatState := tsFree
      else if pd_OPER_STATE = 1 then
        ssTxz.SeatState := tsReserved
      else if pd_OPER_STATE = 2 then
        ssTxz.SeatState := tsRealized
      else
        ssTxz.SeatState := tsFree;
      // pd_OPER_STATE; // Статус операции
      ssTxz.Selected := pd_OPER_SELECTED; // Выделено
      ssTxz.LastAction := pd_OPER_ACTION; // Последнее действие
      // ssTxz.Printed := pd_OPER_PRINTED; // Напечатано или нет
      ssTxz.PrintCount := pd_OPER_PRINT_COUNT; // Сколько раз напечатано
      ssTxz.Cheqed := pd_OPER_CHEQED; // Проведено или нет
      ssTxz.LockStamp := pd_OPER_LOCK_STAMP; // Время выделения
      ssTxz.SaleForm := pd_OPER_SALE_FORM; // Тип оплаты
      ssTxz.SaleStamp := pd_OPER_SALE_STAMP; // Время операции
      ssTxz.ModStamp := pd_OPER_MOD_STAMP; // Время изменения
      ssTxz.RepertKod := pd_OPER_REPERT_KOD; // Код репертуара
      ssTxz.RepertVer := pd_OPER_REPERT_VER; // Версия репертуара
      {
      // update later
      ssTxz.TicketKod := pd_OPER_TICKET_KOD; // Код типа билета
      ssTxz.TicketVer := pd_OPER_TICKET_VER; // Версия типа билета
      ssTxz.SaleCost := pd_OPER_COST_VALUE; // Цена
      }
      // ssTxz.SeatKod := pd_OPER_SEAT_KOD; // Код места
      // ssTxz.SeatVer := pd_OPER_SEAT_VER; // Версия места
      ssTxz.Reason := pd_OPER_MISC_REASON; // Код причины возврата
      ssTxz.SerialStr := pd_OPER_MISC_SERIAL; // Сериийный номер
      ssTxz.SessionUid := pd_SESSION_ID; // Код сессии
      ssTxz.UserUid := pd_DBUSER_ID; // Код пользователя
      ssTxz.UserName := pd_DBUSER_NAM; // Имя пользователя
      ssTxz.UserHost := pd_SESSION_HOST; // Хост пользователя
      // --------------------------------------------------------------------------
      if (ssTxz.UserUid < 0) then
      begin
        ssTxz.Foreign := trUnknown;
        ssTxz.Current := trUnknown;
      end
      else
      begin
        ssTxz.Current := trNo;
        if (ssTxz.UserUid = Global_User_Kod) then
        begin
          ssTxz.Foreign := trNo;
          if (ssTxz.SessionUid = Global_Session_ID) then
            ssTxz.Current := trYes;
        end
        else
        begin
          ssTxz.Foreign := trYes;
        end;
      end;
      // --------------------------------------------------------------------------
      if (ssTxz.Tag < -1) and ssTxz.Selected and (ssTxz.Foreign = trNo)
        and (ssTxz.TicketVer = -1)
        and (ssTxz.SeatState in [tsFree, tsPrepared, tsReserved]) then
      begin
        // Skip update
        DEBUGMessEnh(0, UnitName, ProcName, 'Skip update...');
        ssTxz.Tag := 0;
        if (ssTxz.SeatState = tsFree) then
          ssTxz.SeatState := tsPrepared;
      end
      else
      begin
        ssTxz.TicketKod := pd_OPER_TICKET_KOD; // Код типа билета
        ssTxz.TicketVer := pd_OPER_TICKET_VER; // Версия типа билета
        ssTxz.SaleCost := pd_OPER_COST_VALUE; // Цена
      end;
      // --------------------------------------------------------------------------
      Result := (ssTxz.Foreign <> trUnknown);
    end;
end;

function Reload_TC(i_Repert_Film: Integer): Boolean;
const
  ProcName: string = 'Reload_TC';
var
  i_Row, i_Column: Integer;
  s_TC_Name: string;
  tmpComponent: TComponent;
  ssTmp: TSeatEx;
  i_TicketSession: Int64;
  StrAction: string;
  ChrAction: Char;
  o_LastAction: TOperAction;
  i_SaleForm: Integer;
  o_SaleForm: TSaleForm;
  v_Row, v_Column: Variant;
begin
  Result := False;
  try
    with dm_Base.ds_Moves do
      if Active and (ParamByName(s_IN_FILT_REPERT).AsInteger = i_Repert_Film) then
      begin
{$IFDEF Debug_Level_7}
        DEBUGMessEnh(0, UnitName, ProcName, Name + '.State = (' + ds_States[State] + ')');
{$ENDIF}
        v_Row := FieldByName(s_OPER_PLACE_ROW).AsVariant;
        v_Column := FieldByName(s_OPER_PLACE_COL).AsVariant;
        if (not VarIsNull(v_Row)) and (not VarIsNull(v_Column)) then
        begin
          i_Row := FieldByName(s_OPER_PLACE_ROW).AsInteger;
          i_Column := FieldByName(s_OPER_PLACE_COL).AsInteger;
          s_TC_Name := Cur_Panel_Cntr.Name + '_TC_Z' + IntToStr(Cur_Zal_Kod)
            + '_R' + IntToStr(i_Row) + '_C' + IntToStr(i_Column);
{$IFDEF Debug_Level_8}
          DEBUGMessEnh(0, UnitName, ProcName, 'TC_Name = ' + s_TC_Name);
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.' + s_OPER_KOD + ' = '
            + IntToStr(FieldByName(s_OPER_KOD).AsInteger));
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.' + s_SESSION_ID + ' = '
            + FieldByName(s_SESSION_ID).AsString);
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.' + s_OPER_LOCK_STAMP + ' = '
            + FieldByName(s_OPER_LOCK_STAMP).AsString);
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.' + s_OPER_SALE_FORM + ' = '
            + FieldByName(s_OPER_SALE_FORM).AsString);
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.' + s_OPER_SALE_STAMP + ' = '
            + FieldByName(s_OPER_SALE_STAMP).AsString);
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.' + s_OPER_MOD_STAMP + ' = '
            + FieldByName(s_OPER_MOD_STAMP).AsString);
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.' + s_OPER_ACTION + ' = '
            + FieldByName(s_OPER_ACTION).AsString);
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.' + s_OPER_STATE + ' = '
            + FieldByName(s_OPER_STATE).AsString);
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.' + s_OPER_SELECTED + ' = '
            + FieldByName(s_OPER_SELECTED).AsString);
          {
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.' + s_OPER_PRINTED + ' = '
            + FieldByName(s_OPER_PRINTED).AsString);
          }
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.' + s_OPER_PRINT_COUNT + ' = '
            + FieldByName(s_OPER_PRINT_COUNT).AsString);
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.' + s_OPER_CHEQED + ' = '
            + FieldByName(s_OPER_CHEQED).AsString);
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.' + s_OPER_TICKET_KOD + ' = '
            + FieldByName(s_OPER_TICKET_KOD).AsString);
{$ENDIF}
          tmpComponent := Cur_Panel_Cntr.FindComponent(s_TC_Name);
          if (tmpComponent is TSeatEx) then
          begin
            ssTmp := (tmpComponent as TSeatEx);
            if (ssTmp.SeatRow = i_Row) and (ssTmp.SeatColumn = i_Column) then
            begin
              if (FieldByName(s_SESSION_ID) is TFIBBCDField) then
                i_TicketSession := (FieldByName(s_SESSION_ID) as TFIBBCDField).AsInt64
              else
                i_TicketSession := FieldByName(s_SESSION_ID).AsInteger;
              StrAction := FieldByName(s_OPER_ACTION).AsString;
              if Length(StrAction) > 0 then
                ChrAction := StrAction[1]
              else
                ChrAction := '-';
              case ChrAction of
                'R': o_LastAction := oaReserve; // (R-(S-C:S-A:S-J))
                'P': o_LastAction := oaSale; // (P-(S-C:S-F))
                'A': o_LastAction := oaActualize; // (A-(S-C:S-F))
                'M': o_LastAction := oaModify; //
                'J': o_LastAction := oaFree; //(F-S)
                'F': o_LastAction := oaRestore; //(R-S)
                'S': o_LastAction := oaSelect; //(S-(C:R:P:A:J:F))
                'C': o_LastAction := oaCancel; //(C-S)
              else // case
                o_LastAction := oaUnknown;
              end; // case
              i_SaleForm := FieldByName(s_OPER_SALE_FORM).AsInteger;
              if (i_SaleForm >= Low(c_IntToSf)) and (i_SaleForm <= High(c_IntToSf)) then
                o_SaleForm := c_IntToSf[i_SaleForm]
              else // if
                o_SaleForm := sfNotPaid;
              Refresh_TC_State(ssTmp,
                FieldByName(s_OPER_KOD).AsInteger, // Код операции уникальный
                FieldByName(s_OPER_VER).AsInteger, // Версия операции
                FieldByName(s_OPER_STATE).AsInteger, // Статус операции
                FieldByName(s_OPER_SELECTED).AsBoolean, // Выделено
                o_LastAction, // Последнее действие (s_OPER_ACTION)
                // FieldByName(s_OPER_PRINTED).AsBoolean, // Напечатано или нет
                FieldByName(s_OPER_PRINT_COUNT).AsInteger, // Сколько раз напечатано
                FieldByName(s_OPER_CHEQED).AsBoolean, // Проведено или нет
                FieldByName(s_OPER_PLACE_ROW).AsInteger, // Ряд
                FieldByName(s_OPER_PLACE_COL).AsInteger, // Место
                FieldByName(s_OPER_LOCK_STAMP).AsDateTime, // Время выделения
                FieldByName(s_OPER_COST_VALUE).AsInteger, // Цена
                o_SaleForm, // Тип продажи (s_OPER_SALE_FORM)
                FieldByName(s_OPER_SALE_STAMP).AsDateTime, // Время операции
                FieldByName(s_OPER_MOD_STAMP).AsDateTime, // Время изменения
                FieldByName(s_OPER_REPERT_KOD).AsInteger, // Код репертуара
                FieldByName(s_OPER_REPERT_VER).AsInteger, // Версия репертуара
                FieldByName(s_OPER_TICKET_KOD).AsInteger, // Код типа билета
                FieldByName(s_OPER_TICKET_VER).AsInteger, // Версия типа билета
                FieldByName(s_OPER_SEAT_KOD).AsInteger, // Код места
                FieldByName(s_OPER_SEAT_VER).AsInteger, // Версия места
                FieldByName(s_OPER_MISC_REASON).AsInteger, // Код причины возврата
                FieldByName(s_OPER_MISC_SERIAL).AsString, // Сериийный номер
                i_TicketSession, // Код сессии (s_SESSION_ID)
                FieldByName(s_DBUSER_KOD).AsInteger, // Код пользователя
                FieldByName(s_DBUSER_NAM).AsString, // Имя пользователя
                FieldByName(s_SESSION_HOST).AsString // Хост пользователя
                );
              Refresh_TC_Hint(ssTmp);
              Result := True;
            end; // if (ssTmp.Row = _Row) and (ssTmp.Column = _Column) then
          end; // if (tmpComponent is TSeatEx) then
        end
        else
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Row or Column is null.');
        end; // Test for Null
      end;
  except
    on E: Exception do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'Proc failed.');
    end;
  end;
end;

procedure Load_All_TC(Repert_Film: Integer; ProgressBar: TGauge);
const
  ProcName: string = 'Load_All_TC';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  i, i_Count, Counter1, Counter2, Counter3: integer;
  tmpComponent: TComponent;
  ssTmp: TSeatEx;
  //  vArray: Variant;
begin
  // --------------------------------------------------------------------------
  // Загрузка всех билетов
  // --------------------------------------------------------------------------
  Time_Start := Now;
  DEBUGMessBrk(0, 'Full Load Start');
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  SetProgressPercent(ProgressBar, 10);
  with dm_Base.ds_Moves do
  begin
    try
      DEBUGMessEnh(0, UnitName, ProcName, Name + '.Close');
      Close;
    except
      on E: Exception do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
        DEBUGMessEnh(0, UnitName, ProcName, Name + '.Close failed.');
      end;
    end;
    try
      Prepare;
      if Assigned(Params.FindParam(s_IN_FILT_REPERT)) then
        ParamByName(s_IN_FILT_REPERT).AsInteger := Repert_Film;
      {
      if Assigned(Params.FindParam(s_IN_UPDATE_ID)) then
        ParamByName(s_IN_UPDATE_ID).AsVariant := Null;
      }
      DEBUGMessEnh(0, UnitName, ProcName, Name + '.Open');
      SetProgressPercent(ProgressBar, 20);
      Open;
      // dm_Base.ev_Oper.Registered := false;
      First;
      Last;
      SetProgressPercent(ProgressBar, 30);
    except
      on E: Exception do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
        DEBUGMessEnh(0, UnitName, ProcName, Name + '.Open failed.');
      end;
    end;
    DEBUGMessEnh(0, UnitName, ProcName, Name + '.RecordCount = ' +
      IntToStr(RecordCount));
    // --------------------------------------------------------------------------
    DEBUGMessBrk(0, 'Cycle 1st');
    // --------------------------------------------------------------------------
    i_Count := Cur_Panel_Cntr.ComponentCount - 1;
    Counter1 := 0;
    Counter2 := 0;
    Counter3 := 0;
    for i := 0 to i_Count do
    begin
      tmpComponent := Cur_Panel_Cntr.Components[i];
      if (tmpComponent is TSeatEx) then
      begin
        ssTmp := (tmpComponent as TSeatEx);
        with ssTmp do
        begin
          ResetToDefault(tsFree);
          Inc(Counter1);
          Tag := -1;
        end;
      end;
    end; // for i := 0 to i_Count do
    SetProgressPercent(ProgressBar, 40);
    // --------------------------------------------------------------------------
    DEBUGMessBrk(0, 'Cycle 2nd');
    // --------------------------------------------------------------------------
    if Active then
    begin
      First;
      SetProgressParams(ProgressBar, 0, RecordCount);
      while not Eof do
      begin
        if Reload_TC(Repert_Film) then
        begin
          Inc(Counter2);
          Tag := 0;
          SetProgressPosition(ProgressBar, Counter2);
        end;
        Next;
      end; // while not Eof do
    end;
    // --------------------------------------------------------------------------
    DEBUGMessBrk(0, 'Cycle 3rd');
    // --------------------------------------------------------------------------
    i_Count := -1;
    for i := 0 to i_Count do
    begin
      tmpComponent := Cur_Panel_Cntr.Components[i];
      if (tmpComponent is TSeatEx) then
      begin
        ssTmp := (tmpComponent as TSeatEx);
        if (ssTmp.Tag = -1) then
        begin
          Inc(Counter3);
          // ssTmp.SeatState := tsFree;
          if (Random(100) mod 3 = 0) then
            ssTmp.SeatState := tsRealized
          else
            ssTmp.SeatState := tsFree;
          ssTmp.TicketKod := i mod 5 + 1;
          // Refresh_TC_State(ssTmp);
          ssTmp.Tag := 0;
          Refresh_TC_Hint(ssTmp);
        end; // if
      end; // if
    end; // for i := Cur_Panel_Cntr.ComponentCount - 1 downto 0 do
    SetProgressParams(ProgressBar, 0, 100);
    // --------------------------------------------------------------------------
    DEBUGMessBrk(0, 'Cycles end');
    DEBUGMessEnh(0, UnitName, ProcName, 'Counter1 = ' + IntToStr(Counter1));
    DEBUGMessEnh(0, UnitName, ProcName, 'Counter2 = ' + IntToStr(Counter2));
    DEBUGMessEnh(0, UnitName, ProcName, 'Counter3 = ' + IntToStr(Counter3));
    // --------------------------------------------------------------------------
  end;
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  DEBUGMessBrk(0, 'Full Load End');
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMessEnh(0, UnitName, ProcName, 'Work time - (' + IntToStr(Hour) + ':' +
    FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0')
    + ')');
end;

procedure PX_Sale(ProgressBar: TGauge; Pst: TSaleType; bCheq: Boolean; AddPrintCount: Integer);
const
  ProcName: string = 'PX_Sale';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  // --------------------------------------------------------------------------
  tmpComponent: TComponent;
  ssTmp: TSeatEx;
  //  vArray: Variant;
  tmp_Choice: Integer;
  b_YesToAll_Reserved, b_NoToAll_Reserved: Boolean;
  i, Cmpnt_Count, Real_Counter: Integer;
  tmp_PrintCount: Integer;
  DoCtrlChange, DoCtrlCancel: Boolean;
  s: string;
  // --------------------------------------------------------------------------
  int_Oper_Kod: integer;
  str_Oper_Serial: string;
  tError_Kod: Integer;
  tError_Text: string;
  // --------------------------------------------------------------------------
  b_PrintStarted: Boolean;
  PrintCounter, re: Integer;
begin
  // --------------------------------------------------------------------------
  // Загрузка всех билетов
  // --------------------------------------------------------------------------
  Time_Start := Now;
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  b_YesToAll_Reserved := false;
  b_NoToAll_Reserved := false;
  b_PrintStarted := false;
  PrintCounter := 0;
  try
    // --------------------------------------------------------------------------
    DEBUGMessBrk(0, 'Cycle 1st start');
    // --------------------------------------------------------------------------
    // cycle to determine i_Count to process
    // --------------------------------------------------------------------------
    Real_Counter := 0;
    Cmpnt_Count := Cur_Panel_Cntr.ComponentCount;
    for i := 0 to Cmpnt_Count - 1 do
    begin
      tmpComponent := Cur_Panel_Cntr.Components[i];
      if (tmpComponent is TSeatEx) then
      begin
        ssTmp := (tmpComponent as TSeatEx);
        // TTicketState = (tsFree, tsBroken, tsPrepared, tsReserved, tsRealized);
        with ssTmp do
        begin
          Tag := 0;
          if (Foreign = trNo) then
          begin
            if (SeatState = tsPrepared) then
            begin
              Tag := -1;
              Inc(Real_Counter);
            end
            else if ((SeatState = tsReserved) and Selected) then
            begin
              Tag := -2;
              Inc(Real_Counter);
            end
            else if ((SeatState = tsRealized) and Selected and (not Cheqed)) then
            begin
              Tag := -3;
              Inc(Real_Counter);
            end;
          end;
        end; // with
      end; // if (tmpComponent is TSeatEx)
    end; // for i := 0 to Cmpnt_Count - 1 do
    // --------------------------------------------------------------------------
    // real cycle with Real_Count value
    // --------------------------------------------------------------------------
    DEBUGMessEnh(0, UnitName, ProcName, 'Places to process = ' + IntToStr(Real_Counter));
    if (Real_Counter > 0) then
      SetProgressParams(ProgressBar, 0, Real_Counter + 5);
    SetProgressPosition(ProgressBar, 0);
    Real_Counter := 0;
    OperModFinal([poCommitTransactionAfter]);
    for i := 0 to Cmpnt_Count - 1 do
    begin
      tmpComponent := Cur_Panel_Cntr.Components[i];
      if (tmpComponent is TSeatEx) then
      begin
        ssTmp := (tmpComponent as TSeatEx);
        // TTicketState = (tsFree, tsBroken, tsPrepared, tsReserved, tsRealized);
        with ssTmp do
          if (Tag < 0) then
          begin
            Inc(Real_Counter);
            Tag := 0;
            DoCtrlChange := false;
            DoCtrlCancel := false;
{$IFDEF Debug_Level_6}
            DEBUGMessEnh(0, UnitName, ProcName, 'Name = ' + Name);
            DEBUGMessEnh(0, UnitName, ProcName, 'SeatState = ' + c_TicketState[SeatState]);
            DEBUGMessEnh(0, UnitName, ProcName, 'Foreign = ' + c_Triplean[Foreign]);
            DEBUGMessEnh(0, UnitName, ProcName, 'Selected = ' + c_Boolean[Selected]);
            DEBUGMessEnh(0, UnitName, ProcName, 'PrintCount = ' + IntToStr(PrintCount));
            // DEBUGMessEnh(0, UnitName, ProcName, 'Printed = ' + c_Boolean[Printed]);
            DEBUGMessEnh(0, UnitName, ProcName, 'Cheqed = ' + c_Boolean[Cheqed]);
{$ENDIF}
            case SeatState of
              tsPrepared:
                if (Pst in [pxCash, pxPosterminal]) then
                begin
{$IFDEF Debug_Level_5}
                  DEBUGMessEnh(0, UnitName, ProcName, 'Let''s sale...');
{$ENDIF}
                  tmp_PrintCount := PrintCount + AddPrintCount;
                  DoCtrlChange := OperModify([poStartTransAction],
                    oaSale, tmp_PrintCount,
                    (Cheqed or bCheq), SeatRow, SeatColumn,
                    PstToInt[Pst], Cur_Repert_Kod, TicketKod, Reason,
                    int_Oper_Kod, str_Oper_Serial, tError_Kod, tError_Text);
                end; // tsPrepared
              tsRealized:
                if (Pst in [pxCheq]) and (not Cheqed) then
                begin
{$IFDEF Debug_Level_5}
                  DEBUGMessEnh(0, UnitName, ProcName, 'Let''s cheq...');
{$ENDIF}
                  tmp_PrintCount := AddPrintCount;
                  DoCtrlChange := OperModify([poStartTransAction],
                    oaModify, tmp_PrintCount,
                    True, SeatRow, SeatColumn,
                    PstToInt[Pst], Cur_Repert_Kod, TicketKod, Reason,
                    int_Oper_Kod, str_Oper_Serial, tError_Kod, tError_Text);
                end; // tsRealized
              tsReserved:
                if (Pst in [pxCash, pxPosterminal]) then
                begin
                  tmp_Choice := 0;
                  if b_YesToAll_Reserved then
                    tmp_Choice := 1
                  else if b_NoToAll_Reserved then
                    tmp_Choice := 2
                  else
                  begin
                    s := ssTmp.Hint;
                    s := Format(Actualize_Mess, [SeatColumn, SeatRow, s]);
                    case MessageDlg(s, mtWarning, [mbYes, mbNo, mbYesToAll, mbNoToAll], 0) of
                      mrYes:
                        tmp_Choice := 1;
                      mrNo:
                        tmp_Choice := 2;
                      mrYesToAll:
                        begin
                          tmp_Choice := 1;
                          b_YesToAll_Reserved := True;
                          b_NoToAll_Reserved := False;
                        end;
                      mrNoToAll:
                        begin
                          tmp_Choice := 2;
                          b_YesToAll_Reserved := False;
                          b_NoToAll_Reserved := True;
                        end;
                    end; // case
                  end;
                  case tmp_Choice of
                    1:
                      begin
{$IFDEF Debug_Level_5}
                        DEBUGMessEnh(0, UnitName, ProcName, 'Let''s actualize...');
{$ENDIF}
                        tmp_PrintCount := PrintCount + AddPrintCount;
                        DoCtrlChange := OperModify([poStartTransAction],
                          oaActualize, tmp_PrintCount,
                          (Cheqed or bCheq), SeatRow, SeatColumn,
                          PstToInt[Pst], Cur_Repert_Kod, TicketKod, Reason,
                          int_Oper_Kod, str_Oper_Serial, tError_Kod, tError_Text);
                      end;
                    2:
                      begin
{$IFDEF Debug_Level_5}
                        DEBUGMessEnh(0, UnitName, ProcName, 'Let''s cancel reserved...');
{$ENDIF}
                        DoCtrlCancel := OperModify([poStartTransAction],
                          oaCancel, -1,
                          Cheqed, SeatRow, SeatColumn,
                          -2, Cur_Repert_Kod, TicketKod, Reason,
                          int_Oper_Kod, str_Oper_Serial, tError_Kod, tError_Text);
                      end;
                  else
                    // do nothing
                  end; // case
                end; // tsReserved
            else
              // foo
            end;
            if (not DoCtrlChange) and ((tError_Kod = 231) or (tError_Kod = 232)) then
            begin
              DoCtrlChange := False;
            end;
            if DoCtrlChange and (not DoCtrlCancel) then
            begin
              // Let's print
              re := 0;
              if (not b_PrintStarted) then
              begin
                re := ClearPrinterBuffer;
{$IFDEF Debug_Level_5}
                DEBUGMessEnh(0, UnitName, ProcName, 'ClearPrinterBuffer result = ' +
                  IntToStr(re));
{$ENDIF}
              end;
              if (re >= 0) then
              begin
                b_PrintStarted := True;
                // PrintJobFirst := True;
                re := Add_TC_Print(0, TicketKod, Get_Ticket_Type_Info,
                  Cur_Repert_Kod, Get_Repert_Info, SeatRow, SeatColumn,
                  SaleCost, 'group 555', SerialStr, true);
{$IFDEF Debug_Level_5}
                DEBUGMessEnh(0, UnitName, ProcName, 'Add_TC_Print result = ' + IntToStr(re));
{$ENDIF}
                if (re > 3) then
                  Inc(PrintCounter);
              end;
            end;
{$IFDEF Debug_Level_5}
            DEBUGMessEnh(0, UnitName, ProcName, 'DoCtrlChange result = ' +
              c_Boolean[DoCtrlChange]);
{$ENDIF}
          end; // if (Tag < 0)
        SetProgressPosition(ProgressBar, Real_Counter);
      end; // if (tmpComponent is TSeatEx) then
    end; // for i := 0 to Cur_Panel_Cntr.ComponentCount - 1 do
    SetProgressPosition(ProgressBar, Real_Counter);
    if b_PrintStarted then
    begin
      if (Cur_Panel_Cntr is TOdeumPanel) then
        with (Cur_Panel_Cntr as TOdeumPanel) do
          re := Final_TC_Print(PrintCounter, CinemaName + ' - ' + OdeumName)
      else
        re := Final_TC_Print(PrintCounter, 'tHE oDEUM');
      if (re > 0) then
        OperModFinal([poCommitTransactionAfter])
      else
        OperModFinal([poRollbackTransactionAfter]);
{$IFDEF Debug_Level_5}
      DEBUGMessEnh(0, UnitName, ProcName, 'Final_TC_Print result = ' + IntToStr(re));
{$ENDIF}
    end;
    OperModFinal([poCommitTransactionAfter]);
    // SetProgressPercent(ProgressBar, 100);
    // --------------------------------------------------------------------------
    DEBUGMessBrk(0, 'Cycle 1st end');
    // --------------------------------------------------------------------------
    SetProgressParams(ProgressBar, 0, 100);
    SetProgressPercent(ProgressBar, 0);
    // --------------------------------------------------------------------------
  finally
    // sbx_Cntr.Visible := bv;
    ProgressBar.Progress := 100;
    ProgressBar.Visible := false;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMessEnh(0, UnitName, ProcName, 'Work time - (' + IntToStr(Hour) + ':' +
    FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0')
    + ')');
end;

end.

