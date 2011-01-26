{-----------------------------------------------------------------------------
 Unit Name: bugger
 Author:    n0mad
 Version:   (A) 2004.11.12.01
 Creation:  04.04.2003
 Purpose:   Debuging
 History:
-----------------------------------------------------------------------------}
unit Bugger;

// ****************************************************************************
interface
{$I bugger.inc}

uses
  {Dialogs, }SysUtils;

{
const
  DEBUGWorkDir: string = '';
  DEBUGProjectName: string = 'ProjectName';
  DEBUGFileNameDateTimeAddon: string = '_(yyyy.mm.dd_hh-nn-ss_ddd)';
  DEBUGSavFileDateTimeAddon: string = '(yyyy-mm-dd`hh-nn-ss)';
  DEBUGFileNameExt: string = 'log';
  DEBUGToFile: boolean = true;
  DEBUGSaveToFile: boolean = false;
  DEBUGShowScr: boolean = false;
  DEBUGShowPrn: boolean = false;
  DEBUGNewLogFile: boolean = true;
  DEBUGLogSeparatorWidth: integer = 77;
  DEBUGShowAddr: boolean = true;
}
// ****************************************************************************
{$IFDEF DEBUG_Module_Start_Finish}
function DEBUGMess(const Shift: integer; const Mess: string): boolean;
{$ENDIF}
function DEBUGMessEnh(const Shift: integer; const UnitName, ProcName, Mess:
  string): boolean;
function DEBUGMessBrk(const Shift: integer; const Mess: string): boolean;
//function DEBUGMessLine(const Breaker: char; const Count: byte): boolean;
function DEBUGMessExt(const Shift: integer; const Mess: string; const DateStamp,
  BreakerFromStart: boolean): boolean;
function DEBUGSave(const FName, Data: string; const DateStamp: boolean): boolean;

implementation

uses
  Bugres, Windows;

const
  UnitName: string = 'Bugger(A)';
  UnitVer: string = '(A)2004.11.12.01';

const
  DEBUG_FileName: string = '.\prog_run.log';
  DEBUG_Shift: integer = 0;
  DEBUG_Shift_Delta: byte = 2;
  DEBUG_Shift_Deep: byte = 20;
  DEBUG_Shift_Stop: byte = 3;
  DEBUG_Shift_Save: integer = 0;
  CRLF: string = #13#10;
  DEBUG_Log_Started: boolean = false;
  DEBUG_Log_Stop: boolean = true;
  // ****************************************************************************

function DEBUGMess(const Shift: integer; const Mess: string): boolean;
begin
  Result := DEBUGMessExt(Shift, Mess, true, false);
end;

function DEBUGMessEnh(const Shift: integer; const UnitName, ProcName, Mess:
  string): boolean;
var
  ProcAddr: LongWord;
begin
  if ((Length(UnitName) > 0) or (Length(ProcName) > 0) or (Length(Mess) > 0)) then
  begin
    if DEBUGShowAddr and (Shift <> 0) then
    begin
      // New style with address
      ProcAddr := LongWord(Pointer(@ProcName)^) + LongWord(Length(ProcName));
      ProcAddr := ProcAddr + (4 - ProcAddr mod 4);
      Result := DEBUGMessExt(Shift, '[' + UnitName + '::' + ProcName + ':@=(0x' +
        IntToHex(ProcAddr, 8) + ')]: ' + Mess, true, false);
    end
    else
      // Old style
      Result := DEBUGMessExt(Shift, '[' + UnitName + '::' + ProcName + ']: ' +
        Mess, true, false);
  end
  else
    // Send void string just to shift
    Result := DEBUGMessExt(Shift, CRLF, false, false);
end;

function DEBUGMessBrk(const Shift: integer; const Mess: string): boolean;
begin
  Result := DEBUGMessExt(Shift, StringOfChar('-', 20) + '=< ' + Mess + ' >=' +
    StringOfChar('-', 20), true, false);
end;

function DEBUGMessLine(const Breaker: char; const Count: byte): boolean;
var
  tmpBreaker: char;
  tmpCount: byte;
begin
  if Breaker = #0 then
    tmpBreaker := '-'
  else
    tmpBreaker := Breaker;
  if Count > 0 then
    tmpCount := Count
  else
    tmpCount := DEBUGLogSeparatorWidth;
  Result := DEBUGMessExt(0, CRLF + StringOfChar(tmpBreaker, tmpCount), false,
    true);
end;

function FreeSpaceCheckPassed(Directory: string; FreePercent: integer;
  FreeBytes: int64): boolean;
var
  FreeAvailable, TotalSpace, TotalFree: Int64;
begin
  Result := false;
  if not GetDiskFreeSpaceEx(PChar(Directory), FreeAvailable, TotalSpace,
    @TotalFree) then
    Result := true
  else if (FreeBytes < FreeAvailable) or (FreePercent < FreeAvailable /
    TotalSpace) then
    Result := true;
end;

function DEBUGMessExt(const Shift: integer; const Mess: string; const DateStamp,
  BreakerFromStart: boolean): boolean;
var
  fh, i, j, last: integer;
  tmp_Mess, tmp_DateStamp: AnsiString;
  tmp_Shift: string;
begin
  Result := false;
  if (DEBUG_Shift > DEBUG_Shift_Deep) then
  begin
    if (DEBUG_Shift mod DEBUG_Shift_Deep = 1)
      and (DEBUG_Shift <> DEBUG_Shift_Save) then
    begin
      try
        DEBUGSave('warning_stack_exhaust_detected.log', '', false);
        if DEBUGShowWarnings then
        begin
          // An exclamation-point icon appears in the message box
          MessageBox(0, PChar('Stack overflow is possible. Current shift = '
            + IntToStr(DEBUG_Shift) + ' > ' + IntToStr(DEBUG_Shift_Deep) + '.' + CRLF
            + 'Обнаружено превышение глубины вызова. Возможно переполнение стека.'),
            PChar(DEBUGProjectName), MB_OK + MB_ICONSTOP + MB_RIGHT {+ MB_RTLREADING});
        end;
      finally
        DEBUG_Shift_Save := DEBUG_Shift;
      end;
      if (DEBUG_Shift_Save div DEBUG_Shift_Deep >= DEBUG_Shift_Stop) then
      begin
        try
          DEBUG_Shift := DEBUG_Shift_Deep div 2;
          DEBUGMessExt(0, Mess, true, false);
          DEBUGMessExt(0, 'Program goes to deep in cycle. Aborted.', true, false);
          if DEBUGShowWarnings then
          begin
            MessageBox(0, PChar('I warned you. Program goes to deep in cycle.'
              + CRLF + 'Вообщем я предупреждал, пора заканчивать вечные циклы.'),
              PChar(DEBUGProjectName), MB_OK + MB_ICONWARNING + MB_RIGHT {+ MB_RTLREADING});
          end;
        finally
          Abort;
        end;
      end;
    end;
  end;
  if DEBUGToFile or (not DEBUG_Log_Stop) then
  begin
    if (not DEBUG_Log_Stop) then
      if not FreeSpaceCheckPassed(ExtractFileDir(ExpandFileName(DEBUG_FileName)),
        DEBUGFreeSpaceLimitPercent, DEBUGFreeSpaceLimitBytes) then
      begin
        DEBUG_Log_Stop := true;
        try
          DEBUGSave('warning_free_space_not_available.log', '', false);
          if DEBUG_Log_Started then
            // log to file if already created
            DEBUGMessExt(0, 'Program exhausted space for logfile. Logging stopped.', true, false)
          else
            // create file if not created
            DEBUGSave(DEBUG_FileName, '', false);
          if DEBUGShowWarnings then
          begin
            MessageBox(0, PChar('Free space for log file not available. Logging will be disabled.'
              + CRLF +
              'Свободного места для журнального файла не осталось. Журналирование будет отключено.'),
              PChar(DEBUGProjectName), MB_OK + MB_ICONWARNING + MB_RIGHT {+ MB_RTLREADING});
          end;
        finally
          DEBUGToFile := false;
        end;
        Exit;
      end;
    try
      tmp_Mess := Mess;
    except
      exit;
    end;
    fh := 0;
    try
      if FileExists(DEBUG_FileName) then
      begin
        fh := FileOpen(DEBUG_FileName, fmOpenReadWrite or fmShareDenyWrite);
        FileSeek(fh, 0, 2);
      end
      else
        fh := FileCreate(DEBUG_FileName);
      if fh > 0 then
      begin
        {--------------------------------}
        if Shift < 0 then
          dec(DEBUG_Shift);
        {--------------------------------}
        tmp_Shift := '';
        if not BreakerFromStart then
        begin
          last := -1;
          tmp_Shift := StringOfChar(' ', DEBUG_Shift * DEBUG_Shift_Delta);
          for i := 0 to DEBUG_Shift div 2 do
          begin
            j := (2 * i) * DEBUG_Shift_Delta + 1;
            if (j > 0) and (j <= length(tmp_Shift)) then
            begin
              tmp_Shift[j] := '|';
              last := j;
            end;
          end;
          j := last;
          if (j > 0) and (j <= length(tmp_Shift)) then
            if (Shift > 0) then
              tmp_Shift[j] := '>'
            else if (Shift < 0) then
              tmp_Shift[j] := '<'
            else
              tmp_Shift[j] := ' ';
        end;
        tmp_DateStamp := '';
        if DateStamp then
          tmp_DateStamp := FormatDateTime('[yyyy.mm.dd]-(hh:nn:ss)-', Now);
        tmp_Mess := tmp_DateStamp + tmp_Shift + Mess + CRLF;
        if Length(Mess) = Length(CRLF) then
          tmp_Mess := '';
        {--------------------------------}
        if Shift > 0 then
          inc(DEBUG_Shift);
        {--------------------------------}
        try
          if Length(tmp_Mess) > 0 then
            FileWrite(fh, tmp_Mess[1], Length(tmp_Mess));
          Result := true;
        except
          // Possibly media is full or something else.
        end;
      end;
    finally
      FileClose(fh);
      DEBUG_Log_Started := true;
    end;
  end
  else
  begin
    // touch file to change modification timestamp
    if DEBUG_Log_Started then
    begin
      // log to file if already created
      fh := 0;
      try
        if FileExists(DEBUG_FileName) then
        begin
          fh := FileOpen(DEBUG_FileName, fmOpenReadWrite or fmShareDenyWrite);
        end
        else
          fh := FileCreate(DEBUG_FileName);
        if (fh > 0) then
        try
          tmp_Mess := '';
          FileSeek(fh, 0, 2);
          FileWrite(fh, tmp_Mess[1], Length(tmp_Mess));
          Result := false;
        except
          // Possibly media is full or something else.
        end;
      finally
        FileClose(fh);
        DEBUG_Log_Started := true;
      end;
    end
    else
      // create file if not created
      DEBUGSave(DEBUG_FileName, '', false);
  end;
  if DEBUGShowScr then
    MessageBox(0, PChar(Mess), PChar(DEBUGProjectName),
      MB_OK + MB_ICONINFORMATION + MB_RIGHT {+ MB_RTLREADING});
end;

function DEBUGSave(const FName, Data: string; const DateStamp: boolean): boolean;
var
  fh: integer;
  tmp_FName, tmp_WorkDir, tmp_Data: AnsiString;
  tmp_DateTime: string;
begin
  Result := false;
  if DEBUGSaveToFile then
  begin
    try
      tmp_FName := ExtractFileName(FName);
      tmp_WorkDir := ExtractFilePath(FName);
      if Length(tmp_WorkDir) = 0 then
        tmp_WorkDir := DEBUGWorkDir;
      tmp_Data := Data;
    except
      exit;
    end;
    fh := 0;
    if DateStamp then
    begin
      // DateSeparator := '-';
      // TimeSeparator := '-';
      try
        tmp_DateTime := FormatDateTime(DEBUGSavFileDateTimeAddon, Now);
      except
        tmp_DateTime := FormatDateTime('(yyyy-mm-dd`hh-nn-ss)', Now);
      end;
    end
    else
      tmp_DateTime := '';
    try
      tmp_FName := tmp_WorkDir + tmp_DateTime + tmp_FName;
      fh := FileCreate(tmp_FName);
      if fh > 0 then
      try
        FileWrite(fh, tmp_Data[1], Length(tmp_Data));
        Result := true;
      except
        // Possibly media is full or something else.
      end;
    finally
      FileClose(fh);
    end;
  end;
end;

initialization
  DEBUG_Log_Started := false;
  DEBUG_Log_Stop := false;
  if (DEBUGFreeSpaceLimitPercent < 0) then
    DEBUGFreeSpaceLimitPercent := 0;
  if (DEBUGFreeSpaceLimitPercent > 100) then
    DEBUGFreeSpaceLimitPercent := 100;
  if (DEBUGFreeSpaceLimitBytes < 0) then
    DEBUGFreeSpaceLimitBytes := 32 * 1024 * 1024;
  if Length(DEBUGProjectName) = 0 then
    DEBUGProjectName := ChangeFileExt(ExtractFileName(ParamStr(0)), '');
  if Length(DEBUGWorkDir) = 0 then
    DEBUGWorkDir := GetCurrentDir + '\'
  else if (DEBUGWorkDir[Length(DEBUGWorkDir)] = '/') then
    DEBUGWorkDir[Length(DEBUGWorkDir)] := '/'
  else if (DEBUGWorkDir[Length(DEBUGWorkDir)] <> '\') then
    DEBUGWorkDir := DEBUGWorkDir + '\';
  if DEBUGNewLogFile then
  begin
    // DEBUGFileName := DEBUGProjectName + FormatDateTime('_(yyyy.mm.dd_hh-nn-ss_ddd)', Now) + '.log';
    DEBUG_FileName := DEBUGWorkDir + DEBUGProjectName +
      FormatDateTime(DEBUGFileNameDateTimeAddon, Now) + '.' + DEBUGFileNameExt;
  end
  else
  begin
    DEBUG_FileName := DEBUGWorkDir + DEBUGProjectName + '.' + DEBUGFileNameExt;
  end;
  DEBUGMess(0, StringOfChar('-', 10) + StringOfChar('=', 10) + '[Start]' +
    StringOfChar('=', 10) + StringOfChar('-', 10));
  DEBUGMess(0, 'DateTime is  = ' +
    FormatDateTime('yyyy, mmmm dd, dddd, hh:nn:ss)', Now));
  DEBUGMess(0, 'DEBUGFileName = "' + DEBUG_FileName + '"');
  DEBUGMess(0, 'CurrentDir = "' + GetCurrentDir + '"');
  DEBUGMess(0, UnitName + '.Init');

finalization
  DEBUGMess(0, UnitName + '.Final');
  DEBUGMess(0, StringOfChar('-', 10) + StringOfChar('=', 10) + '[Finish]' +
    StringOfChar('=', 10) + StringOfChar('-', 10));

end.

