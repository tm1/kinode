@echo off
del restoreka-log.bak
ren restoreka.log restoreka-log.bak
md C:\FB_DATA\BACKUP.DIR
echo Wait a moment ...
echo ======================================================
if ["h%1"]==["h"] goto _def1
if ["h%2"]==["h"] goto _def1a
gbak -c -user "creator001" -pas "secretkey" -z -y restoreka.log -v C:\FB_DATA\%2 %1:C:\FB_DATA\kappa.fdb
goto _exit1
:_def1a
gbak -c -user "creator001" -pas "secretkey" -z -y restoreka.log -v C:\FB_DATA\kappa.fbk %1:C:\FB_DATA\kappa.fdb
goto _exit1
:_def1
gbak -c -user "creator001" -pas "secretkey" -z -y restoreka.log -v C:\FB_DATA\kappa.fbk localhost:C:\FB_DATA\kappa.fdb
:_exit1
echo ======================================================
echo ====================================================== >> restoreka.log
if ["h%1"]==["h"] goto _def2
if ["h%2"]==["h"] goto _def2a
echo gbak -c -user "creator001" -pas "secretkey" -z -y restoreka.log -v C:\FB_DATA\%2 %1:C:\FB_DATA\kappa.fdb
echo gbak -c -user "creator001" -pas "secretkey" -z -y restoreka.log -v C:\FB_DATA\%2 %1:C:\FB_DATA\kappa.fdb >> restoreka.log
goto _exit2
:_def2a
echo gbak -c -user "creator001" -pas "secretkey" -z -y restoreka.log -v C:\FB_DATA\kappa.fbk %1:C:\FB_DATA\kappa.fdb
echo gbak -c -user "creator001" -pas "secretkey" -z -y restoreka.log -v C:\FB_DATA\kappa.fbk %1:C:\FB_DATA\kappa.fdb >> restoreka.log
goto _exit2
:_def2
echo gbak -c -user "creator001" -pas "secretkey" -z -y restoreka.log -v C:\FB_DATA\kappa.fbk localhost:C:\FB_DATA\kappa.fdb
echo gbak -c -user "creator001" -pas "secretkey" -z -y restoreka.log -v C:\FB_DATA\kappa.fbk localhost:C:\FB_DATA\kappa.fdb >> restoreka.log
:_exit2
echo ======================================================
echo ====================================================== >> restoreka.log
date /t 
date /t >> restoreka.log
time /t
time /t >> restoreka.log

rem type restoreka.log
less restoreka.log
