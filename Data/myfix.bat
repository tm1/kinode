echo off

rem set ib=C:\Program Files\Borland\InterBase\bin\
set ib=D:\Program Files\Firebird\bin\
set ibf=%ib%gfix
set ibb=%ib%gbak
set usr=-user sysdba
set psw=-password masterkey
echo
rem ------------------------------------------
rem 0. Опускаем БД
rem 1. Отключаем сборку мусора
rem 2. Пытаемся чинить
rem ------------------------------------------
echo on
"%ibf%" -housekeeping 0  %usr% %psw%  %2%1
"%ibf%" -validate -full  %usr% %psw%  %2%1
"%ibf%" -mend -ignore  %usr% %psw%  %2%1
"%ibb%" -B -limbo -ignore -garbage_collect -verbose -y %1.Backup_log %usr% %psw%  %2%1 %1.gbk
"%ibb%" -R -verbose -y %1.Restore_log %usr% %psw%  %1.gbk %2%1.restore
rem "%ibf%" -housekeeping 0 %1

