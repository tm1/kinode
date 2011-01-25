{-----------------------------------------------------------------------------
 Unit Name: StrConsts
 Author:    n0mad
 Version:   1.1.6.71
 Creation:  06.08.2003
 Purpose:   Standard contants
 History:
-----------------------------------------------------------------------------}
unit StrConsts;

interface

const
  // -------------------------------------------------------------------------
  c_Null_Terminator: Char = #0;
  c_Tab: Char = #9;
  c_Quote: Char = '''';
  c_Space: Char = ' ';
  c_CR: Char = #13;
  c_LF: Char = #10;
  c_CRLF: string = #13#10;
  c_White_Space: string = #13#10#9;
  c_Separator_20: string = '--------------------';
  // -------------------------------------------------------------------------
  c_Menu_In_Str: string = ' ::::: ';
  c_Valuta: string = 'тенге';
  // -------------------------------------------------------------------------
  BoolYesNo: array[Boolean] of Char = ('N', 'Y');
  c_Boolean: array[Boolean] of string = ('Нет (No)', 'Да (Yes)');
  // -------------------------------------------------------------------------

implementation

end.
