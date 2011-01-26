@echo off
del gidxka-log.bak
ren gidxka.log gidxka-log.bak
echo Wait a moment ...
echo . > gidxka.log

set _user_=devel001
set _pasw_=primarykey
set _db_=localhost:F:\FB_DATA\kappa.fdb

echo -----------------------------------------------------------------------------------------
echo ----------------------------------------------------------------------------------------- >> gidxka.log
echo gidx -user "%_user_%" -password "%_pasw_%" -c -s -u "%_db_%"
echo gidx -user "%_user_%" -password "%_pasw_%" -c -s -u "%_db_%" >> gidxka.log
echo -----------------------------------------------------------------------------------------
echo ----------------------------------------------------------------------------------------- >> gidxka.log
date /t
date /t >> gidxka.log
time /t
time /t >> gidxka.log
echo ----------------------------------------------------------------------------------------- >> gidxka.log
rem gidx -a -r -u "%_user_%" -p "%_pasw_%" -z "%_db_%" >> gidxka.log
gidx -user "%_user_%" -password "%_pasw_%" -c -s -u "%_db_%" >> gidxka.log

echo ...
echo ======================================================
set _user_=
set _pasw_=
set _db_=

date /t
time /t

rem type gidxka.log
less gidxka.log
