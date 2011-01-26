{-----------------------------------------------------------------------------
 Unit Name: udBase
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  15.05.2004
 Purpose:   DB container, default transactions
 History:
-----------------------------------------------------------------------------}
unit udBase;

interface

{$I kinode01.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, FIBDatabase,
  pFIBDatabase, Db, FIB, FIBDataSet, pFIBDataSet, SIBEABase, SIBFIBEA, ExtCtrls,
  pFIBErrorHandler, FIBQuery, pFIBQuery, pFIBStoredProc;

type
  TMixDS = record
    DS_UID: Integer;
    DS_Name: string[40];
    DS_InsUpd: Integer;
    DS_FN_Kod: string[40];
    DS_FN_Ver: string[40];
    DS_MaxVal: Int64;
  end;

  Tdm_Base = class(TDataModule)
    db_kino2: TpFIBDatabase;
    tr_Common_Read2: TpFIBTransaction;
    tr_Common_Write2: TpFIBTransaction;
    ds_Branch: TpFIBDataSet;
    ds_Globset: TpFIBDataSet;
    ds_Zal: TpFIBDataSet;
    ds_Place: TpFIBDataSet;
    ds_Cost: TpFIBDataSet;
    ds_Repert: TpFIBDataSet;
    ds_Ticket: TpFIBDataSet;
    ds_Genre: TpFIBDataSet;
    ds_Tariff: TpFIBDataSet;
    ds_Film: TpFIBDataSet;
    ds_Seans: TpFIBDataSet;
    ds_Changelog_Max: TpFIBDataSet;
    ds_Changelog_List: TpFIBDataSet;
    ev_Changelog: TSIBfibEventAlerter;
    tr_Event_Write3: TpFIBTransaction;
    ds_Changelog_Buf: TpFIBDataSet;
    tmr_Buffer: TTimer;
    ds_Moves: TpFIBDataSet;
    tr_Session_Finish2: TpFIBTransaction;
    sp_Create_Tariff_Version: TpFIBStoredProc;
    tr_Tariff_Write: TpFIBTransaction;
    tr_Oper_Mod_Write: TpFIBTransaction;
    sp_Oper_Mod: TpFIBStoredProc;
    tr_Oper_Clr_Write: TpFIBTransaction;
    sp_Oper_Clr: TpFIBStoredProc;
    ds_Rep_Instant: TpFIBDataSet;
    ds_Rep_Ticket: TpFIBDataSet;
    ds_Rep_Daily_Odeums: TpFIBDataSet;
    ds_Rep_Daily_Repert: TpFIBDataSet;
    ds_Rep_Daily_Moves: TpFIBDataSet;
    dsrc_Rep_Daily_Odeums: TDataSource;
    dsrc_Rep_Daily_Repert: TDataSource;
    dsrc_Rep_Daily_Moves: TDataSource;
    ds_Price: TpFIBDataSet;
    ds_Abjnl: TpFIBDataSet;
    ds_Rep_Daily_Abonem: TpFIBDataSet;
    dsrc_Rep_Daily_Abonem: TDataSource;
    ds_Rep_Ticket_Odeums: TpFIBDataSet;
    dsrc_Rep_Ticket_Odeums: TDataSource;
    ds_Rep_Ticket_Tickets: TpFIBDataSet;
    dsrc_Rep_Ticket_Tickets: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ds_DatasetBeforeOpen(DataSet: TDataSet);
    procedure ds_DatasetAfterPostOrCancelOrDelete(DataSet: TDataSet);
    procedure ds_DatasetBeforePost(DataSet: TDataSet);
    procedure ds_DatasetBeforeDelete(DataSet: TDataSet);
    procedure ds_DatasetBeforeClose(DataSet: TDataSet);
    procedure db_kino2Connect(Sender: TObject);
    procedure ev_ChangelogEventAlert(Sender: TObject; EventName: string; EventCount: Integer);
    procedure tmr_BufferTimer(Sender: TObject);
    procedure db_kino2BeforeDisconnect(Sender: TObject);
    procedure db_kino2ErrorRestoreConnect(Database: TFIBDatabase; E: EFIBError; var Actions:
      TOnLostConnectActions);
    procedure db_kino2LostConnect(Database: TFIBDatabase; E: EFIBError; var Actions:
      TOnLostConnectActions);
    procedure eh_Kino2FIBErrorEvent(Sender: TObject; ErrorValue: EFIBError;
      KindIBError: TKindIBError; var DoRaise: Boolean);
    procedure ds_MovesFieldChange(Sender: TField);
    procedure ds_MovesAfterRefresh(DataSet: TDataSet);
    procedure ds_RepertFieldChange(Sender: TField);
    procedure ds_RepertAfterRefresh(DataSet: TDataSet);
    procedure ds_RepertAfterDelete(DataSet: TDataSet);
    procedure ds_Rep_Daily_BeforeOpen(DataSet: TDataSet);
  private
    { Private declarations }
    FChangelog_Max_Value: Int64;
    FChangelog_Buf_Busy: Boolean;
    FEventsRegistered: Boolean;
    FEventProcessed: Boolean;
    t1_event_locked_real: Boolean;
    t1_event_locked_timed: Boolean;
    t1_non_upd_rec: Integer;
    FGetMaxProcessed: Boolean;
    FEventTableNames: TStrings;
    function GetChangelog_Max_Value: Int64;
    procedure SetChangelog_Max_Value(Value: Int64);
    function Get_DataSetsID_By_Name(DataSet_ID: Integer): TMixDS;
    // ------------------------------
    procedure All_Events_Unregister(Sender: TObject);
    function Changelog_Events_Reg(const AddEvents: Boolean; Dataset: TDataset): integer;
    procedure ChangelogEvent(const EventName: string; const EventCount: Integer;
      const BufferOnly: Boolean);
    procedure Prepare_Buf_Dataset;
    procedure Clear_Buf_Dataset(const TableName: string);
  public
    { Public declarations }
    function DataModule2Connected: Boolean;
    function DataBase2Path: string;
    property Changelog_Max_Value: Int64 read GetChangelog_Max_Value write SetChangelog_Max_Value;
  end;

var
  dm_Base: Tdm_Base;

implementation

uses
  Bugger, urCommon, StrConsts, Math, uhOper, uhMain;

{$R *.DFM}

const
  UnitName: string = 'udBase';
  RF_DataSetsCount = 34;
  RF_DataSets: array[0..RF_DataSetsCount] of TMixDS = (
    (DS_UID: 0; DS_Name: ''; DS_InsUpd: 0; DS_FN_Kod: ''; DS_FN_Ver: ''; DS_MaxVal: 0),
    (DS_UID: 1; DS_Name: 'DBUSER'; DS_InsUpd: 0;
    DS_FN_Kod: 'DBUSER_KOD'; DS_FN_Ver: 'DBUSER_VER'; DS_MaxVal: 0),
    (DS_UID: 2; DS_Name: 'BRANCH'; DS_InsUpd: 0;
    DS_FN_Kod: 'BRANCH_KOD'; DS_FN_Ver: 'BRANCH_VER'; DS_MaxVal: 0),
    (DS_UID: 3; DS_Name: 'GLOBAL'; DS_InsUpd: 0;
    DS_FN_Kod: 'GLOBAL_KOD'; DS_FN_Ver: 'GLOBAL_VER'; DS_MaxVal: 0),
    (DS_UID: 4; DS_Name: 'ODEUM'; DS_InsUpd: 0;
    DS_FN_Kod: 'ODEUM_KOD'; DS_FN_Ver: 'ODEUM_VER'; DS_MaxVal: 0),
    (DS_UID: 5; DS_Name: 'SEAT'; DS_InsUpd: 0;
    DS_FN_Kod: 'SEAT_KOD'; DS_FN_Ver: 'SEAT_VER'; DS_MaxVal: 0),
    (DS_UID: 6; DS_Name: ''; DS_InsUpd: 0; DS_FN_Kod: ''; DS_FN_Ver: ''; DS_MaxVal: 0),
    (DS_UID: 7; DS_Name: 'TICKET'; DS_InsUpd: 0;
    DS_FN_Kod: 'TICKET_KOD'; DS_FN_Ver: 'TICKET_VER'; DS_MaxVal: 0),
    (DS_UID: 8; DS_Name: 'TARIFF'; DS_InsUpd: 0;
    DS_FN_Kod: 'TARIFF_KOD'; DS_FN_Ver: 'TARIFF_VER'; DS_MaxVal: 0),
    (DS_UID: 9; DS_Name: 'COST'; DS_InsUpd: 0;
    DS_FN_Kod: 'COST_KOD'; DS_FN_Ver: 'COST_VER'; DS_MaxVal: 0),
    (DS_UID: 10; DS_Name: 'GENRE'; DS_InsUpd: 0;
    DS_FN_Kod: 'GENRE_KOD'; DS_FN_Ver: 'GENRE_VER'; DS_MaxVal: 0),
    (DS_UID: 11; DS_Name: 'FILM'; DS_InsUpd: 0;
    DS_FN_Kod: 'FILM_KOD'; DS_FN_Ver: 'FILM_VER'; DS_MaxVal: 0),
    (DS_UID: 12; DS_Name: 'SEANS'; DS_InsUpd: 0;
    DS_FN_Kod: 'SEANS_KOD'; DS_FN_Ver: 'SEANS_VER'; DS_MaxVal: 0),
    (DS_UID: 13; DS_Name: 'REPERT'; DS_InsUpd: 0;
    DS_FN_Kod: 'REPERT_KOD'; DS_FN_Ver: 'REPERT_VER'; DS_MaxVal: 0),
    (DS_UID: 14; DS_Name: 'CINEMA'; DS_InsUpd: 0;
    DS_FN_Kod: 'CINEMA_KOD'; DS_FN_Ver: 'CINEMA_VER'; DS_MaxVal: 0),
    (DS_UID: 15; DS_Name: 'MAKET'; DS_InsUpd: 0;
    DS_FN_Kod: 'MAKET_KOD'; DS_FN_Ver: 'MAKET_VER'; DS_MaxVal: 0),
    (DS_UID: 16; DS_Name: 'CARD'; DS_InsUpd: 0;
    DS_FN_Kod: 'CARD_KOD'; DS_FN_Ver: 'CARD_VER'; DS_MaxVal: 0),
    (DS_UID: 17; DS_Name: 'INVITER'; DS_InsUpd: 0;
    DS_FN_Kod: 'INVITER_KOD'; DS_FN_Ver: 'INVITER_VER'; DS_MaxVal: 0),
    (DS_UID: 18; DS_Name: 'VISITGRP'; DS_InsUpd: 0;
    DS_FN_Kod: 'VISITGRP_KOD'; DS_FN_Ver: 'VISITGRP_VER'; DS_MaxVal: 0),
    (DS_UID: 19; DS_Name: 'OPER'; DS_InsUpd: 3;
    DS_FN_Kod: 'OPER_KOD'; DS_FN_Ver: 'OPER_VER'; DS_MaxVal: 0),
    (DS_UID: 20; DS_Name: 'ABONEM'; DS_InsUpd: 0;
    DS_FN_Kod: 'ABONEM_KOD'; DS_FN_Ver: 'ABONEM_VER'; DS_MaxVal: 0),
    (DS_UID: 21; DS_Name: 'PRICE'; DS_InsUpd: 0;
    DS_FN_Kod: 'PRICE_KOD'; DS_FN_Ver: 'PRICE_VER'; DS_MaxVal: 0),
    (DS_UID: 22; DS_Name: 'ABJNL'; DS_InsUpd: 0;
    DS_FN_Kod: 'ABJNL_KOD'; DS_FN_Ver: 'ABJNL_VER'; DS_MaxVal: 0),
    (DS_UID: 23; DS_Name: ''; DS_InsUpd: 0; DS_FN_Kod: ''; DS_FN_Ver: ''; DS_MaxVal: 0),
    (DS_UID: 24; DS_Name: ''; DS_InsUpd: 0; DS_FN_Kod: ''; DS_FN_Ver: ''; DS_MaxVal: 0),
    (DS_UID: 701; DS_Name: ''; DS_InsUpd: 0; DS_FN_Kod: ''; DS_FN_Ver: ''; DS_MaxVal: 0),
    (DS_UID: 702; DS_Name: ''; DS_InsUpd: 0; DS_FN_Kod: ''; DS_FN_Ver: ''; DS_MaxVal: 0),
    (DS_UID: 703; DS_Name: ''; DS_InsUpd: 0; DS_FN_Kod: ''; DS_FN_Ver: ''; DS_MaxVal: 0),
    (DS_UID: 704; DS_Name: ''; DS_InsUpd: 0; DS_FN_Kod: ''; DS_FN_Ver: ''; DS_MaxVal: 0),
    (DS_UID: 705; DS_Name: ''; DS_InsUpd: 0; DS_FN_Kod: ''; DS_FN_Ver: ''; DS_MaxVal: 0),
    (DS_UID: 706; DS_Name: ''; DS_InsUpd: 0; DS_FN_Kod: ''; DS_FN_Ver: ''; DS_MaxVal: 0),
    (DS_UID: 707; DS_Name: ''; DS_InsUpd: 0; DS_FN_Kod: ''; DS_FN_Ver: ''; DS_MaxVal: 0),
    (DS_UID: 708; DS_Name: ''; DS_InsUpd: 0; DS_FN_Kod: ''; DS_FN_Ver: ''; DS_MaxVal: 0),
    (DS_UID: 709; DS_Name: ''; DS_InsUpd: 0; DS_FN_Kod: ''; DS_FN_Ver: ''; DS_MaxVal: 0),
    (DS_UID: 710; DS_Name: ''; DS_InsUpd: 0; DS_FN_Kod: ''; DS_FN_Ver: ''; DS_MaxVal: 0)
    );

function Tdm_Base.DataModule2Connected: Boolean;
begin
  Result := false;
  if Assigned(db_kino2) then
  begin
    // Result := db_kino2.Connected;
    {
    laTerminateApp - the application will be closed automatically
    laCloseConnect - the Active property in all FIBPlus objects will equal false
    laIgnore - a lost of connection will be ignored
    laWaitRestore - the Active property in all FIBPlus objects will equal false and then WaitForRestoreConnect will be called.
    }
    Result := db_kino2.ExTestConnected(laIgnore);
  end;
  DBConnected2 := Result;
  Update_DB_Conn_State;
end;

function Tdm_Base.DataBase2Path: string;
begin
  Result := '<unknown>';
  if Assigned(db_kino2) then
    Result := db_kino2.DBName;
end;

procedure Tdm_Base.DataModuleCreate(Sender: TObject);
const
  ProcName: string = 'DataModuleDestroy';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  DBConnected2 := False;
  FChangelog_Max_Value := -1;
  FChangelog_Buf_Busy := false;
  FEventsRegistered := false;
  FEventProcessed := false;
  FGetMaxProcessed := false;
  t1_event_locked_real := false;
  t1_event_locked_timed := false;
  t1_non_upd_rec := 0;
  ds_Changelog_List.Active := false;
  {construct the list}
  FEventTableNames := TStringList.Create;
  try
    FEventTableNames.Clear;
  except
    on E: Exception do
    begin
      FEventTableNames := nil;
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'FEventTableNames.Clear failed.');
    end;
  end;
  if ev_Changelog.Registered then
    ev_Changelog.RegisterEvents;
  {
      if (not Dataset_event_locked) and fibDataset.Active then
      try
        if Assigned(fibDataset.FN(s_SESSIONID)) then
        begin
          fibDataset.FN(s_SESSIONID).AsString := IntToStr(UserID);
          DEBUGMessEnh(0, UnitName, ProcName, s_SESSIONID + ' = [' +
            fibDataset.FN(s_SESSIONID).AsString + ']');
        end;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Error during (P) ' + s_SESSIONID +
            ' assigning ' + s_SESSIONID + ' = (' + IntToStr(UserID) + ')');
        end;
      end;
  }
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tdm_Base.DataModuleDestroy(Sender: TObject);
const
  ProcName: string = 'DataModuleDestroy';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  if Assigned(dm_Base) then
  try
    dm_Base.All_Events_Unregister(nil);
  except
    on E: Exception do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'All_Events_Unregister failed.');
    end;
  end;
  {destroy the list object}
  FEventTableNames.Free;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function Tdm_Base.GetChangelog_Max_Value: Int64;
const
  ProcName: string = 'GetChangelog_Max_Value';
var
  sRes: string;
begin
  Result := -1;
  // -----------------------------------------------------------
  if FEventsRegistered then
  begin
    Result := FChangelog_Max_Value;
  end
  else
  begin
    // -----------------------------------------------------------
    if FGetMaxProcessed then
    begin
      while FGetMaxProcessed do
        Application.ProcessMessages;
      Result := FChangelog_Max_Value;
    end
    else
    begin
      // -----------------------------------------------------------
      FGetMaxProcessed := true;
      try
        with ds_Changelog_Max do
        try
          if Assigned(ParamByName(s_IN_CHANGE_NUM)) then
          begin
            try
              // -----------------------------------------------------------
              if Active then
                Close;
              DEBUGMessEnh(0, UnitName, ProcName, s_IN_CHANGE_NUM + ' = [' +
                IntToStr(FChangelog_Max_Value) + ']');
              ParamByName(s_IN_CHANGE_NUM).AsString := IntToStr(FChangelog_Max_Value);
              // Обновляем Select-sql из репозитория, если нужно
              Prepare;
              Open;
              if Assigned(FN(s_MAX_CHANGE_KOD)) then
              begin
                sRes := FN(s_MAX_CHANGE_KOD).AsString;
                DEBUGMessEnh(0, UnitName, ProcName, s_MAX_CHANGE_KOD + ' = [' + sRes + ']');
                Result := StrToInt(sRes);
              end;
              Close;
              // -----------------------------------------------------------
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
          end
          else
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Param [' + s_IN_CHANGE_NUM + '] is missed.');
            Result := 0;
          end;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, 'Error getting Changelog_Max.');
          end;
        end;
      finally
        FChangelog_Max_Value := Result;
        FGetMaxProcessed := false;
      end;
      // -----------------------------------------------------------
    end;
  end;
  // -----------------------------------------------------------
end;

procedure Tdm_Base.SetChangelog_Max_Value(Value: Int64);
const
  ProcName: string = 'SetChangelog_Max_Value';
begin
  if FChangelog_Max_Value <> Value then
  begin
    FChangelog_Max_Value := Value;
    DEBUGMessEnh(0, UnitName, ProcName, 'Setting Changelog_Max = [' + IntToStr(Value) + ']');
  end;
end;

function Tdm_Base.Get_DataSetsID_By_Name(DataSet_ID: Integer): TMixDS;
begin
  if (DataSet_ID <= 0) or (DataSet_ID > High(RF_DataSets)) then
  begin
    Result.DS_UID := 0;
    Result.DS_Name := '';
    Result.DS_InsUpd := 0;
    Result.DS_FN_Kod := '';
    Result.DS_FN_Ver := '';
    Result.DS_MaxVal := 0;
  end
  else
    Result := RF_DataSets[DataSet_ID];
end;

procedure Tdm_Base.All_Events_Unregister(Sender: TObject);
const
  ProcName: string = 'All_Events_Unregister';
var
  i: integer;
  tmp_Component: TComponent;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  with dm_Base do
    for i := 0 to ComponentCount - 1 do
    begin
      tmp_Component := Components[i];
      try
        if (tmp_Component is TSIBfibEventAlerter) then
        begin
          with (tmp_Component as TSIBfibEventAlerter) do
          begin
            if Registered then
            begin
              DEBUGMessEnh(0, UnitName, ProcName, Name + '.UnRegisterEvents');
              UnRegisterEvents;
            end;
          end;
        end;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.UnRegisterEvents failed.');
        end;
      end;
    end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

function Tdm_Base.Changelog_Events_Reg(const AddEvents: Boolean; Dataset: TDataset): Integer;
const
  ProcName: string = 'Changelog_Events_Reg';
var
  Exists0_Table, Exists1_InsertEvent, Exists2_UpdateEvent, Exists3_KillEvent, ExistsAny, ExistsAll,
    WasRegistered: Boolean;
  Index0_Table, Index1_Insert, Index2_Update, Index3_Kill: Integer;
  Res: Int64;
  iDataset_ID: Integer;
  sEventTable: string;
  iEventTable_ID: Integer;
  var_MixDS: TMixDS;
begin
  Result := FEventTableNames.Count;
  sEventTable := '';
  iEventTable_ID := 0;
  if (DataSet is TpFIBDataSet) then
  begin
    iDataset_ID := (Dataset as TpFIBDataSet).DataSet_ID;
    var_MixDS := Get_DataSetsID_By_Name(iDataset_ID);
    sEventTable := Trim(var_MixDS.DS_Name);
    iEventTable_ID := iDataset_ID;
  end;
  if (sEventTable = '') or (iEventTable_ID = 0) then
    Exit;
  if FEventProcessed or t1_event_locked_real then
  begin
    DEBUGMessEnh(0, UnitName, ProcName, 'Waiting... - EventReg(' + BoolYesNo[AddEvents]
      + ') for [' + sEventTable + ']');
    while (FEventProcessed or t1_event_locked_real) and DataModule2Connected do
      Application.ProcessMessages;
    DEBUGMessEnh(0, UnitName, ProcName, 'Continue... - EventReg(' + BoolYesNo[AddEvents]
      + ') for [' + sEventTable + ']');
  end;
  if (not DataModule2Connected) then
  begin
    // todo: Restore connect
    DEBUGMessEnh(0, UnitName, ProcName, 'Connection lost - EventReg(' + BoolYesNo[AddEvents]
      + ') for [' + sEventTable + ']');
    Exit;
  end;
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, 'Enter into - EventReg(' + BoolYesNo[AddEvents]
    + ') for [' + sEventTable + ']');
  FEventProcessed := true;
  WasRegistered := ev_Changelog.Registered;
  FEventsRegistered := WasRegistered and (FEventTableNames.Count > 0);
  DEBUGMessEnh(0, UnitName, ProcName, 'EvsReged = ' + BoolYesNo[FEventsRegistered] +
    ', EvTableNames = (' + FEventTableNames.CommaText + ')');
  try
    // -----------------------------------------------------------
    Index0_Table := FEventTableNames.IndexOfName(sEventTable);
    Exists0_Table := (Index0_Table > -1);
    // -----------------------------------------------------------
    Index1_Insert := ev_Changelog.Events.IndexOf(s_EVENT_PREFIX + sEventTable +
      s_EVENT_POSTFIX1_INSERT);
    Exists1_InsertEvent := (Index1_Insert > -1);
    // -----------------------------------------------------------
    Index2_Update := ev_Changelog.Events.IndexOf(s_EVENT_PREFIX + sEventTable +
      s_EVENT_POSTFIX2_UPDATE);
    Exists2_UpdateEvent := (Index2_Update > -1);
    // -----------------------------------------------------------
    Index3_Kill := ev_Changelog.Events.IndexOf(s_EVENT_PREFIX + sEventTable +
      s_EVENT_POSTFIX3_KILL);
    Exists3_KillEvent := (Index3_Kill > -1);
    // -----------------------------------------------------------
    ExistsAny := (Exists1_InsertEvent or Exists2_UpdateEvent or Exists3_KillEvent);
    ExistsAll := (Exists1_InsertEvent and Exists2_UpdateEvent and Exists3_KillEvent);
    // -----------------------------------------------------------
    if AddEvents then
    begin
      // =========================
      if not Exists0_Table then
        FEventTableNames.AddObject(sEventTable + '=' + IntToStr(iEventTable_ID), Dataset);
      // =========================
      if (not ExistsAll) then
      begin
        if WasRegistered then
        begin
          ev_Changelog.UnRegisterEvents;
        end;
        if not Exists1_InsertEvent then
          ev_Changelog.Events.Add(s_EVENT_PREFIX + sEventTable + s_EVENT_POSTFIX1_INSERT);
        if not Exists2_UpdateEvent then
          ev_Changelog.Events.Add(s_EVENT_PREFIX + sEventTable + s_EVENT_POSTFIX2_UPDATE);
        if not Exists3_KillEvent then
          ev_Changelog.Events.Add(s_EVENT_PREFIX + sEventTable + s_EVENT_POSTFIX3_KILL);
      end;
    end
    else
    begin
      // =========================
      if Exists0_Table then
      begin
        Index0_Table := FEventTableNames.IndexOfName(sEventTable);
        FEventTableNames.Delete(Index0_Table);
      end;
      // =========================
      if ExistsAny then
      begin
        if WasRegistered then
        begin
          ev_Changelog.UnRegisterEvents;
        end;
        if Exists1_InsertEvent then
        begin
          Index1_Insert := ev_Changelog.Events.IndexOf(s_EVENT_PREFIX + sEventTable +
            s_EVENT_POSTFIX1_INSERT);
          ev_Changelog.Events.Delete(Index1_Insert);
        end;
        if Exists2_UpdateEvent then
        begin
          Index2_Update := ev_Changelog.Events.IndexOf(s_EVENT_PREFIX + sEventTable +
            s_EVENT_POSTFIX2_UPDATE);
          ev_Changelog.Events.Delete(Index2_Update);
        end;
        if Exists3_KillEvent then
        begin
          Index3_Kill := ev_Changelog.Events.IndexOf(s_EVENT_PREFIX + sEventTable +
            s_EVENT_POSTFIX3_KILL);
          ev_Changelog.Events.Delete(Index3_Kill);
        end;
      end;
    end;
    // -----------------------------------------------------------
    if FEventTableNames.Count > 0 then
    begin
      if not ev_Changelog.Registered then
      begin
        Clear_Buf_Dataset(sEventTable);
        Res := Changelog_Max_Value;
        DEBUGMessEnh(0, UnitName, ProcName, 'Changelog_Max = [' + IntToStr(Res) + ']');
        ev_Changelog.RegisterEvents;
      end;
    end
    else
    begin
      if ev_Changelog.Registered then
      begin
        ev_Changelog.UnRegisterEvents;
      end;
      Clear_Buf_Dataset('');
    end;
    // -----------------------------------------------------------
  finally
    Result := FEventTableNames.Count;
    FEventsRegistered := ev_Changelog.Registered and (FEventTableNames.Count > 0);
    FEventProcessed := false;
  end;
  // -----------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, 'EvsReged = ' + BoolYesNo[FEventsRegistered] +
    ', EvTableNames = (' + FEventTableNames.CommaText + ')');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tdm_Base.ds_DatasetBeforeOpen(DataSet: TDataSet);
const
  ProcName: string = 'ds_DatasetBeforeOpen';
{$IFDEF Debug_Level_5}
var
  i: Integer;
{$ENDIF}
begin
  // -----------------------------------------------------------
  if (DataSet is TpFIBDataSet) then
    with (DataSet as TpFIBDataSet) do
    begin
      // -----------------------------------------------------------
      try
        if Assigned(ParamByName(s_IN_SESSION_ID)) then
        begin
          ParamByName(s_IN_SESSION_ID).AsVariant := Null;
        end;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Error during (O) ' + s_IN_SESSION_ID +
            ' assigning null.');
        end;
      end;
      // -----------------------------------------------------------
{$IFDEF Debug_Level_5}
      DEBUGMessEnh(0, UnitName, ProcName, Name + '.DataSet_ID = ' + IntToStr(DataSet_ID));
      for i := 0 to (Params.Count - 1) do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, Params[i].Name
          + ' = (' + BoolYesNo[Params[i].IsNull] + ') [' + Params[i].AsString + ']');
      end; // for
{$ENDIF}
      // -----------------------------------------------------------
      if (DataSet_ID > 0) and (DataSet_ID <= RF_DataSetsCount) then
      begin
        {
        if Length(InsertSQL.Text) = 0 then
        begin
          InsertSQL.Text := s_No_Action;
          DEBUGMessEnh(0, UnitName, ProcName, 'Setting InsertSQL for [' + Name + ']');
        end;
        }
        Changelog_Events_Reg(true, Dataset);
      end; // if
    end; // with
  // -----------------------------------------------------------
end;

procedure Tdm_Base.ds_DatasetAfterPostOrCancelOrDelete(DataSet: TDataSet);
const
  ProcName: string = 'ds_DatasetAfterPCD';
begin
  // -----------------------------------------------------------
  if (DataSet is TpFIBDataSet) then
    with (DataSet as TpFIBDataSet) do
    begin
      try
        if not (t1_event_locked_real or FEventProcessed or FChangelog_Buf_Busy) then
        begin
          if (ds_Changelog_Buf.RecordCount > 0) then
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Calling ChangelogEvent() now');
            ChangelogEvent('', 0, true);
          end;
          tmr_Buffer.Enabled := false;
        end
        else if not (UpdateSQL.Text = s_No_Action) then
        begin
          if not tmr_Buffer.Enabled then
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Setting ChangelogEvent() on timer');
            tmr_Buffer.Enabled := true;
          end;
        end;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'ChangelogEvent() failed.');
        end;
      end; // try
    end; // with
  // -----------------------------------------------------------
end;

procedure Tdm_Base.ds_DatasetBeforePost(DataSet: TDataSet);
const
  ProcName: string = 'ds_DatasetBeforePost';
{$IFDEF Debug_Level_5}
var
  i: Integer;
{$ENDIF}
begin
  // -----------------------------------------------------------
  if (DataSet is TpFIBDataSet) then
    with (DataSet as TpFIBDataSet) do
    begin
      // -----------------------------------------------------------
      if (DataSet.State in [dsInsert, dsEdit]) then
        if Assigned(ParamByName(s_IN_SESSION_ID)) then
        try
          begin
            if t1_event_locked_real then
              ParamByName(s_IN_SESSION_ID).AsVariant := Null
            else
              ParamByName(s_IN_SESSION_ID).AsString := IntToStr(Global_Session_ID);
          end;
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, 'Error during (P) ' + s_IN_SESSION_ID +
              ' assigning ' + s_IN_SESSION_ID + ' = (' + IntToStr(Global_Session_ID) + ')');
          end;
        end;
      // -----------------------------------------------------------
{$IFDEF Debug_Level_5}
      DEBUGMessEnh(0, UnitName, ProcName, Name + '.DataSet_ID = ' + IntToStr(DataSet_ID));
{$ENDIF}
{$IFDEF Debug_Level_5}
      for i := 0 to (Params.Count - 1) do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, Params[i].Name
          + ' = (' + BoolYesNo[Params[i].IsNull] + ') [' + Params[i].AsString + ']');
      end; // for
{$ENDIF}
{$IFDEF Debug_Level_5}
      for i := 0 to (FieldCount - 1) do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, Fields[i].FieldName
          + ' = (' + BoolYesNo[Fields[i].IsNull] + ') [' + Fields[i].AsString + ']');
      end; // for
{$ENDIF}
      // -----------------------------------------------------------
    end; // with
  // -----------------------------------------------------------
end;

procedure Tdm_Base.ds_DatasetBeforeDelete(DataSet: TDataSet);
const
  ProcName: string = 'ds_DatasetBeforeDelete';
{$IFDEF Debug_Level_5}
var
  i: Integer;
{$ENDIF}
begin
  // -----------------------------------------------------------
  if (DataSet is TpFIBDataSet) then
    with (DataSet as TpFIBDataSet) do
    begin
      // -----------------------------------------------------------
      if (DataSet.State in [dsBrowse]) then
      try
        if Assigned(ParamByName(s_IN_SESSION_ID)) then
        begin
          if t1_event_locked_real then
            ParamByName(s_IN_SESSION_ID).AsVariant := Null
          else
            ParamByName(s_IN_SESSION_ID).AsString := IntToStr(Global_Session_ID);
        end;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Error during (P) ' + s_IN_SESSION_ID +
            ' assigning ' + s_IN_SESSION_ID + ' = (' + IntToStr(Global_Session_ID) + ')');
        end;
      end; // try
      // -----------------------------------------------------------
{$IFDEF Debug_Level_5}
      DEBUGMessEnh(0, UnitName, ProcName, Name + '.DataSet_ID = ' + IntToStr(DataSet_ID));
{$ENDIF}
{$IFDEF Debug_Level_5}
      for i := 0 to (Params.Count - 1) do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, Params[i].Name
          + ' = (' + BoolYesNo[Params[i].IsNull] + ') [' + Params[i].AsString + ']');
      end; // for
{$ENDIF}
{$IFDEF Debug_Level_5}
      for i := 0 to (FieldCount - 1) do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, Fields[i].FieldName
          + ' = (' + BoolYesNo[Fields[i].IsNull] + ') [' + Fields[i].AsString + ']');
      end; // for
{$ENDIF}
      // -----------------------------------------------------------
    end; // with
  // -----------------------------------------------------------
end;

procedure Tdm_Base.ds_DatasetBeforeClose(DataSet: TDataSet);
const
  ProcName: string = 'ds_DatasetBeforeClose';
begin
  // -----------------------------------------------------------
  if (DataSet is TpFIBDataSet) then
    with (DataSet as TpFIBDataSet) do
    begin
      if (DataSet_ID > 0) and (DataSet_ID <= RF_DataSetsCount) then
      begin
        Changelog_Events_Reg(false, Dataset);
      end;
    end;
  // -----------------------------------------------------------
end;

procedure Tdm_Base.Prepare_Buf_Dataset;
const
  ProcName: string = 'Prepare_Buf_Dataset';
var
  reccount: Integer;
  tmp_ChangeKod_Max: Int64;
  str_ChangeKod: string;
begin
  //
  FChangelog_Buf_Busy := ds_Changelog_Buf.Active and FChangelog_Buf_Busy;
  if FChangelog_Buf_Busy then
  begin
    DEBUGMessEnh(0, UnitName, ProcName, 'Waiting... - PrepareBuf');
    while FChangelog_Buf_Busy do
      Application.ProcessMessages;
    DEBUGMessEnh(0, UnitName, ProcName, 'Continue... - PrepareBuf');
  end;
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  with ds_Changelog_Buf do
  begin
    FChangelog_Buf_Busy := true;
    try
      try
        Active := false;
        {
        SelectSQL.Text :=
          'select CHANGE_KOD, SESSION_ID, CHANGE_STAMP, CHANGE_ACTION,' +
          ' CHANGED_TABLE_ID, CHANGED_TABLE_NAM, CHANGED_TABLE_KOD, CHANGED_TABLE_VER' +
          ' from SP_CHANGELOG_RF(:IN_SESSION_ID, :IN_CHANGE_NUM, :IN_TABLE_LIST)';
        }
        tmp_ChangeKod_Max := Changelog_Max_Value;
        // Копируем Select-sql для идентичности полей
        if ((ds_Changelog_List.DataSet_ID <> 0)
          and (DataSet_ID <> ds_Changelog_List.DataSet_ID)) then
        begin
          SelectSQL.Text := ds_Changelog_List.SelectSQL.Text;
          DataSet_ID := ds_Changelog_List.DataSet_ID;
          // Должен прибыть пустой набор
          if Assigned(Params.FindParam(s_IN_SESSION_ID)) then
            ParamByName(s_IN_SESSION_ID).AsString := IntToStr(Global_Session_ID);
          if Assigned(Params.FindParam(s_IN_CHANGE_NUM)) then
            ParamByName(s_IN_CHANGE_NUM).AsString := IntToStr(tmp_ChangeKod_Max);
          if Assigned(Params.FindParam(s_IN_TABLE_LIST)) then
            ParamByName(s_IN_TABLE_LIST).AsString := '';
          Open;
          First;
          Last;
          reccount := RecordCount;
          DEBUGMessEnh(0, UnitName, ProcName, 'RecordCount0 = (' + IntToStr(reccount) + ')');
          if (reccount > 0) then
          begin
            str_ChangeKod := '';
            if Assigned(FN(s_CHANGE_KOD)) then
            try
              str_ChangeKod := FN(s_CHANGE_KOD).AsString;
              tmp_ChangeKod_Max := StrToInt(str_ChangeKod);
              Changelog_Max_Value := tmp_ChangeKod_Max;
            finally
              DEBUGMessEnh(0, UnitName, ProcName, s_CHANGE_KOD + ' = (' + str_ChangeKod + ')');
            end;
          end;
          // Обновили Select-sql из репозитория
          Close;
        end;
        DataSet_ID := 0;
        // DEBUGMessEnh(0, UnitName, ProcName, 'SelectSQL.Text = (' + SelectSQL.Text + ')');
        if Assigned(Params.FindParam(s_IN_SESSION_ID)) then
          ParamByName(s_IN_SESSION_ID).AsString := IntToStr(Global_Session_ID);
        if Assigned(Params.FindParam(s_IN_CHANGE_NUM)) then
          ParamByName(s_IN_CHANGE_NUM).AsString := IntToStr(tmp_ChangeKod_Max);
        if Assigned(Params.FindParam(s_IN_TABLE_LIST)) then
          ParamByName(s_IN_TABLE_LIST).AsString := '';
        // ---------
        // Чтобы операции (I,U,D) были без обращений к базе
        // ---------
        // Гуляя по исходникам библиотеки FIBPlus, я обнаружил, что если
        // Поставить "No Action", то SQL-операторы на сервер не передаются.
        // Основная проблема была в том, что если оставить их пустыми, то
        // методы Append, Edit будут недоступны. Однако при Delete этот фокус
        // не пройдет, см. ниже.
        // ---------
        InsertSQL.Text := s_No_Action;
        UpdateSQL.Text := s_No_Action;
        DeleteSQL.Text := s_No_Action;
        // Держим открытым до дисконнекта
        Open;
        Last; // Это для определения реального числа записей в RecordCount
        First;
        reccount := RecordCount;
        DEBUGMessEnh(0, UnitName, ProcName, 'RecordCount1 = (' + IntToStr(reccount) + ')');
        // Очищаем буфер-датасет
        while (not Eof) do
        try
          Delete;
        except
          Next;
        end;
        reccount := RecordCount;
        DEBUGMessEnh(0, UnitName, ProcName, 'RecordCount2 = (' + IntToStr(reccount) + ')');
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Error preparing Buffer_Dataset.');
        end;
      end;
    finally
      FChangelog_Buf_Busy := false;
    end;
    DEBUGMessEnh(0, UnitName, ProcName, 'Buffer_Dataset.Active = [' + BoolYesNo[Active] + ']');
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tdm_Base.Clear_Buf_Dataset(const TableName: string);
const
  ProcName: string = 'Clear_Buf_Dataset';
var
  Field_Exists: Boolean;
  reccount: Integer;
begin
  if not ds_Changelog_Buf.Active then
  begin
    FChangelog_Buf_Busy := false;
    Exit;
  end;
  //
  if FChangelog_Buf_Busy or t1_event_locked_real then
  begin
    DEBUGMessEnh(0, UnitName, ProcName, 'Waiting... - ClearBuf(' + TableName + ')');
    while FChangelog_Buf_Busy or t1_event_locked_real do
      Application.ProcessMessages;
    DEBUGMessEnh(0, UnitName, ProcName, 'Continue... - ClearBuf(' + TableName + ')');
  end;
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, 'Enter into - ClearBuf(' + TableName + ')');
  with ds_Changelog_Buf do
    if Active then
    begin
      FChangelog_Buf_Busy := true;
      try
        try
          First;
          Field_Exists := Assigned(FN(s_CHANGED_TABLE_NAM));
          reccount := RecordCount;
          DEBUGMessEnh(0, UnitName, ProcName, 'RecordCount1 = (' + IntToStr(reccount) + ')');
          // Очищаем буфер-датасет
          if (TableName = '') or (not Field_Exists) then
            while (not Eof) do
            try
              Delete;
            except
              Next;
            end
          else
            while (not Eof) do
            begin
              try
                if (FN(s_CHANGED_TABLE_NAM).AsString <> TableName) then
                  Next
                else
                  Delete;
              except
                Next;
              end;
            end;
          reccount := RecordCount;
          DEBUGMessEnh(0, UnitName, ProcName, 'RecordCount2 = (' + IntToStr(reccount) + ')');
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, 'Error during Buf_Dataset clearing.');
          end;
        end;
      finally
        FChangelog_Buf_Busy := false;
      end;
    end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tdm_Base.ChangelogEvent(const EventName: string; const EventCount: Integer;
  const BufferOnly: Boolean);
const
  ProcName: string = 'ChangelogEvent';
var
  str_TableName, str_TableKod, str_TableVer: string;
  fibDS: TpFIBDataSet;
  j, iz_MixDS: Integer;
  z_MixDS: TMixDS;
  updrec, reccnt: Integer;
  sIns, sUpd, sDel: string;
  bIns, bUpd, bDel: boolean;
  iKey: Integer;
  Saved_EnabledControls: Boolean;
  var_ChangeKod_Max: Int64;
  // -----------------------------------------------------------

  procedure ProcessChangelog(ds_Buffer: TpFIBDataSet);
  var
    i: Integer;
    bProcess, bHandled, bFieldTypeError, bRecordFound: Boolean;
  begin
    bProcess := false;
    if (Assigned(ds_Buffer) and (ds_Buffer is TpFIBDataSet)
      and ds_Buffer.Active and (ds_Buffer.RecordCount > 0)) then
      bProcess := true;
    if bProcess then
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Processing ' + ds_Buffer.Name + '...');
      for i := 0 to FEventTableNames.Count - 1 do
      begin
        str_TableName := FEventTableNames.Names[i];
        iz_MixDS := StrToInt(FEventTableNames.Values[str_TableName]);
        z_MixDS := Get_DataSetsID_By_Name(iz_MixDS);
        str_TableKod := z_MixDS.DS_FN_Kod;
        str_TableVer := z_MixDS.DS_FN_Ver;
        fibDS := nil;
        if (FEventTableNames.Objects[i] is TpFIBDataSet) then
          fibDS := (FEventTableNames.Objects[i] as TpFIBDataSet);
        if Assigned(fibDS) and (str_TableName <> '')
          and (str_TableKod <> '') and (str_TableVer <> '') then
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Cycle for [' + str_TableName + '], ' +
            fibDS.Name + '.State = ' + ds_States[fibDS.State] + '');
          ds_Buffer.First;
          // -----------------------------------------------------------
          // Если редактируем, то уходим - сделаем это в другой раз,
          // можно здесь пользователя предупредить об обновлениях
          // -----------------------------------------------------------
          if fibDS.State <> dsBrowse then
          begin
            if ds_Buffer <> ds_Changelog_Buf then
              // fibds.EnableControls;
              while not ds_Buffer.Eof do
              try
                try
                  if (ds_Buffer.FN(s_CHANGED_TABLE_ID).AsInteger = z_MixDS.DS_UID) then
                  begin
                    ds_Changelog_Buf.Append;
                    //--
                    ds_Changelog_Buf.FN(s_CHANGE_KOD).AsVariant :=
                      ds_Buffer.FN(s_CHANGE_KOD).AsVariant;
                    //--
                    ds_Changelog_Buf.FN(s_SESSION_ID).AsString :=
                      ds_Buffer.FN(s_SESSION_ID).AsString;
                    //--
                    ds_Changelog_Buf.FN(s_CHANGE_STAMP).AsDateTime :=
                      ds_Buffer.FN(s_CHANGE_STAMP).AsDateTime;
                    //--
                    ds_Changelog_Buf.FN(s_CHANGE_ACTION).AsString :=
                      ds_Buffer.FN(s_CHANGE_ACTION).AsString;
                    //--
                    ds_Changelog_Buf.FN(s_CHANGED_TABLE_ID).AsInteger :=
                      ds_Buffer.FN(s_CHANGED_TABLE_ID).AsInteger;
                    //--
                    ds_Changelog_Buf.FN(s_CHANGED_TABLE_NAM).AsString :=
                      ds_Buffer.FN(s_CHANGED_TABLE_NAM).AsString;
                    //--
                    ds_Changelog_Buf.FN(s_CHANGED_TABLE_KOD).AsVariant :=
                      ds_Buffer.FN(s_CHANGED_TABLE_KOD).AsVariant;
                    //--
                    ds_Changelog_Buf.FN(s_CHANGED_TABLE_VER).AsVariant :=
                      ds_Buffer.FN(s_CHANGED_TABLE_VER).AsVariant;
                    //--
                    try
                      ds_Changelog_Buf.Post;
                      Inc(reccnt);
                    except
                      ds_Changelog_Buf.Cancel;
                    end;
                  end;
                except
                  on E: Exception do
                  begin
                    DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
                    DEBUGMessEnh(0, UnitName, ProcName, fibds.Name +
                      '.Refresh failed.');
                  end;
                end;
                // Обновляем "возраст", обработанные записи выбраны больше не будут
                var_ChangeKod_Max := Max(var_ChangeKod_Max,
                  StrToInt(ds_Buffer.FN(s_CHANGE_KOD).AsString));
              finally
                ds_Buffer.Next;
              end; // while and finally
          end
          else
          begin
            with fibds do
            begin
              Saved_EnabledControls := not ControlsDisabled;
              // Запоминаем значение ключа, чтобы потом поставить
              // пользователя на нужную запись
              iKey := FN(str_TableKod).AsInteger;
              DisableControls;
            end;
            try
              with fibds do
              begin
                // -----------------------------------------------------------
                // Гуляя по исходникам библиотеки FIBPlus, я обнаружил, что если
                // Поставить "No Action", то SQL-операторы на сервер не передаются.
                // Основная проблема была в том, что если оставить их пустыми, то
                // методы Append, Edit будут недоступны. Однако при Delete этот фокус
                // не пройдет, см. ниже.
                // -----------------------------------------------------------
                sIns := InsertSQL.Text;
                bIns := CanInsert;
                InsertSQL.Text := s_No_Action;
                sUpd := UpdateSQL.Text;
                bUpd := CanEdit;
                UpdateSQL.Text := s_No_Action;
                sDel := DeleteSQL.Text;
                bDel := CanDelete;
                DeleteSQL.Text := s_No_Action;
              end;
              while not ds_Buffer.Eof do
              begin
                bHandled := false;
                try
                  if (ds_Buffer.FN(s_CHANGED_TABLE_ID).AsInteger = z_MixDS.DS_UID) then
                  begin
                    // -----------------------------------------------------------
                    // Добавляем
                    // -----------------------------------------------------------
                    if ds_Buffer.FN(s_CHANGE_ACTION).AsString = s_Inserted then
                    begin
                      with ds_Buffer do
                      begin
                        DEBUGMessEnh(0, UnitName, ProcName, fibds.Name + '.Append(' +
                          str_TableKod + ' = ' + FN(s_CHANGED_TABLE_KOD).AsString + ', ' +
                          str_TableVer + ' = ' + FN(s_CHANGED_TABLE_VER).AsString + ')');
                        fibds.Append;
                        bFieldTypeError := false;
                        if fibds.FN(str_TableKod).DataType in [ftInteger, ftSmallint, ftWord] then
                        begin
                          fibds.FN(str_TableKod).AsInteger := FN(s_CHANGED_TABLE_KOD).AsInteger;
                        end
                        else
                        try
                          fibds.FN(str_TableKod).AsVariant := FN(s_CHANGED_TABLE_KOD).AsVariant;
                        except
                          bFieldTypeError := true;
                        end;
                        fibds.FN(str_TableVer).AsInteger := 0;
                        { fibds.FN(str_TableVer).AsInteger := FN(s_CHANGED_TABLE_VER).AsInteger; }
                      end;
                      if bFieldTypeError then
                        fibds.Cancel
                      else
                      try
                        fibds.Post;
                        Dec(t1_non_upd_rec);
                        try
                          fibds.Refresh;
                          bHandled := true;
                        except
                          on E: Exception do
                          begin
                            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
                            DEBUGMessEnh(0, UnitName, ProcName, fibds.Name +
                              '.Refresh failed.');
                          end;
                        end;
                      except
                        fibds.Cancel;
                      end;
                    end;
                    // -----------------------------------------------------------
                    // При удалении мы не можем четко узнать число записей,
                    // нужных для обновления - к ним примешиваются записи, удаленные и
                    // этим клиентом, но они, в таком случае, не будут найдены по Locate
                    // -----------------------------------------------------------
                    if ds_Buffer.FN(s_CHANGE_ACTION).AsString = s_Killed then
                    begin
                      dec(t1_non_upd_rec);
                      dec(updrec);
                    end;
                    bRecordFound := false;
                    if fibds.FN(str_TableKod).DataType in [ftInteger, ftSmallint, ftWord] then
                    begin
                      bRecordFound := fibds.Locate(str_TableKod,
                        ds_Buffer.FN(s_CHANGED_TABLE_KOD).AsInteger, []);
                    end
                    else
                    try
                      bRecordFound := fibds.Locate(str_TableKod,
                        ds_Buffer.FN(s_CHANGED_TABLE_KOD).AsVariant, []);
                    except
                    end;
                    if bRecordFound then
                    begin
                      // -----------------------------------------------------------
                      // удаляем, запись была не наша.
                      // -----------------------------------------------------------
                      try
                        if ds_Buffer.FN(s_CHANGE_ACTION).AsString = s_Killed then
                        begin
                          with ds_Buffer do
                          begin
                            DEBUGMessEnh(0, UnitName, ProcName, fibds.Name + '.Delete(' +
                              str_TableKod + ' = ' + FN(s_CHANGED_TABLE_KOD).AsString + ', ' +
                              str_TableVer + ' = ' + FN(s_CHANGED_TABLE_VER).AsString + ')');
                          end;
                          fibds.Delete;
                          inc(updrec);
                          bHandled := true;
                        end;
                      except
                      end;
                      // -----------------------------------------------------------
                      // Обновляем
                      // -----------------------------------------------------------
                      if ds_Buffer.FN(s_CHANGE_ACTION).AsString = s_Updated then
                      begin
                        with ds_Buffer do
                        begin
                          DEBUGMessEnh(0, UnitName, ProcName, fibds.Name + '.Edit(' +
                            str_TableKod + ' = ' + FN(s_CHANGED_TABLE_KOD).AsString + ', ' +
                            str_TableVer + ' = ' + FN(s_CHANGED_TABLE_VER).AsString + ')');
                          fibds.Edit;
                          bFieldTypeError := false;
                          if fibds.FN(str_TableKod).DataType in [ftInteger, ftSmallint, ftWord] then
                          begin
                            fibds.FN(str_TableKod).AsInteger := FN(s_CHANGED_TABLE_KOD).AsInteger;
                          end
                          else
                          try
                            fibds.FN(str_TableKod).AsVariant := FN(s_CHANGED_TABLE_KOD).AsVariant;
                          except
                            bFieldTypeError := true;
                          end;
                          fibds.FN(str_TableVer).AsInteger := 0;
                          { fibds.FN(str_TableVer).AsInteger := FN(s_CHANGED_TABLE_VER).AsInteger; }
                        end;
                        if bFieldTypeError then
                          fibds.Cancel
                        else
                        try
                          fibds.Post;
                          Dec(t1_non_upd_rec);
                          try
                            fibds.Refresh;
                            bHandled := true;
                          except
                            on E: Exception do
                            begin
                              DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
                              DEBUGMessEnh(0, UnitName, ProcName, fibds.Name +
                                '.Refresh failed.');
                            end;
                          end;
                        except
                          fibds.Cancel;
                        end;
                      end;
                    end;
                    // Обновляем "возраст", обработанные записи выбраны больше не будут
                    var_ChangeKod_Max := Max(var_ChangeKod_Max,
                      StrToInt(ds_Buffer.FN(s_CHANGE_KOD).AsString));
                  end;
                finally
                  if bHandled then
                  try
                    ds_Buffer.Delete;
                  except
                    ds_Buffer.Next;
                  end
                  else
                    ds_Buffer.Next;
                end; // finally
              end; // while
            finally
              // восстанавливаем все обратно
              fibds.InsertSQL.Text := sIns;
              fibds.UpdateSQL.Text := sUpd;
              fibds.DeleteSQL.Text := sDel;
              if fibds.State = dsBrowse then
                fibds.Locate(str_TableKod, iKey, []);
              if Saved_EnabledControls then
                fibds.EnableControls;
              {
              Label2.Caption := '';
              if t1_non_upd_rec <> 0 then
                Label2.Caption := 'Невозможно обновить ' + IntToStr(t1_non_upd_rec) + ' записей'
              else
                Label2.Caption := 'Другими пользователями обновлено ' + IntToStr(updrec) +
                  ' записей';
              }
            end;
          end;
          // -----------------------------------------------------------
        end
        else
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Cannot do cycle for [' + str_TableName + '].');
        end;
      end; // for
    end; // if
  end;
var
  Saved_Dataset_ID: Integer;
  str_TableList, str_TableIns, str_TableUpd: string;
begin
  // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  if t1_event_locked_real then
  begin
    DEBUGMessEnh(0, UnitName, ProcName, 'Waiting... - t1_event_locked_real');
    while t1_event_locked_real do
      Application.ProcessMessages;
    DEBUGMessEnh(0, UnitName, ProcName, 'Continue... - t1_event_locked_real');
  end;
  DEBUGMessEnh(1, UnitName, ProcName, '>>>--->>>--->>>');
  // -----------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, 'EventName = (' + EventName + '), Count = (' +
    IntToStr(EventCount) + ')');
  try
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // t1_event_locked_real введен мною для того, чтобы предотвратить
    // повторный вызов этого события, если находимся в нем.
    // Может и излишняя предосторожность, но пусть,
    // к тому же пригодилось в событии выше
    // -----------------------------------------------------------
    if 1 = 1 then
    begin
      // -----------------------------------------------------------
      t1_event_locked_real := true;
      tmr_Buffer.Enabled := false;
      // -----------------------------------------------------------
      Saved_Dataset_ID := ds_Changelog_List.DataSet_ID;
      var_ChangeKod_Max := Changelog_Max_Value;
      try
        with ds_Changelog_List do
        begin
          Active := false;
          if (ds_Changelog_List.Tag = 0) then
          begin
            // Меняем туда и обратно, чтобы автоматически установились нужные флаги и опции
            DataSet_ID := 0;
            DataSet_ID := Saved_Dataset_ID;
            // Должен прибыть пустой набор
            if Assigned(Params.FindParam(s_IN_SESSION_ID)) then
              ParamByName(s_IN_SESSION_ID).AsVariant := Null;
            if Assigned(Params.FindParam(s_IN_CHANGE_NUM)) then
              ParamByName(s_IN_CHANGE_NUM).AsVariant := Null;
            if Assigned(Params.FindParam(s_IN_TABLE_LIST)) then
              ParamByName(s_IN_TABLE_LIST).AsVariant := Null;
            if Assigned(Params.FindParam(s_IN_TABLE_INS)) then
              ParamByName(s_IN_TABLE_INS).AsVariant := Null;
            if Assigned(Params.FindParam(s_IN_TABLE_UPD)) then
              ParamByName(s_IN_TABLE_UPD).AsVariant := Null;
            // Внутри идет вызов ListDataSetInfo.LoadDataSetInfo,
            // если (psApplyRepositary in PrepareOptions) and (DataSet_ID>0)
            Prepare;
            // Обновили Select-sql из репозитория
            Close;
            ds_Changelog_List.Tag := 1;
          end;
          DataSet_ID := 0;
          if (1 = 0) then
          begin
            SelectSQL.Text :=
              'select CHANGE_KOD, SESSION_ID, CHANGE_STAMP, CHANGE_ACTION,' +
              ' CHANGED_TABLE_ID, CHANGED_TABLE_NAM, CHANGED_TABLE_KOD, CHANGED_TABLE_VER' +
              ' from SP_CHANGELOG_RF(:IN_SESSION_ID, :IN_CHANGE_NUM,' +
              ' :IN_TABLE_LIST, :IN_TABLE_INS, :IN_TABLE_UPD)';
          end;
          // No insert, update or delete for ds_Changelog_List
          InsertSQL.Text := s_No_Action;
          UpdateSQL.Text := s_No_Action;
          DeleteSQL.Text := s_No_Action;
          // -----------------------------------------------------------
          // выбираем записи введенные или измененные не этим пользователем,
          // это не относится к удаленным записям - они выбираются все.
          // -----------------------------------------------------------
          if Assigned(Params.FindParam(s_IN_SESSION_ID)) then
            ParamByName(s_IN_SESSION_ID).AsString := IntToStr(Global_Session_ID);
          if Assigned(Params.FindParam(s_IN_CHANGE_NUM)) then
            ParamByName(s_IN_CHANGE_NUM).AsString := IntToStr(var_ChangeKod_Max);
          if Assigned(Params.FindParam(s_IN_TABLE_LIST)) then
          begin
            str_TableList := s_Delimiter;
            for j := 0 to FEventTableNames.Count - 1 do
            begin
              str_TableName := FEventTableNames.Names[j];
              iz_MixDS := StrToInt(FEventTableNames.Values[str_TableName]);
              z_MixDS := Get_DataSetsID_By_Name(iz_MixDS);
              str_TableList := str_TableList + IntToStr(z_MixDS.DS_UID) + s_Delimiter;
            end;
            DEBUGMessEnh(0, UnitName, ProcName, 'str_TableList = (' + str_TableList + ')');
            ParamByName(s_IN_TABLE_LIST).AsString := str_TableList;
          end;
          if Assigned(Params.FindParam(s_IN_TABLE_INS)) then
          begin
            str_TableIns := s_Delimiter;
            for j := 0 to FEventTableNames.Count - 1 do
            begin
              str_TableName := FEventTableNames.Names[j];
              iz_MixDS := StrToInt(FEventTableNames.Values[str_TableName]);
              z_MixDS := Get_DataSetsID_By_Name(iz_MixDS);
              if (z_MixDS.DS_InsUpd and 1 = 1) then
                str_TableIns := str_TableIns + IntToStr(z_MixDS.DS_UID) + s_Delimiter;
            end;
            DEBUGMessEnh(0, UnitName, ProcName, 'str_TableIns = (' + str_TableIns + ')');
            ParamByName(s_IN_TABLE_INS).AsString := str_TableIns;
          end;
          if Assigned(Params.FindParam(s_IN_TABLE_UPD)) then
          begin
            str_TableUpd := s_Delimiter;
            for j := 0 to FEventTableNames.Count - 1 do
            begin
              str_TableName := FEventTableNames.Names[j];
              iz_MixDS := StrToInt(FEventTableNames.Values[str_TableName]);
              z_MixDS := Get_DataSetsID_By_Name(iz_MixDS);
              if (z_MixDS.DS_InsUpd and 2 = 2) then
                str_TableUpd := str_TableUpd + IntToStr(z_MixDS.DS_UID) + s_Delimiter;
            end;
            DEBUGMessEnh(0, UnitName, ProcName, 'str_TableUpd = (' + str_TableUpd + ')');
            ParamByName(s_IN_TABLE_UPD).AsString := str_TableUpd;
          end;
          // -----------------------------------------------------------
          Open;
          Last; // Это для определения реального числа записей в RecordCount
          First;
          updrec := RecordCount;
          DEBUGMessEnh(0, UnitName, ProcName, 'UpdRecTotal = (' + IntToStr(updrec) + ')');
        end;
        //если не все записи будут обновлены
        t1_non_upd_rec := updrec;
        reccnt := 0;
        // -----------------------------------------------------------
        ProcessChangelog(ds_Changelog_Buf);
        if not BufferOnly then
        begin
          ProcessChangelog(ds_Changelog_List);
          // ProcessChangelog(ds_Changelog_Buf);
        end;
        // -----------------------------------------------------------
        reccnt := ds_Changelog_Buf.RecordCount;
        if reccnt <> 0 then
          DEBUGMessEnh(0, UnitName, ProcName, 'В буфере ' + IntToStr(reccnt)
            + ' необновленных записей.');
        if t1_non_upd_rec <> 0 then
          DEBUGMessEnh(0, UnitName, ProcName, 'Невозможно обновить ' + IntToStr(t1_non_upd_rec)
            + ' записей.')
        else
          DEBUGMessEnh(0, UnitName, ProcName, 'Другими пользователями обновлено ' + IntToStr(updrec)
            + ' записей.');
        // -----------------------------------------------------------
      finally
        Changelog_Max_Value := var_ChangeKod_Max;
        try
          ds_Changelog_List.Close;
          ds_Changelog_List.DataSet_ID := Saved_Dataset_ID;
          tmr_Buffer.Enabled := (ds_Changelog_Buf.RecordCount > 0);
        except
        end;
        // -----------------------------------------------------------
        t1_event_locked_real := false;
        // -----------------------------------------------------------
      end;
    end;
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  except
    on E: Exception do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'Something failed.');
    end;
  end;
  Refresh_TC_Count(30);
  // -----------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<<<---<<<---<<<');
  // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
end;

procedure Tdm_Base.db_kino2Connect(Sender: TObject);
begin
  //
  Prepare_Buf_Dataset;
end;

procedure Tdm_Base.ev_ChangelogEventAlert(Sender: TObject; EventName: string; EventCount: Integer);
const
  ProcName: string = 'ev_ChangelogEventAlert';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  try
    ChangelogEvent(EventName, EventCount, false);
  except
    on E: Exception do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'ChangelogEvent() failed.');
    end;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tdm_Base.tmr_BufferTimer(Sender: TObject);
const
  ProcName: string = 'tmr_BufferTimer';
begin
  try
    if not (t1_event_locked_real or FEventProcessed or FChangelog_Buf_Busy) then
    begin
      if (ds_Changelog_Buf.RecordCount > 0) then
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Calling ChangelogEvent() on timer');
        ChangelogEvent('', 0, true);
      end;
      tmr_Buffer.Enabled := false;
    end
    else
    begin
      if not tmr_Buffer.Enabled then
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Setting ChangelogEvent() on next tick');
        tmr_Buffer.Enabled := true;
      end;
    end;
  except
    on E: Exception do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
      DEBUGMessEnh(0, UnitName, ProcName, 'ChangelogEvent() failed.');
    end;
  end;
end;

procedure Tdm_Base.db_kino2BeforeDisconnect(Sender: TObject);
const
  ProcName: string = 'db_kino2BeforeDisconnect';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tdm_Base.db_kino2LostConnect(Database: TFIBDatabase; E: EFIBError; var Actions:
  TOnLostConnectActions);
const
  ProcName: string = 'db_kino2LostConnect';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  {laTerminateApp, laCloseConnect, laIgnore, laWaitRestore}
  DEBUGMessEnh(0, UnitName, ProcName, 'E.SQLCode = (' + IntToStr(E.SQLCode) +
    ') = (' + IntToHex(E.SQLCode, 8) + ')');
  DEBUGMessEnh(0, UnitName, ProcName, 'E.Message = (' + E.Message + ')');
  Actions := laCloseConnect;
  // todo: Restore connect
  DBConnected2 := db_kino2.Connected;
  Update_DB_Conn_State;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tdm_Base.db_kino2ErrorRestoreConnect(Database: TFIBDatabase; E: EFIBError; var Actions:
  TOnLostConnectActions);
const
  ProcName: string = 'db_kino2ErrorRestoreConnect';
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  DEBUGMessEnh(0, UnitName, ProcName, 'E.Message = (' + E.Message + ')');
  DEBUGMessEnh(0, UnitName, ProcName, 'E.SQLCode = (' + IntToStr(E.SQLCode) +
    ') = (' + IntToHex(E.SQLCode, 8) + ')');
  Actions := laTerminateApp;
  // todo: Restore connect
  DBConnected2 := db_kino2.Connected;
  Update_DB_Conn_State;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tdm_Base.eh_Kino2FIBErrorEvent(Sender: TObject;
  ErrorValue: EFIBError; KindIBError: TKindIBError; var DoRaise: Boolean);
begin
  //
end;

procedure Tdm_Base.ds_MovesFieldChange(Sender: TField);
const
  ProcName: string = 'ds_MovesFieldChange';
begin
  // DEBUGMessEnh(1, UnitName, ProcName, '->');
{$IFDEF Debug_Level_9}
  // --------------------------------------------------------------------------
  if Assigned(Sender) and (Sender is TField) then
    DEBUGMessEnh(0, UnitName, ProcName, 'Changed ' + (Sender as TField).FieldName + '.');
  // --------------------------------------------------------------------------
{$ENDIF}
  // Reload_TC(Cur_Repert_Kod);
  // DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tdm_Base.ds_MovesAfterRefresh(DataSet: TDataSet);
const
  ProcName: string = 'ds_MovesAfterRefresh';
begin
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  Reload_TC(Cur_Repert_Kod);
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tdm_Base.ds_RepertFieldChange(Sender: TField);
const
  ProcName: string = 'ds_RepertFieldChange';
begin
  // DEBUGMessEnh(1, UnitName, ProcName, '->');
{$IFDEF Debug_Level_6}
  // --------------------------------------------------------------------------
  if Assigned(Sender) and (Sender is TField) then
    DEBUGMessEnh(0, UnitName, ProcName, 'Changed ' + (Sender as TField).FieldName + '.');
  // --------------------------------------------------------------------------
{$ENDIF}
  // DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tdm_Base.ds_RepertAfterRefresh(DataSet: TDataSet);
const
  ProcName: string = 'ds_RepertAfterRefresh';
begin
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  Update_Changes_Monitor;
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tdm_Base.ds_RepertAfterDelete(DataSet: TDataSet);
const
  ProcName: string = 'ds_RepertAfterDelete';
begin
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(1, UnitName, ProcName, '->');
{$ENDIF}
  // --------------------------------------------------------------------------
  ds_DatasetAfterPostOrCancelOrDelete(DataSet);
  if Assigned(DataSet) and (DataSet is TDataSet) then
    DEBUGMessEnh(0, UnitName, ProcName, 'Changed - ' + DataSet.Name + '.AfterDelete');
  Update_Changes_Monitor;
  // --------------------------------------------------------------------------
{$IFDEF Debug_Level_9}
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
{$ENDIF}
end;

procedure Tdm_Base.ds_Rep_Daily_BeforeOpen(DataSet: TDataSet);
const
  ProcName: string = 'ds_Rep_Daily_BeforeOpen';
{$IFDEF Debug_Level_5}
var
  i: Integer;
{$ENDIF}
begin
  // -----------------------------------------------------------
  if (DataSet is TpFIBDataSet) then
    with (DataSet as TpFIBDataSet) do
    begin
      DEBUGMessEnh(0, UnitName, ProcName, 'Opening (' + Name + ')');
      if (DataSet.State in [dsInactive]) then
      try
        // -----------------------------------------------------------
        if (DataSet_ID > 0) then
        begin
{$IFDEF Debug_Level_9}
          DEBUGMessEnh(0, UnitName, ProcName, Name + '.SelectSQL.Text = ['
            + SelectSQL.Text + ']');
{$ENDIF}
          DataSet_ID := 0;
        end;
        // -----------------------------------------------------------
        if Assigned(ParamByName(s_IN_SESSION_ID)) then
        begin
          ParamByName(s_IN_SESSION_ID).AsString := IntToStr(Global_Session_ID);
        end;
      except
        on E: Exception do
        begin
          DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
          DEBUGMessEnh(0, UnitName, ProcName, 'Error during (0) ' + s_IN_SESSION_ID +
            ' assigning ' + s_IN_SESSION_ID + ' = (' + IntToStr(Global_Session_ID) + ')');
        end;
      end; // try
      // -----------------------------------------------------------
{$IFDEF Debug_Level_5}
      for i := 0 to (Params.Count - 1) do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, Params[i].Name
          + ' = (' + BoolYesNo[Params[i].IsNull] + ') [' + Params[i].AsString + ']');
      end; // for
{$ENDIF}
    end; // with
  // -----------------------------------------------------------
end;

end.

