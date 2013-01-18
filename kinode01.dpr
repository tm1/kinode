{-----------------------------------------------------------------------------
 Program:   kinode
 Unit Name: kinode01.dpr
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  01.03.2004
 Purpose:   Main project unit
 History:
-----------------------------------------------------------------------------}
program kinode01;

{%File 'mod01\bugger.inc'}
{%File 'kinode01.inc'}

{$I kinode01.inc}

uses
{$IFNDEF No_Jcl_Debug}
  ExcpnDlg in 'jclDebug\ExcpnDlg.pas' {ExceptionDialog},
{$ENDIF}
{$IFNDEF No_Eureka_Debug}
  // ExceptionLog {Eureka},
{$ENDIF}
  Bugger in 'mod01\Bugger.pas',
  BugRes in 'mod01\BugRes.pas',
  Forms,
  Windows,
  SysUtils,
{$IFDEF Use_Local_Lib}
  ShpCtrl2 in 'Lib\ShpCtrl2.pas',
  WcBitBtn in 'Lib\WcBitBtn.pas',
  FrmRstr in 'Lib\FrmRstr.pas',
{$IFNDEF No_XP_Menu}
  XPMenu in 'Lib\XPMenu.pas',
{$ENDIF}
  THostInfoUnit in 'Lib\THostInfoUnit.pas',
{$ELSE}
  // try to find in Delphi search paths
{$ENDIF}
  SLForms in 'mod01\SLForms.pas' {SLForm},
  StrConsts in 'mod01\StrConsts.pas',
  uTools in 'mod01\uTools.pas',
  uhGetver in 'mod01\uhGetver.pas',
  uThreads in 'mod01\uThreads.pas',
  ufMain in 'forms01\ufMain.pas' {fm_Main},
  uhMain in 'forms01\uhMain.pas',
  ufSplash in 'forms01\ufSplash.pas' {fm_Splash},
  ufLogin in 'forms02\ufLogin.pas' {fm_Login},
  udCommon in 'mod02\udCommon.pas' {dm_Common: TDataModule},
  uhCommon in 'mod02\uhCommon.pas',
  urCommon in 'mod02\urCommon.pas',
  udBase in 'mod02\udBase.pas' {dm_Base: TDataModule},
  uhLoader in 'mod03\uhLoader.pas',
  urLoader in 'mod03\urLoader.pas',
  uhCells in 'mod03\uhCells.pas',
  uhTicket in 'mod03\uhTicket.pas',
  ufInfo in 'forms04\ufInfo.pas' {fm_Info},
  ufDRpAz in 'forms04\ufDRpAz.pas' {fm_DRpAz},
  ufDRpBe in 'forms04\ufDRpBe.pas' {fm_DRpBe},
  ufDRpEx in 'forms04\ufDRpEx.pas' {fm_DRpEx},
  ufDted in 'forms03\ufDted.pas' {fm_Dted},
  ufGenre in 'forms03\ufGenre.pas' {fm_Genre},
  ufFilm in 'forms03\ufFilm.pas' {fm_Film},
  ufSeans in 'forms03\ufSeans.pas' {fm_Seans},
  ufTariff in 'forms03\ufTariff.pas' {fm_Tariff},
  ufCost in 'forms03\ufCost.pas' {fm_Cost},
  ufRepert in 'forms03\ufRepert.pas' {fm_Repert},
  ufPrice in 'forms03\ufPrice.pas' {fm_Price},
  ufAbjnl in 'forms03\ufAbjnl.pas' {fm_Abjnl},
  uhBase in 'mod02\uhBase.pas',
  uhTariff in 'mod03\uhTariff.pas',
  uhOper in 'mod03\uhOper.pas',
  DCPbase64 in 'mod04\DCPbase64.pas',
  uhImport in 'mod04\uhImport.pas',
  uhPrint in 'mod04\uhPrint.pas';

{$R *.RES}

resourcestring
  // OldUniqueProgramID = '{15058F94-EFB9-4114-8451-9EB34EBC9E9E}';
  UniqueProgramID = '{17A4D964-389E-47EC-ABB7-5AC31B14D0ED}';

var
  Time_Start, Time_End: TDateTime;
  Hour, Min, Sec, MSec: Word;
  sMessage: string;
  hMap: THandle;
  HandleData: PHandle;
  {Print_DLL_Found, }Client_DLL_Found: Boolean;
  aClient_DLL_Path: array[0..1024] of char;
  pClient_DLL_Name: PChar;
  BufSize1: integer;
  verMajor, verMinor, verRelease, verBuild: Integer;
  tError_Kod: Integer;
  tError_Text: string;
  SessionLock: Boolean;
const
  UnitName: string = 'kinode01';
  ProcName: string = 'MainProgram';
begin
  asm
      jmp @@loc
      db $90, $90, $90, $90, $90, $90, $90, $90
      db $0D, $0A, '#-Sign4U-#', $0D, $0A, 0
      db 'Main()', 0
      db 'Begin here', $0D, $0A, 0
      db $90, $90, $90, $90, $90, $90, $90, $90
    @@loc:
  end;
  DEBUGMessEnh(1, UnitName, ProcName, 'Start');
  // --------------------------------------------------------------------------
  Time_Start := Now;
  SessionLock := false;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, 'UniqueProgramID = ' + UniqueProgramID);
  DEBUGMessEnh(0, UnitName, ProcName, 'Application.Handle = ' + IntToStr(Application.Handle) + ' = '
    + IntToHex1(Application.Handle, 8));
  hMap := CreateFileMapping(DWord(-1), nil, PAGE_READWRITE, 0, SizeOf(THandle),
    PChar(UniqueProgramID));
  // --------------------------------------------------------------------------
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    hMap := OpenFileMapping(FILE_MAP_READ, false, PChar(UniqueProgramID));
    if hMap <> 0 then
    begin
      HandleData := MapViewOfFile(hMap, FILE_MAP_READ, 0, 0, SizeOf(THandle));
      if IsIconic(HandleData^) then
        ShowWindow(HandleData^, sw_restore);
      SetForegroundWindow(HandleData^);
      DEBUGMessEnh(0, UnitName, ProcName, 'Already started. Switching to app (' +
        IntToStr(HandleData^) + ' = ' + IntToHex1(HandleData^, 8) + ') ...');
    end
  end
  else
  begin
    if hMap = 0 then
      RaiseLastWin32Error;
    HandleData := MapViewOfFile(hMap, FILE_MAP_ALL_ACCESS, 0, 0, SizeOf(THandle));
    HandleData^ := Application.Handle;
    Application.Initialize;
    DEBUGMessEnh(0, UnitName, ProcName, 'Showing splash ...');
    fm_Splash := Tfm_Splash.Create(nil);
    with fm_Splash do
    try
      FormInit;
      SetProgress(0);
      Show; // *** show fm_Splash, splash screen with ProgressBar
      Update; // *** force display of fm_Splash
      // --------------------------------------------------------------------------
      sMessage := '';
      sMessage := 'Work Dir >> ' + GetCurrentDir;
      AddToLog(sMessage, false, false);
      DEBUGMessEnh(0, UnitName, ProcName, sMessage);
      AddToLog('Loaded from >> ' + Application.ExeName, false, false);
      AddToLog(GetModuleVersionInfo_App, false, false);
      SetProgress(15);
      // --------------------------------------------------------------------------
      sMessage := 'Searching for print module dll...';
      AddToLog(sMessage, true, true);
      DEBUGMessBrk(0, sMessage);
      // Print_DLL_Found := false;
      if _Get_PrintModule_Handle = 0 then
        PrintModuleLoad;
      if _Get_PrintModule_Handle <> 0 then
      begin
        AddToLog('Found at >> ' + _Get_PrintModule_FileName, false, false);
        SetProgress(25);
        AddToLog(GetModuleVersionInfoStr(_Get_PrintModule_FileName), true, false);
        // Print_DLL_Found := true;
      end
      else
      begin
        sMessage := 'Error!!! >> Print module [' + _Get_PrintModule_Name + '] is not found.';
        AddToLog(sMessage, false, false);
        DEBUGMessEnh(0, UnitName, ProcName, sMessage);
        // FormClean(false);
        Application.MessageBox(PChar(sMessage), 'Module load error', MB_ICONERROR);
      end;
      // --------------------------------------------------------------------------
      sMessage := 'Searching for IB/FB client dll...';
      AddToLog(sMessage, true, true);
      DEBUGMessBrk(0, sMessage);
      Client_DLL_Found := false;
      FillChar(aClient_DLL_Path, SizeOf(aClient_DLL_Path), #0);
      BufSize1 := SearchPath(nil, PChar(Def_Client_Lib), nil, SizeOf(aClient_DLL_Path) - 1,
        @aClient_DLL_Path, pClient_DLL_Name);
      if BufSize1 > 0 then
      begin
        if BufSize1 < SizeOf(aClient_DLL_Path) then
        begin
          sClient_DLL_Path := aClient_DLL_Path;
          AddToLog('Found at >> ' + sClient_DLL_Path, false, false);
          SetProgress(35);
          AddToLog(GetModuleVersionInfo_Client_DLL(sClient_DLL_Path), true, false);
          Client_DLL_Found := true;
        end;
      end
      else
      begin
        sMessage := 'Error!!! >> Client library [' + Def_Client_Lib + '] is not found.';
        AddToLog(sMessage, false, false);
        DEBUGMessEnh(0, UnitName, ProcName, sMessage);
        FormClean(false);
        Application.MessageBox(PChar(sMessage), 'Connect error', MB_ICONERROR);
      end;
      // --------------------------------------------------------------------------
      if Client_DLL_Found then
      begin
        sMessage := 'Trying connect to database...';
        AddToLog(sMessage, true, true);
        DEBUGMessBrk(0, sMessage);
        ScrollMemo(true);
        // --------------------------------------------------------------------------
        try
          Application.CreateForm(Tdm_Common, dm_Common);
          sMessage := 'Database path >> ' + dm_Common.DataBase1Path;
          AddToLog(sMessage, true, false);
          DEBUGMessEnh(0, UnitName, ProcName, sMessage);
        except
          dm_Common.Free;
          dm_Common := nil;
        end;
        // --------------------------------------------------------------------------
        if Assigned(dm_Common) then
        begin
          with dm_Common do
            if DataModule1Connected then
            begin
              SetProgress(45);
              sMessage := GetDatabaseVersion(verMajor, verMinor, verRelease, verBuild);
              AddToLog(sMessage, true, false);
              DEBUGMessEnh(0, UnitName, ProcName, sMessage);
              // --------------------------------------------------------------------------
              Time_End := Now;
              DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
              DEBUGMessEnh(0, UnitName, ProcName, 'Init time - (' + IntToStr(Hour) + ':' +
                FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
              // --------------------------------------------------------------------------
              sMessage := 'Creating login form ...';
              AddToLog(sMessage, true, true);
              DEBUGMessBrk(0, sMessage);
              acLoginShowModal(nil);
              SetProgress(55);
              if (Global_User_Kod > 0) and (Global_Session_ID > 0) and
                (Length(Global_Session_Key) > 0) then
              begin
                // --------------------------------------------------------------------------
                try
                  sMessage := 'Creating datamodule ...';
                  AddToLog(sMessage, true, false);
                  DEBUGMessBrk(0, sMessage);
                  Application.CreateForm(Tdm_Base, dm_Base);
                  with dm_Base do
                  begin
                    db_kino2.SQLDialect := db_kino1.SQLDialect;
                    db_kino2.DBName := db_kino1.DatabaseName;
                    db_kino2.DBParams.Clear;
                    db_kino2.ConnectParams.CharSet := db_kino1.ConnectParams.CharSet;
                    db_kino2.ConnectParams.RoleName := Sec_Role_Name;
                    db_kino2.ConnectParams.UserName := Sec_User_Name;
                    db_kino2.ConnectParams.Password := Sec_Password;
                    try
                      db_kino2.Connected := true;
                      SessionLock := false;
                      if LockUserSession(Global_User_Kod, Global_Session_ID, Global_Session_Key,
                        tError_Kod, tError_Text) then
                      begin
                        SessionLock := true;
                        DEBUGMessEnh(0, UnitName, ProcName, 'Session locked for "' + Global_User_Nam
                          + '"');
                      end
                      else
                      begin
                        DEBUGMessEnh(0, UnitName, ProcName, 'Session lock failure for "' +
                          Global_User_Nam + '"');
                        MessageBox(0, PChar('---   Session lock failure   ---' + c_CRLF +
                          'Вроде бы все правильно, но заблокировать сессию не получается.'
                          + c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF
                          + 'Код ошибки = ' + IntToStr(tError_Kod) + ';' + c_CRLF + tError_Text),
                          'Session lock', MB_ICONERROR);
                      end;
                      if not SessionLock then
                        DBLastError2 := 'Session lock failure for "' + Global_User_Nam + '"';
                    except
                      on E: Exception do
                      begin
                        DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
                        DEBUGMessEnh(0, UnitName, ProcName, 'Database connection failed.');
                        DBLastError2 := E.Message;
                      end;
                    end;
                  end;
                  sMessage := 'Datamodule creation done.';
                  AddToLog(sMessage, true, false);
                  DEBUGMessEnh(0, UnitName, ProcName, sMessage);
                except
                  dm_Base.Free;
                  dm_Base := nil;
                end;
                if Assigned(dm_Base) then
                begin
                  with dm_Base do
                    if DataModule2Connected and SessionLock then
                    begin
                      // --------------------------------------------------------------------------
                      if dm_Common.DataModule1Connected then
                      begin
                        dm_Common.db_kino1.Connected := false;
                      end;
                      // --------------------------------------------------------------------------
                      Application.ShowMainForm := false;
                      DEBUGMessEnh(0, UnitName, ProcName, 'Showing mainform ...');
                      Application.CreateForm(Tfm_Main, fm_Main);
                      if Assigned(fm_Main) then
                      begin
                        SetProgress(65);
                        DEBUGMessBrk(0, 'Loading all digests.');
                        fm_Main.LoadDigests(fm_Splash.gg_LoadProgress);
                        SetTimer(1317, true);
                        {
                        Sleep(2000);
                        Application.ProcessMessages;
                        Sleep(5000);
                        Application.ProcessMessages;
                        }
                        Application.MainForm.Visible := true;
                        Application.ShowMainForm := true;
                        // --------------------------------------------------------------------------
                        Time_End := Now;
                        DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
                        DEBUGMessEnh(0, UnitName, ProcName, 'Load time - (' + IntToStr(Hour) + ':' +
                          FixFmt(Min, 2, '0') + ':' + FixFmt(Sec, 2, '0') + '.' +
                          FixFmt(MSec, 3, '0') + ')');
                        // --------------------------------------------------------------------------
                        DEBUGMessBrk(0, 'Let''s run!');
                        DEBUGMessEnh(0, UnitName, ProcName, '...');
                        Application.Run;
                        DEBUGMessEnh(0, UnitName, ProcName, '...');
                        DEBUGMessBrk(0, 'Let''s done!');
                      end
                      else
                      begin
                        sMessage := 'Mainform creation failed.';
                        DEBUGMessEnh(0, UnitName, ProcName, sMessage);
                        Application.MessageBox(PChar('---   Cannot create mainform   ---' + c_CRLF
                          + sMessage), 'Load error', MB_ICONERROR);
                      end;
                    end
                    else
                    begin
                      AddToLog('Error!!! >> Cannot connect to database.', true, false);
                      FormClean(false);
                      ScrollMemo(true);
                      Application.MessageBox(PChar('Не могу подсоединиться к базе. Ошибка такая:'
                        + c_CRLF + c_Separator_20 + c_CRLF + c_CRLF + DBLastError2),
                        'Connect error', MB_ICONERROR);
                    end;
                  // --------------------------------------------------------------------------
                  {
                  DEBUGMessEnh(0, UnitName, ProcName, 'DataModule1Connected = ' +
                    BoolYesNo[dm_Common.DataModule1Connected]);
                  DEBUGMessEnh(0, UnitName, ProcName, 'DataModule2Connected = ' +
                    BoolYesNo[dm_Base.DataModule2Connected]);
                  }
                  FinishUserSession;
                  if dm_Base.DataModule2Connected then
                  begin
                    DEBUGMessEnh(0, UnitName, ProcName, 'DataModule2.Disconnect');
                    dm_Base.db_kino2.Connected := false;
                  end;
                  // --------------------------------------------------------------------------
                end
                else
                begin
                  DBLastError2 := 'Cannot create datamodule (Maybe not enough resources).';
                  sMessage := 'Error!!! >> ' + DBLastError2;
                  AddToLog(sMessage, true, false);
                  DEBUGMessEnh(0, UnitName, ProcName, sMessage);
                  FormClean(false);
                  ScrollMemo(true);
                  Application.MessageBox(PChar('Не могу подсоединиться к базе. Ошибка такая:' +
                    c_CRLF + c_Separator_20 + c_CRLF + c_CRLF + DBLastError2), 'Connect error',
                    MB_ICONERROR);
                end;
              end
              else
                DEBUGMessEnh(0, UnitName, ProcName, 'User escaped.');
            end
            else
            begin
              AddToLog('Error!!! >> Cannot connect to database.', true, false);
              FormClean(false);
              ScrollMemo(true);
              Application.MessageBox(PChar('Не могу подсоединиться к базе. Ошибка такая:' + c_CRLF
                + c_Separator_20 + c_CRLF + c_CRLF + DBLastError1), 'Connect error', MB_ICONERROR);
            end;
          if dm_Common.DataModule1Connected then
          begin
            dm_Common.db_kino1.Connected := false;
          end;
        end
        else
        begin
          DBLastError1 := 'Cannot create datamodule (Maybe wrong client dll).';
          sMessage := 'Error!!! >> ' + DBLastError1;
          AddToLog(sMessage, true, false);
          DEBUGMessEnh(0, UnitName, ProcName, sMessage);
          FormClean(false);
          ScrollMemo(true);
          Application.MessageBox(PChar('Не могу подсоединиться к базе. Ошибка такая:' + c_CRLF +
            c_Separator_20 + c_CRLF + c_CRLF + DBLastError1), 'Connect error', MB_ICONERROR);
        end;
      end;
      // --------------------------------------------------------------------------
    finally
      if Assigned(fm_Splash) then
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Freeing splash ...');
        fm_Splash.Free;
      end;
    end;
    UnmapViewOfFile(HandleData);
  end;
  CloseHandle(hMap);
  // --------------------------------------------------------------------------
  // calculating work time
  // --------------------------------------------------------------------------
  Time_End := Now;
  DecodeTime(Time_End - Time_Start, Hour, Min, Sec, MSec);
  DEBUGMessEnh(0, UnitName, ProcName, 'Total time - (' + IntToStr(Hour) + ':' + FixFmt(Min, 2, '0')
    + ':' + FixFmt(Sec, 2, '0') + '.' + FixFmt(MSec, 3, '0') + ')');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, 'Finish');
  asm
      jmp @@loc
      db $90, $90, $90, $90, $90, $90, $90, $90
      db $0D, $0A, '#-Sign4U-#', $0D, $0A, 0
      db 'Main()', 0
      db 'End here', $0D, $0A, 0
      db $90, $90, $90, $90, $90, $90, $90, $90
    @@loc:
  end;
end.

