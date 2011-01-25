@echo off
echo -*----------------------------------------------------------------*-
echo =*=                clcunits.bat for Delphi ver 0.3.0                =*=
echo -*----------------------------------------------------------------*-
rem call b.bat clean
echo Clean temp files (*.~* *.bak *.tmp *.swp *.$$$ *.gid) ...
rem pause > nul
del /s *.~* *.bak *.tmp *.swp *.$$$ *.gid | more
echo Clean compiler units (*.dcu *.obj *.drc) ...
rem pause > nul
del /s *.dcu *.obj *.drc | more
echo Clean map files (*.map *.jdbg) ...
rem pause > nul
echo del /s *.map *.jdbg
rem del /s *.map *.jdbg | more
echo --------------------------------------------------------------------
