echo off
rem -- ufDRprt.ChangeNamesEx.patch.bat --
echo Running :   patch -u --verbose --dry-run file1 patchfile1
patch -u --verbose --dry-run ..\forms04\ufDRpEx.pas ..\CodeSnip\ufDRprt.pas.ChangeNamesEx.patch
patch -u --verbose --dry-run ..\forms04\ufDRpEx.dfm ..\CodeSnip\ufDRprt.dfm.ChangeNamesEx.patch
