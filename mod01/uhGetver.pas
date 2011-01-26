{-----------------------------------------------------------------------------
 Unit Name: uhGetVer
 Author:    n0mad
 Version:   1.1.6.75
 Creation:  15.10.2002
 Purpose:   Getting versions of modules
 History:
-----------------------------------------------------------------------------}
unit uhGetver;

interface
{$I bugger.inc}

uses
  Bugger, StrConsts, Windows, SysUtils;

function GetModuleVersionInfoStr(const ModuleName: string): string;
function GetModuleVersionInfo(const ModuleName: string; var ProductName, ProductVersion,
  FileVersion: string): string;

implementation

const
  UnitName: string = 'uhGetver';
  Translation_Block: string = '\VarFileInfo\Translation';
  Lang_Specific_Block: string = '\StringFileInfo\';
  Default_Lang: string = '040904E4';
  // English 1252 - '040904E4';
  // Russian 1251 - '041904E3';
  Default_Error_String: string = '<Error>';

function GetModuleVersionInfoStr(const ModuleName: string): string;
var
  vProductName, vProductVersion, vFileVersion: string;
begin
  Result := GetModuleVersionInfo(ModuleName, vProductName, vProductVersion, vFileVersion);
end;

function GetModuleVersionInfo(const ModuleName: string; var ProductName, ProductVersion,
  FileVersion: string): string;
const
  ProcName: string = 'GetModuleVersionInfo';

  procedure GetVersionStringDef(var sBuffer: string; const sVersionBuffer,
    sPath, sDefault: string);
  var
    lplpBuffer: Pointer;
    puLen: Cardinal;
  begin
    sBuffer := sDefault;
    if (length(sVersionBuffer) > 0) and (length(sPath) > 0) then
      if VerQueryValue(@sVersionBuffer[1], PChar(sPath), lplpBuffer, puLen) then
        if (lplpBuffer <> nil) and (puLen > 0) then
        begin
          SetLength(sBuffer, puLen);
          StrCopy(@sBuffer[1], lplpBuffer);
          SetLength(sBuffer, puLen - 1);
        end;
  end;
var
  s, VersionInfo_Buf, ProductName_Buf, ProductVersion_Buf, LegalCopyright_Buf,
    FileDescription_Buf, CompanyName_Buf, FileVersion_Buf, Version_Block: string;
  VerInfoBlockSize, SubBlockSize: dword;
  dwHandle: Cardinal;
  wLang, wCharset: word;
  Point1, Point2: Pointer;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  s := '';
  ProductName_Buf := 'N/A';
  ProductVersion_Buf := 'N/A';
  LegalCopyright_Buf := 'N/A';
  FileDescription_Buf := 'N/A';
  CompanyName_Buf := 'N/A';
  FileVersion_Buf := 'N/A';
  VerInfoBlockSize := GetFileVersionInfoSize(PChar(ModuleName), dwHandle);
  if VerInfoBlockSize > 0 then
  begin
    SetLength(VersionInfo_Buf, VerInfoBlockSize + 1);
    Point1 := @VersionInfo_Buf[1];
    if GetFileVersionInfo(PChar(ModuleName), dwHandle, VerInfoBlockSize, Point1) then
    begin
      if VerQueryValue(Point1, '\', Point2, SubBlockSize) then
        with TVSFixedFileInfo(Point2^) do
        begin
          FileVersion_Buf := IntToStr(HiWord(dwFileVersionMS))
            + '.' + IntToStr(LoWord(dwFileVersionMS))
            + '.' + IntToStr(HiWord(dwFileVersionLS))
            + '.' + IntToStr(LoWord(dwFileVersionLS));
        end;
      if VerQueryValue(Point1, PChar(Translation_Block), Point2, SubBlockSize) then
      begin
        wLang := word(Point2^);
        Point2 := Pointer(dword(Point2) + 2);
        wCharset := word(Point2^);
        Version_Block := Lang_Specific_Block + IntToHex(wLang, 4) + IntToHex(wCharset, 4);
      end
      else
        Version_Block := Lang_Specific_Block + Default_Lang;
      GetVersionStringDef(ProductName_Buf, VersionInfo_Buf, Version_Block +
        '\\ProductName', Default_Error_String);
      GetVersionStringDef(ProductVersion_Buf, VersionInfo_Buf, Version_Block +
        '\\ProductVersion', Default_Error_String);
      GetVersionStringDef(LegalCopyright_Buf, VersionInfo_Buf, Version_Block +
        '\\LegalCopyright', Default_Error_String);
      GetVersionStringDef(FileDescription_Buf, VersionInfo_Buf, Version_Block +
        '\\FileDescription', Default_Error_String);
      GetVersionStringDef(CompanyName_Buf, VersionInfo_Buf, Version_Block +
        '\\CompanyName', Default_Error_String);
      GetVersionStringDef(FileVersion_Buf, VersionInfo_Buf, Version_Block +
        '\\FileVersion', Default_Error_String);
    end;
  end;
  ProductName := ProductName_Buf;
  ProductVersion := ProductVersion_Buf;
  FileVersion := FileVersion_Buf;
  Result :=
    'Product Name : "' + ProductName_Buf + '"'
    + c_CRLF
    + 'Product Version : [' + ProductVersion_Buf + ']'
    + c_CRLF
    + 'Legal Copyright : "' + LegalCopyright_Buf + '"'
    + c_CRLF
    + 'File Description : "' + FileDescription_Buf + '"'
    + c_CRLF
    + 'Company Name : "' + CompanyName_Buf + '"'
    + c_CRLF
    + 'File Version : [' + FileVersion_Buf + ']';
  DEBUGMessEnh(0, UnitName, ProcName, 'Module Path : "' + ExpandFileName(ModuleName) + '"');
  DEBUGMessEnh(0, UnitName, ProcName, 'Product Name : "' + ProductName_Buf + '"');
  DEBUGMessEnh(0, UnitName, ProcName, 'Product Version : [' + ProductVersion_Buf + ']');
  DEBUGMessEnh(0, UnitName, ProcName, 'Legal Copyright : "' + LegalCopyright_Buf + '"');
  DEBUGMessEnh(0, UnitName, ProcName, 'File Description : "' + FileDescription_Buf + '"');
  DEBUGMessEnh(0, UnitName, ProcName, 'Company Name : "' + CompanyName_Buf + '"');
  DEBUGMessEnh(0, UnitName, ProcName, 'File Version : [' + FileVersion_Buf + ']');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
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

