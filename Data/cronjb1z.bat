@echo off

z:
cd \FB_DATA

echo 1. Sweeping ...
call gstka1#.bat
call gfixka1#.bat

echo 2. Clearing locks ...
call gstka1#.bat
call kappa.clear.locks.cmd

echo 3. Backing up ...
call gstka1#.bat
call bka3z.bat

echo 4. Finishing ...
call gstka1#.bat

echo Done.
