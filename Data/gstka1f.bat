@echo off

set _log_=gstatka.log

if not ["%1"]==[""] set _log_=%1

if exist %_log_% del %_log_%.031

if exist %_log_% ren %_log_%.030 %_log_%.031

if exist %_log_% ren %_log_%.029 %_log_%.030
if exist %_log_% ren %_log_%.028 %_log_%.029
if exist %_log_% ren %_log_%.027 %_log_%.028
if exist %_log_% ren %_log_%.026 %_log_%.027
if exist %_log_% ren %_log_%.025 %_log_%.026
if exist %_log_% ren %_log_%.024 %_log_%.025
if exist %_log_% ren %_log_%.023 %_log_%.024
if exist %_log_% ren %_log_%.022 %_log_%.023
if exist %_log_% ren %_log_%.021 %_log_%.022
if exist %_log_% ren %_log_%.020 %_log_%.021

if exist %_log_% ren %_log_%.019 %_log_%.020
if exist %_log_% ren %_log_%.018 %_log_%.019
if exist %_log_% ren %_log_%.017 %_log_%.018
if exist %_log_% ren %_log_%.016 %_log_%.017
if exist %_log_% ren %_log_%.015 %_log_%.016
if exist %_log_% ren %_log_%.014 %_log_%.015
if exist %_log_% ren %_log_%.013 %_log_%.014
if exist %_log_% ren %_log_%.012 %_log_%.013
if exist %_log_% ren %_log_%.011 %_log_%.012
if exist %_log_% ren %_log_%.010 %_log_%.011

if exist %_log_% ren %_log_%.009 %_log_%.010
if exist %_log_% ren %_log_%.008 %_log_%.009
if exist %_log_% ren %_log_%.007 %_log_%.008
if exist %_log_% ren %_log_%.006 %_log_%.007
if exist %_log_% ren %_log_%.005 %_log_%.006
if exist %_log_% ren %_log_%.004 %_log_%.005
if exist %_log_% ren %_log_%.003 %_log_%.004
if exist %_log_% ren %_log_%.002 %_log_%.003
if exist %_log_% ren %_log_%.001 %_log_%.002
if exist %_log_% ren %_log_% %_log_%.001

echo Wait a moment ...
echo . > %_log_%

set _user_=devel001
set _pasw_=primarykey
set _db_=localhost/3050:F:\FB_DATA\kappa.fdb

echo -----------------------------------------------------------------------------------------
echo ----------------------------------------------------------------------------------------- >> %_log_%
echo gstat -a -r -s -u "%_user_%" -p "%_pasw_%" -z "%_db_%"
echo gstat -a -r -s -u "%_user_%" -p "%_pasw_%" -z "%_db_%" >> %_log_%
echo -----------------------------------------------------------------------------------------
echo ----------------------------------------------------------------------------------------- >> %_log_%
date /t
date /t >> %_log_%
time /t
time /t >> %_log_%
echo ----------------------------------------------------------------------------------------- >> %_log_%
rem gstat -a -r -u "%_user_%" -p "%_pasw_%" -z "%_db_%" >> %_log_%
gstat -a -r -s -u "%_user_%" -p "%_pasw_%" -z "%_db_%" >> %_log_%

echo ...
echo ======================================================
set _user_=
set _pasw_=
set _db_=

date /t
time /t

rem type %_log_%
if ["%1"]==[""] less %_log_%

set _log_=
