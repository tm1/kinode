@echo off

echo Let's go ...
echo ------------------------------------------
call IBEScript.bat "kappa.clear.lockuser.sql"
call IBEScript.bat "kappa.clear.userstatus.sql"
echo ------------------------------------------
echo Done.
