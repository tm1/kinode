{-----------------------------------------------------------------------------
 Unit Name: uhCommon
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  19.04.2004
 Purpose:   DB datamodule helper
 History:
-----------------------------------------------------------------------------}
unit uhCommon;

interface

{$I kinode01.inc}

uses
  Classes, Db;

type
  TCombo_Load_HandleProcEx = function(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string; var
    _Kod: integer; var _Nam: string; PointerToData: Pointer): Boolean;

  // -----------------------------------------------------------------------------
function LoadFromMemListInt(const str_ParamName: string; const int_DefaultValue:
  integer; var int_ParamValue: integer): boolean;
function LoadFromMemListStr(const str_ParamName: string; const str_DefaultValue:
  string; var str_ParamValue: string): boolean;
function SaveToMemListStr(const str_ParamName, str_ParamValue: string): boolean;
// -----------------------------------------------------------------------------
function LoadDatabaseParameters(var SQLDialect: integer; var DatabaseName, CharSet, RoleName,
  UserName, Password: string): boolean;
function SaveDatabaseParameters(const SQLDialect: integer; const DatabaseName, CharSet, RoleName,
  UserName, Password: string): boolean;
// -----------------------------------------------------------------------------
function LoadInitParameterStr(const str_SectionName, str_ParamName, str_DefaultValue: string;
  var str_ParamValue: string): boolean;
function LoadInitParameterInt(const str_SectionName, str_ParamName: string; const int_DefaultValue:
  integer; var int_ParamValue: integer): boolean;
function SaveInitParameter(const str_SectionName, str_ParamName, str_ParamValue: string): boolean;
// -----------------------------------------------------------------------------
function GetHostInfoEx(var HostName: string; var HostAddress: string; var
  HostAddr: LongInt): boolean;
function GetHostInfo: string;
// -----------------------------------------------------------------------------
function LoadLastUser(var UserKod: integer; var UserName: string): boolean;
function SaveLastUser(const UserKod: integer; const UserName: string): boolean;
// -----------------------------------------------------------------------------
function GetModuleVersionStr_App: string;
function GetModuleVersionInfo_App: string;
function GetModuleVersionInfo_Client_DLL(const ModuleName: string): string;
// -----------------------------------------------------------------------------
function AuthenticateUser(const DBUser_Code: integer; const DBUser_Name, DBUser_Password: string;
  var Session_ID: Int64; var Error_Kod: Integer; var Error_Text: string): boolean;
function LockUserSession(const DBUser_Code: integer; const Session_ID: Int64; const Session_Key:
  string; var Error_Kod: Integer; var Error_Text: string): boolean;
function CloseActiveDatasets: boolean;
function FinishUserSession: boolean;
// -----------------------------------------------------------------------------
function Combo_Load_DataSet(DataSet: TDataSet; Lines: TStrings; s_DataSet_Kod, s_DataSet_Nam:
  string; Combo_Load_HandleProc: TCombo_Load_HandleProcEx;
  PointerToData: Pointer): integer; // Цикл загрузки записей из запроса
// -----------------------------------------------------------------------------
//function Combo_Load_Film(DataSet: TDataSet; Lines: TStrings): integer;
//function Combo_Load_Genre(DataSet: TDataSet; Lines: TStrings): integer;
function Combo_Load_Repert(DataSet: TDataSet; Lines: TStrings): integer;
//function Combo_Load_Seans(DataSet: TDataSet; Lines: TStrings): integer;
//function Combo_Load_Tarif(DataSet: TDataSet; Lines: TStrings): integer;
//function Combo_Load_Ticket(DataSet: TDataSet; Lines: TStrings): integer;
// -----------------------------------------------------------------------------
function Combo_Load_DBUser(DataSet: TDataSet; Lines: TStrings): integer;
function Combo_Load_Zal(DataSet: TDataSet; Lines: TStrings): integer;
function Combo_Load_Tariff(DataSet: TDataSet; Lines: TStrings): integer;
function Combo_Load_Globalvar(DataSet: TDataSet; Lines: TStrings): integer;
//function Combo_Load_Rate(DataSet: TDataSet; Lines: TStrings): integer;
// -----------------------------------------------------------------------------
//function Combo_Load_Cost_Desc(DataSet: TDataSet; Lines: TStrings): integer;
// Загрузка типов билетов из запроса
//function Combo_Load_Ticket_Desc(DataSet: TDataSet; Lines: TStrings): integer;
// Загрузка типов билетов из запроса
//function Combo_Load_Zal_Map(DataSet: TDataSet; Lines: TStrings): integer;
// Загрузка залов из запроса
// -----------------------------------------------------------------------------
function fchp_DataSet(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string;
  var _Kod: integer; var _Nam: string; PointerToData: Pointer): Boolean;
// -----------------------------------------------------------------------------
//function fchp_Cost_Desc(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string;
//  var _Kod: integer; var _Nam: string): boolean;
//function fchp_Ticket_Desc(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam:
//  string; var _Kod: integer; var _Nam: string): boolean;
//function fchp_Zal_Map(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string;
//  var _Kod: integer; var _Nam: string): boolean;
// -----------------------------------------------------------------------------
function TestDBConnect: Boolean;
// -----------------------------------------------------------------------------
function CreateTariffVersion(const Tariff_Kod: integer; var Tariff_Ver: Integer;
  var Error_Kod: Integer; var Error_Text: string): boolean;
// -----------------------------------------------------------------------------

implementation

uses
  Bugger, IniFiles, SysUtils, Forms, udCommon, urCommon, udBase, strConsts,
  THostInfoUnit, uhGetver, uTools, FIBDataset;

const
  UnitName: string = 'uhCommon';

var
  MemList_Pref: TStringList;

function LoadFromMemListInt(const str_ParamName: string; const int_DefaultValue:
  integer; var int_ParamValue: integer): boolean;
var
  tmp_str: string;  
begin
  Result := false;
  int_ParamValue := int_DefaultValue;
  if Assigned(MemList_Pref) then
  begin
    tmp_str := MemList_Pref.Values[str_ParamName];
    if Length(tmp_str) > 0 then
    begin
      try
        int_ParamValue := StrToInt(tmp_str);
        Result := true;
      except
      end;
    end;
  end;
end;

function LoadFromMemListStr(const str_ParamName: string; const str_DefaultValue:
  string; var str_ParamValue: string): boolean;
var
  tmp_str: string;  
begin
  Result := false;
  str_ParamValue := str_DefaultValue;
  if Assigned(MemList_Pref) then
  begin
    tmp_str := MemList_Pref.Values[str_ParamName];
    if Length(tmp_str) > 0 then
    begin
      str_ParamValue := tmp_str;
      Result := true;
    end;
  end;
end;

function SaveToMemListStr(const str_ParamName, str_ParamValue: string): boolean;
begin
  Result := false;
  if Assigned(MemList_Pref) then
  begin
    MemList_Pref.Values[str_ParamName] := str_ParamValue;
  end;
end;

function LoadDatabaseParameters(var SQLDialect: integer; var DatabaseName, CharSet, RoleName,
  UserName, Password: string): boolean;
const
  ProcName: string = 'LoadDatabaseParameters';
  sErrorParam: string = '<Error>';
var
  IniFile: TIniFile;
  sIniFileName: string;
  LineReadError: Boolean;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  LineReadError := false;
  sIniFileName := ExtractFilePath(ParamStr(0)) + Ini_File_Name;
  IniFile := TIniFile.Create(sIniFileName);
  try
    SQLDialect := IniFile.ReadInteger(s_Database_Section, s_SQLDialect, -1);
    if SQLDialect <> Def_SQLDialect then
    begin
      SQLDialect := Def_SQLDialect;
      LineReadError := true;
    end;
    DEBUGMessEnh(0, UnitName, ProcName, s_SQLDialect + ' = ' + IntToStr(SQLDialect));
    DatabaseName := IniFile.ReadString(s_Database_Section, s_DatabaseName, sErrorParam);
    if DatabaseName = sErrorParam then
    begin
      DatabaseName := Def_DatabaseName;
      LineReadError := true;
    end;
    DEBUGMessEnh(0, UnitName, ProcName, s_DatabaseName + ' = (' + DatabaseName + ')');
    CharSet := IniFile.ReadString(s_Database_Section, s_CharSet, sErrorParam);
    if CharSet = sErrorParam then
    begin
      CharSet := Def_CharSet;
      LineReadError := true;
    end;
    DEBUGMessEnh(0, UnitName, ProcName, s_CharSet + ' = (' + CharSet + ')');
    RoleName := IniFile.ReadString(s_Database_Section, s_RoleName, sErrorParam);
    if RoleName = sErrorParam then
    begin
      RoleName := Def_RoleName;
      LineReadError := true;
    end;
    DEBUGMessEnh(0, UnitName, ProcName, s_RoleName + ' = (' + RoleName + ')');
    UserName := IniFile.ReadString(s_Database_Section, s_UserName, sErrorParam);
    if UserName = sErrorParam then
    begin
      UserName := Def_UserName;
      LineReadError := true;
    end;
    DEBUGMessEnh(0, UnitName, ProcName, s_UserName + ' = (' + UserName + ')');
    Password := IniFile.ReadString(s_Database_Section, s_Password, sErrorParam);
    if Password = sErrorParam then
    begin
      Password := Def_Password;
      LineReadError := true;
    end;
    // DEBUGMessEnh(0, UnitName, ProcName, s_Password + ' = (' + Password + ')');
    DEBUGMessEnh(0, UnitName, ProcName, s_Password + ' = (' + s_SECRET + ')');
  finally
    IniFile.Free;
  end;
  {
  Def_DatabaseName = 'localhost/3051:C:\FB_DATA\kappa.fdb';
  Def_CharSet = 'WIN1251';
  Def_RoleName = 'CASHIER';
  Def_UserName = 'CASHIER001';
  Def_Password = 'secondarykey';
  }
  Result := LineReadError;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function SaveDatabaseParameters(const SQLDialect: integer; const DatabaseName, CharSet, RoleName,
  UserName, Password: string): boolean;
const
  ProcName: string = 'SaveDatabaseParameters';
var
  IniFile: TIniFile;
  sIniFileName: string;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  sIniFileName := ExtractFilePath(ParamStr(0)) + Ini_File_Name;
  IniFile := TIniFile.Create(sIniFileName);
  try
    IniFile.WriteInteger(s_Database_Section, s_SQLDialect, SQLDialect);
    IniFile.WriteString(s_Database_Section, s_DatabaseName, DatabaseName);
    IniFile.WriteString(s_Database_Section, s_CharSet, CharSet);
    IniFile.WriteString(s_Database_Section, s_RoleName, RoleName);
    IniFile.WriteString(s_Database_Section, s_UserName, UserName);
    IniFile.WriteString(s_Database_Section, s_Password, Password);
    DEBUGMessEnh(0, UnitName, ProcName, 'DB params saved.');
  finally
    IniFile.Free;
  end;
  Result := true;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function LoadInitParameterStr(const str_SectionName, str_ParamName, str_DefaultValue: string;
  var str_ParamValue: string): boolean;
const
  ProcName: string = 'LoadInitParameterStr';
  sErrorParam: string = '<Error>';
var
  IniFile: TIniFile;
  sIniFileName: string;
  LineReadError: Boolean;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  LineReadError := false;
  sIniFileName := ExtractFilePath(ParamStr(0)) + Ini_File_Name;
  IniFile := TIniFile.Create(sIniFileName);
  try
    str_ParamValue := IniFile.ReadString(str_SectionName, str_ParamName, sErrorParam);
    if str_ParamValue = sErrorParam then
    begin
      str_ParamValue := str_DefaultValue;
      LineReadError := true;
    end;
    DEBUGMessEnh(0, UnitName, ProcName, 'Section = [' + str_SectionName + '], Param = (' +
      str_ParamName + '), Value = "' + str_ParamValue + '"');
  finally
    IniFile.Free;
  end;
  Result := not LineReadError;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function LoadInitParameterInt(const str_SectionName, str_ParamName: string; const int_DefaultValue:
  integer; var int_ParamValue: integer): boolean;
const
  ProcName: string = 'LoadInitParameterInt';
  iErrorParam: integer = -1;
var
  IniFile: TIniFile;
  sIniFileName: string;
  LineReadError: Boolean;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  LineReadError := false;
  sIniFileName := ExtractFilePath(ParamStr(0)) + Ini_File_Name;
  IniFile := TIniFile.Create(sIniFileName);
  try
    int_ParamValue := IniFile.ReadInteger(str_SectionName, str_ParamName, iErrorParam);
    if int_ParamValue = iErrorParam then
    begin
      int_ParamValue := int_DefaultValue;
      LineReadError := true;
    end;
    DEBUGMessEnh(0, UnitName, ProcName, 'Section = [' + str_SectionName + '], Param = (' +
      str_ParamName + '), Value = ' + IntToStr(int_ParamValue) + '');
  finally
    IniFile.Free;
  end;
  Result := not LineReadError;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function SaveInitParameter(const str_SectionName, str_ParamName, str_ParamValue: string): boolean;
const
  ProcName: string = 'SaveInitParameter';
var
  IniFile: TIniFile;
  sIniFileName: string;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  sIniFileName := ExtractFilePath(ParamStr(0)) + Ini_File_Name;
  IniFile := TIniFile.Create(sIniFileName);
  try
    IniFile.WriteString(str_SectionName, str_ParamName, str_ParamValue);
    DEBUGMessEnh(0, UnitName, ProcName, 'Section = [' + str_SectionName + '], Param = (' +
      str_ParamName + '), Value = "' + str_ParamValue + '"');
  finally
    IniFile.Free;
  end;
  Result := true;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function GetHostInfoEx(var HostName: string; var HostAddress: string; var
  HostAddr: LongInt): boolean;
const
  ProcName: string = 'GetHostInfoEx';
var
  HostInfo: THostInfo;
begin
  HostName := 'localhost';
  HostAddress := '127.0.0.1';
  HostAddr := 0;
  Result := false;
  try
    HostInfo := THostInfo.Create;
    if HostInfo.Initialize then
    begin
      HostName := HostInfo.HostName;
      HostAddress := HostInfo.HostAddress;
      HostAddr := HostInfo.HostAddr;
      Result := true;
      DEBUGMessEnh(0, UnitName, ProcName, 'HostName = (' + HostName + ')');
      DEBUGMessEnh(0, UnitName, ProcName, 'HostAddress = [' + HostAddress + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'HostAddr = ' + IntToHex1(HostAddr, 8));
    end;
  except
    DEBUGMessEnh(0, UnitName, ProcName, 'Cannot get hostinfo.');
  end;
end;

function GetHostInfo: string;
const
  ProcName: string = 'GetHostInfo';
var
  HostName: string;
  HostAddress: string;
  HostAddr: LongInt;
begin
  if GetHostInfoEx(HostName, HostAddress, HostAddr) then
    Result := '(' + HostName + ') [' + HostAddress + ']'
  else
    Result := 'unknown remote host';
end;

function LoadLastUser(var UserKod: integer; var UserName: string): boolean;
const
  ProcName: string = 'LoadLastUser';
var
  IniFile: TIniFile;
  sIniFileName: string;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  sIniFileName := ExtractFilePath(ParamStr(0)) + Ini_File_Name;
  IniFile := TIniFile.Create(sIniFileName);
  try
    UserKod := IniFile.ReadInteger(s_LastUser, s_UserKod, Def_UserKod);
    if UserKod <> Def_UserKod then
      UserKod := Def_UserKod;
    DEBUGMessEnh(0, UnitName, ProcName, s_UserKod + ' = ' + IntToStr(UserKod));
    UserName := IniFile.ReadString(s_LastUser, s_UserName, Def_UserName);
    DEBUGMessEnh(0, UnitName, ProcName, s_UserName + ' = (' + UserName + ')');
  finally
    IniFile.Free;
  end;
  {
  UserKod := 2;
  UserName := 'Operator';
  }
  Result := true;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function SaveLastUser(const UserKod: integer; const UserName: string): boolean;
const
  ProcName: string = 'SaveLastUser';
var
  IniFile: TIniFile;
  sIniFileName: string;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  sIniFileName := ExtractFilePath(ParamStr(0)) + Ini_File_Name;
  IniFile := TIniFile.Create(sIniFileName);
  try
    IniFile.WriteInteger(s_LastUser, s_UserKod, UserKod);
    IniFile.WriteString(s_LastUser, s_UserName, UserName);
    DEBUGMessEnh(0, UnitName, ProcName, 'Last user params saved.');
  finally
    IniFile.Free;
  end;
  Result := true;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function GetModuleVersionStr_App: string;
begin
  if (not App_Version_Checked) then
    GetModuleVersionInfo_App;
  Result := '"' + sApp_ProductName + '", (' + sApp_ProductVersion + '), [' + sApp_FileVersion + ']';
end;

function GetModuleVersionInfo_App: string;
begin
  Result := GetModuleVersionInfo(Application.ExeName, sApp_ProductName, sApp_ProductVersion,
    sApp_FileVersion);
  App_Version_Checked := true;
end;

function GetModuleVersionStr_Client_DLL: string;
begin
  if (not Client_DLL_Version_Checked) then
    GetModuleVersionInfo_Client_DLL(sClient_DLL_Path);
  Result := '"' + sClient_DLL_ProductName + '", (' + sClient_DLL_ProductVersion + '), [' +
    sClient_DLL_FileVersion + ']';
end;

function GetModuleVersionInfo_Client_DLL(const ModuleName: string): string;
begin
  Result := GetModuleVersionInfo(ModuleName, sClient_DLL_ProductName,
    sClient_DLL_ProductVersion, sClient_DLL_FileVersion);
  Client_DLL_Version_Checked := true;
end;

function AuthenticateUser(const DBUser_Code: integer; const DBUser_Name, DBUser_Password: string;
  var Session_ID: Int64; var Error_Kod: Integer; var Error_Text: string): boolean;
const
  ProcName: string = 'AuthenticateUser';
  s_HostInfo: string = 'unknown remote host';
var
  var_Error_Kod: Integer;
  var_Error_Text: string;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  Result := false;
  Session_ID := 0;
  Error_Kod := -1;
  with dm_Common.sp_Session_Start do
  try
    if Assigned(dm_Common) and Assigned(dm_Common.sp_Session_Start) then
    begin
      ParamCheck := true;
      StoredProcName := '';
      StoredProcName := s_IP_SESSION_START;
      // ------------ Setting params ------------
      if Assigned(Params.FindParam(s_USER_UID)) then
        ParamByName(s_USER_UID).AsInteger := DBUser_Code;
      // ------------
      if Assigned(Params.FindParam(s_USER_KEY)) then
        ParamByName(s_USER_KEY).AsString := DBUser_Password;
      // ------------
      s_HostInfo := GetHostInfo;
      if Assigned(Params.FindParam(s_USER_HOST)) then
        ParamByName(s_USER_HOST).AsString := s_HostInfo;
      // ------------
      if Assigned(Params.FindParam(s_USER_PROG)) then
        ParamByName(s_USER_PROG).AsString := GetModuleVersionStr_App;
      // ------------
      if Assigned(Params.FindParam(s_USER_CLIENT)) then
        ParamByName(s_USER_CLIENT).AsString := GetModuleVersionStr_Client_DLL;
      // ------------
      DEBUGMessEnh(0, UnitName, ProcName, s_USER_UID + ' = ' + IntToStr(DBUser_Code));
      DEBUGMessEnh(0, UnitName, ProcName, s_USER_KEY + ' = ' + s_SECRET {DBUser_Password});
      DEBUGMessEnh(0, UnitName, ProcName, s_USER_HOST + ' = ' + s_HostInfo);
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      Prepare;
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.TRParams = (' + Transaction.TRParams.CommaText
        + ')');
      ExecProc;
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      // ------------ Returning params ------------
      Global_User_Kod := DBUser_Code;
      Global_User_Nam := DBUser_Name;
      // ------------
      Session_ID := 0;
      try
        if Assigned(FieldByName[s_SESSION_SID]) then
          Session_ID := FieldByName[s_SESSION_SID].AsInt64;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_SESSION_SID +
            ') is failed.');
        end;
      end;
      // ------------
      Global_Session_Key := '';
      try
        if Assigned(FN(s_SESSION_KEY)) then
          Global_Session_Key := FieldByName[s_SESSION_KEY].AsString;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_SESSION_KEY +
            ') is failed.');
        end;
      end;
      // ------------
      Sec_Role_Name := '';
      try
        if Assigned(FN(s_ROLE_NAME)) then
          Sec_Role_Name := FieldByName[s_ROLE_NAME].AsString;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_ROLE_NAME +
            ') is failed.');
        end;
      end;
      // ------------
      Sec_User_Name := '';
      try
        if Assigned(FN(s_USER_NAME)) then
          Sec_User_Name := FieldByName[s_USER_NAME].AsString;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_USER_NAME +
            ') is failed.');
        end;
      end;
      // ------------
      Sec_Password := dm_Common.db_kino1.ConnectParams.Password;
      // ------------
      var_Error_Kod := 0;
      try
        if Assigned(FieldByName[s_ERROR_ID]) then
          var_Error_Kod := FieldByName[s_ERROR_ID].AsInteger;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_ERROR_ID +
            ') is failed.');
        end;
      end;
      Error_Kod := var_Error_Kod;
      DEBUGMessEnh(0, UnitName, ProcName, s_ERROR_ID + ' = ' + IntToStr(var_Error_Kod));
      // ------------
      var_Error_Text := '-*-';
      try
        if Assigned(FieldByName[s_ERROR_TEXT]) then
          var_Error_Text := FieldByName[s_ERROR_TEXT].AsString;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_ERROR_TEXT +
            ') is failed.');
        end;
      end;
      Error_Text := var_Error_Text;
      DEBUGMessEnh(0, UnitName, ProcName, s_ERROR_TEXT + ' = ' + var_Error_Text);
      // ------------
      DEBUGMessEnh(0, UnitName, ProcName, s_SESSION_SID + ' = ' + IntToStr(Session_ID));
      if (var_Error_Kod = 0) and (Session_ID > 0) and (Length(Global_Session_Key) > 0) then
        Result := true;
      // ------------ Check done ------------
    end;
  except
    on E: Exception do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'Exception during call to stored proc (' + StoredProcName
        + ').');
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      DBLastError1 := E.Message;
      Error_Text := E.Message;
    end;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function LockUserSession(const DBUser_Code: integer; const Session_ID: Int64; const Session_Key:
  string; var Error_Kod: Integer; var Error_Text: string): boolean;
const
  ProcName: string = 'LockUserSession';
var
  var_Error_Kod: Integer;
  var_Error_Text: string;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  Result := false;
  Error_Kod := -1;
  with dm_Common.sp_Session_Finish do
  try
    // ------------ Transaction check start ------------
    DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' +
      BoolYesNo[Transaction.Active]);
    DEBUGMessEnh(0, UnitName, ProcName, Database.Name + '.Connected = ' +
      BoolYesNo[Database.Connected]);
    if Transaction.Active then
    try
      try
        if Database.Connected then
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Doing Transaction.Commit');
          Transaction.Commit;
        end
        else
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Doing Transaction.Rollback');
          Transaction.Rollback;
        end;
      except
        if Transaction.Active then
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Except Transaction.Rollback');
          Transaction.Rollback;
        end;
      end;
    except
      on E: Exception do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
        DEBUGMessEnh(0, UnitName, ProcName, 'Exception during stored proc (' + StoredProcName
          + ') transaction commit.');
        DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' +
          BoolYesNo[Transaction.Active]);
        DBLastError1 := E.Message;
      end;
    end;
    // ------------ Transaction check done ------------
    if Assigned(dm_Common) and Assigned(dm_Common.sp_Session_Finish) then
    begin
      // ------------ Connection check start ------------
      DEBUGMessEnh(0, UnitName, ProcName, 'DataModule1Connected = ' +
        BoolYesNo[dm_Common.DataModule1Connected]);
      DEBUGMessEnh(0, UnitName, ProcName, 'DataModule2Connected = ' +
        BoolYesNo[dm_Base.DataModule2Connected]);
      if dm_Base.DataModule2Connected then
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Change owner database to db_kino2.');
        Transaction := nil;
        Database := dm_Base.db_kino2;
        Transaction := dm_Base.tr_Session_Finish2;
      end
      else if dm_Common.DataModule1Connected then
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Change owner database to db_kino1.');
        Transaction := nil;
        Database := dm_Common.db_kino1;
        Transaction := dm_Common.tr_Session_Finish1;
      end
      else
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'No connection is available.');
        Transaction := nil;
        Database := nil;
      end;
      // ------------ Connection check done ------------
      if (Transaction <> nil) and (Database = dm_Base.db_kino2) then
      begin
        ParamCheck := true;
        StoredProcName := '';
        StoredProcName := s_IP_SESSION_FINISH;
        // ------------
        // Lock: First step
        // ------------
        if Assigned(Params.FindParam(s_USER_UID)) then
          ParamByName(s_USER_UID).AsInteger := Global_User_Kod;
        // ------------
        if Assigned(Params.FindParam(s_SESSION_SID)) then
          ParamByName(s_SESSION_SID).AsInt64 := Global_Session_ID;
        // ------------
        if Assigned(Params.FindParam(s_LOCK_FLAG)) then
          ParamByName(s_LOCK_FLAG).AsInteger := 1;
        // ------------
        if Assigned(Params.FindParam(s_SESSION_KEY)) then
          ParamByName(s_SESSION_KEY).AsString := Global_Session_Key;
        // ------------
        DEBUGMessEnh(0, UnitName, ProcName, s_USER_UID + ' = ' + IntToStr(Global_User_Kod));
        DEBUGMessEnh(0, UnitName, ProcName, s_SESSION_SID + ' = ' + IntToStr(Global_Session_ID));
        if Assigned(Params.FindParam(s_LOCK_FLAG)) then
          DEBUGMessEnh(0, UnitName, ProcName, s_LOCK_FLAG + ' = ' +
            ParamByName(s_LOCK_FLAG).AsString);
        DEBUGMessEnh(0, UnitName, ProcName, s_SESSION_KEY + ' = ' + s_SECRET {Global_Session_Key});
        DEBUGMessEnh(0, UnitName, ProcName, 'Doing Transaction.StartTransaction');
        DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.TRParams = (' +
          Transaction.TRParams.CommaText + ')');
        Transaction.StartTransaction;
        Prepare;
        ExecProc;
        DEBUGMessEnh(0, UnitName, ProcName, 'Doing Transaction.Commit');
        Transaction.Commit;
        // ------------
        var_Error_Kod := 0;
        try
          if Assigned(FieldByName[s_ERROR_ID]) then
            var_Error_Kod := FieldByName[s_ERROR_ID].AsInteger;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_ERROR_ID +
              ') is failed.');
          end;
        end;
        Error_Kod := var_Error_Kod;
        DEBUGMessEnh(0, UnitName, ProcName, s_ERROR_ID + ' = ' + IntToStr(var_Error_Kod));
        // ------------
        var_Error_Text := '-*-';
        try
          if Assigned(FieldByName[s_ERROR_TEXT]) then
            var_Error_Text := FieldByName[s_ERROR_TEXT].AsString;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_ERROR_TEXT +
              ') is failed.');
          end;
        end;
        Error_Text := var_Error_Text;
        DEBUGMessEnh(0, UnitName, ProcName, s_ERROR_TEXT + ' = ' + var_Error_Text);
        // ------------
        // Lock: Second step
        // ------------
        if Assigned(Params.FindParam(s_USER_UID)) then
          ParamByName(s_USER_UID).AsInteger := Global_User_Kod;
        // ------------
        if Assigned(Params.FindParam(s_SESSION_SID)) then
          ParamByName(s_SESSION_SID).AsInt64 := Global_Session_ID;
        // ------------
        if Assigned(Params.FindParam(s_LOCK_FLAG)) then
          ParamByName(s_LOCK_FLAG).AsInteger := 2;
        // ------------
        if Assigned(Params.FindParam(s_SESSION_KEY)) then
          ParamByName(s_SESSION_KEY).AsString := Global_Session_Key;
        // ------------
        DEBUGMessEnh(0, UnitName, ProcName, s_USER_UID + ' = ' + IntToStr(Global_User_Kod));
        DEBUGMessEnh(0, UnitName, ProcName, s_SESSION_SID + ' = ' + IntToStr(Global_Session_ID));
        if Assigned(Params.FindParam(s_LOCK_FLAG)) then
          DEBUGMessEnh(0, UnitName, ProcName, s_LOCK_FLAG + ' = ' +
            ParamByName(s_LOCK_FLAG).AsString);
        DEBUGMessEnh(0, UnitName, ProcName, s_SESSION_KEY + ' = ' + s_SECRET {Global_Session_Key});
        DEBUGMessEnh(0, UnitName, ProcName, 'Doing Transaction.StartTransaction');
        DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.TRParams = (' +
          Transaction.TRParams.CommaText + ')');
        Transaction.StartTransaction;
        Prepare;
        ExecProc;
        DEBUGMessEnh(0, UnitName, ProcName, 'Skiping Transaction.Commit');
        DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' +
          BoolYesNo[Transaction.Active]);
        // ------------
        var_Error_Kod := 0;
        try
          if Assigned(FieldByName[s_ERROR_ID]) then
            var_Error_Kod := FieldByName[s_ERROR_ID].AsInteger;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_ERROR_ID +
              ') is failed.');
          end;
        end;
        Error_Kod := var_Error_Kod;
        DEBUGMessEnh(0, UnitName, ProcName, s_ERROR_ID + ' = ' + IntToStr(var_Error_Kod));
        // ------------
        var_Error_Text := '-*-';
        try
          if Assigned(FieldByName[s_ERROR_TEXT]) then
            var_Error_Text := FieldByName[s_ERROR_TEXT].AsString;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_ERROR_TEXT +
              ') is failed.');
          end;
        end;
        Error_Text := var_Error_Text;
        DEBUGMessEnh(0, UnitName, ProcName, s_ERROR_TEXT + ' = ' + var_Error_Text);
        // ------------
        if var_Error_Kod = 0 then
          Result := true;
      end
      else
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'OwnerDatabase.Name is [' + Database.Name +
          ']. Need db_kino2 for lock.');
      end;
    end;
  except
    on E: Exception do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'Exception during call to stored proc (' + StoredProcName
        + ').');
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      DBLastError1 := E.Message;
      Error_Text := E.Message;
    end;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function CloseActiveDatasets: boolean;
const
  ProcName: string = 'CloseActiveDatasets';
var
  i: Integer;
  ds: TFIBDataset;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  Result := false;
  if Assigned(dm_Common) and Assigned(dm_Common.db_kino1) and dm_Common.db_kino1.Connected then
  begin
    // dm_Common.db_kino1.CloseDataSets;
    with dm_Common.db_kino1 do
      for i := Pred(DataSetCount) downto 0 do
      begin
        if DataSets[i] <> nil then
          if (DataSets[i].Owner is TFIBDataSet) then
          begin
            ds := TFIBDataSet(DataSets[i].Owner);
            try
              DEBUGMessEnh(0, UnitName, ProcName, ds.Name + '.Active = ' + c_Boolean[ds.Active]);
              if ds.Active then
              begin
                DEBUGMessEnh(0, UnitName, ProcName, ds.Name + ' is active. Closing...');
                ds.Close;
              end;
              // TFIBDataSet(DataSets[i].Owner).Close;
            except
              DEBUGMessEnh(0, UnitName, ProcName, 'Error during ' + ds.Name + ' close...');
            end;
          end;
      end;
  end;
  // --------------------------------------------------------------------------
  if Assigned(dm_Base) and Assigned(dm_Base.db_kino2) and dm_Base.db_kino2.Connected then
  begin
    // dm_Base.db_kino2.CloseDataSets;
    with dm_Base.db_kino2 do
      for i := Pred(DataSetCount) downto 0 do
      begin
        if DataSets[i] <> nil then
          if (DataSets[i].Owner is TFIBDataSet) then
          begin
            ds := TFIBDataSet(DataSets[i].Owner);
            try
              DEBUGMessEnh(0, UnitName, ProcName, ds.Name + '.Active = ' + c_Boolean[ds.Active]);
              if ds.Active then
              begin
                DEBUGMessEnh(0, UnitName, ProcName, ds.Name + ' is active. Closing...');
                ds.Close;
              end;
              // TFIBDataSet(DataSets[i].Owner).Close;
            except
              DEBUGMessEnh(0, UnitName, ProcName, 'Error during ' + ds.Name + ' close...');
            end;
          end;
      end;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function FinishUserSession: boolean;
const
  ProcName: string = 'FinishUserSession';
var
  var_Error_Kod: Integer;
  var_Error_Text: string;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  Result := CloseActiveDatasets;
  with dm_Common.sp_Session_Finish do
  try
    // ------------ Transaction check start ------------
    DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' +
      BoolYesNo[Transaction.Active]);
    DEBUGMessEnh(0, UnitName, ProcName, Database.Name + '.Connected = ' +
      BoolYesNo[Database.Connected]);
    if Transaction.Active then
    try
      try
        if Database.Connected then
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Doing Transaction.Commit');
          Transaction.Commit;
        end
        else
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Doing Transaction.Rollback');
          Transaction.Rollback;
        end;
      except
        if Transaction.Active then
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Except Transaction.Rollback');
          Transaction.Rollback;
        end;
      end;
    except
      on E: Exception do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
        DEBUGMessEnh(0, UnitName, ProcName, 'Exception during stored proc (' + StoredProcName
          + ') transaction commit.');
        DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' +
          BoolYesNo[Transaction.Active]);
        DBLastError1 := E.Message;
      end;
    end;
    // ------------ Transaction check done ------------
    if Assigned(dm_Common) and Assigned(dm_Common.sp_Session_Finish) then
    begin
      // ------------ Connection check start ------------
      DEBUGMessEnh(0, UnitName, ProcName, 'DataModule1Connected = ' +
        BoolYesNo[dm_Common.DataModule1Connected]);
      DEBUGMessEnh(0, UnitName, ProcName, 'DataModule2Connected = ' +
        BoolYesNo[dm_Base.DataModule2Connected]);
      if dm_Base.DataModule2Connected then
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Change owner database to db_kino2.');
        Transaction := nil;
        Database := dm_Base.db_kino2;
        Transaction := dm_Base.tr_Session_Finish2;
      end
      else if dm_Common.DataModule1Connected then
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Change owner database to db_kino1.');
        Transaction := nil;
        Database := dm_Common.db_kino1;
        Transaction := dm_Common.tr_Session_Finish1;
      end
      else
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'No connection is available.');
        Transaction := nil;
        Database := nil;
      end;
      // ------------ Connection check done ------------
      if Transaction <> nil then
      begin
        ParamCheck := true;
        StoredProcName := '';
        StoredProcName := s_IP_SESSION_FINISH;
        // ------------
        if Assigned(Params.FindParam(s_USER_UID)) then
          ParamByName(s_USER_UID).AsInteger := Global_User_Kod;
        // ------------
        if Assigned(Params.FindParam(s_SESSION_SID)) then
          ParamByName(s_SESSION_SID).AsInt64 := Global_Session_ID;
        // ------------
        if Assigned(Params.FindParam(s_LOCK_FLAG)) then
          ParamByName(s_LOCK_FLAG).AsInteger := 3;
        // ------------
        if Assigned(Params.FindParam(s_SESSION_KEY)) then
          ParamByName(s_SESSION_KEY).AsString := Global_Session_Key;
        // ------------
        DEBUGMessEnh(0, UnitName, ProcName, s_USER_UID + ' = ' + IntToStr(Global_User_Kod));
        DEBUGMessEnh(0, UnitName, ProcName, s_SESSION_SID + ' = ' + IntToStr(Global_Session_ID));
        if Assigned(Params.FindParam(s_LOCK_FLAG)) then
          DEBUGMessEnh(0, UnitName, ProcName, s_LOCK_FLAG + ' = ' +
            ParamByName(s_LOCK_FLAG).AsString);
        DEBUGMessEnh(0, UnitName, ProcName, s_SESSION_KEY + ' = ' + s_SECRET {Global_Session_Key});
        DEBUGMessEnh(0, UnitName, ProcName, 'Doing Transaction.StartTransaction');
        DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.TRParams = (' +
          Transaction.TRParams.CommaText + ')');
        Transaction.StartTransaction;
        Prepare;
        ExecProc;
        DEBUGMessEnh(0, UnitName, ProcName, 'Doing Transaction.Commit');
        Transaction.Commit;
        // ------------
        var_Error_Kod := 0;
        try
          if Assigned(FieldByName[s_ERROR_ID]) then
            var_Error_Kod := FieldByName[s_ERROR_ID].AsInteger;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_ERROR_ID +
              ') is failed.');
          end;
        end;
        // Error_Kod := var_Error_Kod;
        DEBUGMessEnh(0, UnitName, ProcName, s_ERROR_ID + ' = ' + IntToStr(var_Error_Kod));
        // ------------
        var_Error_Text := '-*-';
        try
          if Assigned(FieldByName[s_ERROR_TEXT]) then
            var_Error_Text := FieldByName[s_ERROR_TEXT].AsString;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_ERROR_TEXT +
              ') is failed.');
          end;
        end;
        // Error_Text := var_Error_Text;
        DEBUGMessEnh(0, UnitName, ProcName, s_ERROR_TEXT + ' = ' + var_Error_Text);
        // ------------
        if var_Error_Kod = 0 then
          Result := true;
      end
      else
      begin
        // Error_Text := 'No connection is available.';
      end;
    end;
  except
    on E: Exception do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'Exception during call to stored proc (' + StoredProcName
        + ').');
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      DBLastError1 := E.Message;
    end;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function Combo_Load_DataSet(DataSet: TDataSet; Lines: TStrings; s_DataSet_Kod, s_DataSet_Nam:
  string; Combo_Load_HandleProc: TCombo_Load_HandleProcEx;
  PointerToData: Pointer): Integer;
const
  ProcName: string = 'Combo_Load_DataSet';
var
  Kod: integer;
  Nam: string;
  Counter: integer;
begin
  // --------------------------------------------------------------------------
  // Цикл загрузки записей из запроса
  // --------------------------------------------------------------------------
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  Result := -1;
  if Assigned(DataSet) {and Assigned(Lines)} then
    with DataSet do
    begin
      if Assigned(Lines) then
      try
        Lines.Clear;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Lines is not null but cannot be cleared.');
        end;
      end;
      DEBUGMessEnh(0, UnitName, ProcName, 'DataSet.Name is (' + DataSet.Name + ').');
      if (not Active) then
      try
        DEBUGMessEnh(0, UnitName, ProcName, 'DataSet is not opened. Try to open.');
        Open;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Opening DataSet is failed.');
          DBLastError2 := E.Message;
          Result := -2;
        end;
      end;
      if Active then
      try
        DisableControls;
        { if (Dataset is TQuery) then
            if not (Dataset as TQuery).UniDirectional then}
        First;
        Last;
        First;
        DEBUGMessEnh(0, UnitName, ProcName, 's_DataSet_Kod = ' + s_DataSet_Kod);
        DEBUGMessEnh(0, UnitName, ProcName, 's_DataSet_Nam = ' + s_DataSet_Nam);
        DEBUGMessEnh(0, UnitName, ProcName, 'Start cycle...');
        Counter := 0;
        while not Eof do
        begin
          Kod := -1;
          Nam := '<error>';
          if Assigned(Combo_Load_HandleProc) then
            if Combo_Load_HandleProc(DataSet, s_DataSet_Kod, s_DataSet_Nam, Kod, Nam, PointerToData)
              then
              if Assigned(Lines) then
              try
                Lines.AddObject(Nam, TObject(Kod));
              except
                on E: Exception do
                begin
                  DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
                  DEBUGMessEnh(0, UnitName, ProcName, 'Adding object to Lines failed.');
                end;
              end;
          inc(Counter);
          Next;
        end;
        DEBUGMessEnh(0, UnitName, ProcName, 'Count = ' + IntToStr(Counter));
        DEBUGMessEnh(0, UnitName, ProcName, 'Finish cycle...');
        { if (Dataset is TQuery) then
            if not (Dataset as TQuery).UniDirectional then}
        First;
        Result := Counter;
      finally
        EnableControls;
      end;
    end
  else
    DEBUGMessEnh(0, UnitName, ProcName, 'Error - DataSet is null.');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function fchp_DataSet(DataSet: TDataSet; s_DataSet_Kod, s_DataSet_Nam: string;
  var _Kod: integer; var _Nam: string; PointerToData: Pointer): Boolean;
const
  ProcName: string = 'fchp_DataSet';
begin
  Result := false;
  if Assigned(DataSet) and (length(s_DataSet_Kod) > 0) and (length(s_DataSet_Nam) > 0) and
    DataSet.Active then
  try
    if Assigned(DataSet.FieldByName(s_DataSet_Kod)) then
      _Kod := DataSet.FieldByName(s_DataSet_Kod).AsInteger;
    if Assigned(DataSet.FieldByName(s_DataSet_Nam)) then
      _Nam := DataSet.FieldByName(s_DataSet_Nam).AsString;
    Result := true;
  except
    on E: Exception do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'Getting field values failed.');
      DBLastError2 := E.Message;
    end;
  end;
end;

function Combo_Load_Repert(DataSet: TDataSet; Lines: TStrings): integer;
const
  ProcName: string = 'Combo_Load_Repert';
begin
  Result := Combo_Load_DataSet(DataSet, Lines, s_REPERT_KOD, s_REPERT_DESC, fchp_Dataset, nil);
end;

function Combo_Load_DBUser(DataSet: TDataSet; Lines: TStrings): integer;
begin
  Result := Combo_Load_DataSet(DataSet, Lines, s_DBUSER_KOD, s_DBUSER_NAM, fchp_DataSet, nil);
end;

function Combo_Load_Zal(DataSet: TDataSet; Lines: TStrings): integer;
begin
  Result := Combo_Load_DataSet(DataSet, Lines, s_ODEUM_KOD, s_ODEUM_DESC, fchp_DataSet, nil);
end;

function Combo_Load_Tariff(DataSet: TDataSet; Lines: TStrings): integer;
begin
  Result := Combo_Load_DataSet(DataSet, Lines, s_TARIFF_KOD, s_TARIFF_DESC, fchp_DataSet, nil);
end;

function Combo_Load_Globalvar(DataSet: TDataSet; Lines: TStrings): integer;
begin
  Result := Combo_Load_DataSet(DataSet, Lines, s_GLOBVAR_KOD, s_GLOBVAR_NAM, fchp_DataSet, nil);
end;

function TestDBConnect: Boolean;
begin
  Result := dm_Base.DataModule2Connected;
end;

function CreateTariffVersion(const Tariff_Kod: integer; var Tariff_Ver: Integer;
  var Error_Kod: Integer; var Error_Text: string): boolean;
const
  ProcName: string = 'CreateTariffVersion';
  s_HostInfo: string = 'unknown remote host';
var
  var_Error_Kod: Integer;
  var_Error_Text: string;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  Result := false;
  with dm_Base.sp_Create_Tariff_Version do
  try
    if Assigned(dm_Base) and Assigned(dm_Base.sp_Create_Tariff_Version) then
    begin
      ParamCheck := true;
      StoredProcName := '';
      StoredProcName := s_IP_CREATE_TARIFF_VERSION;
      // ------------ Setting params ------------
      if Assigned(Params.FindParam(s_IN_TARIFF_KOD)) then
        ParamByName(s_IN_TARIFF_KOD).AsInteger := Tariff_Kod;
      // ------------
      if Assigned(Params.FindParam(s_IN_TARIFF_VER)) then
        ParamByName(s_IN_TARIFF_VER).AsVariant := Null;
      // ------------
      if Assigned(Params.FindParam(s_IN_SESSION_ID)) then
        ParamByName(s_IN_SESSION_ID).AsInt64 := Global_Session_ID;
      // ------------
      DEBUGMessEnh(0, UnitName, ProcName, s_IN_TARIFF_KOD + ' = ' + IntToStr(Tariff_Kod));
      DEBUGMessEnh(0, UnitName, ProcName, s_IN_TARIFF_VER + ' = null');
      DEBUGMessEnh(0, UnitName, ProcName, s_IN_SESSION_ID + ' = ' + IntToStr(Global_Session_ID));
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      Prepare;
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.TRParams = (' + Transaction.TRParams.CommaText
        + ')');
      ExecProc;
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      // ------------ Returning params ------------
      Tariff_Ver := -2;
      try
        if Assigned(FieldByName[s_OUT_TARIFF_VER]) then
          Tariff_Ver := FieldByName[s_OUT_TARIFF_VER].AsInteger;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_OUT_TARIFF_VER +
            ') is failed.');
        end;
      end;
      // ------------
      var_Error_Kod := 0;
      try
        if Assigned(FieldByName[s_ERROR_ID]) then
          var_Error_Kod := FieldByName[s_ERROR_ID].AsInteger;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_ERROR_ID +
            ') is failed.');
        end;
      end;
      Error_Kod := var_Error_Kod;
      DEBUGMessEnh(0, UnitName, ProcName, s_ERROR_ID + ' = ' + IntToStr(var_Error_Kod));
      // ------------
      var_Error_Text := '-*-';
      try
        if Assigned(FieldByName[s_ERROR_TEXT]) then
          var_Error_Text := FieldByName[s_ERROR_TEXT].AsString;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_ERROR_TEXT +
            ') is failed.');
        end;
      end;
      Error_Text := var_Error_Text;
      DEBUGMessEnh(0, UnitName, ProcName, s_ERROR_TEXT + ' = ' + var_Error_Text);
      // ------------
      DEBUGMessEnh(0, UnitName, ProcName, s_OUT_TARIFF_VER + ' = ' + IntToStr(Tariff_Ver));
      if (var_Error_Kod = 0) and (Tariff_Ver > 0) then
        Result := true;
      // ------------ Check done ------------
    end;
  except
    on E: Exception do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'Exception during call to stored proc (' + StoredProcName
        + ').');
      DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' + BoolYesNo[Transaction.Active]);
      DBLastError1 := E.Message;
      Error_Text := E.Message;
    end;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

initialization
  // --------------------------------------------------------------------------
  MemList_Pref := TStringList.Create;
  // --------------------------------------------------------------------------

finalization
  // --------------------------------------------------------------------------
  MemList_Pref.Free;
  MemList_Pref := nil;
  // --------------------------------------------------------------------------

end.

