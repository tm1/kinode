{-----------------------------------------------------------------------------
 Unit Name: udCommon
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  19.04.2004
 Purpose:   DB container, default transactions
 History:
-----------------------------------------------------------------------------}
unit udCommon;

interface

{$I kinode01.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, FIBDatabase,
  pFIBDatabase, FIBQuery, pFIBQuery, pFIBStoredProc, Db, pFIBDataSet, pFIBErrorHandler, FIBDataSet,
  FIB;

type
  Tdm_Common = class(TDataModule)db_kino1: TpFIBDatabase;
    tr_Common_Read1: TpFIBTransaction;
    tr_Common_Write1: TpFIBTransaction;
    sp_Get_Version: TpFIBStoredProc;
    ds_DBUser: TpFIBDataSet;
    tr_DBUser_Write: TpFIBTransaction;
    qr_DBUser_List: TpFIBQuery;
    eh_Kino1: TpFibErrorHandler;
    tr_Session_Start1: TpFIBTransaction;
    sp_Session_Start: TpFIBStoredProc;
    sp_Session_Finish: TpFIBStoredProc;
    tr_Session_Finish1: TpFIBTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure db_kino1AfterDisconnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function DataModule1Connected: Boolean;
    function DataBase1Path: string;
    function GetDatabaseVersion(var verMajor, verMinor, verRelease, verBuild: integer): string;
  end;

var
  dm_Common: Tdm_Common;

implementation

uses
  Bugger, uhCommon, StrConsts, urCommon;

{$R *.DFM}

const
  UnitName: string = 'udCommon';
  ar_KindIBError: array[TKindIBError] of string = ('keNoError', 'keException', 'keForeignKey',
    'keLostConnect', 'keSecurity', 'keCheck', 'keOther');

function Tdm_Common.DataModule1Connected: Boolean;
begin
  Result := false;
  if Assigned(db_kino1) then
    Result := db_kino1.Connected;
end;

function Tdm_Common.DataBase1Path: string;
begin
  Result := '<unknown>';
  if Assigned(db_kino1) then
    Result := db_kino1.DBName;
end;

function Tdm_Common.GetDatabaseVersion(var verMajor, verMinor, verRelease, verBuild: integer):
  string;
const
  ProcName: string = 'GetDataBaseVersion';
var
  ActiveState: Boolean;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  Result := '<unknown>';
  if Assigned(db_kino1) then
    if db_kino1.Connected then
      with sp_Get_Version do
      begin
        ActiveState := Transaction.Active;
        try
          ParamCheck := true;
          StoredProcName := '';
          StoredProcName := s_IP_GET_VERSION;
          if not Transaction.Active then
            Transaction.StartTransaction;
          Prepare;
          ExecProc;
          verMajor := 0;
          verMinor := 0;
          verRelease := 0;
          verBuild := 0;
          try
            if Assigned(FieldByName[s_VERSION_MAJOR]) then
              verMajor := FieldByName[s_VERSION_MAJOR].AsInteger;
          except
            on E: Exception do
            begin
              DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
              DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_VERSION_MAJOR +
                ') is failed.');
            end;
          end;
          try
            if Assigned(FieldByName[s_VERSION_MINOR]) then
              verMinor := FieldByName[s_VERSION_MINOR].AsInteger;
          except
            on E: Exception do
            begin
              DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
              DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_VERSION_MINOR +
                ') is failed.');
            end;
          end;
          try
            if Assigned(FieldByName[s_VERSION_RELEASE]) then
              verRelease := FieldByName[s_VERSION_RELEASE].AsInteger;
          except
            on E: Exception do
            begin
              DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
              DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_VERSION_RELEASE +
                ') is failed.');
            end;
          end;
          try
            if Assigned(FieldByName[s_VERSION_BUILD]) then
              verBuild := FieldByName[s_VERSION_BUILD].AsInteger;
          except
            on E: Exception do
            begin
              DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
              DEBUGMessEnh(0, UnitName, ProcName, 'Getting result field (' + s_VERSION_BUILD +
                ') is failed.');
            end;
          end;
          DEBUGMessEnh(0, UnitName, ProcName, s_VERSION_MAJOR + ' = ' + IntToStr(verMajor));
          DEBUGMessEnh(0, UnitName, ProcName, s_VERSION_MINOR + ' = ' + IntToStr(verMinor));
          DEBUGMessEnh(0, UnitName, ProcName, s_VERSION_RELEASE + ' = ' + IntToStr(verRelease));
          DEBUGMessEnh(0, UnitName, ProcName, s_VERSION_BUILD + ' = ' + IntToStr(verBuild));
          Result := IntToStr(verMajor) + '.' + IntToStr(verMinor) + '.' + IntToStr(verRelease) + '.'
            + IntToStr(verBuild);
          if (not ActiveState) and Transaction.Active then
            Transaction.Commit;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, 'Exception during call to stored proc (' +
              StoredProcName + ').');
            DEBUGMessEnh(0, UnitName, ProcName, 'Transaction.Active = ' +
              BoolYesNo[Transaction.Active]);
            DBLastError1 := E.Message;
          end;
        end;
      end;
  Result := 'Database version : ' + Result;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tdm_Common.DataModuleCreate(Sender: TObject);
const
  ProcName: string = 'DataModuleCreate';
var
  tSQLDialect: integer;
  tDatabaseName, tCharSet, tRoleName, tUserName, tPassword: string;
  IniReadError: Boolean;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, 'db_kino1.Connected = ' + BoolYesNo[db_kino1.Connected]);
  DEBUGMessEnh(0, UnitName, ProcName, 'FIBVersion = ' + IntToStr(FIBPlusVersion) + '.' +
    IntToStr(FIBPlusBuild) + '.' + IntToStr(FIBCustomBuild) + ' build '
    + FIBPlusBuildDate);
  db_kino1.Connected := false;
  db_kino1.AliasName := '';
  with db_kino1 do
  begin
    IniReadError := LoadDatabaseParameters(tSQLDialect, tDatabaseName, tCharSet, tRoleName,
      tUserName, tPassword);
    SQLDialect := tSQLDialect;
    DBName := tDatabaseName;
    DBParams.Clear;
    // DBParams.Add('no_garbage_collect');
    ConnectParams.CharSet := tCharSet;
    DEBUGMessEnh(0, UnitName, ProcName, 'DBParams = ' + DBParams.CommaText);
    ConnectParams.RoleName := tRoleName;
    ConnectParams.UserName := tUserName;
    ConnectParams.Password := tPassword;
    DEBUGMessEnh(0, UnitName, ProcName, 'Try to connect ...');
    try
      Connected := true;
    except
      on E: Exception do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
        DEBUGMessEnh(0, UnitName, ProcName, 'Database connection failed.');
        DBLastError1 := E.Message;
      end;
    end;
  end;
  DEBUGMessEnh(0, UnitName, ProcName, 'db_kino1.Connected = ' + BoolYesNo[db_kino1.Connected]);
  if {db_kino1.Connected} IniReadError then
  try
    with db_kino1 do
      SaveDatabaseParameters(SQLDialect, DBName, ConnectParams.CharSet, ConnectParams.RoleName,
        ConnectParams.UserName, ConnectParams.Password);
  except
    on E: Exception do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'Cannot save DB parameters to inifile.');
    end;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tdm_Common.db_kino1AfterDisconnect(Sender: TObject);
const
  ProcName: string = 'db_kino1AfterDisconnect';
begin
  //
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

end.

