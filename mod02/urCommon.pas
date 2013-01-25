{-----------------------------------------------------------------------------
 Unit Name: urCommon
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  19.04.2004
 Purpose:   DB datamodule resouces
 History:
-----------------------------------------------------------------------------}
unit urCommon;

interface

uses
  ibase, db;

const
  Def_SQLDialect: integer = 3;
  Def_UserKod: integer = 2;
  Def_Client_Lib: string = IBASE_DLL;
  DBConnected1: Boolean = false;
  DBConnected2: Boolean = false;
  DBLastError1: string = '<none>';
  DBLastError2: string = '<none>';
  // -------------------------------------------------------------------------
  Global_User_Kod: integer = 0;
  Global_User_Nam: string = '';
  Global_Session_ID: int64 = 0;
  Global_Session_Key: string = '';
  Sec_Role_Name: string = '';
  Sec_User_Name: string = '';
  Sec_Password: string = '';
  // -------------------------------------------------------------------------
  App_Version_Checked: Boolean = false;
  sApp_ProductName: string = '<unknown-program>';
  sApp_ProductVersion: string = '0.0.0.0';
  sApp_FileVersion: string = '0.0.0.0';
  sClient_DLL_Path: string = IBASE_DLL;
  Client_DLL_Version_Checked: Boolean = false;
  sClient_DLL_ProductName: string = '<unknown-client>';
  sClient_DLL_ProductVersion: string = '0.0.0.0';
  sClient_DLL_FileVersion: string = '0.0.0.0';
  // -------------------------------------------------------------------------
  Actualize_Mess: string = 'Хотите продать бронь для %u места в %u ряду ?'
  + #13#10#13#10 + 'Подсказка:' + #13#10 + '=====================' + #13#10 + '%s';
  Restore_Mess: string = 'Хотите вернуть билет для %u места в %u ряду ?'
  + #13#10#13#10 + 'Подсказка:' + #13#10 + '=====================' + #13#10 + '%s';
  // -------------------------------------------------------------------------
  // _Zal_Prefix: string = 'UN';
  // _Serial: integer = 0;
  // _Print_Serial: boolean = false;
  // _Show_All_Info: Boolean = false;
  s_No_Action: string = 'No Action';
  s_Delimiter: char = '~';
  s_Inserted: char = 'I';
  s_Updated: char = 'U';
  s_Killed: char = 'K';
  s_Deleted: char = 'D';
  s_Recovered: char = 'R';
  s_Hupted: char = 'H';
  {
  Value	        Meaning
  ----------------------------------------------------------------------
  dsInactive	Dataset is closed, so its data is unavailable.
  dsBrowse	Data can be viewed, but not changed. This is the default state of an open dataset.
  dsEdit	Active record can be modified.
  dsInsert	The active record is a newly inserted buffer that has not been posted. This record can be modified and then either posted or discarded.
  dsSetKey	TTable and TClientDataSet only. Record searching is enabled, or a SetRange operation is under way. A restricted set of data can be viewed, and no data can be edited or inserted.
  dsCalcFields	An OnCalcFields event is in progress. Noncalculated fields cannot be edited, and new records cannot be inserted.
  dsFilter	An OnFilterRecord event is in progress. A restricted set of data can be viewed. No data can edited or inserted.
  dsNewValue	Temporary state used internally to indicate that a field component’s NewValue property is being accessed.
  dsOldValue	Temporary state used internally to indicate that a field component’s OldValue property is being accessed.
  dsCurValue	Temporary state used internally to indicate that a field component’s CurValue property is being accessed.
  dsBlockRead	Data-aware controls are not updated and events are not triggered when the cursor moves (Next is called).
  dsInternalCalc	Temporary state used internally to indicate that values need to be calculated for a field that has a FieldKind of fkInternalCalc.
  dsOpening	DataSet is in the process of opening but has not finished. This state occurs when the dataset is opened for asynchronous fetching.
  }
  ds_States: array[TDatasetState] of string =
  (
    'Неактивно [dsInactive]',
    'Просмотр [dsBrowse]',
    'Редактирование [dsEdit]',
    'Вставка [dsInsert]',
    '[dsSetKey]',
    '[dsCalcFields]',
    'Фильтруется... [dsFilter]',
    '[dsNewValue]',
    '[dsOldValue]',
    '[dsCurValue]',
    '[dsBlockRead]',
    '[dsInternalCalc]',
    'Открывается... [dsOpening]'
    );

  // -------------------------------------------------------------------------
  // Ticket possible actions
  // -------------------------------------------------------------------------
  // 'R' -- Reserve   -- (R-(S-C:S-A:S-J)) //
  // 'P' -- Sale      -- (P-(S-C:S-M:S-F)) //
  // 'A' -- Actualize -- (A-(S-C:S-F))     //
  // 'M' -- Modify    -- (M-(S-C:S-F))     //
  // 'J' -- Free      -- (F-S)             //
  // 'F' -- Restore   -- (R-S)             //
  // 'S' -- Select    -- (S-(C:R:P:A:J:F)) //
  // 'C' -- Cancel    -- (C-S)             //
  // -------------------------------------------------------------------------
  {
  s_ACTION_RESERVE = 'R';
  s_ACTION_SALE = 'P';
  s_ACTION_ACTUALIZE = 'A';
  s_ACTION_FREE = 'J';
  s_ACTION_RESTORE = 'F';
  s_ACTION_SELECT = 'S';
  s_ACTION_CANCEL = 'C';
  }
  // -------------------------------------------------------------------------
  Common_Odeum_Horz_Pos: integer = 10;
  Common_Odeum_Vert_Pos: integer = 50;
  // -------------------------------------------------------------------------
  m_CRLF = '\n';
  max_CinemaLogoBmp_Fmt_Len: integer = 5;
  max_OdeumLogoBmp_Fmt_Len: integer = 5;
  max_OdeumName_Fmt_Len: integer = 1023;
  // -------------------------------------------------------------------------
  max_Ryad_Fmt_Len: integer = 1023;
  max_Mesto_Fmt_Len: integer = 1023;
  max_Cena_Fmt_Len: integer = 1023;
  max_Summa_Fmt_Len: integer = 1023;
  max_Tenge_Fmt_Len: integer = 1023;
  max_Halyava_Fmt_Len: integer = 1023;
  max_Kolvomest_Fmt_Len: integer = 1023;
  // -------------------------------------------------------------------------
  max_FilmName_Fmt_Len: integer = 1023;
  max_SeansDateTime_Fmt_Len: integer = 1023;
  max_GroupNum_Fmt_Len: integer = 1023;
  max_GroupSum_Fmt_Len: integer = 1023;
  max_NomerRyada_Fmt_Len: integer = 1023;
  max_NomerMesta_Fmt_Len: integer = 1023;
  max_TicketLabel_Fmt_Len: integer = 1023;
  max_TicketSum_Fmt_Len: integer = 1023;
  max_SerialNum_Fmt_Len: integer = 1023;
  // -------------------------------------------------------------------------
  max_CinemaLogoBmp_Pos_Value: integer = 999;
  max_OdeumLogoBmp_Pos_Value: integer = 999;
  max_OdeumName_Pos_Value: integer = 999;
  // -------------------------------------------------------------------------
  max_Ryad_Pos_Value: integer = 999;
  max_Mesto_Pos_Value: integer = 999;
  max_Cena_Pos_Value: integer = 999;
  max_Summa_Pos_Value: integer = 999;
  max_Tenge_Pos_Value: integer = 999;
  max_Halyava_Pos_Value: integer = 999;
  max_Kolvomest_Pos_Value: integer = 999;
  // -------------------------------------------------------------------------
  max_FilmName_Pos_Value: integer = 999;
  max_SeansDateTime_Pos_Value: integer = 999;
  max_GroupNum_Pos_Value: integer = 999;
  max_GroupSum_Pos_Value: integer = 999;
  max_NomerRyada_Pos_Value: integer = 999;
  max_NomerMesta_Pos_Value: integer = 999;
  max_TicketLabel_Pos_Value: integer = 999;
  max_TicketSum_Pos_Value: integer = 999;
  max_SerialNum_Pos_Value: integer = 999;
  // -------------------------------------------------------------------------
  CinemaLogoBmp1_Pos_X_Def: integer = 100;
  CinemaLogoBmp1_Pos_Y_Def: integer = 100;
  OdeumLogoBmp1_Pos_X_Def: integer = 100;
  OdeumLogoBmp1_Pos_Y_Def: integer = 100;
  OdeumName1_Pos_X_Def: integer = 100;
  OdeumName1_Pos_Y_Def: integer = 100;
  // -------------------------------------------------------------------------
  Ryad1_Pos_X_Def: integer = 100;
  Ryad1_Pos_Y_Def: integer = 100;
  Mesto1_Pos_X_Def: integer = 100;
  Mesto1_Pos_Y_Def: integer = 100;
  Cena1_Pos_X_Def: integer = 100;
  Cena1_Pos_Y_Def: integer = 100;
  Summa1_Pos_X_Def: integer = 100;
  Summa1_Pos_Y_Def: integer = 100;
  Tenge1_Pos_X_Def: integer = 100;
  Tenge1_Pos_Y_Def: integer = 100;
  Halyava1_Pos_X_Def: integer = 100;
  Halyava1_Pos_Y_Def: integer = 100;
  Kolvomest1_Pos_X_Def: integer = 100;
  Kolvomest1_Pos_Y_Def: integer = 100;
  // -------------------------------------------------------------------------
  FilmName1_Pos_X_Def: integer = 100;
  FilmName1_Pos_Y_Def: integer = 100;
  SeansDateTime1_Pos_X_Def: integer = 100;
  SeansDateTime1_Pos_Y_Def: integer = 100;
  GroupNum1_Pos_X_Def: integer = 100;
  GroupNum1_Pos_Y_Def: integer = 100;
  GroupSum1_Pos_X_Def: integer = 100;
  GroupSum1_Pos_Y_Def: integer = 100;
  NomerRyada1_Pos_X_Def: integer = 100;
  NomerRyada1_Pos_Y_Def: integer = 100;
  NomerMesta1_Pos_X_Def: integer = 100;
  NomerMesta1_Pos_Y_Def: integer = 100;
  TicketLabel1_Pos_X_Def: integer = 100;
  TicketLabel1_Pos_Y_Def: integer = 100;
  TicketSum1_Pos_X_Def: integer = 100;
  TicketSum1_Pos_Y_Def: integer = 100;
  SerialNum1_Pos_X_Def: integer = 100;
  SerialNum1_Pos_Y_Def: integer = 100;
  SerialNum2_Pos_X_Def: integer = 100;
  SerialNum2_Pos_Y_Def: integer = 100;
  // -------------------------------------------------------------------------

resourcestring
  // Some predefined constants
  // -------------------------------------------------------------------------
  Ini_File_Name = 'kinode.ini';
  // -------------------------------------------------------------------------
  Def_DatabaseName = 'localhost/3051:C:\FB_DATA\kappa.fdb';
  Def_CharSet = 'WIN1251';
  Def_RoleName = 'ENTRANCE';
  Def_UserName = 'CASHIER001';
  Def_Password = 'secondarykey';
  // -------------------------------------------------------------------------
  s_Database_Section = 'Database';
  s_SQLDialect = 'SQLDialect';
  s_DatabaseName = 'DatabaseName';
  s_CharSet = 'CharSet';
  s_RoleName = 'RoleName';
  s_UserName = 'UserName';
  s_Password = 'Password';
  s_LastUser = 'LastUser';
  s_UserKod = 'UserKod';
  s_Preferences_Section = 'Preferences';
  s_OdeumKod = 'OdeumKod';
  s_OdeumBgColor = 'OdeumBgColor';
  s_CommonOdeumHorzPos = 'CommonOdeumHorzPos';
  s_CommonOdeumVertPos = 'CommonOdeumVertPos';
  s_OdeumHorzPos = 'OdeumHorzPos';
  s_OdeumVertPos = 'OdeumVertPos';
  s_CommonOdeumShowHint = 'CommonOdeumShowHint';
  s_PrintMaketVersion = 'PrintMaketVersion';
  s_PrintMaketHorzShift = 'PrintMaketHorzShift';
  s_PrintMaketVertShift = 'PrintMaketVertShift';
  s_Yes = 'Yes';
  s_No = 'No';
  s_RptPref = 'RptPref';
  s_BlankForm_Section = 'BlankForm';
  s_BlankForm_Num = 'BlankFormNumber';
  str_Fmt = '_Fmt';
  str_Pos_X = '_Pos_X';
  str_Pos_Y = '_Pos_Y';
  str_CinemaLogoBmp = 'CinemaLogoBmp';
  CinemaLogoBmp_Fmt_Def = '@2,%s';
  str_OdeumLogoBmp = 'OdeumLogoBmp';
  OdeumLogoBmp_Fmt_Def = '@2,%s';
  str_OdeumName = 'OdeumName';
  OdeumName_Fmt_Def = '@2,050,050' + m_CRLF + '#Courier New,1000,20,204' + m_CRLF + '^0190,0030;' + '%s';
  str_Ryad = 'Ryad';
  Ryad_Fmt_Def = '@2,000,050' + m_CRLF + '#Arial,0000,16,204' + m_CRLF + '^0029,0000;' + '%s';
  str_Mesto = 'Mesto';
  Mesto_Fmt_Def = '@2,000,050' + m_CRLF + '#Arial,0000,16,204' + m_CRLF + '^0040,0000;' + '%s';
  str_Cena = 'Cena';
  Cena_Fmt_Def = '@2,000,050' + m_CRLF + '#Arial,0000,16,204' + m_CRLF + '^0032,0000;' + '%s';
  str_Summa = 'Summa';
  Summa_Fmt_Def = '@2,000,050' + m_CRLF + '#Arial,0000,16,204' + m_CRLF + '^0032,0000;' + '%s';
  str_Tenge = 'Tenge';
  Tenge_Fmt_Def = '@2,000,050' + m_CRLF + '#Arial,0000,16,204' + m_CRLF + '^0028,0000;' + '%s';
  str_Halyava = 'Halyava';
  Halyava_Fmt_Def = '@2,000,050' + m_CRLF + '#Arial,0000,18,204' + m_CRLF + '^0105,0000;' + '%s';
  str_Kolvomest = 'Kolvomest';
  Kolvomest_Fmt_Def = '@2,000,050' + m_CRLF + '#Arial,0000,16,204' + m_CRLF + '^0092,0000;' + '%s';
  str_FilmName = 'FilmName';
  FilmName_Fmt_Def = '@2,025,050' + m_CRLF + '#Times New Roman,1000,25,204' + m_CRLF + '^0246,0000;' + '%s';
  str_SeansDateTime = 'SeansDateTime';
  SeansDateTime_Fmt_Def = '@2,000,050' + m_CRLF + '#Arial,0000,19,204' + m_CRLF + '^0120,0000;' + '%s' + m_CRLF
    + '#Arial,0000,18,204' + m_CRLF + '^0052,0000;' + '  ' + '%s' + '  ' + m_CRLF
    + '#Arial,1000,19,204' + m_CRLF + '^0048,0000;' + '%s';
  str_GroupNum = 'GroupNum';
  GroupNum_Fmt_Def = '@2,000,050' + m_CRLF + '#Arial,1100,20,204' + m_CRLF + '^0181,0000;' + '%s' + m_CRLF;
  str_GroupSum = 'GroupSum';
  GroupSum_Fmt_Def = '@2,000,050' + m_CRLF + '#Arial,0000,18,204' + m_CRLF + '^0030,0000;' + '%s';
  str_NomerRyada = 'NomerRyada';
  NomerRyada_Fmt_Def = '@2,000,050' + m_CRLF + '#Arial,1100,20,204' + m_CRLF + '^0039,0000;' + '%s' + m_CRLF;
  str_NomerMesta = 'NomerMesta';
  NomerMesta_Fmt_Def = '@2,000,050' + m_CRLF + '#Arial,1100,20,204' + m_CRLF + '^0039,0000;' + '%s';
  str_TicketLabel = 'TicketLabel';
  TicketLabel_Fmt_Def = '@2,000,050' + m_CRLF + '#Arial,0000,18,204' + m_CRLF + '^0105,0000;' + '%s';
  str_TicketSum = 'TicketSum';
  TicketSum_Fmt_Def = '@2,000,050' + m_CRLF + '#Arial,1000,19,204' + m_CRLF + '^0032,0000;' + '%s';
  str_SerialNum = 'SerialNum';
  SerialNum_Fmt_Def = '@2,000,050' + m_CRLF + '#Arial,1000,20,204' + m_CRLF + '^0068,0000;' + '%s%s';
  // -------------------------------------------------------------------------
  // Procedure names and params
  // -------------------------------------------------------------------------
  s_SECRET = '*****';
  s_IP_GET_VERSION = 'IP_GET_VERSION';
  s_VERSION_MAJOR = 'VERSION_MAJOR';
  s_VERSION_MINOR = 'VERSION_MINOR';
  s_VERSION_RELEASE = 'VERSION_RELEASE';
  s_VERSION_BUILD = 'VERSION_BUILD';
  s_IP_SESSION_START = 'IP_SESSION_START';
  s_USER_UID = 'USER_UID';
  s_USER_KEY = 'USER_KEY';
  s_USER_HOST = 'USER_HOST';
  s_USER_PROG = 'USER_PROG';
  s_USER_CLIENT = 'USER_CLIENT';
  s_SESSION_SID = 'SESSION_SID';
  s_SESSION_KEY = 'SESSION_KEY';
  s_ROLE_NAME = 'ROLE_NAME';
  s_USER_NAME = 'USER_NAME';
  s_USER_PASS = 'USER_PASS';
  s_ERROR_ID = 'ERROR_ID';
  s_ERROR_TEXT = 'ERROR_TEXT';
  s_LOCK_FLAG = 'LOCK_FLAG';
  s_IP_SESSION_FINISH = 'IP_SESSION_FINISH';
  s_IP_CREATE_TARIFF_VERSION = 'IP_CREATE_TARIFF_VERSION';
  s_IN_TARIFF_KOD = 'IN_TARIFF_KOD';
  s_IN_TARIFF_VER = 'IN_TARIFF_VER';
  // s_OUT_RECORDS_COUNT = 'OUT_RECORDS_COUNT';
  s_OUT_TARIFF_VER = 'OUT_TARIFF_VER';
  s_IP_OPER_MOD = 'IP_OPER_MOD';
  s_IN_OPER_ACTION = 'IN_OPER_ACTION';
  // s_IN_OPER_PRINTED = 'IN_OPER_PRINTED';
  s_IN_OPER_PRINT_COUNT = 'IN_OPER_PRINT_COUNT';
  s_IN_OPER_CHEQED = 'IN_OPER_CHEQED';
  s_IN_OPER_PLACE_ROW = 'IN_OPER_PLACE_ROW';
  s_IN_OPER_PLACE_COL = 'IN_OPER_PLACE_COL';
  s_IN_OPER_SALE_FORM = 'IN_OPER_SALE_FORM';
  s_IN_OPER_REPERT_KOD = 'IN_OPER_REPERT_KOD';
  s_IN_OPER_TICKET_KOD = 'IN_OPER_TICKET_KOD';
  s_IN_OPER_MISC_REASON = 'IN_OPER_MISC_REASON';
  s_OUT_OPER_KOD = 'OPER_KOD';
  s_OUT_OPER_SERIAL = 'OPER_MISC_SERIAL';
  s_IP_OPER_CLR = 'IP_OPER_CLR';
  s_IN_CLEAR_MODE = 'IN_CLEAR_MODE';
  s_OUT_TOTAL_COUNT = 'TOTAL_COUNT';
  s_OUT_CLEARED_COUNT = 'CLEARED_COUNT';
  // -------------------------------------------------------------------------
  // Dataset open params
  // -------------------------------------------------------------------------
  s_IN_SESSION_ID = 'IN_SESSION_ID';
  s_IN_FILT_REPERT_DATE = 'IN_FILT_REPERT_DATE';
  s_IN_FILT_MODE_DATE = 'IN_FILT_MODE_DATE';
  s_IN_FILT_REPERT_ODEUM = 'IN_FILT_REPERT_ODEUM';
  s_IN_FILT_MODE_ODEUM = 'IN_FILT_MODE_ODEUM';
  s_IN_FILT_TARIFF_KOD = 'IN_FILT_TARIFF_KOD';
  s_IN_FILT_TARIFF_VER = 'IN_FILT_TARIFF_VER';
  s_IN_FILT_ODEUM = 'IN_FILT_ODEUM';
  s_IN_FILT_DATE = 'IN_FILT_DATE';
  s_IN_FILT_MODE = 'IN_FILT_MODE';
  s_IN_FILT_REPERT = 'IN_FILT_REPERT';
  s_IN_UPDATE_ID = 'IN_UPDATE_ID';
  s_IN_FILT_PARAM1 = 'IN_FILT_PARAM1';
  s_IN_REPORT_MODE = 'IN_REPORT_MODE';
  // -------------------------------------------------------------------------
  // Event names and fields
  // -------------------------------------------------------------------------
  s_EVENT_PREFIX = 'CHANGED_';
  s_EVENT_POSTFIX1_INSERT = '_INSERT';
  s_EVENT_POSTFIX2_UPDATE = '_UPDATE';
  s_EVENT_POSTFIX3_KILL = '_KILL';
  s_IN_CHANGE_NUM = 'IN_CHANGE_NUM';
  s_MAX_CHANGE_KOD = 'MAX_CHANGE_KOD';
  s_IN_TABLE_LIST = 'IN_TABLE_LIST';
  s_IN_TABLE_INS = 'IN_TABLE_INS';
  s_IN_TABLE_UPD = 'IN_TABLE_UPD';
  s_CHANGE_KOD = 'CHANGE_KOD';
  s_SESSION_ID = 'SESSION_ID';
  s_CHANGE_STAMP = 'CHANGE_STAMP';
  s_CHANGE_ACTION = 'CHANGE_ACTION';
  s_CHANGED_TABLE_ID = 'CHANGED_TABLE_ID';
  s_CHANGED_TABLE_NAM = 'CHANGED_TABLE_NAM';
  s_CHANGED_TABLE_KOD = 'CHANGED_TABLE_KOD';
  s_CHANGED_TABLE_VER = 'CHANGED_TABLE_VER';
  // -------------------------------------------------------------------------
  // Dataset names and fields
  // -------------------------------------------------------------------------
  s_DBUSER = 'DBUSER';
  // s_DBUSER_CHANGED = 'DBUSER_CHANGED';
  // s_AU_DBUSER = 'AU_DBUSER';
  s_DBUSER_KOD = 'DBUSER_KOD';
  s_DBUSER_NAM = 'DBUSER_NAM';
  s_DBUSER_HASH = 'DBUSER_HASH';
  s_DBUSER_ENABLED = 'DBUSER_ENABLED';
  // -------------------------------------------------------------------------
  s_ODEUM = 'ODEUM';
  // s_ODEUM_CHANGED = 'ODEUM_CHANGED';
  // s_AU_ODEUM = 'AU_ODEUM';
  s_ODEUM_KOD = 'ODEUM_KOD';
  s_ODEUM_NAM = 'ODEUM_NAM';
  s_ODEUM_CINEMA = 'ODEUM_CINEMA';
  s_CINEMA_NAM = 'CINEMA_NAM';
  s_ODEUM_PREFIX = 'ODEUM_PREFIX';
  s_ODEUM_CAPACITY = 'ODEUM_CAPACITY';
  s_ODEUM_DESC = 'ODEUM_DESC';
  s_ODEUM_ENABLED = 'ODEUM_ENABLED';
  s_CINEMA_LOGO = 'CINEMA_LOGO';
  s_ODEUM_LOGO = 'ODEUM_LOGO';
  // -------------------------------------------------------------------------
  s_REPERT = 'REPERT';
  // s_REPERT_CHANGED = 'REPERT_CHANGED';
  // s_AU_REPERT = 'AU_REPERT';
  s_REPERT_KOD = 'REPERT_KOD';
  s_REPERT_DATE = 'REPERT_DATE';
  s_REPERT_ODEUM_KOD = 'REPERT_ODEUM_KOD';
  s_REPERT_ODEUM_VER = 'REPERT_ODEUM_VER';
  s_REPERT_SEANS_KOD = 'REPERT_SEANS_KOD';
  s_REPERT_SEANS_VER = 'REPERT_SEANS_VER';
  s_REPERT_FILM_KOD = 'REPERT_FILM_KOD';
  s_REPERT_FILM_VER = 'REPERT_FILM_VER';
  s_REPERT_TARIFF_KOD = 'REPERT_TARIFF_KOD';
  s_REPERT_TARIFF_VER = 'REPERT_TARIFF_VER';
  s_REPERT_DESC = 'REPERT_DESC';
  s_REPERT_ENABLED = 'REPERT_ENABLED';
  // -------------------------------------------------------------------------
  s_TARIFF = 'TARIFF';
  // s_TARIFF_CHANGED = 'TARIFF_CHANGED';
  // s_AU_TARIFF = 'AU_TARIFF';
  s_TARIFF_KOD = 'TARIFF_KOD';
  s_TARIFF_VER = 'TARIFF_VER';
  s_TARIFF_NAM = 'TARIFF_NAM';
  s_TARIFF_BASE_COST = 'TARIFF_BASE_COST';
  s_TARIFF_FREEZED = 'TARIFF_FREEZED';
  s_TARIFF_DESC = 'TARIFF_DESC';
  s_TARIFF_COMMENT = 'TARIFF_COMMENT';
  // s_TARIFF_ENABLED = 'TARIFF_ENABLED';
  // -------------------------------------------------------------------------
  s_GLOBVAR = 'GLOBVAR';
  // s_GLOBVAR_CHANGED = 'GLOBVAR_CHANGED';
  // s_AU_GLOBVAR = 'AU_GLOBVAR';
  s_GLOBVAR_KOD = 'GLOBVAR_KOD';
  s_GLOBVAR_NAM = 'GLOBVAR_NAM';
  s_GLOBVAR_COMMENT = 'GLOBVAR_COMMENT';
  s_GLOBVAR_VALUE = 'GLOBVAR_VALUE';
  // -------------------------------------------------------------------------
  s_SEAT = 'SEAT';
  // s_SEAT_CHANGED = 'SEAT_CHANGED';
  // s_AU_PLACE = 'AU_PLACE';
  s_SEAT_KOD = 'SEAT_KOD';
  s_SEAT_ODEUM = 'SEAT_ODEUM';
  s_SEAT_COL = 'SEAT_COL';
  s_SEAT_ROW = 'SEAT_ROW';
  s_SEAT_X = 'SEAT_X';
  s_SEAT_Y = 'SEAT_Y';
  s_SEAT_BROKEN = 'SEAT_BROKEN';
  // -------------------------------------------------------------------------
  s_TICKET = 'TICKET';
  // s_TICKET_CHANGED = 'TICKET_CHANGED';
  // s_AU_TICKET = 'AU_TICKET';
  s_TICKET_KOD = 'TICKET_KOD';
  s_TICKET_NAM = 'TICKET_NAM';
  s_TICKET_CLASS = 'TICKET_CLASS';
  s_TICKET_CALCUL1 = 'TICKET_CALCUL1';
  s_TICKET_CONST1 = 'TICKET_CONST1';
  s_TICKET_MAKET = 'TICKET_MAKET';
  s_TICKET_LABEL = 'TICKET_LABEL';
  s_TICKET_SERIALIZE = 'TICKET_SERIALIZE';
  s_TICKET_BGCOLOR = 'TICKET_BGCOLOR';
  s_TICKET_FNTCOLOR = 'TICKET_FNTCOLOR';
  s_TICKET_MENU_ORDER = 'TICKET_MENU_ORDER';
  s_TICKET_USE_COUNT = 'TICKET_USE_COUNT';
  s_TICKET_LAST_ACCESS = 'TICKET_LAST_ACCESS';
  s_TICKET_VISIBLE = 'TICKET_VISIBLE';
  // -------------------------------------------------------------------------
  s_CLASS = 'CLASS';
  // s_CLASS_CHANGED = 'CLASS_CHANGED';
  // s_AU_CLASS = 'AU_CLASS';
  s_CLASS_KOD = 'CLASS_KOD';
  s_CLASS_NAM = 'CLASS_NAM';
  s_CLASS_TO_PRINT = 'CLASS_TO_PRINT';
  s_CLASS_FOR_FREE = 'CLASS_FOR_FREE';
  s_CLASS_INVITED_GUEST = 'CLASS_INVITED_GUEST';
  s_CLASS_GROUP_VISIT = 'CLASS_GROUP_VISIT';
  s_CLASS_VIP_CARD = 'CLASS_VIP_CARD';
  s_CLASS_VIP_BYNAME = 'CLASS_VIP_BYNAME';
  s_CLASS_SEASON_TICKET = 'CLASS_SEASON_TICKET';
  // -------------------------------------------------------------------------
  s_FILM = 'FILM';
  // s_FILM_CHANGED = 'FILM_CHANGED';
  // s_AU_FILM = 'AU_FILM';
  s_FILM_KOD = 'FILM_KOD';
  s_FILM_VER = 'FILM_VER';
  s_FILM_NAM = 'FILM_NAM';
  s_FILM_GENRE_KOD = 'FILM_GENRE_KOD';
  s_FILM_GENRE_VER = 'FILM_GENRE_VER';
  s_FILM_RELEASE = 'FILM_RELEASE';
  s_FILM_SCREENTIME = 'FILM_SCREENTIME';
  s_FILM_COMMENT = 'FILM_COMMENT';
  s_FILM_USE_COUNT = 'FILM_USE_COUNT';
  s_FILM_LAST_ACCESS = 'FILM_LAST_ACCESS';
  s_FILM_DESC = 'FILM_DESC';
  // -------------------------------------------------------------------------
  s_COST = 'COST';
  // s_COST_CHANGED = 'COST_CHANGED';
  // s_AU_COST = 'AU_COST';
  s_COST_KOD = 'COST_KOD';
  s_COST_TARIFF_KOD = 'COST_TARIFF_KOD';
  s_COST_TARIFF_VER = 'COST_TARIFF_VER';
  s_COST_TICKET_KOD = 'COST_TICKET_KOD';
  s_COST_TICKET_VER = 'COST_TICKET_VER';
  s_COST_VALUE = 'COST_VALUE';
  s_COST_FREEZED = 'COST_FREEZED';
  // -------------------------------------------------------------------------
  s_OPER = 'OPER';
  // s_OPER_CHANGED = 'OPER_CHANGED';
  // s_AU_OPER = 'AU_OPER';
  s_OPER_REPERT = 'OPER_REPERT';
  s_OPER_REPERT_DATE = 'OPER_REPERT_DATE';
  s_OPER_REPERT_ODEUM = 'OPER_REPERT_ODEUM';
  s_OPER_REPERT_SEANS = 'OPER_REPERT_SEANS';
  s_OPER_REPERT_FILM = 'OPER_REPERT_FILM';
  s_OPER_REPERT_TARIFF = 'OPER_REPERT_TARIFF';
  // s_OPER_ODEUM_PLACE = 'OPER_ODEUM_PLACE';
  // s_OPER_TICKET = 'OPER_TICKET';
  // s_OPER_SUM = 'OPER_SUM';
  // s_OPER_TIMESTAMP1 = 'OPER_TIMESTAMP1';
  // s_OPER_TIMESTAMP2 = 'OPER_TIMESTAMP2';
  // s_OPER_STATE_CH = 'OPER_STATE_CH';
  // s_OPER_STATE_SELECTED = 'OPER_STATE_SELECTED';
  // s_OPER_STATE_HISTORY = 'OPER_STATE_HISTORY';
  // s_OPER_STATE_RESTORED = 'OPER_STATE_RESTORED';
  // s_OPER_STATE_PRINTED = 'OPER_STATE_PRINTED';
  // s_OPER_MISC_INVITER = 'OPER_MISC_INVITER';
  // s_OPER_MISC_GROUP = 'OPER_MISC_GROUP';
  // s_OPER_MISC_CARD = 'OPER_MISC_CARD';

  s_OPER_KOD = 'OPER_KOD';
  s_OPER_VER = 'OPER_VER';
  s_OPER_STATE = 'OPER_STATE';
  s_OPER_SELECTED = 'OPER_SELECTED';
  s_OPER_ACTION = 'OPER_ACTION';
  // s_OPER_PRINTED = 'OPER_PRINTED';
  s_OPER_PRINT_COUNT = 'OPER_PRINT_COUNT';
  s_OPER_CHEQED = 'OPER_CHEQED';
  s_OPER_PLACE_ROW = 'OPER_PLACE_ROW';
  s_OPER_PLACE_COL = 'OPER_PLACE_COL';
  s_OPER_COST_VALUE = 'OPER_COST_VALUE';
  s_OPER_LOCK_STAMP = 'OPER_LOCK_STAMP';
  s_OPER_SALE_FORM = 'OPER_SALE_FORM';
  s_OPER_SALE_STAMP = 'OPER_SALE_STAMP';
  s_OPER_MOD_STAMP = 'OPER_MOD_STAMP';
  s_OPER_REPERT_KOD = 'OPER_REPERT_KOD';
  s_OPER_REPERT_VER = 'OPER_REPERT_VER';
  s_OPER_TICKET_KOD = 'OPER_TICKET_KOD';
  s_OPER_TICKET_VER = 'OPER_TICKET_VER';
  s_OPER_SEAT_KOD = 'OPER_SEAT_KOD';
  s_OPER_SEAT_VER = 'OPER_SEAT_VER';
  s_OPER_MISC_REASON = 'OPER_MISC_REASON';
  s_OPER_MISC_SERIAL = 'OPER_MISC_SERIAL';
  s_SESSION_HOST = 'SESSION_HOST';
  s_SESSION_DBUSER = 'SESSION_DBUSER';
  // -------------------------------------------------------------------------
  s_PRICE = 'PRICE';
  // s_PRICE_CHANGED = 'PRICE_CHANGED';
  // s_AU_PRICE = 'AU_PRICE';
  s_PRICE_KOD = 'PRICE_KOD';
  s_PRICE_VER = 'PRICE_VER';
  s_PRICE_ABONEM_KOD = 'PRICE_ABONEM_KOD';
  s_PRICE_ABONEM_VER = 'PRICE_ABONEM_VER';
  s_PRICE_VALUE = 'PRICE_VALUE';
  s_PRICE_FREEZED = 'PRICE_FREEZED';
  // -------------------------------------------------------------------------
  s_ABJNL = 'ABJNL';
  // s_ABJNL_CHANGED = 'ABJNL_CHANGED';
  // s_AU_ABJNL = 'AU_ABJNL';
  s_ABJNL_KOD = 'ABJNL_KOD';
  s_ABJNL_VER = 'ABJNL_VER';
  s_ABJNL_ODEUM_KOD = 'ABJNL_ODEUM_KOD';
  s_ABJNL_ODEUM_VER = 'ABJNL_ODEUM_VER';
  s_ABJNL_ABONEM_KOD = 'ABJNL_ABONEM_KOD';
  s_ABJNL_ABONEM_VER = 'ABJNL_ABONEM_VER';
  s_ABJNL_PRICE_KOD = 'ABJNL_PRICE_KOD';
  s_ABJNL_PRICE_VER = 'ABJNL_PRICE_VER';
  s_ABJNL_SALE_DATE = 'ABJNL_SALE_DATE';
  s_ABJNL_STATE = 'ABJNL_STATE';
  s_ABJNL_CHEQED = 'ABJNL_CHEQED';
  s_ABJNL_MOD_STAMP = 'ABJNL_MOD_STAMP';
  s_ABJNL_FREEZED = 'ABJNL_FREEZED';
  // -------------------------------------------------------------------------
  s_GENRE = 'GENRE';
  // s_GENRE_CHANGED = 'GENRE_CHANGED';
  // s_AU_GENRE = 'AU_GENRE';
  s_GENRE_KOD = 'GENRE_KOD';
  s_GENRE_VER = 'GENRE_VER';
  s_GENRE_NAM = 'GENRE_NAM';
  s_GENRE_COMMENT = 'GENRE_COMMENT';
  s_GENRE_ENABLED = 'GENRE_ENABLED';
  // s_GENRE_USE_COUNT = 'GENRE_USE_COUNT';
  // s_GENRE_LAST_ACCESS = 'GENRE_LAST_ACCESS';
  // -------------------------------------------------------------------------
  s_SEANS = 'SEANS';
  // s_SEANS_CHANGED = 'SEANS_CHANGED';
  // s_AU_SEANS = 'AU_SEANS';
  s_SEANS_KOD = 'SEANS_KOD';
  s_SEANS_HOUR = 'SEANS_HOUR';
  s_SEANS_MINUTE = 'SEANS_MINUTE';
  s_SEANS_TIME = 'SEANS_TIME';
  // -------------------------------------------------------------------------
  s_CARD = 'CARD';
  // s_CARD_CHANGED = 'CARD_CHANGED';
  // s_AU_CARD = 'AU_CARD';
  s_CARD_KOD = 'CARD_KOD';
  s_CARD_KIND = 'CARD_KIND';
  s_CARD_SYM = 'CARD_SYM';
  s_CARD_NUM = 'CARD_NUM';
  s_CARD_IDENT = 'CARD_IDENT';
  s_CARD_HOLDER_NAM = 'CARD_HOLDER_NAM';
  s_CARD_PERSON = 'CARD_PERSON';
  s_CARD_COMMENT = 'CARD_COMMENT';
  s_CARD_START = 'CARD_START';
  s_CARD_FINISH = 'CARD_FINISH';
  s_CARD_ENABLED = 'CARD_ENABLED';
  // -------------------------------------------------------------------------
  s_PERSON = 'PERSON';
  // s_PERSON_CHANGED = 'PERSON_CHANGED';
  // s_AU_PERSON = 'AU_PERSON';
  s_PERSON_KOD = 'PERSON_KOD';
  s_PERSON_NAM = 'PERSON_NAM';
  s_PERSON_ENABLED = 'PERSON_ENABLED';
  // -------------------------------------------------------------------------
  s_GROUPER = 'GROUPER';
  // s_GROUPER_CHANGED = 'GROUPER_CHANGED';
  // s_AU_GROUPER = 'AU_GROUPER';
  s_GROUPER_KOD = 'GROUPER_KOD';
  s_GROUPER_NAM = 'GROUPER_NAM';
  s_GROUPER_ENABLED = 'GROUPER_ENABLED';
  // -------------------------------------------------------------------------
  s_INVITER = 'INVITER';
  // s_INVITER_CHANGED = 'INVITER_CHANGED';
  // s_AU_INVITER = 'AU_INVITER';
  s_INVITER_KOD = 'INVITER_KOD';
  s_INVITER_NAM = 'INVITER_NAM';
  s_INVITER_ENABLED = 'INVITER_ENABLED';
  // -------------------------------------------------------------------------

implementation

end.

