{-----------------------------------------------------------------------------
 Unit Name  :  BugRes.pas
    Author  :  n0mad
   Version  :  (B) 2004.11.04.01
  Creation  :  04.11.2004
   Purpose  :  Debuging resources
   Program  :  Common type
   History  :
-----------------------------------------------------------------------------}
unit BugRes;

interface

const
  DEBUGWorkDir: string = '';  
  DEBUGProjectName: string = '';
  DEBUGFileNameDateTimeAddon: string = '_(yyyy_mm_dd^hh_nn_ss_ddd)';
  DEBUGSavFileDateTimeAddon: string = '(yyyy-mm-dd^hh-nn-ss)';
  DEBUGFileNameExt: string = 'log';
  DEBUGToFile: boolean = true;
  DEBUGSaveToFile: boolean = true;
  DEBUGShowScr: boolean = false;
  DEBUGShowWarnings: boolean = true;
  DEBUGShowPrn: boolean = false;
  DEBUGNewLogFile: boolean = true;
  DEBUGShowAddr: boolean = true;
  DEBUGLogSeparatorWidth: integer = 77;
  DEBUGFreeSpaceLimitPercent: integer = 4;
  DEBUGFreeSpaceLimitBytes: int64 = 8 * 1024 * 1024;

implementation

end.
