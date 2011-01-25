@echo off
echo ============================================================
echo FB gsec wrapper ver. 0.0.4
echo Usage: param1 = i / s - interactive / silent (without pause)
echo ============================================================
echo.
echo Searching "security.fdb" in "%%2", C:, D:, E:, F:, %%SystemDrive%% ...
set _fb_dir_=
if ["%2"]==[""] goto _check_cdef
if exist "%2\security.fdb" goto _found_test
:_check_cdef
if exist C:\Progra~1\Firebird\security.fdb goto _found_c
if exist D:\Progra~1\Firebird\security.fdb goto _found_d
if exist E:\Progra~1\Firebird\security.fdb goto _found_e
if exist F:\Progra~1\Firebird\security.fdb goto _found_f
set _fb_dir_="%ProgramFiles%\Firebird"
goto _default
:_found_test
set _fb_dir_=%2
echo Found (test) ...
goto _default
:_found_c
set _fb_dir_=C:\Progra~1\Firebird
goto _default
:_found_d
set _fb_dir_=D:\Progra~1\Firebird
goto _default
:_found_e
set _fb_dir_=E:\Progra~1\Firebird
goto _default
:_found_f
set _fb_dir_=F:\Progra~1\Firebird
goto _default
rem ========================
:_default
echo Found in directory : %_fb_dir_%
if ["%1"]==["s"] goto _skip_pause
pause
:_skip_pause
echo ************************************************************
echo. | gsec -z
echo ************************************************************
echo display | gsec -user sysdba -pass masterkey -database localhost/3050:"%_fb_dir_%\security.fdb"
echo.
echo ************************************************************
if ["%1"]==["i"] goto linteractive
echo del cashier-001 | gsec -user sysdba -pass masterkey -database localhost/3050:"%_fb_dir_%\security.fdb"
echo add creator001 -gid 10 -uid 101 -pw secretkey | gsec -user sysdba -pass masterkey -database localhost/3050:"%_fb_dir_%\security.fdb"
echo add devel001 -gid 20 -uid 201 -pw primarykey | gsec -user sysdba -pass masterkey -database localhost/3050:"%_fb_dir_%\security.fdb"
echo add devel002 -gid 20 -uid 202 -pw contributorykey | gsec -user sysdba -pass masterkey -database localhost/3050:"%_fb_dir_%\security.fdb"
echo add cashier001 -gid 30 -uid 301 -pw secondarykey | gsec -user sysdba -pass masterkey -database localhost/3050:"%_fb_dir_%\security.fdb"
echo add cashier002 -gid 30 -uid 302 -pw auxiliarykey | gsec -user sysdba -pass masterkey -database localhost/3050:"%_fb_dir_%\security.fdb"
echo add cashier003 -gid 30 -uid 303 -pw subsidiarykey | gsec -user sysdba -pass masterkey -database localhost/3050:"%_fb_dir_%\security.fdb"
echo add cashier004 -gid 30 -uid 304 -pw ancillarykey | gsec -user sysdba -pass masterkey -database localhost/3050:"%_fb_dir_%\security.fdb"
echo.
echo ************************************************************
echo modify sysdba -gid 99 -uid 999 -pw p2_i5+3vl3#sd$2bd13nbdf^5nsf6^sg98 | gsec -user sysdba -pass masterkey -database localhost/3050:"%_fb_dir_%\security.fdb"
rem echo modify sysdba -gid 99 -uid 999 -pw %3 | gsec -user sysdba -pass p2_i5+3vl3#sd$2bd13nbdf^5nsf6^sg98 -database localhost/3050:"%_fb_dir_%\security.fdb"
echo.
echo ************************************************************
echo.> gsec$tmp.txt
echo display>> gsec$tmp.txt
gsec -user sysdba -pass masterkey -database localhost/3050:"%_fb_dir_%\security.fdb" < gsec$tmp.txt
echo.> gsec$tmp.txt
del gsec$tmp.txt
echo.
echo ************************************************************
goto lend
:linteractive
rem gsec -user sysdba -pass masterkey -database localhost/3050:"%_fb_dir_%\security.fdb"
gsec -user sysdba -pass p2_i5+3vl3#sd$2bd13nbdf^5nsf6^sg98 -database localhost/3050:"%_fb_dir_%\security.fdb"
:lend
set _fb_dir_=
echo Done.
rem -- the end --
