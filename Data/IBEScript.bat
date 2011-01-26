@echo off
if ["%PROGRAMFILES%"]==[""] goto _w9x
echo ---=: nt,2k or xp :=---
rem pause > nul
if not exist "%PROGRAMFILES%\HK-Software\IB Expert 2003\IBEScript.exe" goto _search_20
echo Found in %PROGRAMFILES% (2003)
"%PROGRAMFILES%\HK-Software\IB Expert 2003\IBEScript.exe" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto _exit
:_search_20
if not exist "%PROGRAMFILES%\HK-Software\IB Expert 2.0\IBEScript.exe" goto _search_def
echo Found in %PROGRAMFILES% (2.0)
"%PROGRAMFILES%\HK-Software\IB Expert 2.0\IBEScript.exe" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto _exit
:_w9x
echo ---=: 9x, me :=---
rem pause > nul

:_search_def
echo Searching on disks C,D,E ...
echo ...
if exist "C:\Program Files\HK-Software\IB Expert 2003\IBEScript.exe" goto _w9x_c1
if exist "D:\Program Files\HK-Software\IB Expert 2003\IBEScript.exe" goto _w9x_d1
if exist "E:\Program Files\HK-Software\IB Expert 2003\IBEScript.exe" goto _w9x_e1
if exist "C:\Program Files\HK-Software\IB Expert 2.0\IBEScript.exe" goto _w9x_c2
if exist "D:\Program Files\HK-Software\IB Expert 2.0\IBEScript.exe" goto _w9x_d2
if exist "E:\Program Files\HK-Software\IB Expert 2.0\IBEScript.exe" goto _w9x_e2
rem _not_found
echo IBEScript.exe not found on default locations C,D,E
echo default path1 "D:\Program Files\HK-Software\IB Expert 2003\IBEScript.exe"
echo default path2 "D:\Program Files\HK-Software\IB Expert 2.0\IBEScript.exe"
echo quitting ...
goto _exit
:_w9x_c1
echo Found on C: (2003)
"C:\Program Files\HK-Software\IB Expert 2003\IBEScript.exe" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto _exit
:_w9x_d1
echo Found on D: (2003)
"D:\Program Files\HK-Software\IB Expert 2003\IBEScript.exe" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto _exit
:_w9x_e1
echo Found on E: (2003)
"E:\Program Files\HK-Software\IB Expert 2003\IBEScript.exe" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto _exit
:_w9x_c2
echo Found on C: (2.0)
"C:\Program Files\HK-Software\IB Expert 2.0\IBEScript.exe" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto _exit
:_w9x_d2
echo Found on D: (2.0)
"D:\Program Files\HK-Software\IB Expert 2.0\IBEScript.exe" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto _exit
:_w9x_e2
echo Found on E: (2.0)
"E:\Program Files\HK-Software\IB Expert 2.0\IBEScript.exe" %1 %2 %3 %4 %5 %6 %7 %8 %9
:_exit
