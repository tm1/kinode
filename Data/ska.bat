@echo off
if ["h%1"]==["h"] goto _help
if ["h%2"]==["h"] goto _def1
call IBEScript.bat %1 -D"%2:C:\FB_DATA\kappa.fdb" -CWIN1251 -USYSDBA -Pmasterkey %3 %4 %5 %6 %7 %8 %9
echo -----------------------------------------------------
echo IBEScript.bat %1 -D"%2:C:\FB_DATA\kappa.fdb" -CWIN1251 -USYSDBA -Pmasterkey %3 %4 %5 %6 %7 %8 %9
goto _exit1
:_def1
call IBEScript.bat %1 -D"localhost/3050:C:\FB_DATA\kappa.fdb" -CWIN1251 -USYSDBA -Pmasterkey %2 %3 %4 %5 %6 %7 %8 %9
echo -----------------------------------------------------
echo IBEScript.bat %1 -D"localhost/3050:C:\FB_DATA\kappa.fdb" -CWIN1251 -USYSDBA -Pmasterkey %2 %3 %4 %5 %6 %7 %8 %9
goto _exit1
:_help
echo -----------------------------------------------------
echo : Usage:
echo :   %0 script.sql [remotehost]
echo -----------------------------------------------------
echo : Samples:
echo :   %0 script.sql
echo :     IBEScript.bat script.sql -D"localhost:C:\FB_DATA\kappa.fdb" -CWIN1251 -USYSDBA -Pmasterkey
echo :   %0 script.sql remotehost
echo :     IBEScript.bat script.sql -D"remotehost:C:\FB_DATA\kappa.fdb" -CWIN1251 -USYSDBA -Pmasterkey
echo :   %0 script.sql remotehost/3051
echo :     IBEScript.bat script.sql -D"remotehost/3051:C:\FB_DATA\kappa.fdb" -CWIN1251 -USYSDBA -Pmasterkey
:_exit1
