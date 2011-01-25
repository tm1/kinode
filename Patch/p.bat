@echo off
echo ------------------------------------------------
if not exist kinode0x.sp goto lerr1
if exist kinode0x.exe goto lpatch
if exist ..\kinode01.exe goto lcopy
:lerr3
echo error: ..\kinode01.exe is not found.
goto lexit
:lerr2
echo error: kinode0x.exe is not found.
goto lexit
:lerr1
echo error: kinode01.sp is not found.
goto lexit
:lcopy
echo kinode0x.exe is not found. copy from ..\kinode01.exe
copy /b ..\kinode01.exe kinode0x.exe
if exist kinode0x.exe goto lpatch
goto lerr2
:lpatch
echo kinode0x.exe is found. patching...
echo ------------------------------------------------
sp.exe kinode0x.sp
:lexit
echo ------------------------------------------------
rem Done.
