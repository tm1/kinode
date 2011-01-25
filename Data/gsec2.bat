@echo off
echo ************************************************************
echo. | gsec -z
echo ************************************************************
echo display | gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb"
echo.
echo ************************************************************
echo del cashier-001 | gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb"
echo add cashier001 -pw secondarykey | gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb"
echo add cashier002 -pw auxiliarykey | gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb"
echo.
echo ************************************************************
echo.> gsec$tmp.txt
echo display>> gsec$tmp.txt
gsec -user sysdba -pass masterkey -database localhost/3050:"D:\Progra~1\Firebird\security.fdb" < gsec$tmp.txt
echo.> gsec$tmp.txt
del gsec$tmp.txt
echo.
echo ************************************************************
rem -- the end --
