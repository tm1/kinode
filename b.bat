@echo off
echo -*----------------------------------------------------------------*-
echo =*=                build.bat for Delphi ver 0.3.0                =*=
echo -*----------------------------------------------------------------*-
rem Project name must be without extension (.dpr, .dpk, etc)
set _ProjectName01_=kinode01
set _ProjectDirIn01_=
set _ProjectDirOut01_=
set _ProjectName02_=
set _ProjectDirIn02_=
set _ProjectDirOut02_=
set _ProjectName03_=
set _ProjectDirIn03_=
set _ProjectDirOut03_=
set _ProjectName04_=
set _ProjectDirIn04_=
set _ProjectDirOut04_=
set _ProjectName05_=
set _ProjectDirIn05_=
set _ProjectDirOut05_=
set _ProjectName06_=
set _ProjectDirIn06_=
set _ProjectDirOut06_=
set _ProjectName07_=
set _ProjectDirIn07_=
set _ProjectDirOut07_=
set _ProjectName08_=
set _ProjectDirIn08_=
set _ProjectDirOut08_=
set _ProjectName09_=
set _ProjectDirIn09_=
set _ProjectDirOut09_=
if [%1]==[build] goto clean
if [%1]==[-b] goto clean
if [%1]==[-B] goto clean
if [%1]==[clean] goto clean
if [%1]==[-c] goto clean
if [%1]==[-C] goto clean
goto run_dcc32
:clean
echo Clean temp files (*.~* *.bak *.tmp *.swp *.$$$ *.gid) ...
rem pause > nul
del /s *.~* *.bak *.tmp *.swp *.$$$ *.gid | more > nul
echo Clean compiler units (*.dcu *.obj *.drc) ...
rem pause > nul
del /s *.dcu *.obj *.drc | more > nul
echo Clean map files (*.map *.jdbg) ...
rem pause > nul
echo del /s *.map *.jdbg
rem del /s *.map *.jdbg | more > nul
echo --------------------------------------------------------------------
if [%1]==[clean] goto done
if [%1]==[-c] goto done
if [%1]==[-C] goto done
:run_dcc32
set _IncludeDirs_=".\Lib;C:\DELPHI\jcl\source;D:\DELPHI\jcl\source;E:\DELPHI\jcl\source;"
set _UnitDirs_=".\Lib;C:\Delphi\Lib;C:\Delphi\FIB442;C:\Delphi\FrRP232;C:\DELPHI\jcl\lib\D5;C:\DELPHI\jcl\source;D:\Delphi\Lib;D:\Delphi\FIB442;D:\Delphi\FrRP232;D:\DELPHI\jcl\lib\D5;D:\DELPHI\jcl\source;E:\Delphi\Lib;E:\Delphi\FIB442;E:\Delphi\FrRP232;E:\DELPHI\jcl\lib\D5;E:\DELPHI\jcl\source;C:\Work\Delphi\Lib;C:\Work\Delphi\FIB442;D:\Work\Delphi\Lib;D:\Work\Delphi\FIB442;E:\Work\Delphi\Lib;E:\Work\Delphi\FIB442;"
set _ResDirs_=".\Lib;C:\Program Files\Borland\Delphi5\Lib;C:\DELPHI\jcl\lib\D5;D:\Program Files\Borland\Delphi5\Lib;D:\DELPHI\jcl\lib\D5;E:\Program Files\Borland\Delphi5\Lib;E:\DELPHI\jcl\lib\D5;"
echo --------------------------------------------------------------------
if ["%_ProjectName01_%"]==[""] goto skip01
if not ["%_ProjectDirIn01_%"]==[""] echo cd %_ProjectDirIn01_% & cd %_ProjectDirIn01_%
pwd & echo =====
dcc32 -M -I%_IncludeDirs_% -U%_UnitDirs_% -R%_ResDirs_% %2 %3 %4 %5 %6 %7 %8 %9 %_ProjectName01_%
echo --------------------------------------------------------------------
echo Running: MakeJclDbg -E %_ProjectName01_%.map
MakeJclDbg -E %_ProjectName01_%.map
if not ["%_ProjectDirOut01_%"]==[""] echo ===== & echo cd %_ProjectDirOut01_% & cd %_ProjectDirOut01_%
echo --------------------------------------------------------------------
:skip01
if ["%_ProjectName02_%"]==[""] goto skip02
if not ["%_ProjectDirIn02_%"]==[""] echo cd %_ProjectDirIn02_% & cd %_ProjectDirIn02_%
pwd & echo =====
dcc32 -M -I%_IncludeDirs_% -U%_UnitDirs_% -R%_ResDirs_% %2 %3 %4 %5 %6 %7 %8 %9 %_ProjectName02_%
echo --------------------------------------------------------------------
echo Running: MakeJclDbg -E %_ProjectName02_%.map
MakeJclDbg -E %_ProjectName02_%.map
if not ["%_ProjectDirOut02_%"]==[""] echo ===== & echo cd %_ProjectDirOut02_% & cd %_ProjectDirOut02_%
echo --------------------------------------------------------------------
:skip02
if ["%_ProjectName03_%"]==[""] goto skip03
if not ["%_ProjectDirIn03_%"]==[""] echo cd %_ProjectDirIn03_% & cd %_ProjectDirIn03_%
pwd & echo =====
dcc32 -M -I%_IncludeDirs_% -U%_UnitDirs_% -R%_ResDirs_% %2 %3 %4 %5 %6 %7 %8 %9 %_ProjectName03_%
echo --------------------------------------------------------------------
echo Running: MakeJclDbg -E %_ProjectName03_%.map
MakeJclDbg -E %_ProjectName03_%.map
if not ["%_ProjectDirOut03_%"]==[""] echo ===== & echo cd %_ProjectDirOut03_% & cd %_ProjectDirOut03_%
echo --------------------------------------------------------------------
:skip03
if ["%_ProjectName04_%"]==[""] goto skip04
if not ["%_ProjectDirIn04_%"]==[""] cd %_ProjectDirIn04_%
pwd & echo =====
dcc32 -M -I%_IncludeDirs_% -U%_UnitDirs_% -R%_ResDirs_% %2 %3 %4 %5 %6 %7 %8 %9 %_ProjectName04_%
echo --------------------------------------------------------------------
echo Running: MakeJclDbg -E %_ProjectName04_%.map
MakeJclDbg -E %_ProjectName04_%.map
if not ["%_ProjectDirOut04_%"]==[""] echo ===== & echo cd %_ProjectDirOut04_% & cd %_ProjectDirOut04_%
echo --------------------------------------------------------------------
:skip04
if ["%_ProjectName05_%"]==[""] goto skip05
if not ["%_ProjectDirIn05_%"]==[""] cd %_ProjectDirIn05_%
pwd & echo =====
dcc32 -M -I%_IncludeDirs_% -U%_UnitDirs_% -R%_ResDirs_% %2 %3 %4 %5 %6 %7 %8 %9 %_ProjectName05_%
echo --------------------------------------------------------------------
echo Running: MakeJclDbg -E %_ProjectName05_%.map
MakeJclDbg -E %_ProjectName05_%.map
if not ["%_ProjectDirOut05_%"]==[""] echo ===== & echo cd %_ProjectDirOut05_% & cd %_ProjectDirOut05_%
echo --------------------------------------------------------------------
:skip05
if ["%_ProjectName06_%"]==[""] goto skip06
if not ["%_ProjectDirIn06_%"]==[""] cd %_ProjectDirIn06_%
pwd & echo =====
dcc32 -M -I%_IncludeDirs_% -U%_UnitDirs_% -R%_ResDirs_% %2 %3 %4 %5 %6 %7 %8 %9 %_ProjectName06_%
echo --------------------------------------------------------------------
echo Running: MakeJclDbg -E %_ProjectName06_%.map
MakeJclDbg -E %_ProjectName06_%.map
if not ["%_ProjectDirOut06_%"]==[""] echo ===== & echo cd %_ProjectDirOut06_% & cd %_ProjectDirOut06_%
echo --------------------------------------------------------------------
:skip06
if ["%_ProjectName07_%"]==[""] goto skip07
if not ["%_ProjectDirIn07_%"]==[""] cd %_ProjectDirIn07_%
pwd & echo =====
dcc32 -M -I%_IncludeDirs_% -U%_UnitDirs_% -R%_ResDirs_% %2 %3 %4 %5 %6 %7 %8 %9 %_ProjectName07_%
echo --------------------------------------------------------------------
echo Running: MakeJclDbg -E %_ProjectName07_%.map
MakeJclDbg -E %_ProjectName07_%.map
if not ["%_ProjectDirOut07_%"]==[""] echo ===== & echo cd %_ProjectDirOut07_% & cd %_ProjectDirOut07_%
echo --------------------------------------------------------------------
:skip07
if ["%_ProjectName08_%"]==[""] goto skip08
if not ["%_ProjectDirIn08_%"]==[""] cd %_ProjectDirIn08_%
pwd & echo =====
dcc32 -M -I%_IncludeDirs_% -U%_UnitDirs_% -R%_ResDirs_% %2 %3 %4 %5 %6 %7 %8 %9 %_ProjectName08_%
echo --------------------------------------------------------------------
echo Running: MakeJclDbg -E %_ProjectName08_%.map
MakeJclDbg -E %_ProjectName08_%.map
if not ["%_ProjectDirOut08_%"]==[""] echo ===== & echo cd %_ProjectDirOut08_% & cd %_ProjectDirOut08_%
echo --------------------------------------------------------------------
:skip08
if ["%_ProjectName09_%"]==[""] goto skip09
if not ["%_ProjectDirIn09_%"]==[""] cd %_ProjectDirIn09_%
pwd & echo =====
dcc32 -M -I%_IncludeDirs_% -U%_UnitDirs_% -R%_ResDirs_% %2 %3 %4 %5 %6 %7 %8 %9 %_ProjectName09_%
echo --------------------------------------------------------------------
echo Running: MakeJclDbg -E %_ProjectName09_%.map
MakeJclDbg -E %_ProjectName09_%.map
if not ["%_ProjectDirOut09_%"]==[""] echo ===== & echo cd %_ProjectDirOut09_% & cd %_ProjectDirOut09_%
echo --------------------------------------------------------------------
:skip09
set _ResDirs_=
set _UnitDirs_=
set _IncludeDirs_=
:done
set _ProjectName01_=
set _ProjectDirIn01_=
set _ProjectDirOut01_=
set _ProjectName02_=
set _ProjectDirIn02_=
set _ProjectDirOut02_=
set _ProjectName03_=
set _ProjectDirIn03_=
set _ProjectDirOut03_=
set _ProjectName04_=
set _ProjectDirIn04_=
set _ProjectDirOut04_=
set _ProjectName05_=
set _ProjectDirIn05_=
set _ProjectDirOut05_=
set _ProjectName06_=
set _ProjectDirIn06_=
set _ProjectDirOut06_=
set _ProjectName07_=
set _ProjectDirIn07_=
set _ProjectDirOut07_=
set _ProjectName08_=
set _ProjectDirIn08_=
set _ProjectDirOut08_=
set _ProjectName09_=
set _ProjectDirIn09_=
set _ProjectDirOut09_=
rem Done.
