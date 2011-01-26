@echo off
del gfixka-log.bak
ren gfixka.log gfixka-log.bak
echo Wait a moment ...
echo . > gfixka.log

set _user_=devel001
set _pasw_=primarykey
set _db_=localhost:E:\FB_DATA\kappa.fdb

echo -----------------------------------------------------------------------------------------
echo ----------------------------------------------------------------------------------------- >> gfixka.log
echo gfix -sweep -user "%_user_%" -password "%_pasw_%" -z "%_db_%"
echo gfix -sweep -user "%_user_%" -password "%_pasw_%" -z "%_db_%" >> gfixka.log
echo -----------------------------------------------------------------------------------------
echo ----------------------------------------------------------------------------------------- >> gfixka.log
date /t
date /t >> gfixka.log
time /t
time /t >> gfixka.log
echo ----------------------------------------------------------------------------------------- >> gfixka.log
gfix -sweep -user "%_user_%" -password "%_pasw_%" -z "%_db_%" >> gfixka.log

echo ...
echo ======================================================
set _user_=
set _pasw_=
set _db_=

date /t
time /t

rem type gfixka.log
rem less gfixka.log
