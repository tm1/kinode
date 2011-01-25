@echo off
echo ************************************************************
echo. | gsec -z
echo ************************************************************
echo display | gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb"
echo.
echo ************************************************************
if ["%1"]==["i"] goto linteractive
echo del cashier-001 | gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb"
echo add creator001 -gid 10 -uid 101 -pw secretkey | gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb"
echo add devel001 -gid 20 -uid 201 -pw primarykey | gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb"
echo add devel002 -gid 20 -uid 202 -pw contributorykey | gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb"
echo add cashier001 -gid 30 -uid 301 -pw secondarykey | gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb"
echo add cashier002 -gid 30 -uid 302 -pw auxiliarykey | gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb"
echo add cashier003 -gid 30 -uid 303 -pw subsidiarykey | gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb"
echo add cashier004 -gid 30 -uid 304 -pw ancillarykey | gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb"
echo.
echo ************************************************************
echo.> gsec$tmp.txt
echo display>> gsec$tmp.txt
gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb" < gsec$tmp.txt
echo.> gsec$tmp.txt
del gsec$tmp.txt
echo.
echo ************************************************************
goto lend
:linteractive
gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb"
:lend
rem -- the end --
