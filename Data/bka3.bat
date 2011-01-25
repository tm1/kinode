@echo off
if not exist backupka.log goto skip_log
if exist backupka-log.bak del backupka-log.bak
ren backupka.log backupka-log.bak
:skip_log
if ["h%1"]==["h"] goto fbk_def1
if not exist kappa(%1).fbk goto skip_def1
if exist kappa(%1).fbk.bak del kappa(%1).fbk.bak
ren kappa(%1).fbk kappa(%1).fbk.bak
goto skip_def1
:fbk_def1
if not exist kappa.fbk goto skip_def1
if exist kappa.fbk.bak del kappa.fbk.bak
ren kappa.fbk kappa.fbk.bak
:skip_def1
if not exist C:\FB_DATA\BACKUP.DIR\nul md C:\FB_DATA\BACKUP.DIR
echo ======================================================
echo Wait a moment ...
if ["h%1"]==["h"] goto gbak_def1
gbak -b -user "devel001" -pas "primarykey" -t -z -y backupka.log -v %1:C:\FB_DATA\kappa.fdb C:\FB_DATA\kappa(%1).fbk
goto bat_exit1
:gbak_def1
gbak -b -user "devel001" -pas "primarykey" -t -z -y backupka.log -v localhost:C:\FB_DATA\kappa.fdb C:\FB_DATA\kappa.fbk
:bat_exit1
echo ======================================================
echo ====================================================== >> backupka.log
if ["h%1"]==["h"] goto log_def2
echo gbak -b -user "devel001" -pas "primarykey" -t -z -y backupka.log -v %1:C:\FB_DATA\kappa.fdb C:\FB_DATA\kappa(%1).fbk
echo gbak -b -user "devel001" -pas "primarykey" -t -z -y backupka.log -v %1:C:\FB_DATA\kappa.fdb C:\FB_DATA\kappa(%1).fbk >> backupka.log
goto bat_exit2
:log_def2
echo gbak -b -user "devel001" -pas "primarykey" -t -z -y backupka.log -v localhost:C:\FB_DATA\kappa.fdb C:\FB_DATA\kappa.fbk
echo gbak -b -user "devel001" -pas "primarykey" -t -z -y backupka.log -v localhost:C:\FB_DATA\kappa.fdb C:\FB_DATA\kappa.fbk >> backupka.log
:bat_exit2
echo ======================================================
echo ====================================================== >> backupka.log
date /t 
date /t >> backupka.log
time /t
time /t >> backupka.log

rem type backupka.log
less backupka.log
