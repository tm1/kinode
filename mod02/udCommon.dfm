object dm_Common: Tdm_Common
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 192
  Top = 107
  Height = 480
  Width = 696
  object db_kino1: TpFIBDatabase
    DBName = 'localhost:C:\FB_DATA\KAPPA.FDB'
    DBParams.Strings = (
      'lc_ctype=WIN1251'
      'user_name=SYSDBA'
      'password=masterkey')
    DefaultTransaction = tr_Common_Read1
    SQLDialect = 3
    Timeout = 0
    UpperOldNames = True
    AfterDisconnect = db_kino1AfterDisconnect
    DesignDBOptions = [ddoIsDefaultDatabase]
    SaveDBParams = False
    Left = 40
    Top = 24
  end
  object tr_Common_Read1: TpFIBTransaction
    DefaultDatabase = db_kino1
    TimeoutAction = TACommit
    TRParams.Strings = (
      'read'
      'read_committed'
      'rec_version'
      'nowait')
    TPBMode = tpbDefault
    Left = 136
    Top = 24
  end
  object tr_Common_Write1: TpFIBTransaction
    DefaultDatabase = db_kino1
    TimeoutAction = TACommit
    TRParams.Strings = (
      'write'
      'concurrency'
      'nowait')
    TPBMode = tpbDefault
    Left = 232
    Top = 24
  end
  object tr_Session_Start1: TpFIBTransaction
    DefaultDatabase = db_kino1
    TimeoutAction = TACommit
    TRParams.Strings = (
      'write'
      'concurrency'
      'nowait')
    TPBMode = tpbDefault
    Left = 40
    Top = 168
  end
  object tr_Session_Finish1: TpFIBTransaction
    DefaultDatabase = db_kino1
    TimeoutAction = TACommit
    TRParams.Strings = (
      'write'
      'concurrency'
      'nowait')
    TPBMode = tpbDefault
    Left = 40
    Top = 240
  end
  object tr_DBUser_Write: TpFIBTransaction
    DefaultDatabase = db_kino1
    TimeoutAction = TACommit
    TRParams.Strings = (
      'write'
      'concurrency'
      'nowait')
    TPBMode = tpbDefault
    Left = 328
    Top = 24
  end
  object sp_Get_Version: TpFIBStoredProc
    Database = db_kino1
    ParamCheck = True
    SQL.Strings = (
      'EXECUTE PROCEDURE IP_GET_VERSION ')
    Transaction = tr_Common_Read1
    StoredProcName = 'IP_GET_VERSION'
    Left = 40
    Top = 96
    qoAutoCommit = True
    qoStartTransaction = True
  end
  object ds_DBUser: TpFIBDataSet
    Database = db_kino1
    Transaction = tr_Common_Read1
    Options = [poTrimCharFields, poRefreshAfterPost, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_DBUser_Write
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  DBU.DBUSER_KOD,'
      '  DBU.DBUSER_NAM'
      'from'
      '  SP_DBUSER_LIST_S DBU'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 1
    Left = 136
    Top = 96
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object qr_DBUser_List: TpFIBQuery
    Database = db_kino1
    ParamCheck = True
    SQL.Strings = (
      'select * from SP_DBUSER_LIST_S')
    Transaction = tr_Common_Read1
    Left = 232
    Top = 96
    qoAutoCommit = True
    qoStartTransaction = True
  end
  object eh_Kino1: TpFibErrorHandler
    Left = 328
    Top = 96
  end
  object sp_Session_Start: TpFIBStoredProc
    Database = db_kino1
    ParamCheck = True
    SQL.Strings = (
      
        'EXECUTE PROCEDURE IP_SESSION_START (?USER_UID, ?USER_KEY, ?USER_' +
        'HOST)')
    Transaction = tr_Session_Start1
    StoredProcName = 'IP_SESSION_START'
    Left = 136
    Top = 168
    qoAutoCommit = True
    qoStartTransaction = True
  end
  object sp_Session_Finish: TpFIBStoredProc
    Database = db_kino1
    ParamCheck = True
    SQL.Strings = (
      
        'EXECUTE PROCEDURE IP_SESSION_FINISH (?USER_UID, ?SESSION_SID, ?S' +
        'ESSION_KEY)')
    Transaction = tr_Session_Finish1
    StoredProcName = 'IP_SESSION_FINISH'
    Left = 232
    Top = 168
  end
end
