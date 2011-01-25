@echo off
call b.bat build %2 %3 %4 %5 %6 %7 %8
if [%1]==[clean] goto clean
if [%1]==[-c] goto clean
if [%1]==[-C] goto clean
goto done
:clean
call b.bat clean
:done
rem Done.
