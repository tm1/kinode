object dm_Base: Tdm_Base
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 192
  Top = 107
  Height = 665
  Width = 812
  object db_kino2: TpFIBDatabase
    DBName = 'localhost:C:\FB_DATA\KAPPA.FDB'
    DBParams.Strings = (
      'lc_ctype=WIN1251'
      'user_name=cashier001'
      'sql_role_name=CASHIER'
      'password=secondarykey')
    DefaultTransaction = tr_Common_Read2
    SQLDialect = 3
    Timeout = 0
    OnConnect = db_kino2Connect
    UpperOldNames = True
    BeforeDisconnect = db_kino2BeforeDisconnect
    DesignDBOptions = []
    SaveDBParams = False
    WaitForRestoreConnect = 15000
    OnLostConnect = db_kino2LostConnect
    OnErrorRestoreConnect = db_kino2ErrorRestoreConnect
    Left = 40
    Top = 24
  end
  object tr_Common_Read2: TpFIBTransaction
    DefaultDatabase = db_kino2
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
  object tr_Common_Write2: TpFIBTransaction
    DefaultDatabase = db_kino2
    TimeoutAction = TACommit
    TRParams.Strings = (
      'write'
      'concurrency'
      'nowait')
    TPBMode = tpbDefault
    Left = 232
    Top = 24
  end
  object tr_Session_Finish2: TpFIBTransaction
    DefaultDatabase = db_kino2
    TimeoutAction = TACommit
    TRParams.Strings = (
      'write'
      'concurrency'
      'nowait')
    TPBMode = tpbDefault
    Left = 408
    Top = 24
  end
  object tr_Event_Write3: TpFIBTransaction
    DefaultDatabase = db_kino2
    TimeoutAction = TACommit
    TRParams.Strings = (
      'write'
      'concurrency'
      'nowait')
    TPBMode = tpbDefault
    Left = 320
    Top = 24
  end
  object ds_Branch: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Common_Write2
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  BRN.BRANCH_KOD,'
      '  BRN.BRANCH_NAM,'
      '  BRN.BRANCH_SIGN'
      'from'
      '  SP_BRANCH_LIST_S BRN'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 2
    Left = 136
    Top = 96
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Globset: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Common_Write2
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  GLB.GLOBSET_KOD,'
      '  GLB.GLOBSET_FOOTPRINT,'
      '  GLB.GLOBSET_BRANCH'
      'from'
      '  SP_GLOBSET_LIST_S GLB'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 3
    Left = 232
    Top = 96
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Zal: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Common_Write2
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  ODM.ODEUM_KOD,'
      '  ODM.ODEUM_NAM,'
      '  ODM.ODEUM_CINEMA,'
      '  ODM.CINEMA_NAM,'
      '  ODM.ODEUM_PREFIX,'
      '  ODM.ODEUM_CAPACITY,'
      '  ODM.ODEUM_DESC,'
      '  ODM.CINEMA_LOGO,'
      '  ODM.ODEUM_LOGO'
      'from'
      '  SP_ODEUM_LIST_S ODM'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 4
    Left = 136
    Top = 160
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Place: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Common_Write2
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  STP.SEAT_KOD,'
      '  STP.SEAT_ROW,'
      '  STP.SEAT_COL,'
      '  STP.SEAT_ODEUM,'
      '  STP.SEAT_X,'
      '  STP.SEAT_Y,'
      '  STP.SEAT_BROKEN'
      'from'
      '  SP_SEAT_LIST_S (:IN_FILT_ODEUM) STP'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 5
    Left = 232
    Top = 160
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Cost: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Common_Write2
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    RefreshSQL.Strings = (
      'select'
      '  CST.COST_KOD,'
      '  CST.COST_VER,'
      '  CST.COST_VALUE,'
      '  CST.COST_FREEZED,'
      '  CST.COST_TARIFF_KOD,'
      '  CST.COST_TARIFF_VER,'
      '  CST.COST_TICKET_KOD,'
      '  CST.COST_TICKET_VER,'
      '  CST.TICKET_NAM,'
      '  CST.TICKET_LABEL,'
      '  CST.COST_STAMP,'
      '  CST.SESSION_ID,'
      '  CST.DBUSER_NAM,'
      '  CST.SESSION_HOST'
      'from'
      '  SP_COST_RF ('
      '    :IN_FILT_TARIFF_KOD,'
      '    :IN_FILT_TARIFF_VER,'
      '    ?COST_KOD) CST'
      '')
    SelectSQL.Strings = (
      'select'
      '  CST.COST_KOD,'
      '  CST.COST_VER,'
      '  CST.COST_VALUE,'
      '  CST.COST_FREEZED,'
      '  CST.COST_TARIFF_KOD,'
      '  CST.COST_TARIFF_VER,'
      '  CST.COST_TICKET_KOD,'
      '  CST.COST_TICKET_VER,'
      '  CST.TICKET_NAM,'
      '  CST.TICKET_LABEL,'
      '  CST.COST_STAMP,'
      '  CST.SESSION_ID,'
      '  CST.DBUSER_NAM,'
      '  CST.SESSION_HOST'
      'from'
      '  SP_COST_RF ('
      '    :IN_FILT_TARIFF_KOD,'
      '    :IN_FILT_TARIFF_VER,'
      '    :IN_SESSION_ID) CST'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      'execute procedure SP_TB_COST_U ('
      '  ?OLD_COST_KOD,'
      '  ?COST_VALUE,'
      '  ?COST_FREEZED,'
      '  :IN_SESSION_ID)'
      '')
    AfterCancel = ds_DatasetAfterPostOrCancelOrDelete
    AfterDelete = ds_DatasetAfterPostOrCancelOrDelete
    AfterPost = ds_DatasetAfterPostOrCancelOrDelete
    BeforeClose = ds_DatasetBeforeClose
    BeforeDelete = ds_DatasetBeforeDelete
    BeforeOpen = ds_DatasetBeforeOpen
    BeforePost = ds_DatasetBeforePost
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.KeyFields = 'COST_KOD'
    DataSet_ID = 9
    Left = 136
    Top = 232
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Repert: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Common_Write2
    AutoCommit = True
    OnFieldChange = ds_RepertFieldChange
    BufferChunks = 32
    CachedUpdates = False
    DeleteSQL.Strings = (
      'execute procedure SP_TB_REPERT_D ('
      '  ?OLD_REPERT_KOD,'
      '  :IN_SESSION_ID)'
      '')
    InsertSQL.Strings = (
      'execute procedure SP_TB_REPERT_I ('
      '  ?REPERT_KOD,'
      '  ?REPERT_DATE,'
      '  ?REPERT_ODEUM_KOD,'
      '  ?REPERT_ODEUM_VER,'
      '  ?REPERT_SEANS_KOD,'
      '  ?REPERT_SEANS_VER,'
      '  ?REPERT_FILM_KOD,'
      '  ?REPERT_FILM_VER,'
      '  ?REPERT_TARIFF_KOD,'
      '  ?REPERT_TARIFF_VER,'
      '  :IN_SESSION_ID)'
      '')
    RefreshSQL.Strings = (
      'select'
      '  RPT.REPERT_KOD,'
      '  RPT.REPERT_VER,'
      '  RPT.REPERT_DATE,'
      '  RPT.REPERT_ODEUM_KOD,'
      '  RPT.REPERT_ODEUM_VER,'
      '  RPT.ODEUM_DESC,'
      '  RPT.REPERT_SEANS_KOD,'
      '  RPT.REPERT_SEANS_VER,'
      '  RPT.SEANS_TIME,'
      '  RPT.SEANS_FINISH,'
      '  RPT.REPERT_FILM_KOD,'
      '  RPT.REPERT_FILM_VER,'
      '  RPT.FILM_NAM,'
      '  RPT.FILM_DESC,'
      '  RPT.REPERT_TARIFF_KOD,'
      '  RPT.REPERT_TARIFF_VER,'
      '  RPT.TARIFF_DESC,'
      '  RPT.REPERT_DESC,'
      '  RPT.REPERT_STAMP,'
      '  RPT.SESSION_ID,'
      '  RPT.DBUSER_NAM,'
      '  RPT.SESSION_HOST'
      'from'
      '  SP_REPERT_RF ('
      '    :IN_FILT_REPERT_ODEUM,'
      '    :IN_FILT_MODE_ODEUM,'
      '    :IN_FILT_REPERT_DATE,'
      '    :IN_FILT_MODE_DATE,'
      '    ?REPERT_KOD) RPT'
      '')
    SelectSQL.Strings = (
      'select'
      '  RPT.REPERT_KOD,'
      '  RPT.REPERT_VER,'
      '  RPT.REPERT_DATE,'
      '  RPT.REPERT_ODEUM_KOD,'
      '  RPT.REPERT_ODEUM_VER,'
      '  RPT.ODEUM_DESC,'
      '  RPT.REPERT_SEANS_KOD,'
      '  RPT.REPERT_SEANS_VER,'
      '  RPT.SEANS_TIME,'
      '  RPT.SEANS_FINISH,'
      '  RPT.REPERT_FILM_KOD,'
      '  RPT.REPERT_FILM_VER,'
      '  RPT.FILM_NAM,'
      '  RPT.FILM_DESC,'
      '  RPT.REPERT_TARIFF_KOD,'
      '  RPT.REPERT_TARIFF_VER,'
      '  RPT.TARIFF_DESC,'
      '  RPT.REPERT_DESC,'
      '  RPT.REPERT_STAMP,'
      '  RPT.SESSION_ID,'
      '  RPT.DBUSER_NAM,'
      '  RPT.SESSION_HOST'
      'from'
      '  SP_REPERT_RF ('
      '    :IN_FILT_REPERT_ODEUM,'
      '    :IN_FILT_MODE_ODEUM,'
      '    :IN_FILT_REPERT_DATE,'
      '    :IN_FILT_MODE_DATE,'
      '    :IN_SESSION_ID) RPT'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      'execute procedure SP_TB_REPERT_U ('
      '  ?OLD_REPERT_KOD,'
      '  ?OLD_REPERT_DATE,'
      '  ?OLD_REPERT_ODEUM_KOD,'
      '  ?OLD_REPERT_ODEUM_VER,'
      '  ?REPERT_SEANS_KOD,'
      '  ?REPERT_SEANS_VER,'
      '  ?REPERT_FILM_KOD,'
      '  ?REPERT_FILM_VER,'
      '  ?REPERT_TARIFF_KOD,'
      '  ?REPERT_TARIFF_VER,'
      '  :IN_SESSION_ID)'
      '')
    AfterCancel = ds_DatasetAfterPostOrCancelOrDelete
    AfterDelete = ds_RepertAfterDelete
    AfterPost = ds_DatasetAfterPostOrCancelOrDelete
    BeforeClose = ds_DatasetBeforeClose
    BeforeDelete = ds_DatasetBeforeDelete
    BeforeOpen = ds_DatasetBeforeOpen
    BeforePost = ds_DatasetBeforePost
    AfterRefresh = ds_RepertAfterRefresh
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.KeyFields = 'REPERT_KOD'
    AutoUpdateOptions.GeneratorName = 'GEN_REPERT_KOD'
    AutoUpdateOptions.SelectGenID = True
    DataSet_ID = 13
    Left = 232
    Top = 232
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Ticket: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Common_Write2
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    RefreshSQL.Strings = (
      'select'
      '  TKT.TICKET_KOD,'
      '  TKT.TICKET_VER,'
      '  TKT.TICKET_NAM,'
      '  TKT.TICKET_CLASS,'
      '  TKT.CLASS_NAM,'
      '  TKT.CLASS_TO_PRINT,'
      '  TKT.CLASS_FOR_FREE,'
      '  TKT.CLASS_INVITED_GUEST,'
      '  TKT.CLASS_GROUP_VISIT,'
      '  TKT.CLASS_VIP_CARD,'
      '  TKT.CLASS_VIP_BYNAME,'
      '  TKT.CLASS_SEASON_TICKET,'
      '  TKT.TICKET_CALCUL1,'
      '  TKT.TICKET_CONST1,'
      '  TKT.TICKET_LABEL,'
      '  TKT.TICKET_SERIALIZE,'
      '  TKT.TICKET_BGCOLOR,'
      '  TKT.TICKET_FNTCOLOR,'
      '  TKT.TICKET_MENU_ORDER,'
      '  TKT.TICKET_FREEZED'
      'from'
      '  SP_TICKET_LIST_S ('
      '    5,'
      '    ?TICKET_KOD) TKT'
      '')
    SelectSQL.Strings = (
      'select'
      '  TKT.TICKET_KOD,'
      '  TKT.TICKET_VER,'
      '  TKT.TICKET_NAM,'
      '  TKT.TICKET_CLASS,'
      '  TKT.CLASS_NAM,'
      '  TKT.CLASS_TO_PRINT,'
      '  TKT.CLASS_FOR_FREE,'
      '  TKT.CLASS_INVITED_GUEST,'
      '  TKT.CLASS_GROUP_VISIT,'
      '  TKT.CLASS_VIP_CARD,'
      '  TKT.CLASS_VIP_BYNAME,'
      '  TKT.CLASS_SEASON_TICKET,'
      '  TKT.TICKET_CALCUL1,'
      '  TKT.TICKET_CONST1,'
      '  TKT.TICKET_LABEL,'
      '  TKT.TICKET_SERIALIZE,'
      '  TKT.TICKET_BGCOLOR,'
      '  TKT.TICKET_FNTCOLOR,'
      '  TKT.TICKET_MENU_ORDER,'
      '  TKT.TICKET_FREEZED'
      'from'
      '  SP_TICKET_LIST_S ('
      '    :IN_FILT_MODE,'
      '    :IN_FILT_PARAM1) TKT'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 7
    Left = 320
    Top = 96
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Genre: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Common_Write2
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    DeleteSQL.Strings = (
      'execute procedure SP_TB_GENRE_D ('
      '  ?OLD_GENRE_KOD,'
      '  :IN_SESSION_ID)'
      '')
    InsertSQL.Strings = (
      'execute procedure SP_TB_GENRE_I ('
      '  ?GENRE_KOD,'
      '  ?GENRE_NAM,'
      '  ?GENRE_COMMENT,'
      '  :IN_SESSION_ID)'
      '')
    RefreshSQL.Strings = (
      'select'
      '  GNR.GENRE_KOD,'
      '  GNR.GENRE_VER,'
      '  GNR.GENRE_NAM,'
      '  GNR.GENRE_COMMENT,'
      '  GNR.GENRE_STAMP,'
      '  GNR.SESSION_ID,'
      '  GNR.DBUSER_NAM,'
      '  GNR.SESSION_HOST'
      'from'
      '  SP_GENRE_RF (?GENRE_KOD) GNR'
      '')
    SelectSQL.Strings = (
      'select'
      '  GNR.GENRE_KOD,'
      '  GNR.GENRE_VER,'
      '  GNR.GENRE_NAM,'
      '  GNR.GENRE_COMMENT,'
      '  GNR.GENRE_STAMP,'
      '  GNR.SESSION_ID,'
      '  GNR.DBUSER_NAM,'
      '  GNR.SESSION_HOST'
      'from'
      '  SP_GENRE_RF (:IN_SESSION_ID) GNR'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      'execute procedure SP_TB_GENRE_U ('
      '  ?OLD_GENRE_KOD,'
      '  ?GENRE_NAM,'
      '  ?GENRE_COMMENT,'
      '  :IN_SESSION_ID)'
      '')
    AfterCancel = ds_DatasetAfterPostOrCancelOrDelete
    AfterDelete = ds_DatasetAfterPostOrCancelOrDelete
    AfterPost = ds_DatasetAfterPostOrCancelOrDelete
    BeforeClose = ds_DatasetBeforeClose
    BeforeDelete = ds_DatasetBeforeDelete
    BeforeOpen = ds_DatasetBeforeOpen
    BeforePost = ds_DatasetBeforePost
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.KeyFields = 'GENRE_KOD'
    AutoUpdateOptions.GeneratorName = 'GEN_GENRE_KOD'
    AutoUpdateOptions.SelectGenID = True
    DataSet_ID = 10
    Left = 320
    Top = 160
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Tariff: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Common_Write2
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    InsertSQL.Strings = (
      'execute procedure SP_TB_TARIFF_I ('
      '  ?TARIFF_KOD,'
      '  ?TARIFF_NAM,'
      '  ?TARIFF_BASE_COST,'
      '  ?TARIFF_FREEZED,'
      '  ?TARIFF_COMMENT,'
      '  :IN_SESSION_ID)'
      '')
    RefreshSQL.Strings = (
      'select'
      '  TRF.TARIFF_KOD,'
      '  TRF.TARIFF_VER,'
      '  TRF.TARIFF_NAM,'
      '  TRF.TARIFF_BASE_COST,'
      '  TRF.TARIFF_FREEZED,'
      '  TRF.TARIFF_DESC,'
      '  TRF.TARIFF_COMMENT,'
      '  TRF.TARIFF_STAMP,'
      '  TRF.SESSION_ID,'
      '  TRF.DBUSER_NAM,'
      '  TRF.SESSION_HOST'
      'from'
      '  SP_TARIFF_RF (?TARIFF_KOD) TRF'
      '')
    SelectSQL.Strings = (
      'select'
      '  TRF.TARIFF_KOD,'
      '  TRF.TARIFF_VER,'
      '  TRF.TARIFF_NAM,'
      '  TRF.TARIFF_BASE_COST,'
      '  TRF.TARIFF_FREEZED,'
      '  TRF.TARIFF_DESC,'
      '  TRF.TARIFF_COMMENT,'
      '  TRF.TARIFF_STAMP,'
      '  TRF.SESSION_ID,'
      '  TRF.DBUSER_NAM,'
      '  TRF.SESSION_HOST'
      'from'
      '  SP_TARIFF_RF (:IN_SESSION_ID) TRF'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    AfterCancel = ds_DatasetAfterPostOrCancelOrDelete
    AfterDelete = ds_DatasetAfterPostOrCancelOrDelete
    AfterPost = ds_DatasetAfterPostOrCancelOrDelete
    BeforeClose = ds_DatasetBeforeClose
    BeforeDelete = ds_DatasetBeforeDelete
    BeforeOpen = ds_DatasetBeforeOpen
    BeforePost = ds_DatasetBeforePost
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.KeyFields = 'TARIFF_KOD'
    AutoUpdateOptions.GeneratorName = 'GEN_TARIFF_KOD'
    AutoUpdateOptions.SelectGenID = True
    DataSet_ID = 8
    Left = 320
    Top = 232
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Film: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Common_Write2
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    DeleteSQL.Strings = (
      'execute procedure SP_TB_FILM_D ('
      '  ?OLD_FILM_KOD,'
      '  :IN_SESSION_ID)'
      '')
    InsertSQL.Strings = (
      'execute procedure SP_TB_FILM_I ('
      '  ?FILM_KOD,'
      '  ?FILM_NAM,'
      '  ?FILM_RELEASE,'
      '  ?FILM_SCREENTIME,'
      '  ?FILM_GENRE_KOD,'
      '  ?FILM_GENRE_VER,'
      '  ?FILM_COMMENT,'
      '  :IN_SESSION_ID)'
      '')
    RefreshSQL.Strings = (
      'select'
      '  FLM.FILM_KOD,'
      '  FLM.FILM_VER,'
      '  FLM.FILM_NAM,'
      '  FLM.FILM_RELEASE,'
      '  FLM.FILM_SCREENTIME,'
      '  FLM.FILM_GENRE_KOD,'
      '  FLM.FILM_GENRE_VER,'
      '  FLM.GENRE_NAM,'
      '  FLM.FILM_COMMENT,'
      '  FLM.FILM_DESC,'
      '  FLM.FILM_STAMP,'
      '  FLM.SESSION_ID,'
      '  FLM.DBUSER_NAM,'
      '  FLM.SESSION_HOST'
      'from'
      '  SP_FILM_RF (?FILM_KOD) FLM'
      '')
    SelectSQL.Strings = (
      'select'
      '  FLM.FILM_KOD,'
      '  FLM.FILM_VER,'
      '  FLM.FILM_NAM,'
      '  FLM.FILM_RELEASE,'
      '  FLM.FILM_SCREENTIME,'
      '  FLM.FILM_GENRE_KOD,'
      '  FLM.FILM_GENRE_VER,'
      '  FLM.GENRE_NAM,'
      '  FLM.FILM_COMMENT,'
      '  FLM.FILM_DESC,'
      '  FLM.FILM_STAMP,'
      '  FLM.SESSION_ID,'
      '  FLM.DBUSER_NAM,'
      '  FLM.SESSION_HOST'
      'from'
      '  SP_FILM_RF (:IN_SESSION_ID) FLM'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      'execute procedure SP_TB_FILM_U ('
      '  ?OLD_FILM_KOD,'
      '  ?FILM_NAM,'
      '  ?FILM_RELEASE,'
      '  ?FILM_SCREENTIME,'
      '  ?FILM_GENRE_KOD,'
      '  ?FILM_GENRE_VER,'
      '  ?FILM_COMMENT,'
      '  :IN_SESSION_ID)'
      '')
    AfterCancel = ds_DatasetAfterPostOrCancelOrDelete
    AfterDelete = ds_DatasetAfterPostOrCancelOrDelete
    AfterPost = ds_DatasetAfterPostOrCancelOrDelete
    BeforeClose = ds_DatasetBeforeClose
    BeforeDelete = ds_DatasetBeforeDelete
    BeforeOpen = ds_DatasetBeforeOpen
    BeforePost = ds_DatasetBeforePost
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.KeyFields = 'FILM_KOD'
    AutoUpdateOptions.GeneratorName = 'GEN_FILM_KOD'
    AutoUpdateOptions.SelectGenID = True
    DataSet_ID = 11
    Left = 136
    Top = 312
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Seans: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Common_Write2
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    DeleteSQL.Strings = (
      'execute procedure SP_TB_SEANS_D ('
      '  ?OLD_SEANS_KOD,'
      '  :IN_SESSION_ID)'
      '')
    InsertSQL.Strings = (
      'execute procedure SP_TB_SEANS_I ('
      '  ?SEANS_KOD,'
      '  ?SEANS_HOUR,'
      '  ?SEANS_MINUTE,'
      '  :IN_SESSION_ID)'
      '')
    RefreshSQL.Strings = (
      'select'
      '  SNS.SEANS_KOD,'
      '  SNS.SEANS_VER,'
      '  SNS.SEANS_HOUR,'
      '  SNS.SEANS_MINUTE,'
      '  SNS.SEANS_TIME,'
      '  SNS.SEANS_STAMP,'
      '  SNS.SESSION_ID,'
      '  SNS.DBUSER_NAM,'
      '  SNS.SESSION_HOST'
      'from'
      '  SP_SEANS_RF (?SEANS_KOD) SNS'
      '')
    SelectSQL.Strings = (
      'select'
      '  SNS.SEANS_KOD,'
      '  SNS.SEANS_VER,'
      '  SNS.SEANS_HOUR,'
      '  SNS.SEANS_MINUTE,'
      '  SNS.SEANS_TIME,'
      '  SNS.SEANS_STAMP,'
      '  SNS.SESSION_ID,'
      '  SNS.DBUSER_NAM,'
      '  SNS.SESSION_HOST'
      'from'
      '  SP_SEANS_RF (:IN_SESSION_ID) SNS'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      'execute procedure SP_TB_SEANS_U ('
      '  ?OLD_SEANS_KOD,'
      '  ?SEANS_HOUR,'
      '  ?SEANS_MINUTE,'
      '  :IN_SESSION_ID)'
      '')
    AfterCancel = ds_DatasetAfterPostOrCancelOrDelete
    AfterDelete = ds_DatasetAfterPostOrCancelOrDelete
    AfterPost = ds_DatasetAfterPostOrCancelOrDelete
    BeforeClose = ds_DatasetBeforeClose
    BeforeDelete = ds_DatasetBeforeDelete
    BeforeOpen = ds_DatasetBeforeOpen
    BeforePost = ds_DatasetBeforePost
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.KeyFields = 'SEANS_KOD'
    AutoUpdateOptions.GeneratorName = 'GEN_SEANS_KOD'
    AutoUpdateOptions.SelectGenID = True
    DataSet_ID = 12
    Left = 232
    Top = 312
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Changelog_Max: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Event_Write3
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  CMX.MAX_CHANGE_KOD'
      'from'
      '  SP_CHANGELOG_MAX (:IN_CHANGE_NUM) CMX'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 556
    Left = 40
    Top = 96
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Changelog_List: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Event_Write3
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  CHG.CHANGE_KOD,'
      '  CHG.SESSION_ID,'
      '  CHG.CHANGE_STAMP,'
      '  CHG.CHANGE_ACTION,'
      '  CHG.CHANGED_TABLE_ID,'
      '  CHG.CHANGED_TABLE_NAM,'
      '  CHG.CHANGED_TABLE_KOD,'
      '  CHG.CHANGED_TABLE_VER'
      'from'
      '  SP_CHANGELOG_RF ('
      '    :IN_SESSION_ID,'
      '    :IN_CHANGE_NUM,'
      '    :IN_TABLE_LIST,'
      '    :IN_TABLE_INS,'
      '    :IN_TABLE_UPD) CHG'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 555
    Left = 40
    Top = 160
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ev_Changelog: TSIBfibEventAlerter
    OnEventAlert = ev_ChangelogEventAlert
    Database = db_kino2
    Left = 40
    Top = 312
  end
  object ds_Changelog_Buf: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Event_Write3
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    Left = 40
    Top = 232
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object tmr_Buffer: TTimer
    OnTimer = tmr_BufferTimer
    Left = 40
    Top = 376
  end
  object ds_Moves: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Common_Write2
    AutoCommit = True
    OnFieldChange = ds_MovesFieldChange
    BufferChunks = 32
    CachedUpdates = False
    RefreshSQL.Strings = (
      'select'
      '  OPR.OPER_KOD,'
      '  OPR.OPER_VER,'
      '  OPR.OPER_STATE,'
      '  OPR.OPER_SELECTED,'
      '  OPR.OPER_ACTION,'
      '  OPR.OPER_PREVIOUS,'
      '  OPR.OPER_PRINTED,'
      '  OPR.OPER_PRINT_COUNT,'
      '  OPR.OPER_CHEQED,'
      '  OPR.OPER_PLACE_ROW,'
      '  OPR.OPER_PLACE_COL,'
      '  OPR.OPER_COST_VALUE,'
      '  OPR.OPER_LOCK_STAMP,'
      '  OPR.OPER_SALE_STAMP,'
      '  OPR.OPER_SALE_FORM,'
      '  OPR.OPER_MOD_STAMP,'
      '  OPR.OPER_REPERT_KOD,'
      '  OPR.OPER_REPERT_VER,'
      '  OPR.OPER_TICKET_KOD,'
      '  OPR.OPER_TICKET_VER,'
      '  OPR.OPER_SEAT_KOD,'
      '  OPR.OPER_SEAT_VER,'
      '  OPR.OPER_MISC_REASON,'
      '  OPR.OPER_MISC_SERIAL,'
      '  OPR.SESSION_ID,'
      '  OPR.DBUSER_KOD,'
      '  OPR.DBUSER_NAM,'
      '  OPR.SESSION_HOST'
      'from'
      '  SP_OPER_RF ('
      '    :IN_FILT_REPERT,'
      '    ?OPER_KOD) OPR'
      '')
    SelectSQL.Strings = (
      'select'
      '  OPR.OPER_KOD,'
      '  OPR.OPER_VER,'
      '  OPR.OPER_STATE,'
      '  OPR.OPER_SELECTED,'
      '  OPR.OPER_ACTION,'
      '  OPR.OPER_PREVIOUS,'
      '  OPR.OPER_PRINTED,'
      '  OPR.OPER_PRINT_COUNT,'
      '  OPR.OPER_CHEQED,'
      '  OPR.OPER_PLACE_ROW,'
      '  OPR.OPER_PLACE_COL,'
      '  OPR.OPER_COST_VALUE,'
      '  OPR.OPER_LOCK_STAMP,'
      '  OPR.OPER_SALE_STAMP,'
      '  OPR.OPER_SALE_FORM,'
      '  OPR.OPER_MOD_STAMP,'
      '  OPR.OPER_REPERT_KOD,'
      '  OPR.OPER_REPERT_VER,'
      '  OPR.OPER_TICKET_KOD,'
      '  OPR.OPER_TICKET_VER,'
      '  OPR.OPER_SEAT_KOD,'
      '  OPR.OPER_SEAT_VER,'
      '  OPR.OPER_MISC_REASON,'
      '  OPR.OPER_MISC_SERIAL,'
      '  OPR.SESSION_ID,'
      '  OPR.DBUSER_KOD,'
      '  OPR.DBUSER_NAM,'
      '  OPR.SESSION_HOST'
      'from'
      '  SP_OPER_RF ('
      '    :IN_FILT_REPERT,'
      '    :IN_SESSION_ID) OPR'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    AfterCancel = ds_DatasetAfterPostOrCancelOrDelete
    AfterDelete = ds_DatasetAfterPostOrCancelOrDelete
    AfterPost = ds_DatasetAfterPostOrCancelOrDelete
    BeforeClose = ds_DatasetBeforeClose
    BeforeDelete = ds_DatasetBeforeDelete
    BeforeOpen = ds_DatasetBeforeOpen
    BeforePost = ds_DatasetBeforePost
    AfterRefresh = ds_MovesAfterRefresh
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.KeyFields = 'OPER_KOD'
    DataSet_ID = 19
    Left = 320
    Top = 312
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object sp_Create_Tariff_Version: TpFIBStoredProc
    Database = db_kino2
    ParamCheck = True
    SQL.Strings = (
      
        'EXECUTE PROCEDURE IP_CREATE_TARIFF_VERSION (?IN_TARIFF_KOD, ?IN_' +
        'TARIFF_VER, ?IN_SESSION_ID)')
    Transaction = tr_Tariff_Write
    StoredProcName = 'IP_CREATE_TARIFF_VERSION'
    Left = 136
    Top = 376
    qoAutoCommit = True
    qoStartTransaction = True
  end
  object tr_Tariff_Write: TpFIBTransaction
    DefaultDatabase = db_kino2
    TimeoutAction = TACommit
    TRParams.Strings = (
      'write'
      'concurrency'
      'nowait')
    TPBMode = tpbDefault
    Left = 408
    Top = 96
  end
  object tr_Oper_Mod_Write: TpFIBTransaction
    DefaultDatabase = db_kino2
    TimeoutAction = TACommit
    TRParams.Strings = (
      'write'
      'concurrency'
      'nowait')
    TPBMode = tpbDefault
    Left = 408
    Top = 160
  end
  object sp_Oper_Mod: TpFIBStoredProc
    Tag = -1
    Database = db_kino2
    ParamCheck = True
    SQL.Strings = (
      
        'EXECUTE PROCEDURE IP_OPER_MOD (?IN_OPER_ACTION, ?IN_OPER_PRINTED' +
        ', ?IN_OPER_CHEQED, ?IN_OPER_PLACE_ROW, ?IN_OPER_PLACE_COL, ?IN_O' +
        'PER_REPERT_KOD, ?IN_OPER_TICKET_KOD, ?IN_OPER_MISC_REASON, ?IN_S' +
        'ESSION_ID)')
    Transaction = tr_Oper_Mod_Write
    StoredProcName = 'IP_OPER_MOD'
    Left = 408
    Top = 232
  end
  object tr_Oper_Clr_Write: TpFIBTransaction
    DefaultDatabase = db_kino2
    TimeoutAction = TACommit
    TRParams.Strings = (
      'write'
      'concurrency'
      'nowait')
    TPBMode = tpbDefault
    Left = 408
    Top = 312
  end
  object sp_Oper_Clr: TpFIBStoredProc
    Database = db_kino2
    ParamCheck = True
    SQL.Strings = (
      
        'EXECUTE PROCEDURE IP_OPER_CLR (?IN_CLEAR_MODE, ?IN_OPER_REPERT_K' +
        'OD, ?IN_SESSION_ID)')
    Transaction = tr_Oper_Clr_Write
    StoredProcName = 'IP_OPER_CLR'
    Left = 408
    Top = 376
    qoAutoCommit = True
    qoStartTransaction = True
  end
  object ds_Rep_Instant: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  OPR.OPER_REPERT_KOD,'
      '  OPR.OPER_REPERT_VER,'
      '  OPR.OPER_STATE,'
      '  OPR.OPER_SELECTED,'
      '  OPR.OPER_ACTION,'
      '  OPR.OPER_ACTION_DESC,'
      '  OPR.OPER_CHEQED,'
      '  OPR.OPER_COST_VALUE,'
      '  OPR.OPER_SALE_FORM,'
      '  OPR.OPER_SALE_FORM_DESC,'
      '  OPR.OPER_TICKET_KOD,'
      '  OPR.OPER_TICKET_VER,'
      '  OPR.TICKET_NAM,'
      '  OPR.TICKET_BGCOLOR,'
      '  OPR.TICKET_FNTCOLOR,'
      '  OPR.OPER_MISC_REASON,'
      '  OPR.DBUSER_KOD,'
      '  OPR.DBUSER_NAM,'
      '  OPR.SESSION_HOST,'
      '  OPR.TOTAL_OPER_COUNT,'
      '  OPR.TOTAL_OPER_SUM,'
      '  OPR.TOTAL_PRINT_COUNT,'
      '  OPR.ODEUM_DESC,'
      '  OPR.SEANS_TIME,'
      '  OPR.SEANS_FINISH,'
      '  OPR.FILM_DESC,'
      '  OPR.TARIFF_DESC'
      'from'
      '  RP_OPER_CN ('
      '    :IN_REPORT_MODE,'
      '    :IN_FILT_REPERT,'
      '    :IN_SESSION_ID) OPR'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 702
    Left = 232
    Top = 376
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Rep_Ticket: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  OPR.OPER_REPERT_KOD,'
      '  OPR.OPER_REPERT_VER,'
      '  OPR.OPER_STATE,'
      '  OPR.OPER_SELECTED,'
      '  OPR.OPER_ACTION,'
      '  OPR.OPER_ACTION_DESC,'
      '  OPR.OPER_CHEQED,'
      '  OPR.OPER_COST_VALUE,'
      '  OPR.OPER_SALE_FORM,'
      '  OPR.OPER_SALE_FORM_DESC,'
      '  OPR.OPER_TICKET_KOD,'
      '  OPR.OPER_TICKET_VER,'
      '  OPR.TICKET_NAM,'
      '  OPR.TICKET_BGCOLOR,'
      '  OPR.TICKET_FNTCOLOR,'
      '  OPR.OPER_MISC_REASON,'
      '  OPR.DBUSER_KOD,'
      '  OPR.DBUSER_NAM,'
      '  OPR.SESSION_HOST,'
      '  OPR.TOTAL_OPER_COUNT,'
      '  OPR.TOTAL_OPER_SUM,'
      '  OPR.TOTAL_PRINT_COUNT,'
      '  OPR.ODEUM_DESC,'
      '  OPR.SEANS_TIME,'
      '  OPR.SEANS_FINISH,'
      '  OPR.FILM_DESC,'
      '  OPR.TARIFF_DESC'
      'from'
      '  RP_OPER_RF ('
      '    :IN_REPORT_MODE,'
      '    :IN_FILT_ODEUM,'
      '    :IN_FILT_DATE,'
      '    :IN_FILT_REPERT,'
      '    :IN_SESSION_ID) OPR'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 701
    Left = 320
    Top = 376
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Rep_Daily_Odeums: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  ODM.ODEUM_KOD,'
      '  ODM.ODEUM_NAM,'
      '  ODM.ODEUM_CINEMA,'
      '  ODM.CINEMA_NAM,'
      '  ODM.ODEUM_PREFIX,'
      '  ODM.ODEUM_CAPACITY,'
      '  ODM.ODEUM_DESC,'
      '  ODM.CINEMA_LOGO,'
      '  ODM.ODEUM_LOGO,'
      '  ODM.FOO_DATE'
      'from'
      '  SP_ODEUM_RF ('
      '    :IN_FILT_ODEUM,'
      '    :IN_FILT_DATE) ODM'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    BeforeOpen = ds_Rep_Daily_BeforeOpen
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 704
    Left = 48
    Top = 448
    poUseBooleanField = False
    poApplyRepositary = True
    dcForceOpen = True
  end
  object ds_Rep_Daily_Repert: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  RPT.REPERT_KOD,'
      '  RPT.REPERT_VER,'
      '  RPT.REPERT_DATE,'
      '  RPT.REPERT_ODEUM_KOD,'
      '  RPT.REPERT_ODEUM_VER,'
      '  RPT.ODEUM_DESC,'
      '  RPT.REPERT_SEANS_KOD,'
      '  RPT.REPERT_SEANS_VER,'
      '  RPT.SEANS_TIME,'
      '  RPT.SEANS_FINISH,'
      '  RPT.REPERT_FILM_KOD,'
      '  RPT.REPERT_FILM_VER,'
      '  RPT.FILM_NAM,'
      '  RPT.FILM_DESC,'
      '  RPT.REPERT_TARIFF_KOD,'
      '  RPT.REPERT_TARIFF_VER,'
      '  RPT.TARIFF_DESC,'
      '  RPT.REPERT_DESC,'
      '  RPT.REPERT_STAMP,'
      '  RPT.SESSION_ID,'
      '  RPT.DBUSER_NAM,'
      '  RPT.SESSION_HOST'
      'from'
      '  SP_REPERT_RF ('
      '    :ODEUM_KOD,'
      '    null,'
      '    :FOO_DATE,'
      '    null,'
      '    null) RPT'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    DataSource = dsrc_Rep_Daily_Odeums
    BeforeOpen = ds_Rep_Daily_BeforeOpen
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 705
    Left = 152
    Top = 464
    poUseBooleanField = False
    poApplyRepositary = True
    dcForceOpen = True
  end
  object ds_Rep_Daily_Moves: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  OPR.OPER_REPERT_KOD,'
      '  OPR.OPER_REPERT_VER,'
      '  OPR.OPER_TICKET_KOD,'
      '  OPR.OPER_TICKET_VER,'
      '  OPR.TICKET_NAM,'
      '  OPR.TICKET_BGCOLOR,'
      '  OPR.TICKET_FNTCOLOR,'
      '  OPR.OPER_STATE,'
      '  OPR.OPER_COST_VALUE,'
      '  OPR.OPER_SALE_FORM,'
      '  OPR.OPER_SALE_FORM_DESC,'
      '  OPR.TOTAL_OPER_COUNT,'
      '  OPR.TOTAL_OPER_SUM,'
      '  OPR.TOTAL_PRINT_COUNT'
      'from RP_OPER_C ('
      '  :IN_REPORT_MODE,'
      '  :REPERT_KOD,'
      '  :IN_SESSION_ID) OPR'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    DataSource = dsrc_Rep_Daily_Repert
    BeforeOpen = ds_Rep_Daily_BeforeOpen
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 706
    Left = 256
    Top = 448
    poUseBooleanField = False
    poApplyRepositary = True
    dcForceOpen = True
  end
  object dsrc_Rep_Daily_Odeums: TDataSource
    DataSet = ds_Rep_Daily_Odeums
    Left = 48
    Top = 512
  end
  object dsrc_Rep_Daily_Repert: TDataSource
    DataSet = ds_Rep_Daily_Repert
    Left = 152
    Top = 528
  end
  object dsrc_Rep_Daily_Moves: TDataSource
    DataSet = ds_Rep_Daily_Moves
    Left = 256
    Top = 512
  end
  object ds_Price: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Common_Write2
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    RefreshSQL.Strings = (
      'select'
      '  PRC.PRICE_KOD,'
      '  PRC.PRICE_VER,'
      '  PRC.PRICE_VALUE,'
      '  PRC.PRICE_FREEZED,'
      '  PRC.PRICE_ABONEM_KOD,'
      '  PRC.PRICE_ABONEM_VER,'
      '  PRC.ABONEM_NAM,'
      '  PRC.PRICE_STAMP,'
      '  PRC.ABONEM_DESC,'
      '  PRC.SESSION_ID,'
      '  PRC.DBUSER_NAM,'
      '  PRC.SESSION_HOST'
      'from'
      '  SP_PRICE_RF (?PRICE_KOD) PRC'
      '')
    SelectSQL.Strings = (
      'select'
      '  PRC.PRICE_KOD,'
      '  PRC.PRICE_VER,'
      '  PRC.PRICE_VALUE,'
      '  PRC.PRICE_FREEZED,'
      '  PRC.PRICE_ABONEM_KOD,'
      '  PRC.PRICE_ABONEM_VER,'
      '  PRC.ABONEM_NAM,'
      '  PRC.PRICE_STAMP,'
      '  PRC.ABONEM_DESC,'
      '  PRC.SESSION_ID,'
      '  PRC.DBUSER_NAM,'
      '  PRC.SESSION_HOST'
      'from'
      '  SP_PRICE_RF (:IN_SESSION_ID) PRC'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      'execute procedure SP_TB_PRICE_U ('
      '  ?OLD_PRICE_KOD,'
      '  ?PRICE_VALUE,'
      '  ?PRICE_FREEZED,'
      '  :IN_SESSION_ID)'
      '')
    AfterCancel = ds_DatasetAfterPostOrCancelOrDelete
    AfterDelete = ds_DatasetAfterPostOrCancelOrDelete
    AfterPost = ds_DatasetAfterPostOrCancelOrDelete
    BeforeClose = ds_DatasetBeforeClose
    BeforeDelete = ds_DatasetBeforeDelete
    BeforeOpen = ds_DatasetBeforeOpen
    BeforePost = ds_DatasetBeforePost
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 21
    Left = 456
    Top = 448
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Abjnl: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    UpdateTransaction = tr_Common_Write2
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    DeleteSQL.Strings = (
      'execute procedure SP_TB_ABJNL_D ('
      '  ?OLD_ABJNL_KOD,'
      '  :IN_SESSION_ID)'
      '')
    InsertSQL.Strings = (
      'execute procedure SP_TB_ABJNL_I ('
      '  ?ABJNL_KOD,'
      '  ?ABJNL_STATE,'
      '  ?ABJNL_SALE_DATE,'
      '  ?ABJNL_CHEQED,'
      '  ?ABJNL_PRICE_KOD,'
      '  ?ABJNL_PRICE_VER,'
      '  :IN_SESSION_ID)'
      '')
    RefreshSQL.Strings = (
      'select'
      '  AJN.ABJNL_KOD,'
      '  AJN.ABJNL_VER,'
      '  AJN.ABJNL_ABONEM_KOD,'
      '  AJN.ABJNL_ABONEM_VER,'
      '  AJN.ABONEM_NAM,'
      '  AJN.ABJNL_PRICE_KOD,'
      '  AJN.ABJNL_PRICE_VER,'
      '  AJN.PRICE_VALUE,'
      '  AJN.ABJNL_STATE,'
      '  AJN.ABJNL_STATE_DESC,'
      '  AJN.ABJNL_SALE_DATE,'
      '  AJN.ABJNL_CHEQED,'
      '  AJN.ABJNL_MOD_STAMP,'
      '  AJN.ABJNL_COUNT,'
      '  AJN.ABONEM_DESC,'
      '  AJN.SESSION_ID,'
      '  AJN.DBUSER_NAM,'
      '  AJN.SESSION_HOST'
      'from'
      '  SP_ABJNL_RF ('
      '    :IN_FILT_DATE,'
      '    :IN_FILT_MODE,'
      '    ?ABJNL_KOD) AJN'
      '')
    SelectSQL.Strings = (
      'select'
      '  AJN.ABJNL_KOD,'
      '  AJN.ABJNL_VER,'
      '  AJN.ABJNL_ABONEM_KOD,'
      '  AJN.ABJNL_ABONEM_VER,'
      '  AJN.ABONEM_NAM,'
      '  AJN.ABJNL_PRICE_KOD,'
      '  AJN.ABJNL_PRICE_VER,'
      '  AJN.PRICE_VALUE,'
      '  AJN.ABJNL_STATE,'
      '  AJN.ABJNL_STATE_DESC,'
      '  AJN.ABJNL_SALE_DATE,'
      '  AJN.ABJNL_CHEQED,'
      '  AJN.ABJNL_MOD_STAMP,'
      '  AJN.ABJNL_COUNT,'
      '  AJN.ABONEM_DESC,'
      '  AJN.SESSION_ID,'
      '  AJN.DBUSER_NAM,'
      '  AJN.SESSION_HOST'
      'from'
      '  SP_ABJNL_RF ('
      '    :IN_FILT_DATE,'
      '    :IN_FILT_MODE,'
      '    :IN_SESSION_ID) AJN'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    UpdateSQL.Strings = (
      'execute procedure SP_TB_ABJNL_U ('
      '  ?OLD_ABJNL_KOD,'
      '  ?ABJNL_STATE,'
      '  ?ABJNL_CHEQED,'
      '  ?ABJNL_PRICE_KOD,'
      '  ?ABJNL_PRICE_VER,'
      '  :IN_SESSION_ID)'
      '')
    AfterCancel = ds_DatasetAfterPostOrCancelOrDelete
    AfterDelete = ds_DatasetAfterPostOrCancelOrDelete
    AfterPost = ds_DatasetAfterPostOrCancelOrDelete
    BeforeClose = ds_DatasetBeforeClose
    BeforeDelete = ds_DatasetBeforeDelete
    BeforeOpen = ds_DatasetBeforeOpen
    BeforePost = ds_DatasetBeforePost
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.KeyFields = 'ABJNL_KOD'
    AutoUpdateOptions.GeneratorName = 'GEN_ABJNL_KOD'
    AutoUpdateOptions.SelectGenID = True
    DataSet_ID = 22
    Left = 456
    Top = 504
    poUseBooleanField = False
    poApplyRepositary = True
  end
  object ds_Rep_Daily_Abonem: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  AJN.ABJNL_SALE_DATE,'
      '  AJN.ABJNL_STATE,'
      '  AJN.ABJNL_ABONEM_KOD,'
      '  AJN.ABJNL_ABONEM_VER,'
      '  AJN.ABONEM_NAM,'
      '  AJN.PRICE_VALUE,'
      '  AJN.ABJNL_CHEQED,'
      '  AJN.TOTAL_ABJNL_COUNT,'
      '  AJN.TOTAL_ABJNL_SUM'
      'from RP_ABJNL_C ('
      '  :IN_REPORT_MODE,'
      '  :IN_FILT_DATE,'
      '  :IN_SESSION_ID) AJN'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    BeforeOpen = ds_Rep_Daily_BeforeOpen
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 707
    Left = 368
    Top = 464
    poUseBooleanField = False
    poApplyRepositary = True
    dcForceOpen = True
  end
  object dsrc_Rep_Daily_Abonem: TDataSource
    DataSet = ds_Rep_Daily_Abonem
    Left = 368
    Top = 528
  end
  object ds_Rep_Ticket_Odeums: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  ODM.ODEUM_KOD,'
      '  ODM.ODEUM_NAM,'
      '  ODM.ODEUM_CINEMA,'
      '  ODM.CINEMA_NAM,'
      '  ODM.ODEUM_PREFIX,'
      '  ODM.ODEUM_CAPACITY,'
      '  ODM.ODEUM_DESC,'
      '  ODM.CINEMA_LOGO,'
      '  ODM.ODEUM_LOGO,'
      '  ODM.FOO_DATE'
      'from'
      '  SP_ODEUM_RF ('
      '    :IN_FILT_ODEUM,'
      '    :IN_FILT_DATE) ODM'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    BeforeOpen = ds_Rep_Daily_BeforeOpen
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 708
    Left = 520
    Top = 24
    poUseBooleanField = False
    poApplyRepositary = True
    dcForceOpen = True
  end
  object dsrc_Rep_Ticket_Odeums: TDataSource
    DataSet = ds_Rep_Ticket_Odeums
    Left = 520
    Top = 96
  end
  object ds_Rep_Ticket_Tickets: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  OPR.OPER_ODEUM_KOD,'
      '  OPR.OPER_ODEUM_VER,'
      '  OPR.OPER_TICKET_KOD,'
      '  OPR.OPER_TICKET_VER,'
      '  OPR.TICKET_NAM,'
      '  OPR.TICKET_BGCOLOR,'
      '  OPR.TICKET_FNTCOLOR,'
      '  OPR.OPER_STATE,'
      '  OPR.OPER_COST_VALUE,'
      '  OPR.OPER_SALE_FORM,'
      '  OPR.OPER_SALE_FORM_DESC,'
      '  OPR.TOTAL_OPER_COUNT,'
      '  OPR.TOTAL_OPER_SUM,'
      '  OPR.TOTAL_PRINT_COUNT'
      'from RP_OPER_TKT ('
      '  :IN_REPORT_MODE,'
      '  :ODEUM_KOD,'
      '  :FOO_DATE,'
      '  :IN_SESSION_ID) OPR'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    DataSource = dsrc_Rep_Ticket_Odeums
    BeforeOpen = ds_Rep_Daily_BeforeOpen
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 709
    Left = 520
    Top = 160
    poUseBooleanField = False
    poApplyRepositary = True
    dcForceOpen = True
  end
  object dsrc_Rep_Ticket_Tickets: TDataSource
    DataSet = ds_Rep_Ticket_Tickets
    Left = 520
    Top = 232
  end
  object ds_Rep_Daily_Presale: TpFIBDataSet
    Database = db_kino2
    Transaction = tr_Common_Read2
    Options = [poTrimCharFields, poRefreshAfterPost, poRefreshDeletedRecord, poStartTransaction, poAutoFormatFields, poAllowChangeSqls]
    AutoCommit = True
    BufferChunks = 32
    CachedUpdates = False
    SelectSQL.Strings = (
      'select'
      '  PRP.OPER_REPERT_KOD,'
      '  PRP.OPER_REPERT_VER,'
      '  PRP.REPERT_DATE,'
      '  PRP.REPERT_START,'
      '  PRP.OPER_TICKET_KOD,'
      '  PRP.OPER_TICKET_VER,'
      '  PRP.TICKET_NAM,'
      '  PRP.TICKET_BGCOLOR,'
      '  PRP.TICKET_FNTCOLOR,'
      '  PRP.OPER_STATE,'
      '  PRP.OPER_COST_VALUE,'
      '  PRP.OPER_SALE_FORM,'
      '  PRP.OPER_SALE_FORM_DESC,'
      '  PRP.TOTAL_OPER_COUNT,'
      '  PRP.TOTAL_OPER_SUM,'
      '  PRP.TOTAL_PRINT_COUNT,'
      '  PRP.REPERT_KOD'
      'from RP_OPER_PRE ('
      '  :IN_REPORT_MODE,'
      '  :ODEUM_KOD,'
      '  :FOO_DATE,'
      '  :IN_SESSION_ID) PRP'
      '')
    UniDirectional = False
    UpdateRecordTypes = [cusUnmodified, cusModified, cusInserted]
    DataSource = dsrc_Rep_Daily_Odeums
    BeforeOpen = ds_Rep_Daily_BeforeOpen
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    DataSet_ID = 710
    Left = 520
    Top = 312
    poUseBooleanField = False
    poApplyRepositary = True
    dcForceOpen = True
  end
  object dsrc_Rep_Daily_Presale: TDataSource
    DataSet = ds_Rep_Daily_Presale
    Left = 520
    Top = 376
  end
end
