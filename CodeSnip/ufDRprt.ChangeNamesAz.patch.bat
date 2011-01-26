echo off
rem -- ufDRprt.ChangeNamesAz.patch.bat --
echo Running :   patch -u --verbose --dry-run file1 patchfile1
patch -u --verbose --dry-run ..\forms04\ufDRpAz.pas ..\CodeSnip\ufDRprt.pas.ChangeNamesAz.patch
patch -u --verbose --dry-run ..\forms04\ufDRpAz.dfm ..\CodeSnip\ufDRprt.dfm.ChangeNamesAz.patch
