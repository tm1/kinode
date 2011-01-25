@echo off
rem call b.bat clean
echo Clean temp files (*.~* *.bak *.tmp *.swp *.$$$ *.gid) ...
rem pause > nul
rem del /s *.~* *.bak *.tmp *.swp *.$$$ *.gid | more
del /s *.~* *.bak *.tmp *.swp *.$$$ *.gid
