@echo off

C:
cd \FB_DATA

echo 1. Sweeping ...
call gstka1#.bat gstatka.log
call gfixka1#.bat

echo 2. Clearing locks ...
rem call gstka1#.bat gstatka.log
call kappa.clear.locks.cmd

echo 3. Backing up ...
rem call gstka1#.bat gstatka.log
rem call bka3c.bat

echo 4. Finishing ...
call gstka1#.bat gstatka.log

echo Done.
