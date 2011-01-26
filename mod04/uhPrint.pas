{-----------------------------------------------------------------------------
 Unit Name: uhPrint
 Author:    n0mad
 Version:   1.2.8.x (cache)
 Creation:  12.10.2002
 Purpose:   Use of external dll for print
 History:
-----------------------------------------------------------------------------}
unit uhPrint;

{$I uhPrint.inc}

interface

uses
  Graphics;

type
  // --------------------------------------------------------------------------
  TGet_Ticket_Type_Info = function(const _TicketClass: Integer;
    var _TICKET_LABEL, _CLASS_NAM: string; var _CLASS_TO_PRINT, _CLASS_FOR_FREE,
    _CLASS_INVITED_GUEST, _CLASS_GROUP_VISIT, _CLASS_VIP_CARD, _CLASS_VIP_BYNAME,
    _CLASS_SEASON_TICKET, _TICKET_SERIALIZE: Boolean): Boolean;
  // --------------------------------------------------------------------------
  TGet_Repert_Info = function(const _Repert: Integer;
    _bmp_CinemaLogo, _bmp_OdeumLogo: TBitmap;
    var _str_Zal_Nam, _str_Zal_Prefix: string; var _dtFilm_Date: TDateTime;
    var _strFilm_Name, _strSeans_Time: string): Boolean;
  // --------------------------------------------------------------------------

// --------------------------------------------------------------------------
// ������������� ������ ����������
// --------------------------------------------------------------------------
function Init_Global_Print(CinemaLogoBmp, OdeumLogoBmp: TBitmap;
  OdeumName: string): Integer; //ready partially
// --------------------------------------------------------------------------
// ������������� ������
// --------------------------------------------------------------------------
function Init_TC_Print(bmp_CinemaLogo, bmp_OdeumLogo: TBitmap;
  str_Zal_Nam: string; dtFilm_Date: TDateTime; strFilm_Name,
  strSeans_Time: string): Integer; //ready
// --------------------------------------------------------------------------
// ���������� � ����� ������
// --------------------------------------------------------------------------
function Add_TC_Print(Print_Type: byte;
  _TicketType: Integer; proc_Get_Ticket_Type_Info: TGet_Ticket_Type_Info;
  _Repert: Integer; proc_Get_Repert_Info: TGet_Repert_Info;
  _Row_Num, _Column_Num, _Sum: Integer; s_Group_Num, s_Serial_Num: string;
  Add_Elem: boolean): Integer; //ready partially
// --------------------------------------------------------------------------
// ������ ������ �������������� �������
// --------------------------------------------------------------------------
function Final_TC_Print(TC_Print_Count: Integer; str_Zal_Nam: string): Integer; //ready
// --------------------------------------------------------------------------
// ������ ������ ������ �������������� �������
// --------------------------------------------------------------------------
function Cancel_TC_Print: Integer; //ready
// --------------------------------------------------------------------------
function Test_TC_Print_Bmp(TestText1, TestText2: string;
  TestBmp1, TestBmp2: TBitmap): Integer; //ready
// --------------------------------------------------------------------------

const
  Emblema_Loaded: Boolean = false;
  PrintJob_StartNew: Boolean = true;
  Print_Serial_Num: Boolean = false;

implementation

{$IFDEF Debug_Level_6}
{$DEFINE uhPrint_DEBUG}
{$ENDIF}

{$IFDEF NO_DEBUG}
{$UNDEF uhPrint_DEBUG}
{$ENDIF}

uses
  Bugger,
  uTools,
  StrConsts,
  uhImport,
  SysUtils,
  Classes,
  DCPbase64;

const
  UnitName: string = 'uhPrint';
  // -----------------------------------------------------------------------------
  // Global GFX
  // -----------------------------------------------------------------------------
  PrintJob_NewCache: Boolean = true;
  BufGfxCache: TStrings = nil;
  // -----------------------------------------------------------------------------
  gfx_CinemaLogo: integer = 0;
  gfx_OdeumLogo: integer = 0;
  // gfx_OdeumName: integer = 0;
  gfx_Ryad: integer = 0;
  gfx_Mesto: integer = 0;
  gfx_Cena: integer = 0;
  gfx_Summa: integer = 0;
  gfx_Tenge: integer = 0;
  gfx_Halyava: integer = 0;
  // gfx_Studpens: integer = 0;
  // gfx_Detski: integer = 0;
  // gfx_Priglas: integer = 0;
  // gfx_Vip: integer = 0;
  gfx_Kolvomest: integer = 0;
  // -----------------------------------------------------------------------------
  // Local GFX
  // -----------------------------------------------------------------------------
  gfx1_Filmname: integer = 0;
  gfx1_Datavremya: integer = 0;
  // -----------------------------------------------------------------------------
  Cinema1Logo_iX: Integer = 0;
  Cinema1Logo_iY: Integer = 0;
  Odeum2Logo_iX: Integer = 0;
  Odeum2Logo_iY: Integer = 0;
  // -----------------------------------------------------------------------------

// --------------------------------------------------------------------------
// ������������� ������ ����������
// --------------------------------------------------------------------------

function Init_Global_Print(CinemaLogoBmp, OdeumLogoBmp: TBitmap;
  OdeumName: string): Integer; //ready partially
const
  ProcName: string = 'Init_Global_Print';
  str_Ryad: string = '���';
  str_Mesto: string = '�����';
  str_Cena: string = '����';
  str_Summa: string = '�����';
  str_Tenge: string = '�����';
  str_Halyava: string = '���������� �����';
  str_Studpens: string = '�������./�������.';
  str_Detski: string = '������� �����';
  str_Priglas: string = '���������������';
  str_Vip: string = 'VIP ��������';
  str_Kolvomest: string = '���-�� ����';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  buffer: string;
  Stream: TStringStream;
  Cinema1Logo_iW, Cinema1Logo_iH, Odeum2Logo_iW, Odeum2Logo_iH: Integer;
  // Cinema1Logo_mW, Cinema1Logo_mH, Odeum2Logo_mW, Odeum2Logo_mH: Integer;
  Logo_Xmax, Logo_Ymax, Logo_Wmax, Logo_Hmax, Logo_1_2_HDelta: Integer;
begin
  // --------------------------------------------------------------------------
  // ������������� ������
  // --------------------------------------------------------------------------
  Time_Start := Now;
  {!$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  {!$ENDIF}
  Result := ClearPrinterBuffer;
  if Result >= 0 then
  begin
    Result := 0;
    // FlushGfxCache;
    // --------------------------------------------------------------------------
    // �������� ���������
    // --------------------------------------------------------------------------
    // Logo_Xmax := 70;
    Logo_Xmax := 50;
    Logo_Ymax := 220;
    Logo_Wmax := 160;
    Logo_Hmax := 74;
    Logo_1_2_HDelta := 4;
    // --------------------------------------------------------------------------
    Cinema1Logo_iX := 0;
    Cinema1Logo_iY := 0;
    Odeum2Logo_iX := 0;
    Odeum2Logo_iY := 0;
    // Cinema1Logo_iW := 0;
    Cinema1Logo_iH := 0;
    // Odeum2Logo_iW := 0;
    Odeum2Logo_iH := 0;
    // --------------------------------------------------------------------------
    gfx_CinemaLogo := 0;
    if Assigned(CinemaLogoBmp) then
    begin
      // --------------------------------------------------------------------------
      // �������� �������� ����������
      // --------------------------------------------------------------------------
      Stream := TStringStream.Create('');
      try
        CinemaLogoBmp.SaveToStream(Stream);
        buffer := '@2,';
        buffer := buffer + Base64EncodeStr(Stream.DataString);
{$IFDEF uhPrint_DEBUG}
        DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
        gfx_CinemaLogo := LoadBitmapFromBase64Str(PChar(buffer), 0, 1);
        if gfx_CinemaLogo > 0 then
          with CinemaLogoBmp do
          begin
            Cinema1Logo_iW := DotsToInches(Width);
            Cinema1Logo_iH := DotsToInches(Height);
            // Cinema1Logo_mW := DotsToMms(Width);
            // Cinema1Logo_mW := DotsToMms(Height);
            Cinema1Logo_iX := Logo_Xmax + (Logo_Wmax - Cinema1Logo_iW) div 2;
            Result := Result + 1;
          end;
      finally
        Stream.Free;
      end;
    end
    else
    begin
      // passed
      Result := Result + 1;
    end;
{$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'gfx_CinemaLogo = [' + IntToStr(gfx_CinemaLogo) + ']');
{$ENDIF}
    gfx_OdeumLogo := 0;
    if Assigned(OdeumLogoBmp) then
    begin
      // --------------------------------------------------------------------------
      // �������� �������� ��������
      // --------------------------------------------------------------------------
      Stream := TStringStream.Create('');
      try
        OdeumLogoBmp.SaveToStream(Stream);
        buffer := '@2,';
        buffer := buffer + Base64EncodeStr(Stream.DataString);
{$IFDEF uhPrint_DEBUG}
        DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
        gfx_OdeumLogo := LoadBitmapFromBase64Str(PChar(buffer), 0, 1);
        if gfx_OdeumLogo > 0 then
          with OdeumLogoBmp do
          begin
            Odeum2Logo_iW := DotsToInches(Width);
            Odeum2Logo_iH := DotsToInches(Height);
            // Odeum2Logo_mW := DotsToMms(Width);
            // Odeum2Logo_mW := DotsToMms(Height);
            Odeum2Logo_iX := Logo_Xmax + (Logo_Wmax - Odeum2Logo_iW) div 2;
            Result := Result + 1;
          end;
      finally
        Stream.Free;
      end;
    end
    else
    begin
      // passed
      Result := Result + 1;
    end;
{$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'gfx_OdeumLogo = [' + IntToStr(gfx_OdeumLogo) + ']');
{$ENDIF}
    if (gfx_OdeumLogo <= 0) and (gfx_CinemaLogo <= 0) then
    begin
      // --------------------------------------------------------------------------
      // �������� �������� ����
      // --------------------------------------------------------------------------
      buffer := '@2,050,050' + c_CRLF + '#Courier New,1000,20,204' + c_CRLF;
      // buffer := buffer + '^0090,0000;' + '������� ���';
      buffer := buffer + '^0190,0030;' + OdeumName;
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
      gfx_OdeumLogo := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'gfx_OdeumLogo = [' + IntToStr(gfx_OdeumLogo) + ']');
{$ENDIF}
      Odeum2Logo_iW := 190;
      Odeum2Logo_iH := 30;
      Odeum2Logo_iX := Logo_Xmax + (Logo_Wmax - Odeum2Logo_iW) div 2;
    end;
    //#########################################################################################
    if (gfx_CinemaLogo > 0) and (gfx_OdeumLogo > 0) then
    begin
      // Odeum2Logo_iX := Logo_Xmax + (Logo_Wmax - Odeum2Logo_iW) div 2;
      Odeum2Logo_iY := Logo_Ymax + (Logo_Hmax - Odeum2Logo_iH - Cinema1Logo_iH -
        Logo_1_2_HDelta) div 2;
      // Cinema1Logo_iX := Logo_Xmax + (Logo_Wmax - Cinema1Logo_iW) div 2;
      Cinema1Logo_iY := Odeum2Logo_iY + Odeum2Logo_iH + Logo_1_2_HDelta;
      //*****************************************************************************************
      // PlaceBitmap(1, 1, Cinema1Logo_iX, Cinema1Logo_iY, gfx_CinemaLogo);
      //*****************************************************************************************
      // PlaceBitmap(1, 1, Odeum2Logo_iX, Odeum2Logo_iY, gfx_OdeumLogo);
    end
    else if (gfx_CinemaLogo > 0) then
    begin
      // Cinema1Logo_iX := Logo_Xmax + (Logo_Wmax - Cinema1Logo_iW) div 2;
      Cinema1Logo_iY := Logo_Ymax + (Logo_Hmax - Cinema1Logo_iH) div 2;
      //*****************************************************************************************
      // PlaceBitmap(1, 1, Cinema1Logo_iX, Cinema1Logo_iY, gfx_CinemaLogo);
    end
    else if (gfx_OdeumLogo > 0) then
    begin
      // Odeum2Logo_iX := Logo_Xmax + (Logo_Wmax - Odeum2Logo_iW) div 2;
      Odeum2Logo_iY := Logo_Ymax + (Logo_Hmax - Odeum2Logo_iH) div 2;
      //*****************************************************************************************
      // PlaceBitmap(1, 1, Odeum2Logo_iX, Odeum2Logo_iY, gfx_OdeumLogo);
    end;
    //#########################################################################################
    if True then
    begin
      // --------------------------------------------------------------------------
      // �������� ����� "���"
      // --------------------------------------------------------------------------
      buffer := '@2,000,050' + c_CRLF;
      buffer := buffer + '#Arial,0000,16,204' + c_CRLF;
      buffer := buffer + '^0029,0000;' + str_Ryad;
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
      gfx_Ryad := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'gfx_Ryad = [' + IntToStr(gfx_Ryad) + ']');
{$ENDIF}
      // --------------------------------------------------------------------------
      // ��������
      // --------------------------------------------------------------------------
      buffer := '@2,000,050' + c_CRLF;
      buffer := buffer + '#Arial,0000,16,204' + c_CRLF;
      buffer := buffer + '^0040,0000;' + str_Mesto;
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
      gfx_Mesto := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'gfx_Mesto = [' + IntToStr(gfx_Mesto) + ']');
{$ENDIF}
      // --------------------------------------------------------------------------
      // ��������
      // --------------------------------------------------------------------------
      buffer := '@2,000,050' + c_CRLF;
      buffer := buffer + '#Arial,0000,16,204' + c_CRLF;
      buffer := buffer + '^0032,0000;' + str_Cena;
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
      gfx_Cena := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'gfx_Cena = [' + IntToStr(gfx_Cena) + ']');
{$ENDIF}
      // --------------------------------------------------------------------------
      // ��������
      // --------------------------------------------------------------------------
      buffer := '@2,000,050' + c_CRLF;
      buffer := buffer + '#Arial,0000,16,204' + c_CRLF;
      buffer := buffer + '^0032,0000;' + str_Summa;
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
      gfx_Summa := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'gfx_Summa = [' + IntToStr(gfx_Summa) + ']');
{$ENDIF}
      // --------------------------------------------------------------------------
      // ��������
      // --------------------------------------------------------------------------
      buffer := '@2,000,050' + c_CRLF;
      buffer := buffer + '#Arial,0000,16,204' + c_CRLF;
      buffer := buffer + '^0028,0000;' + str_Tenge;
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
      gfx_Tenge := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'gfx_Tenge = [' + IntToStr(gfx_Tenge) + ']');
{$ENDIF}
      // --------------------------------------------------------------------------
      // ��������
      // --------------------------------------------------------------------------
      buffer := '@2,000,050' + c_CRLF;
      buffer := buffer + '#Arial,0000,18,204' + c_CRLF;
      buffer := buffer + '^0105,0000;' + str_Halyava;
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
      gfx_Halyava := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'gfx_Halyava = [' + IntToStr(gfx_Halyava) + ']');
{$ENDIF}
      (*
      // --------------------------------------------------------------------------
      // ��������
      // --------------------------------------------------------------------------
      buffer := '@2,000,050' + c_CRLF;
      buffer := buffer + '#Arial,0000,18,204' + c_CRLF;
      buffer := buffer + '^0105,0000;' + str_Studpens;
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
      gfx_Studpens := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'gfx_Studpens = [' + IntToStr(gfx_Studpens) + ']');
{$ENDIF}
      *)
      (*
      // --------------------------------------------------------------------------
      // ��������
      // --------------------------------------------------------------------------
      buffer := '@2,000,050' + c_CRLF;
      buffer := buffer + '#Arial,0000,18,204' + c_CRLF;
      buffer := buffer + '^0105,0000;' + str_Detski;
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
      gfx_Detski := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'gfx_Detski = [' + IntToStr(gfx_Detski) + ']');
{$ENDIF}
      *)
      (*
      // --------------------------------------------------------------------------
      // ��������
      // --------------------------------------------------------------------------
      buffer := '@2,000,050' + c_CRLF;
      buffer := buffer + '#Arial,0000,18,204' + c_CRLF;
      buffer := buffer + '^0105,0000;' + str_Priglas;
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
      gfx_Priglas := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'gfx_Priglas = [' + IntToStr(gfx_Priglas) + ']');
{$ENDIF}
      *)
      (*
      // --------------------------------------------------------------------------
      // ��������
      // --------------------------------------------------------------------------
      buffer := '@2,000,050' + c_CRLF;
      buffer := buffer + '#Arial,0000,18,204' + c_CRLF;
      buffer := buffer + '^0105,0000;' + str_Vip;
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
      gfx_Vip := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'gfx_Vip = [' + IntToStr(gfx_Vip) + ']');
{$ENDIF}
      *)
      // --------------------------------------------------------------------------
      // ��������
      // --------------------------------------------------------------------------
      buffer := '@2,000,050' + c_CRLF;
      buffer := buffer + '#Arial,0000,16,204' + c_CRLF;
      buffer := buffer + '^0092,0000;' + str_Kolvomest;
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
      gfx_Kolvomest := PrepareBitmapFromText(PChar(buffer), 0, 1);
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'gfx_Kolvomest = [' + IntToStr(gfx_Kolvomest) + ']');
{$ENDIF}
      Result := Result + 1;
    end;
    {!$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(-1, UnitName, ProcName, '<-');
    {!$ENDIF}
    // --------------------------------------------------------------------------
    // calculating work time
    // --------------------------------------------------------------------------
    Time_End := Now;
    DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
    {!$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0')
      + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
    {!$ENDIF}
  end;
end;

// --------------------------------------------------------------------------
// ������������� ������
// --------------------------------------------------------------------------

function Init_TC_Print(bmp_CinemaLogo, bmp_OdeumLogo: TBitmap;
  str_Zal_Nam: string; dtFilm_Date: TDateTime; strFilm_Name,
  strSeans_Time: string): Integer; //ready
const
  ProcName: string = 'Init_TC_Print';
  strVremya: string = '�����';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  buffer: string;
begin
  // --------------------------------------------------------------------------
  // ������������� ������
  // --------------------------------------------------------------------------
  Time_Start := Now;
  {!$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  {!$ENDIF}
  Result := -1;
  if PrintJob_StartNew or (not Emblema_Loaded) then
  begin
    if (not Emblema_Loaded) then
    begin
      // --------------------------------------------------------------------------
      // ��������
      // --------------------------------------------------------------------------
      FlushGfxCache;
      Init_Global_Print(bmp_CinemaLogo, bmp_OdeumLogo, str_Zal_Nam);
      InitializePrinterJob;
      PrintBuffer('', PChar('Kinode - Preload images for (' + str_Zal_Nam + ').'));
      Emblema_Loaded := true;
      Result := Result + 1;
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'Hurra1 - gfx_CinemaLogo = ('
        + IntToStr(gfx_CinemaLogo) + '), gfx_OdeumLogo = ('
        + IntToStr(gfx_OdeumLogo) + ')');
{$ENDIF}
    end
    else
    begin
      // passed
      Result := Result + 1;
    end;
    // --------------------------------------------------------------------------
    // ��������
    // --------------------------------------------------------------------------
    buffer := '@2,025,050' + c_CRLF + '#Times New Roman,1000,25,204' + c_CRLF;
    // buffer := buffer + '^0266,0000;' + strFilm_Name;
    buffer := buffer + '^0246,0000;' + strFilm_Name;
{$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
    gfx1_Filmname := PrepareBitmapFromText(PChar(buffer), 0, 0);
{$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'gfx1_Filmname = [' + IntToStr(gfx1_Filmname) + ']');
{$ENDIF}
    // --------------------------------------------------------------------------
    // ��������
    // --------------------------------------------------------------------------
    buffer := '@2,000,050' + c_CRLF;
    buffer := buffer + '#Arial,0000,19,204' + c_CRLF;
    buffer := buffer + '^0120,0000;' + FormatDateTime('d mmmm yyyy', dtFilm_Date) + c_CRLF;
    buffer := buffer + '#Arial,0000,18,204' + c_CRLF;
    buffer := buffer + '^0049,0000;' + '  ' + strVremya + '  ' + c_CRLF;
    buffer := buffer + '#Arial,1000,19,204' + c_CRLF;
    // buffer := buffer + '^0100,0000;' + strSeans_Time;
    buffer := buffer + '^0060,0000;' + strSeans_Time;
{$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
    gfx1_Datavremya := PrepareBitmapFromText(PChar(buffer), 0, 0);
{$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'gfx1_Datavremya = [' + IntToStr(gfx1_Datavremya) + ']');
{$ENDIF}
    InitializePrinterJob;
    PrintJob_StartNew := False;
    PrintJob_NewCache := True;
    Result := Result + 1;
  end
  else
  begin
    // passed
    Result := Result + 1;
  end;
  {!$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  {!$ENDIF}
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  {!$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(0, UnitName, ProcName, 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0')
    + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
  {!$ENDIF}
end;

// --------------------------------------------------------------------------
// ����������� ��� ������ ������
// --------------------------------------------------------------------------
 {
const
  BufGfxCache: TStrings = nil;
 }

function CacheBitmapFromText(const strFmtTextLine: string; GfxId,
  Permanent: Integer): Integer;
const
  ProcName: string = 'CacheBitmapFromText';
var
  strFmtTextBase64, strGfx: string;
  b_FoundInCache: Boolean;
  iGfx: Integer;
begin
  {!$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  {!$ENDIF}
  // --------------------------------------------------------------------------
  if (Length(strFmtTextLine) = 0) then
  begin
    Result := 0;
  end
  else
  begin
    iGfx := -1;
    b_FoundInCache := False;
    strFmtTextBase64 := Base64EncodeStr(strFmtTextLine);
    // --------------------------------------------------------------------------
    if not Assigned(BufGfxCache) then
    begin
      {!$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'Creating new GfxCache...');
      {!$ENDIF}
      BufGfxCache := TStringList.Create;
    end; // if
    // --------------------------------------------------------------------------
    if Assigned(BufGfxCache) then
    try
      {!$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'GfxCache Count = ' + IntToStr(BufGfxCache.Count));
      {!$ENDIF}
      if PrintJob_NewCache then
      begin
        {!$IFDEF uhPrint_DEBUG}
        DEBUGMessEnh(0, UnitName, ProcName, 'Clearing GfxCache...');
        {!$ENDIF}
        BufGfxCache.Clear;
        PrintJob_NewCache := False;
      end;
      if (BufGfxCache.Count > 0) then
      begin
        strGfx := BufGfxCache.Values[strFmtTextBase64];
        if (Length(strGfx) > 0) then
        try
          iGfx := StrToInt(strGfx);
          b_FoundInCache := True;
        except
          // string to integer conversion error
        end;
      end;
    except
      {!$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'Current GfxCache is bad (1)...');
      {!$ENDIF}
    end; // try
    // --------------------------------------------------------------------------
    if b_FoundInCache and (iGfx > 0) then
    begin
      Result := iGfx;
      {!$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'Found in GfxCache, GfxId = ' + IntToStr(Result));
      {!$ENDIF}
    end
    else
    begin
      // --------------------------------------------------------------------------
      {!$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'Not found in GfxCache...');
      {!$ENDIF}
      Result := PrepareBitmapFromText(PChar(strFmtTextLine), 0, 0);
      // --------------------------------------------------------------------------
      if Assigned(BufGfxCache) and (Length(strFmtTextBase64) > 0)
        and (Result > 0) then
      try
        BufGfxCache.Add(strFmtTextBase64 + '=' + IntToStr(Result));
        {!$IFDEF uhPrint_DEBUG}
        DEBUGMessEnh(0, UnitName, ProcName, 'Added to GfxCache, GfxId = ' + IntToStr(Result));
        {!$ENDIF}
      except
        {!$IFDEF uhPrint_DEBUG}
        DEBUGMessEnh(0, UnitName, ProcName, 'Current GfxCache is bad (2)...');
        {!$ENDIF}
      end // try
      else
      begin
        {!$IFDEF uhPrint_DEBUG}
        DEBUGMessEnh(0, UnitName, ProcName, 'Not added, too bad, GfxId = ' + IntToStr(Result));
        {!$ENDIF}
      end;
      // --------------------------------------------------------------------------
    end; // if b_FoundInCache then
  end;
  // --------------------------------------------------------------------------
  {!$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  {!$ENDIF}
end;

// --------------------------------------------------------------------------
// ���������� � ����� ������
// --------------------------------------------------------------------------

function Add_TC_Print(Print_Type: byte;
  _TicketType: Integer; proc_Get_Ticket_Type_Info: TGet_Ticket_Type_Info;
  _Repert: Integer; proc_Get_Repert_Info: TGet_Repert_Info;
  _Row_Num, _Column_Num, _Sum: Integer; s_Group_Num, s_Serial_Num: string;
  Add_Elem: boolean): Integer; //ready partially
const
  ProcName: string = 'Add_TC_Print';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  gfx2_Ryadnum, gfx2_Mestonum, gfx2_Cenamesta, gfx2_Primechanie, gfx2_Serial: Integer;
  s_NomerRyada, s_NomerMesta, str_Sum: string;
  buffer: string;
  // str_Zal_Nam, str_Film_Name, str_Seans_Desk: string;
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  b_Get_Ticket_Type_Info_Result, b_Get_Repert_Info: boolean;
  str_TICKET_LABEL, str_CLASS_NAM: string;
  b_CLASS_TO_PRINT, b_CLASS_FOR_FREE, b_CLASS_INVITED_GUEST, b_CLASS_GROUP_VISIT,
    b_CLASS_VIP_CARD, b_CLASS_VIP_BYNAME, b_CLASS_SEASON_TICKET, b_TICKET_SERIALIZE: Boolean;
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  bmp_CinemaLogo, bmp_OdeumLogo: TBitmap;
  str_Zal_Nam, str_Zal_Prefix: string;
  dtFilm_Date: TDateTime;
  strFilm_Name, strSeans_Time: string;
  Text_X, Text_Y: Integer;
  res: Integer;
begin
  // --------------------------------------------------------------------------
  // ���������� � ����� ������
  // --------------------------------------------------------------------------
  Time_Start := Now;
  {!$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  {!$ENDIF}
  {!$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(0, UnitName, ProcName, 'Add_Elem = ' + c_Boolean[Add_Elem]);
  {!$ENDIF}
  // --------------------------------------------------------------------------
  Result := -1;
  res := Result;
  if Assigned(proc_Get_Ticket_Type_Info)
    and Assigned(proc_Get_Repert_Info) then
  begin
    // gfx2_Ryadnum := 0;
    gfx2_Mestonum := 0;
    // gfx2_Cenamesta := 0;
    // gfx2_Primechanie := 0;
    // gfx2_Serial := 0;
    // --------------------------------------------------------------------------
    // ����� ���������� � ���� ������
    // --------------------------------------------------------------------------
    {
    CLASS_NAM            DOM_STRING_40
    CLASS_TO_PRINT       DOM_BOOLEAN_T
    CLASS_FOR_FREE       DOM_BOOLEAN_F
    CLASS_INVITED_GUEST  DOM_BOOLEAN_F
    CLASS_GROUP_VISIT    DOM_BOOLEAN_F
    CLASS_VIP_CARD       DOM_BOOLEAN_F
    CLASS_VIP_BYNAME     DOM_BOOLEAN_F
    CLASS_SEASON_TICKET  DOM_BOOLEAN_F
    }
    // --------------------------------------------------------------------------
    // b_Get_Ticket_Type_Info_Result := false;
    try
      b_Get_Ticket_Type_Info_Result :=
        proc_Get_Ticket_Type_Info(_TicketType, str_TICKET_LABEL, str_CLASS_NAM,
        b_CLASS_TO_PRINT, b_CLASS_FOR_FREE, b_CLASS_INVITED_GUEST, b_CLASS_GROUP_VISIT,
        b_CLASS_VIP_CARD, b_CLASS_VIP_BYNAME, b_CLASS_SEASON_TICKET, b_TICKET_SERIALIZE);
      Inc(res);
    except
      b_Get_Ticket_Type_Info_Result := false;
    end;
    // --------------------------------------------------------------------------
    if b_Get_Ticket_Type_Info_Result and b_CLASS_TO_PRINT then
    begin
      Inc(res);
      // bmp_CinemaLogo := nil;
      // bmp_OdeumLogo := nil;
      if PrintJob_StartNew then
      begin
        // --------------------------------------------------------------------------
        // b_Get_Repert_Info := false;
        bmp_CinemaLogo := TBitmap.Create;
        try
          bmp_OdeumLogo := TBitmap.Create;
          try
            b_Get_Repert_Info :=
              proc_Get_Repert_Info(_Repert, bmp_CinemaLogo, bmp_OdeumLogo,
              str_Zal_Nam, str_Zal_Prefix, dtFilm_Date, strFilm_Name, strSeans_Time);
            Init_TC_Print(bmp_CinemaLogo, bmp_OdeumLogo, str_Zal_Nam,
              dtFilm_Date, strFilm_Name, strSeans_Time);
            if b_Get_Repert_Info then
            begin
              PrintJob_StartNew := False;
              // PrintJob_NewCache := True;
            end;
            Inc(res);
          finally
            bmp_OdeumLogo.Free;
            // bmp_OdeumLogo := nil;
          end;
        finally
          bmp_CinemaLogo.Free;
          // bmp_CinemaLogo := nil;
        end;
      end
      else
      begin
        // Passed
        Inc(res);
      end;
      // --------------------------------------------------------------------------
      {
      proc_Get_Ticket_Type_Info(_TicketClass, str_CLASS_NAM,
        b_CLASS_TO_PRINT, b_CLASS_FOR_FREE, b_CLASS_INVITED_GUEST, b_CLASS_GROUP_VISIT,
        b_CLASS_VIP_CARD, b_CLASS_VIP_BYNAME, b_CLASS_SEASON_TICKET);
      }
      // --------------------------------------------------------------------------
      if Print_Type = 1 then
      begin
        // ���������
        buffer := '@2,000,050' + c_CRLF;
        buffer := buffer + '#Arial,1100,20,204' + c_CRLF;
        buffer := buffer + '^0181,0000;' + s_Group_Num + c_CRLF;
        // gfx2_Ryadnum := PrepareBitmapFromText(PChar(buffer), 0, 0);
        gfx2_Ryadnum := CacheBitmapFromText(buffer, 0, 0);
{$IFDEF uhPrint_DEBUG}
        DEBUGMessEnh(0, UnitName, ProcName, 'gfx2_Ryadnum = [' + IntToStr(gfx2_Ryadnum) + ']');
{$ENDIF}
        str_Sum := IntToStr(_Sum);
        buffer := '@2,000,050' + c_CRLF;
        buffer := buffer + '#Arial,0000,18,204' + c_CRLF;
        buffer := buffer + '^0030,0000;' + str_Sum;
        // gfx2_Primechanie := PrepareBitmapFromText(PChar(buffer), 0, 0);
        gfx2_Primechanie := CacheBitmapFromText(buffer, 0, 0);
{$IFDEF uhPrint_DEBUG}
        DEBUGMessEnh(0, UnitName, ProcName, 'gfx2_Primechanie = [' +
          IntToStr(gfx2_Primechanie) + ']');
{$ENDIF}
      end
      else
      begin
        // �������
        s_NomerRyada := IntToStr(_Row_Num);
        buffer := '@2,000,050' + c_CRLF;
        buffer := buffer + '#Arial,1100,20,204' + c_CRLF;
        buffer := buffer + '^0039,0000;' + s_NomerRyada + c_CRLF;
        // gfx2_Ryadnum := PrepareBitmapFromText(PChar(buffer), 0, 0);
        gfx2_Ryadnum := CacheBitmapFromText(buffer, 0, 0);
{$IFDEF uhPrint_DEBUG}
        DEBUGMessEnh(0, UnitName, ProcName, 'gfx2_Ryadnum = [' + IntToStr(gfx2_Ryadnum) + ']');
{$ENDIF}
        s_NomerMesta := IntToStr(_Column_Num);
        buffer := '@2,000,050' + c_CRLF;
        buffer := buffer + '#Arial,1100,20,204' + c_CRLF;
        buffer := buffer + '^0039,0000;' + s_NomerMesta;
        // gfx2_Mestonum := PrepareBitmapFromText(PChar(buffer), 0, 0);
        gfx2_Mestonum := CacheBitmapFromText(buffer, 0, 0);
{$IFDEF uhPrint_DEBUG}
        DEBUGMessEnh(0, UnitName, ProcName, 'gfx2_Mestonum = [' + IntToStr(gfx2_Mestonum) + ']');
{$ENDIF}
        if Length(str_TICKET_LABEL) > 0 then
        begin
          buffer := '@2,000,050' + c_CRLF;
          buffer := buffer + '#Arial,0000,18,204' + c_CRLF;
          buffer := buffer + '^0105,0000;' + str_TICKET_LABEL;
          // gfx2_Primechanie := PrepareBitmapFromText(PChar(buffer), 0, 0);
          gfx2_Primechanie := CacheBitmapFromText(buffer, 0, 0);
        end
        else
          gfx2_Primechanie := 0;
{$IFDEF uhPrint_DEBUG}
        DEBUGMessEnh(0, UnitName, ProcName, 'gfx2_Primechanie = [' +
          IntToStr(gfx2_Primechanie) + ']');
{$ENDIF}
      end;
      if b_CLASS_FOR_FREE then
      begin
        // ����������
        gfx2_Cenamesta := gfx_Halyava;
      end
      else
      begin
        // �������
        str_Sum := IntToStr(_Sum);
        buffer := '@2,000,050' + c_CRLF;
        buffer := buffer + '#Arial,1000,19,204' + c_CRLF;
        buffer := buffer + '^0032,0000;' + str_Sum;
        // gfx2_Cenamesta := PrepareBitmapFromText(PChar(buffer), 0, 0);
        gfx2_Cenamesta := CacheBitmapFromText(buffer, 0, 0);
{$IFDEF uhPrint_DEBUG}
        DEBUGMessEnh(0, UnitName, ProcName, 'gfx2_Cenamesta = [' + IntToStr(gfx2_Cenamesta) + ']');
{$ENDIF}
      end;
      //*****************************************************************************************
      if Add_Elem and Print_Serial_Num and b_TICKET_SERIALIZE then
      begin
        buffer := '@2,000,050' + c_CRLF;
        buffer := buffer + '#Arial,1000,20,204' + c_CRLF;
        // ----------------
        // Length(WWWWWWW) is 7, width is 175 dots ~ 0,86 inches ~ 21,90 mm.
        // buffer := buffer + '^0094,0000;' + 'WWWWWWW';
        // ----------------
        // Length(WW00000) is 7, width is 125 dots ~ 0,62 inches ~ 15,60 mm.
        // buffer := buffer + '^0068,0000;' + 'WW' + '00000';
        // ----------------
        // Length(AL00001) is 7, width is 111 dots ~ 0,55 inches ~ 13,90 mm.
        // buffer := buffer + '^0068,0000;' + str_Zal_Prefix + FixFmt(_Serial_Num, 5, '0');
        buffer := buffer + '^0068,0000;' + str_Zal_Prefix + s_Serial_Num;
        // ----------------
        gfx2_Serial := PrepareBitmapFromText(PChar(buffer), 0, 0);
      end
      else
        gfx2_Serial := 0;
{$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'gfx2_Serial = [' + IntToStr(gfx2_Serial) + ']');
{$ENDIF}
      //#########################################################################################
      if BeginLabelCmd >= 0 then
        Inc(res);
      // --------------------------------------------------------------------------
      if (gfx_CinemaLogo > 0) and (gfx_OdeumLogo > 0) then
      begin
        {
        Odeum2Logo_iY := Logo_Ymax + (Logo_Hmax - Odeum2Logo_iH - Cinema1Logo_iH
          - Logo_1_2_HDelta) div 2;
        Cinema1Logo_iY := Odeum2Logo_iY + Odeum2Logo_iH + Logo_1_2_HDelta;
        }
        //*****************************************************************************************
        PlaceBitmap(1, 1, Cinema1Logo_iX, Cinema1Logo_iY, gfx_CinemaLogo);
        //*****************************************************************************************
        PlaceBitmap(1, 1, Odeum2Logo_iX, Odeum2Logo_iY, gfx_OdeumLogo);
      end
      else if (gfx_CinemaLogo > 0) then
      begin
        {
        Cinema1Logo_iY := Logo_Ymax + (Logo_Hmax - Cinema1Logo_iH) div 2;
        }
        //*****************************************************************************************
        PlaceBitmap(1, 1, Cinema1Logo_iX, Cinema1Logo_iY, gfx_CinemaLogo);
      end
      else if (gfx_OdeumLogo > 0) then
      begin
        {
        Odeum2Logo_iY := Logo_Ymax + (Logo_Hmax - Odeum2Logo_iH) div 2;
        }
        //*****************************************************************************************
        PlaceBitmap(1, 1, Odeum2Logo_iX, Odeum2Logo_iY, gfx_OdeumLogo);
      end;
      //*****************************************************************************************
      Text_X := 10;
      Text_Y := 215;
      //*****************************************************************************************
      // PlaceBitmap(1, 1, Text_X, Text_Y, gfx_Test);
      //*****************************************************************************************
      // �������� ������
      // --------------------------------------------------------------------------
      // PlaceBitmap(1, 1, 21, 215, gfx1_Filmname); // 95, 105
      PlaceBitmap(1, 1, Text_X + 11, Text_Y, gfx1_Filmname);
      //*****************************************************************************************
      // ���� � �����
      // --------------------------------------------------------------------------
      // PlaceBitmap(1, 1, 15, 188, gfx1_Datavremya); // 110, 80
      // PlaceBitmap(1, 1, Text_X + 5, Text_Y - 27, gfx1_Datavremya);
      PlaceBitmap(1, 1, Text_X + 25, Text_Y - 27, gfx1_Datavremya);
      //*****************************************************************************************
      // ������� "���"
      // --------------------------------------------------------------------------
      // PlaceBitmap(1, 1, 228, 167, gfx_Ryad); // 340, 60
      PlaceBitmap(1, 1, Text_X + 218, Text_Y - 48, gfx_Ryad);
      //*****************************************************************************************
      if Print_Type = 1 then
      begin
        //*****************************************************************************************
        // ���������
        // --------------------------------------------------------------------------
        // ����� ����
        // --------------------------------------------------------------------------
        // PlaceBitmap(1, 1, 30, 167, gfx2_Ryadnum); // 150, 60
        PlaceBitmap(1, 1, Text_X + 20, Text_Y - 48, gfx2_Ryadnum);
      end
      else
      begin
        //*****************************************************************************************
        // �������
        // --------------------------------------------------------------------------
        // ����� ����
        // --------------------------------------------------------------------------
        // PlaceBitmap(1, 1, 189, 167, gfx2_Ryadnum); // 300, 60
        PlaceBitmap(1, 1, Text_X + 179, Text_Y - 48, gfx2_Ryadnum);
        //*****************************************************************************************
        // ������� "�����"
        // --------------------------------------------------------------------------
        // PlaceBitmap(1, 1, 149, 167, gfx_Mesto); // 230, 60
        PlaceBitmap(1, 1, Text_X + 139, Text_Y - 48, gfx_Mesto);
        //*****************************************************************************************
        // ����� �����
        // --------------------------------------------------------------------------
        // PlaceBitmap(1, 1, 110, 167, gfx2_Mestonum); // 190, 60
        PlaceBitmap(1, 1, Text_X + 100, Text_Y - 48, gfx2_Mestonum);
      end;
      //*****************************************************************************************
      if b_CLASS_FOR_FREE then
      begin
        //*****************************************************************************************
        // ����������
        // --------------------------------------------------------------------------
        // PlaceBitmap(1, 1, 152, 146, gfx_Halyava); // 225, 45
        PlaceBitmap(1, 1, Text_X + 142, Text_Y - 69, gfx_Halyava);
      end
      else
      begin
        //*****************************************************************************************
        // �������
        // --------------------------------------------------------------------------
        if Print_Type = 1 then
        begin
          //*****************************************************************************************
          // PlaceBitmap(1, 1, 225, 146, gfx_Summa); // 320, 45
          PlaceBitmap(1, 1, Text_X + 215, Text_Y - 69, gfx_Summa);
        end
        else
        begin
          //*****************************************************************************************
          // PlaceBitmap(1, 1, 225, 146, gfx_Cena); // 320, 45
          PlaceBitmap(1, 1, Text_X + 215, Text_Y - 69, gfx_Cena);
        end;
        //*****************************************************************************************
        // PlaceBitmap(1, 1, 193, 146, gfx2_Cenamesta); // 250, 45
        PlaceBitmap(1, 1, Text_X + 183, Text_Y - 69, gfx2_Cenamesta);
        //*****************************************************************************************
        // PlaceBitmap(1, 1, 165, 146, gfx_Tenge); // 190, 45
        PlaceBitmap(1, 1, Text_X + 155, Text_Y - 69, gfx_Tenge);
      end;
      //*****************************************************************************************
      if Print_Type = 1 then
      begin
        //*****************************************************************************************
        // PlaceBitmap(1, 1, 170, 131, gfx_Kolvomest); // 290, 30
        PlaceBitmap(1, 1, Text_X + 160, Text_Y - 84, gfx_Kolvomest);
        //*****************************************************************************************
        // PlaceBitmap(1, 1, 132, 131, gfx_Kolvomest); // 290, 30
        PlaceBitmap(1, 1, Text_X + 122, Text_Y - 84, gfx2_Primechanie);
      end
      else
      begin
        //*****************************************************************************************
        // PlaceBitmap(1, 1, 152, 131, gfx2_Primechanie); // 225, 30
        PlaceBitmap(1, 1, Text_X + 142, Text_Y - 84, gfx2_Primechanie);
      end;
      //*****************************************************************************************
      if Add_Elem and Print_Serial_Num and b_TICKET_SERIALIZE then
      begin
        //*****************************************************************************************
        // PlaceBitmap(1, 1, 149, 109, gfx2_Serial); // 225, 30
        PlaceBitmap(1, 1, Text_X + 139, Text_Y - 106, gfx2_Serial);
        //*****************************************************************************************
        // PlaceBitmap(1, 1, 149, 73, gfx2_Serial); // 225, 30
        PlaceBitmap(1, 1, Text_X + 139, Text_Y - 142, gfx2_Serial);
      end;
      //*****************************************************************************************
      if EndLabelCmd >= 0 then
        Inc(res);
      //#########################################################################################
      // Inc(Printed_Ticket_Count);
      Result := res;
    end
    else
    begin
      Result := res;
      {!$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'Error: Procs calling failed.');
      {!$ENDIF}
    end; // if proc_Call_ok
  end
  else
  begin
    Result := -2;
    {!$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'Error: Procs not assigned.');
    {!$ENDIF}
  end; // if Assigned
  {!$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  {!$ENDIF}
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  {!$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(0, UnitName, ProcName, 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0')
    + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
  {!$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Final_TC_Print
  Author:    n0mad
  Date:      24-���-2002
  Arguments: TC_Print_Count: integer
  Result:    Integer
-----------------------------------------------------------------------------}

function Final_TC_Print(TC_Print_Count: Integer; str_Zal_Nam: string): Integer; //ready
const
  ProcName: string = 'Final_TC_Print';
var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  s: string;
begin
  Time_Start := Now;
{$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  Result := FinalizePrinterJob;
  if Result > -1 then
  begin
    s := 'Kinode - ' + IntToStr(TC_Print_Count) + ' tickets loaded for (' + str_Zal_Nam + ').';
    {!$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'Sent to printer. (' + s + ')');
    {!$ENDIF}
    Result := PrintBuffer('', PChar(s));
    (* Inc(Printed_Ticket_Count, TC_Print_Count); *)
    PrintJob_StartNew := True;
    PrintJob_NewCache := True;
  end;
{$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  {!$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(0, UnitName, ProcName, 'Work time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0')
    + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
  {!$ENDIF}
end;

{-----------------------------------------------------------------------------
  Procedure: Cancel_TC_Print
  Author:    n0mad
  Date:      18-���-2002
  Arguments: None
  Result:    Integer
-----------------------------------------------------------------------------}

function Cancel_TC_Print: Integer; // ready
const
  ProcName: string = 'Cancel_TC_Print';
begin
  {!$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  {!$ENDIF}
  Result := ClearPrinterBuffer;
  PrintJob_StartNew := True;
  PrintJob_NewCache := True;
  {!$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
  {!$ENDIF}
end;

function Test_TC_Print_Bmp(TestText1, TestText2: string;
  TestBmp1, TestBmp2: TBitmap): Integer; //ready
const
  ProcName: string = 'Test_TC_Print';
var
  s, buffer: string;
  gfx_Test_Text1, gfx_Test_Text2: Integer;
  gfx_Test_Bmp1, gfx_Test_Bmp2: Integer;
  Stream: TStringStream;
  Logo1_iW, Logo1_iH, Logo2_iW, Logo2_iH: Integer;
  // Logo1_mW, Logo1_mH, Logo2_mW, Logo2_mH: Integer;
  Logo1_iX, Logo1_iY, Logo2_iX, Logo2_iY: Integer;
  Logo_Xmax, Logo_Ymax, Logo_Wmax, Logo_Hmax, Logo_1_2_HDelta: Integer;
  Text_X, Text_Y: Integer;
begin
{$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  {
  Label1.Caption := format('Bmp1 dims - in dots (%u; %u) ~ inches (%f; %f) ~ mms (%f; %f).',
    [Bitmap.Width, Bitmap.Height,
    DotsToInches(Bitmap.Width) / 100, DotsToInches(Bitmap.Height) / 100,
      DotsToMms(Bitmap.Width) / 10, DotsToMms(Bitmap.Height) / 10]);
  }
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  Result := -1;
  // --------------------------------------------------------------------------
  // Logo1_iW := 0;
  Logo1_iH := 0;
  // Logo2_iW := 0;
  Logo2_iH := 0;
  // --------------------------------------------------------------------------
  // Logo1_mW := 0;
  // Logo1_mH := 0;
  // Logo2_mW := 0;
  // Logo2_mH := 0;
  // --------------------------------------------------------------------------
  Logo1_iX := 0;
  // Logo1_iY := 0;
  Logo2_iX := 0;
  // Logo2_iY := 0;
  // --------------------------------------------------------------------------
  if ClearPrinterBuffer >= 0 then
  begin
    // --------------------------------------------------------------------------
    // ��������
    // --------------------------------------------------------------------------
    buffer := '@2,000,050' + c_CRLF;
    buffer := '@2,025,050' + c_CRLF + '#Times New Roman,1000,25,204' + c_CRLF;
    buffer := buffer + '^0266,0000;' + TestText1; // Film_Name;
    // =============================================================================
    // buffer := '@2,000,050' + c_CRLF;
    // buffer := '@2,025,050' + c_CRLF + '#Times New Roman,1000,25,204' + c_CRLF;
    // buffer := buffer + '^0266,0000;' + '-=- test -=-'; // Film_Name; // 2.66 inches ~ 6,7564 mm
    // =============================================================================
{$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
    gfx_Test_Text1 := PrepareBitmapFromText(PChar(buffer), 0, 0);
{$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'gfx_Test_Text1 = [' + IntToStr(gfx_Test_Text1) + ']');
{$ENDIF}
    // --------------------------------------------------------------------------
    // ��������
    // --------------------------------------------------------------------------
    buffer := '@2,000,050' + c_CRLF;
    buffer := '@2,025,050' + c_CRLF + '#Times New Roman,1000,25,204' + c_CRLF;
    buffer := buffer + '^0256,0000;' + TestText2; // Film_Name;
    // =============================================================================
    // buffer := '@2,000,050' + c_CRLF;
    // buffer := '@2,025,050' + c_CRLF + '#Times New Roman,1000,25,204' + c_CRLF;
    // buffer := buffer + '^0266,0000;' + '-=- test -=-'; // Film_Name; // 2.66 inches ~ 6,7564 mm
    // =============================================================================
{$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
    gfx_Test_Text2 := PrepareBitmapFromText(PChar(buffer), 0, 0);
{$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'gfx_Test_Text2 = [' + IntToStr(gfx_Test_Text2) + ']');
{$ENDIF}
    // --------------------------------------------------------------------------
    Logo_Xmax := 70;
    Logo_Ymax := 220;
    Logo_Wmax := 160;
    Logo_Hmax := 74;
    Logo_1_2_HDelta := 4;
    // --------------------------------------------------------------------------
    gfx_Test_Bmp1 := 0;
    if Assigned(TestBmp1) then
    begin
      // --------------------------------------------------------------------------
      // ��������
      // --------------------------------------------------------------------------
      Stream := TStringStream.Create('');
      try
        TestBmp1.SaveToStream(Stream);
        buffer := '@2,';
        buffer := buffer + Base64EncodeStr(Stream.DataString);
{$IFDEF uhPrint_DEBUG}
        DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
        gfx_Test_Bmp1 := LoadBitmapFromBase64Str(PChar(buffer), 0, 0);
        if gfx_Test_Bmp1 > 0 then
          with TestBmp1 do
          begin
            Logo1_iW := DotsToInches(Width);
            Logo1_iH := DotsToInches(Height);
            // Logo1_mW := DotsToMms(Width);
            // Logo1_mW := DotsToMms(Height);
            Logo1_iX := Logo_Xmax + (Logo_Wmax - Logo1_iW) div 2;
          end;
      finally
        Stream.Free;
      end;
    end;
{$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'gfx_Test_Bmp1 = [' + IntToStr(gfx_Test_Bmp1) + ']');
{$ENDIF}
    gfx_Test_Bmp2 := 0;
    if Assigned(TestBmp2) then
    begin
      // --------------------------------------------------------------------------
      // ��������
      // --------------------------------------------------------------------------
      Stream := TStringStream.Create('');
      try
        TestBmp2.SaveToStream(Stream);
        buffer := '@2,';
        buffer := buffer + Base64EncodeStr(Stream.DataString);
{$IFDEF uhPrint_DEBUG}
        DEBUGMessEnh(0, UnitName, ProcName, 'buffer = [' + buffer + ']');
{$ENDIF}
        gfx_Test_Bmp2 := LoadBitmapFromBase64Str(PChar(buffer), 0, 0);
        if gfx_Test_Bmp2 > 0 then
          with TestBmp2 do
          begin
            Logo2_iW := DotsToInches(Width);
            Logo2_iH := DotsToInches(Height);
            // Logo2_mW := DotsToMms(Width);
            // Logo2_mW := DotsToMms(Height);
            Logo2_iX := Logo_Xmax + (Logo_Wmax - Logo2_iW) div 2;
          end;
      finally
        Stream.Free;
      end;
    end;
{$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'gfx_Test_Bmp2 = [' + IntToStr(gfx_Test_Bmp2) + ']');
{$ENDIF}
    //#########################################################################################
    Text_X := 10;
    Text_Y := 180;
    // --------------------------------------------------------------------------
    BeginLabelCmd;
    if (gfx_Test_Bmp1 > 0) and (gfx_Test_Bmp2 > 0) then
    begin
      Logo2_iY := Logo_Ymax + (Logo_Hmax - Logo2_iH - Logo1_iH - Logo_1_2_HDelta) div 2;
      Logo1_iY := Logo2_iY + Logo2_iH + Logo_1_2_HDelta;
      //*****************************************************************************************
      PlaceBitmap(1, 1, Logo1_iX, Logo1_iY, gfx_Test_Bmp1);
      //*****************************************************************************************
      PlaceBitmap(1, 1, Logo2_iX, Logo2_iY, gfx_Test_Bmp2);
    end
    else if (gfx_Test_Bmp1 > 0) then
    begin
      Logo1_iY := Logo_Ymax + (Logo_Hmax - Logo1_iH) div 2;
      //*****************************************************************************************
      PlaceBitmap(1, 1, Logo1_iX, Logo1_iY, gfx_Test_Bmp1);
    end
    else if (gfx_Test_Bmp2 > 0) then
    begin
      Logo2_iY := Logo_Ymax + (Logo_Hmax - Logo2_iH) div 2;
      //*****************************************************************************************
      PlaceBitmap(1, 1, Logo2_iX, Logo2_iY, gfx_Test_Bmp2);
    end;
    //*****************************************************************************************
    PlaceBitmap(1, 1, Text_X + 10, Text_Y + 20, gfx_Test_Text1);
    //*****************************************************************************************
    PlaceBitmap(1, 1, Text_X, Text_Y, gfx_Test_Text2);
    //*****************************************************************************************
    EndLabelCmd;
    //#########################################################################################
    if FinalizePrinterJob > -1 then
    begin
      s := 'Demokino - Test ticket II loaded.';
      {!$IFDEF uhPrint_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'Sent to printer. (' + s + ')');
      {!$ENDIF}
      Result := PrintBuffer('', PChar(s));
    end;
  end;
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
{$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure ModuleInit;
const
  ProcName: string = 'Init';
begin
{$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  if not Assigned(BufGfxCache) then
  begin
    {!$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'Creating GfxCache...');
    {!$ENDIF}
    BufGfxCache := TStringList.Create;
  end; // if
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
{$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure ModuleFinal;
const
  ProcName: string = 'Final';
begin
{$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  if Assigned(BufGfxCache) then
  begin
    {!$IFDEF uhPrint_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'Freeing GfxCache...');
    {!$ENDIF}
    BufGfxCache.Free;
  end; // if
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
{$IFDEF uhPrint_DEBUG}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

initialization
  ModuleInit;

finalization
  ModuleFinal;

end.
