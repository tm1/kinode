{-----------------------------------------------------------------------------
 Unit Name: bugger.inc
 Author:    n0mad
 Version:   1.1.6.63
 Creation:  04.04.2003
 Purpose:   Define debug conditionals
 History:
-----------------------------------------------------------------------------}
//{$DEFINE NO_DEBUG}

// {$DEFINE DEBUG_Module_Start_Finish}
{$IFDEF NO_DEBUG}
  {$UNDEF DEBUG_Module_Start_Finish}
{$ENDIF}
