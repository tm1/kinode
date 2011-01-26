{-----------------------------------------------------------------------------
 Unit Name: uhImport
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  12.10.2002
 Purpose:   Imports from external dll
 History:
-----------------------------------------------------------------------------}
unit uhImport;

{$I uhPrint.inc}

interface

uses
  Bugger,
  Windows,
  Sysutils;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
type
  TModuleHandle = Longword;
  TGetVersion = procedure(var MajorVersion, MinorVersion, Release,
    Build, Flags: Word); stdcall;
  TInitializePrinterJob = function: Integer; stdcall;
  TFinalizePrinterJob = function: Integer; stdcall;
  TPrepareBitmapFromText = function(const lpFmtTextLine: PChar;
    GfxId, Permanent: Integer): Integer; stdcall;
  TLoadBitmapFromFile = function(const lpFmtFilename: PChar;
    GfxId, Permanent: Integer): Integer; stdcall;
  TPlaceBitmap = function(HeightMplr, WidthMplr, Row, Column,
    GfxId: Integer): Integer; stdcall;
  TBeginLabelCmd = function: Integer; stdcall;
  TEndLabelCmd = function: Integer; stdcall;
  TPrintBuffer = function(const lpPrinterName, lpJobTitle: PChar): Integer; stdcall;
  TFlushGfxCache = function: Integer; stdcall;
  TMeasurementSystem = function(Mode: Integer): Integer; stdcall;
  TClearPrinterBuffer = function: Integer; stdcall;
  TLoadBitmapFromBase64Str = function(const lpFmtBase64Str: PChar;
    GfxId, Permanent: Integer): Integer; stdcall;
  {
    // ----------------------------------------------------------------------
    std_GetVersion index 1001 name 'dpl_GetVersion',
    std_InitializePrinterJob index 1002 name 'dpl_InitializePrinterJob',
    std_FinalizePrinterJob index 1003 name 'dpl_FinalizePrinterJob',
    std_PrepareBitmapFromText index 1004 name 'dpl_PrepareBitmapFromText',
    std_LoadBitmapFromFile index 1005 name 'dpl_LoadBitmapFromFile',
    std_PlaceBitmap index 1006 name 'dpl_PlaceBitmap',
    std_BeginLabelCmd index 1007 name 'dpl_BeginLabelCmd',
    std_EndLabelCmd index 1008 name 'dpl_EndLabelCmd',
    std_PrintBuffer index 1009 name 'dpl_PrintBuffer',
    std_FlushGfxCache index 1010 name 'dpl_FlushGfxCache',
    std_MeasurementSystem index 1011 name 'dpl_MeasurementSystem',
    std_ClearPrinterBuffer index 1012 name 'dpl_ClearPrinterBuffer';
    std_LoadBitmapFromBase64Str index 1013 name 'dpl_LoadBitmapFromBase64Str';
    // ----------------------------------------------------------------------
    procedure std_GetVersion(var MajorVersion, MinorVersion, Release,
      Build: Word); stdcall; external 'Print1c.dll';
    function std_InitializePrinterJob: Integer; stdcall; external 'Print1c.dll';
    function std_FinalizePrinterJob: Integer; stdcall; external 'Print1c.dll';
    function std_PrepareBitmapFromText(const lpFmtTextLine: PChar; GfxId,
      Permanent: Integer): Integer; stdcall; external 'Print1c.dll';
    function std_LoadBitmapFromFile(const lpFmtFilename: PChar; GfxId,
      Permanent: Integer): Integer; stdcall; external 'Print1c.dll';
    function std_PlaceBitmap(HeightMplr, WidthMplr, Row, Column,
      GfxId: Integer): Integer; stdcall; external 'Print1c.dll';
    function std_BeginLabelCmd: Integer; stdcall; external 'Print1c.dll';
    function std_EndLabelCmd: Integer; stdcall; external 'Print1c.dll';
    function std_PrintBuffer(const lpPrinterName, lpJobTitle: PChar): Integer;
      stdcall; external 'Print1c.dll';
    function std_FlushGfxCache: Integer; stdcall; external 'Print1c.dll';
    function std_MeasurementSystem(Mode: Integer): Integer; stdcall; external 'Print1c.dll';
    function std_ClearPrinterBuffer: Integer; stdcall; external 'Print1c.dll';
    function std_LoadBitmapFromBase64Str(const lpFmtBase64Str: PChar; GfxId,
      Permanent: Integer): Integer; stdcall; external 'Print1c.dll';
    // ----------------------------------------------------------------------
  }

const
  // -----------------------------------------------------------------------------
  Load_PrintModule_At_Init: Boolean = false;
  // -----------------------------------------------------------------------------
  epUnassigned = -255;
  epException = -254;
  // -----------------------------------------------------------------------------
  // Dimensions
  // -----------------------------------------------------------------------------
  MmPerInch: real = 25.4;
  PrinterResolutionDPI: integer = 203;
  PrinterModeMetric: boolean = false;

function _Get_PrintModule_Name: string;
function _Get_PrintModule_Handle: TModuleHandle;
function _Get_PrintModule_FileName: string;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
// Пересчет в координаты принтера
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function DimToPix(Number: Integer): Integer;
function InchesToDots(Number: Integer): Integer;
function MmsToDots(Number: Integer): Integer;
function DotsToInches(Number: Integer): Integer;
function DotsToMms(Number: Integer): Integer;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
// Imported functions
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function GetPrintModuleVersionString: WideString;
function InitializePrinterJob: Integer;
function FinalizePrinterJob: Integer;
function PrepareBitmapFromText(const lpFmtTextLine: PChar; GfxId, Permanent: Integer): Integer;
function LoadBitmapFromFile(const lpFmtFilename: PChar; GfxId, Permanent: Integer): Integer;
function PlaceBitmap(HeightMplr, WidthMplr, Row, Column, GfxId: Integer): Integer;
function BeginLabelCmd: Integer;
function EndLabelCmd: Integer;
function PrintBuffer(const lpPrinterName, lpJobTitle: PChar): Integer;
function FlushGfxCache: Integer;
function MeasurementSystem(Mode: Integer): Integer;
function ClearPrinterBuffer: Integer;
function LoadBitmapFromBase64Str(const lpFmtBase64Str: PChar; GfxId, Permanent: Integer): Integer;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
function PrintModuleLoad: boolean;
function PrintModuleFree: boolean;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

implementation

{$IFDEF Debug_Level_6}
{$DEFINE uhImport_DEBUG}
{$ENDIF}

{$IFDEF NO_DEBUG}
{$UNDEF uhImport_DEBUG}
{$ENDIF}

const
  UnitName: string = 'uhImport';
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  Print_ModuleName: string = 'Print1c';
  Print_ModuleHandle: THandle = 0;
  Print_ModuleFileName: string = 'not found';
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  ext_GetVersion: TGetVersion = nil;
  s_GetVersion: string = 'dpl_GetVersion';
  ext_InitializePrinterJob: TInitializePrinterJob = nil;
  s_InitializePrinterJob: string = 'dpl_InitializePrinterJob';
  ext_FinalizePrinterJob: TFinalizePrinterJob = nil;
  s_FinalizePrinterJob: string = 'dpl_FinalizePrinterJob';
  ext_PrepareBitmapFromText: TPrepareBitmapFromText = nil;
  s_PrepareBitmapFromText: string = 'dpl_PrepareBitmapFromText';
  ext_LoadBitmapFromFile: TLoadBitmapFromFile = nil;
  s_LoadBitmapFromFile: string = 'dpl_LoadBitmapFromFile';
  ext_PlaceBitmap: TPlaceBitmap = nil;
  s_PlaceBitmap: string = 'dpl_PlaceBitmap';
  ext_BeginLabelCmd: TBeginLabelCmd = nil;
  s_BeginLabelCmd: string = 'dpl_BeginLabelCmd';
  ext_EndLabelCmd: TEndLabelCmd = nil;
  s_EndLabelCmd: string = 'dpl_EndLabelCmd';
  ext_PrintBuffer: TPrintBuffer = nil;
  s_PrintBuffer: string = 'dpl_PrintBuffer';
  ext_FlushGfxCache: TFlushGfxCache = nil;
  s_FlushGfxCache: string = 'dpl_FlushGfxCache';
  ext_MeasurementSystem: TMeasurementSystem = nil;
  s_MeasurementSystem: string = 'dpl_MeasurementSystem';
  ext_ClearPrinterBuffer: TClearPrinterBuffer = nil;
  s_ClearPrinterBuffer: string = 'dpl_ClearPrinterBuffer';
  ext_LoadBitmapFromBase64Str: TLoadBitmapFromBase64Str = nil;
  s_LoadBitmapFromBase64Str: string = 'dpl_LoadBitmapFromBase64Str';
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

function _Get_PrintModule_Name: string;
begin
  Result := Print_ModuleName;
end;

function _Get_PrintModule_Handle: TModuleHandle;
begin
  Result := Print_ModuleHandle;
end;

function _Get_PrintModule_FileName: string;
begin
  Result := Print_ModuleFileName;
end;

// ****************************************************************************

function DimToPix(Number: Integer): Integer;
//  *----------------------------------*---------------------------*
//  | PrintHead Resolution (DPI)       |         Dot Size          |
//  *--------------------*-------------*-------------*-------------*
//  |      Dots/inch     |   Dots/mm   |    Inches   | Millimeters |
//  *--------------------*-------------*-------------*-------------*
//  |         152        |      6.0    |   .0066     |    .167     |
//  *--------------------*-------------*-------------*-------------*
//  |         203        |      8.0    |   .0049     |    .125     |
//  *--------------------*-------------*-------------*-------------*
//  | 289 (DMX 430 only) |     11.4    |   .0035     |    .088     |
//  *--------------------*-------------*-------------*-------------*
//  |         300        |     11.8    |   .0033     |    .085     |
//  *--------------------*-------------*-------------*-------------*
var
  mesys: Integer;
begin
  mesys := MeasurementSystem(0);
  case mesys of
    1: PrinterModeMetric := false; // inches
    2: PrinterModeMetric := true; // millimeters
  end;
  {
  if PrinterModeMetric then
    Result := round((Number / 10) * (PrinterResolutionDPI / MmPerInch))
  else
    Result := round((Number / 100) * PrinterResolutionDPI);
  }
  if PrinterModeMetric then
    Result := MmsToDots(Number)
  else
    Result := InchesToDots(Number);
end;
// ****************************************************************************

function InchesToDots(Number: Integer): Integer;
begin
  Result := round((Number / 100) * PrinterResolutionDPI);
end;
// ****************************************************************************

function MmsToDots(Number: Integer): Integer;
begin
  Result := round((Number / 10) * (PrinterResolutionDPI / MmPerInch));
end;
// ****************************************************************************

function DotsToInches(Number: Integer): Integer;
begin
  Result := round((Number / PrinterResolutionDPI) * 100);
end;
// ****************************************************************************

function DotsToMms(Number: Integer): Integer;
begin
  Result := round((Number / (PrinterResolutionDPI / MmPerInch)) * 10);
end;
// ****************************************************************************

{
procedure foo;
begin
  // =============================================================================
  // buffer := '@2,000,050' + c_CRLF;
  // buffer := '@2,025,050' + c_CRLF + '#Times New Roman,1000,25,204' + c_CRLF;
  // buffer := buffer + '^0266,0000;' + '-=- test -=-'; // Film_Name; // 2.66 inches ~ 6,7564 mm
  // =============================================================================
  ImgWidth := DimToPix(Abs(StrToInt(copy(s, 2, 4))));
  Delete(s, 1, 6);
  ImgHeight := DimToPix(Abs(StrToInt(copy(s, 1, 4))));
  Delete(s, 1, 5);
  ImgWidthReal := Bitmap.Canvas.TextWidth(scut);
  DebugMess(
    format(' s1(%s) = "%s"', [format_fixed(i, 2, ' '), s]) + #13#10 +
    format(' Length is %u, width is %u dots ~ %f inches ~ %f mm.', [length(s),
    ImgWidth, DotsToInches(ImgWidth) / 100, DotsToMms(ImgWidth) / 10]) + #13#10 +
      format(' s2(%s) = "%s"', [format_fixed(i, 2, ' '), scut]) + #13#10 +
    format(' Length is %u, width is %u dots ~ %f inches ~ %f mm.', [length(scut),
    ImgWidthReal, DotsToInches(ImgWidthReal) / 100, DotsToMms(ImgWidthReal) / 10]));
  xshift := round((ImgWidth - ImgWidthReal) * HAlignInPercent / 100);
  yshift := round((MaxHeight - ImgHeight) * (100 - VAlignInPercent) / 100);
  if DebugShowPrn then
  begin
    Bitmap.Canvas.Rectangle(xstart, 0, xstart + ImgWidth, MaxHeight);
    Bitmap.Canvas.Rectangle(xstart + xshift, yshift, xstart + xshift +
      ImgWidthReal, yshift + ImgHeight);
  end;
  Bitmap.Canvas.TextOut(xstart + xshift, yshift, scut);
  xstart := xstart + ImgWidth;
end;
}

function GetPrintModuleVersionString: WideString;
var
  _MajorVersion, _MinorVersion, _Release, _Build, _Flags: Word;
  _VersionString: string;
begin
  if Assigned(ext_GetVersion) then
  begin
    try
      ext_GetVersion(_MajorVersion, _MinorVersion, _Release, _Build, _Flags);
      _VersionString := IntToStr(_MajorVersion) + '.' + IntToStr(_MinorVersion)
        + '.' + IntToStr(_Release) + '.' + IntToStr(_Build);
      if (_Flags and 16) > 0 then
        _VersionString := _VersionString + 'rc';
      if _Flags > 0 then
      begin
        _VersionString := _VersionString + ' Debug (';
        if (_Flags and 1) > 0 then
          _VersionString := _VersionString + 'F';
        if (_Flags and 2) > 0 then
          _VersionString := _VersionString + 'B';
        if (_Flags and 4) > 0 then
          _VersionString := _VersionString + 'S';
        if (_Flags and 8) > 0 then
          _VersionString := _VersionString + 'P';
        _VersionString := _VersionString + ')';
      end
      else
        _VersionString := _VersionString + ' Ready';
      Result := _VersionString + ' release';
    except
      Result := '<bad function>';
    end;
  end
  else
    Result := '<wrong version>';
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

function InitializePrinterJob: Integer;
begin
  Result := epUnassigned;
  if Assigned(ext_InitializePrinterJob) then
  try
    Result := ext_InitializePrinterJob
  except
    Result := epException;
  end;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

function FinalizePrinterJob: Integer;
begin
  Result := epUnassigned;
  if Assigned(ext_FinalizePrinterJob) then
  try
    Result := ext_FinalizePrinterJob
  except
    Result := epException;
  end;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

function PrepareBitmapFromText(const lpFmtTextLine: PChar; GfxId,
  Permanent: Integer): Integer;
begin
  Result := epUnassigned;
  if Assigned(ext_PrepareBitmapFromText) then
  try
    Result := ext_PrepareBitmapFromText(lpFmtTextLine, GfxId, Permanent)
  except
    Result := epException;
  end;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

function LoadBitmapFromFile(const lpFmtFilename: PChar; GfxId,
  Permanent: Integer): Integer;
begin
  Result := epUnassigned;
  if Assigned(ext_LoadBitmapFromFile) then
  try
    Result := ext_LoadBitmapFromFile(lpFmtFilename, GfxId, Permanent)
  except
    Result := epException;
  end;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

function PlaceBitmap(HeightMplr, WidthMplr, Row, Column, GfxId: Integer): Integer;
const
  ProcName: string = 'PlaceBitmap';
var
  Mpld_Row, Mpld_Col, Dim_Row, Dim_Col: Integer;
begin
{$IFDEF uhImport_DEBUG}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  Result := epUnassigned;
  if Assigned(ext_PlaceBitmap) then
  try
{$IFDEF uhImport_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName,
      format('HeightMplr = %d, WidthMplr = %d, Row = %d, Column = %d, GfxId = %d',
      [HeightMplr, WidthMplr, Row, Column, GfxId]));
    // ++++++
    Mpld_Row := (abs(HeightMplr) mod 10) * Row;
    Mpld_Col := (abs(WidthMplr) mod 10) * Column;
    Dim_Row := DimToPix(Mpld_Row);
    Dim_Col := DimToPix(Mpld_Col);
    // ++++++
    DEBUGMessEnh(0, UnitName, ProcName,
      format('Gfx is placed at - in dots (%u; %u) ~ inches (%f; %f) ~ mms (%f; %f).',
      [Dim_Row, Dim_Col,
      DotsToInches(Dim_Row) / 100, DotsToInches(Dim_Col) / 100,
        DotsToMms(Dim_Row) / 10, DotsToMms(Dim_Col) / 10]));
{$ENDIF}
    Result := ext_PlaceBitmap(HeightMplr, WidthMplr, Row, Column, GfxId)
  except
    Result := epException;
  end;
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
{$IFDEF uhImport_DEBUG}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

function BeginLabelCmd: Integer;
begin
  Result := epUnassigned;
  if Assigned(ext_BeginLabelCmd) then
  try
    Result := ext_BeginLabelCmd
  except
    Result := epException;
  end;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

function EndLabelCmd: Integer;
begin
  Result := epUnassigned;
  if Assigned(ext_EndLabelCmd) then
  try
    Result := ext_EndLabelCmd
  except
    Result := epException;
  end;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

function PrintBuffer(const lpPrinterName, lpJobTitle: PChar): Integer;
begin
  Result := epUnassigned;
  if Assigned(ext_PrintBuffer) then
  try
    Result := ext_PrintBuffer(lpPrinterName, lpJobTitle)
  except
    Result := epException;
  end;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

function FlushGfxCache: Integer;
begin
  Result := epUnassigned;
  if Assigned(ext_FlushGfxCache) then
  try
    Result := ext_FlushGfxCache
  except
    Result := epException;
  end;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

function MeasurementSystem(Mode: Integer): Integer;
begin
  Result := epUnassigned;
  if Assigned(ext_MeasurementSystem) then
  try
    Result := ext_MeasurementSystem(Mode)
  except
    Result := epException;
  end;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

function ClearPrinterBuffer: Integer;
begin
  Result := epUnassigned;
  if Assigned(ext_ClearPrinterBuffer) then
  try
    Result := ext_ClearPrinterBuffer
  except
    Result := epException;
  end;
end;
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

function LoadBitmapFromBase64Str(const lpFmtBase64Str: PChar; GfxId, Permanent: Integer): Integer;
begin
  Result := epUnassigned;
  if Assigned(ext_PrepareBitmapFromText) then
  try
    Result := ext_LoadBitmapFromBase64Str(lpFmtBase64Str, GfxId, Permanent)
  except
    Result := epException;
  end;
end;

function PrintModuleLoad: boolean;
const
  ProcName: string = 'ModuleLoad';
  s_Function_Not_Found: string = 'Failed to import function "%s" from %.';
var
  mesys: Integer;
begin
{$IFDEF uhImport_DEBUG}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  if Print_ModuleHandle <> 0 then
    PrintModuleFree;
  Print_ModuleHandle := LoadLibrary(PChar(Print_ModuleName));
  if Print_ModuleHandle <> 0 then
  begin
    SetLength(Print_ModuleFileName, 2048);
    SetLength(Print_ModuleFileName, GetModuleFileName(Print_ModuleHandle,
      @Print_ModuleFileName[1], 2048));
{$IFDEF uhImport_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, Print_ModuleName + ' module is opened, path - "'
      + Print_ModuleFileName + '".');
{$ENDIF}
    // 1001
    @ext_GetVersion := GetProcAddress(Print_ModuleHandle, PChar(s_GetVersion));
    if @ext_GetVersion <> nil then
{$IFDEF uhImport_DEBUG}
      DEBUGMessEnh(0, UnitName, ProcName, 'Module version is [' +
        GetPrintModuleVersionString + '].')
{$ENDIF}
    else
      DEBUGMessEnh(0, UnitName, ProcName, Format(s_Function_Not_Found, [s_GetVersion,
        Print_ModuleName]));
    // 1002
    @ext_InitializePrinterJob := GetProcAddress(Print_ModuleHandle,
      PChar(s_InitializePrinterJob));
    if @ext_InitializePrinterJob = nil then
      DEBUGMessEnh(0, UnitName, ProcName, Format(s_Function_Not_Found, [s_InitializePrinterJob,
        Print_ModuleName]));
    // 1003
    @ext_FinalizePrinterJob := GetProcAddress(Print_ModuleHandle, PChar(s_FinalizePrinterJob));
    if @ext_FinalizePrinterJob = nil then
      DEBUGMessEnh(0, UnitName, ProcName, Format(s_Function_Not_Found, [s_FinalizePrinterJob,
        Print_ModuleName]));
    // 1004
    @ext_PrepareBitmapFromText := GetProcAddress(Print_ModuleHandle,
      PChar(s_PrepareBitmapFromText));
    if @ext_PrepareBitmapFromText = nil then
      DEBUGMessEnh(0, UnitName, ProcName, Format(s_Function_Not_Found, [s_PrepareBitmapFromText,
        Print_ModuleName]));
    // 1005
    @ext_LoadBitmapFromFile := GetProcAddress(Print_ModuleHandle, PChar(s_LoadBitmapFromFile));
    if @ext_LoadBitmapFromFile = nil then
      DEBUGMessEnh(0, UnitName, ProcName, Format(s_Function_Not_Found, [s_LoadBitmapFromFile,
        Print_ModuleName]));
    // 1006
    @ext_PlaceBitmap := GetProcAddress(Print_ModuleHandle, PChar(s_PlaceBitmap));
    if @ext_PlaceBitmap = nil then
      DEBUGMessEnh(0, UnitName, ProcName, Format(s_Function_Not_Found, [s_PlaceBitmap,
        Print_ModuleName]));
    // 1007
    @ext_BeginLabelCmd := GetProcAddress(Print_ModuleHandle, PChar(s_BeginLabelCmd));
    if @ext_BeginLabelCmd = nil then
      DEBUGMessEnh(0, UnitName, ProcName, Format(s_Function_Not_Found, [s_BeginLabelCmd,
        Print_ModuleName]));
    // 1008
    @ext_EndLabelCmd := GetProcAddress(Print_ModuleHandle, PChar(s_EndLabelCmd));
    if @ext_EndLabelCmd = nil then
      DEBUGMessEnh(0, UnitName, ProcName, Format(s_Function_Not_Found, [s_EndLabelCmd,
        Print_ModuleName]));
    // 1009
    @ext_PrintBuffer := GetProcAddress(Print_ModuleHandle, PChar(s_PrintBuffer));
    if @ext_PrintBuffer = nil then
      DEBUGMessEnh(0, UnitName, ProcName, Format(s_Function_Not_Found, [s_PrintBuffer,
        Print_ModuleName]));
    // 1010
    @ext_FlushGfxCache := GetProcAddress(Print_ModuleHandle, PChar(s_FlushGfxCache));
    if @ext_FlushGfxCache = nil then
      DEBUGMessEnh(0, UnitName, ProcName, Format(s_Function_Not_Found, [s_FlushGfxCache,
        Print_ModuleName]));
    // 1011
    @ext_MeasurementSystem := GetProcAddress(Print_ModuleHandle, PChar(s_MeasurementSystem));
    if @ext_MeasurementSystem = nil then
      DEBUGMessEnh(0, UnitName, ProcName, Format(s_Function_Not_Found, [s_MeasurementSystem,
        Print_ModuleName]))
    else
    begin
      mesys := MeasurementSystem(0);
      case mesys of
        1: PrinterModeMetric := false; // inches
        2: PrinterModeMetric := true; // millimeters
      end;
    end;
    // 1012
    @ext_ClearPrinterBuffer := GetProcAddress(Print_ModuleHandle, PChar(s_ClearPrinterBuffer));
    if @ext_ClearPrinterBuffer = nil then
      DEBUGMessEnh(0, UnitName, ProcName, Format(s_Function_Not_Found, [s_ClearPrinterBuffer,
        Print_ModuleName]));
    // 1013
    @ext_LoadBitmapFromBase64Str := GetProcAddress(Print_ModuleHandle,
      PChar(s_LoadBitmapFromBase64Str));
    if @ext_LoadBitmapFromBase64Str = nil then
      DEBUGMessEnh(0, UnitName, ProcName, Format(s_Function_Not_Found, [s_LoadBitmapFromBase64Str,
        Print_ModuleName]));
  end
  else
  begin
    @ext_GetVersion := nil; // 1001
    @ext_InitializePrinterJob := nil; // 1002
    @ext_FinalizePrinterJob := nil; // 1003
    @ext_PrepareBitmapFromText := nil; // 1004
    @ext_LoadBitmapFromFile := nil; // 1005
    @ext_PlaceBitmap := nil; // 1006
    @ext_BeginLabelCmd := nil; // 1007
    @ext_EndLabelCmd := nil; // 1008
    @ext_PrintBuffer := nil; // 1009
    @ext_FlushGfxCache := nil; // 1010
    @ext_MeasurementSystem := nil; // 1011
    @ext_ClearPrinterBuffer := nil; // 1012
    @ext_LoadBitmapFromBase64Str := nil; // 1013
{$IFDEF uhImport_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'Failed to open module ' + Print_ModuleName + '.')
{$ENDIF}
  end;
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  Result := (Print_ModuleHandle <> 0);
{$IFDEF uhImport_DEBUG}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

function PrintModuleFree: boolean;
const
  ProcName: string = 'ModuleFree';
begin
{$IFDEF uhImport_DEBUG}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  if Print_ModuleHandle <> 0 then
  try
    FreeLibrary(Print_ModuleHandle);
    Print_ModuleHandle := 0;
{$IFDEF uhImport_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, Print_ModuleName + ' module is closed.');
{$ENDIF}
    @ext_GetVersion := nil; // 1001
    @ext_InitializePrinterJob := nil; // 1002
    @ext_FinalizePrinterJob := nil; // 1003
    @ext_PrepareBitmapFromText := nil; // 1004
    @ext_LoadBitmapFromFile := nil; // 1005
    @ext_PlaceBitmap := nil; // 1006
    @ext_BeginLabelCmd := nil; // 1007
    @ext_EndLabelCmd := nil; // 1008
    @ext_PrintBuffer := nil; // 1009
    @ext_FlushGfxCache := nil; // 1010
    @ext_MeasurementSystem := nil; // 1011
    @ext_ClearPrinterBuffer := nil; // 1012
    @ext_LoadBitmapFromBase64Str := nil; // 1013
{$IFDEF uhImport_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, Print_ModuleName + ' functions was set to nil.');
{$ENDIF}
  except
{$IFDEF uhImport_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'Failed to close module ' + Print_ModuleName + '.');
{$ENDIF}
  end
  else
  begin
{$IFDEF uhImport_DEBUG}
    DEBUGMessEnh(0, UnitName, ProcName, 'Module ' + Print_ModuleName + ' was not loaded.');
{$ENDIF}
  end;
  Result := (Print_ModuleHandle = 0);
  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
{$IFDEF uhImport_DEBUG}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

initialization
  if Load_PrintModule_At_Init then
    PrintModuleLoad
  else
{$IFDEF uhImport_DEBUG}
    DEBUGMessEnh(0, UnitName, 'initialization', 'Skipping module load...');
{$ENDIF}

finalization
  PrintModuleFree;

end.

