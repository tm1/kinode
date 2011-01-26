{-----------------------------------------------------------------------------
 Unit Name: uTools
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  01.03.2004
 Purpose:   Various purpose tools
 History:
-----------------------------------------------------------------------------}
unit uTools;

interface
{$I bugger.inc}

function FormatTextToMax(_text: string; MaxLength: integer; SpaceChar: Char;
  pt3: boolean): string;
function FixFmt(Number: Cardinal; Digits: byte; Filler: Char): string;
function Sign(n: real): integer;
function XorStr(Input1, Input2: string): string;
function FmtHex2Str(Input: string; var Output: string): boolean;
function FmtStr2Hex(Input: string; var Output: string): boolean;
function Split(s, term: string; var s1, s2: string): boolean;
function Str2Num(s: string; var i: Int64): boolean; overload;
function Str2Num(s: string; var i: Integer): boolean; overload;
function Str2Num(s: string; var i: SmallInt): boolean; overload;
function Str2Num(s: string; var i: Byte): boolean; overload;
function Byte2Str8(n: Int64): string;
function Byte2Str4(n: Integer): string;
function Byte2Str2(n: SmallInt): string;
function Byte2Str1(n: Byte): string;
function Str2Byte8(s: string): Int64;
function Str2Byte4(s: string): Integer;
function Str2Byte2(s: string): SmallInt;
function Str2Byte1(s: string): Byte;
function IntToHex1(Value: Integer; Digits: Integer): string;

implementation

uses
  Bugger, SysUtils;

const
  UnitName: string = 'uTools';

function FormatTextToMax(_text: string; MaxLength: integer; SpaceChar: Char;
  pt3: boolean): string;
var
  s: string;
begin
  {
  ("ABCDEF", 8, "x", true)  -> "ABCDEFxx"
  ("ABCDEF", 8, "x", false) -> "ABCDEFxx"
  ("ABCDEF", 6, "x", true)  -> "ABCDEF"
  ("ABCDEF", 6, "x", false) -> "ABCDEF"
  ("ABCDEF", 5, "x", true)  -> "AB..."
  ("ABCDEF", 5, "x", false) -> "ABCDE"
  ("ABCDEF", 4, "x", true)  -> "ABC."
  ("ABCDEF", 4, "x", false) -> "ABCD"
  ("ABCDEF", 3, "x", true)  -> "AB."
  ("ABCDEF", 3, "x", false) -> "ABC"
  ("ABCDEF", 2, "x", true)  -> "A."
  ("ABCDEF", 2, "x", false) -> "AB"
  ("ABCDEF", 1, "x", true)  -> "A"
  ("ABCDEF", 1, "x", false) -> "A"
  }
  Result := '';
  if (length(_text) > 0) and (MaxLength > 0) then
  begin
    if length(_text) > MaxLength then
    begin
      s := copy(_text, 1, MaxLength);
      if pt3 then
        if (MaxLength > 4) then
          s := copy(s, 1, length(s) - 3) + '...'
        else if (MaxLength > 1) then
          s := copy(s, 1, length(s) - 1) + '.';
    end
    else
      s := _text + StringOfChar(SpaceChar, MaxLength - length(_text));
    Result := s;
  end;
end;

function FixFmt(Number: Cardinal; Digits: byte; Filler: Char): string;
var
  i: integer;
  s: string;
begin
  s := IntToStr(Abs(Number));
  i := length(s);
  if i > Digits then
    Delete(s, 1, i - Digits)
  else if i < Digits then
    s := Concat(StringOfChar(Filler, Digits - i), s);
  Result := s;
end;

function Sign(n: real): integer;
begin
  if n = 0 then
    Result := 0
  else if n > 0 then
    Result := 1
  else
    Result := -1;
end;

function XorStr(Input1, Input2: string): string;
var
  i, j: Integer;
  b: Byte;
  s: string;
begin
  if Length(Input2) = 0 then
    Result := Input1
  else
  begin
    i := 0;
    j := 0;
    s := '';
    while i < Length(Input1) do
    begin
      Inc(i);
      Inc(j);
      if j > Length(Input2) then
        j := 1;
      asm
        jmp @@loc
        db $90, $90, $90, $90, $90, $90, $90, $90
        db $0D, $0A, '#-Sign4U-#', $0D, $0A, 0
        db 'XorStr Operation', 0
        db 'Begin here', $0D, $0A, 0
        db $90, $90, $90, $90, $90, $90, $90, $90
      @@loc:
      end;
      b := Byte(Input1[i]) xor Byte(Input2[j]);
      asm
        jmp @@loc
        db $90, $90, $90, $90, $90, $90, $90, $90
        db $0D, $0A, '#-Sign4U-#', $0D, $0A, 0
        db 'XorStr Operation', 0
        db 'End here', $0D, $0A, 0
        db $90, $90, $90, $90, $90, $90, $90, $90
      @@loc:
      end;
      s := s + Char(b);
    end;
    Result := s;
  end;
end;

function FmtHex2Str(Input: string; var Output: string): boolean;
const
  abc: string[16] = '0123456789abcdef';
var
  i, p1, p2, len: Integer;
  str: string;
  test: Boolean;
begin
  Result := false;
  try
    len := Length(Input);
    if not Odd(len) then
    begin
      // SetLength(Output, len shr 1);
      Output := StringOfChar(#0, len shr 1);
      test := true;
      for i := 1 to len shr 1 do
      begin
        str := LowerCase(Copy(Input, i shl 1 - 1, 2));
        p1 := Pos(str[1], abc);
        p2 := Pos(str[2], abc);
        if (p1 > 0) and (p2 > 0) then
          Output[i] := Char((p1 - 1) shl 4 + (p2 - 1))
        else
        begin
          test := false;
          Break;
        end;
      end;
      Result := test;
    end
    else
      Output := '';
  except
  end;
end;

function FmtStr2Hex(Input: string; var Output: string): boolean;
var
  i, len: Integer;
  str: string;
begin
  Result := false;
  try
    len := Length(Input);
    // SetLength(Output, len shl 1);
    Output := StringOfChar(#0, len shl 1);
    for i := 1 to len do
    begin
      str := LowerCase(IntToHex(Byte(Input[i]), 2));
      Output[i shl 1 - 1] := str[1];
      Output[i shl 1] := str[2];
    end;
    Result := true;
  except
  end;
end;

function Split(s, term: string; var s1, s2: string): boolean;
var
  p: Integer;
begin
  Result := false;
  if (length(term) > 0) and (length(s) > length(term)) then
  begin
    p := pos(term, s);
    if p > 0 then
    begin
      s1 := copy(s, 1, p - 1);
      s2 := copy(s, p + length(term), length(s) - p + length(term));
      Result := true;
    end
    else
    begin
      s1 := '';
      s2 := '';
    end;
  end
  else
  begin
    s1 := '';
    s2 := '';
  end;
end;

function Str2Num(s: string; var i: Int64): boolean; overload;
begin
  try
    i := StrToInt(s);
    Result := true;
  except
    i := 0;
    Result := false;
  end;
end;

function Str2Num(s: string; var i: Integer): boolean; overload;
begin
  try
    i := StrToInt(s);
    Result := true;
  except
    i := 0;
    Result := false;
  end;
end;

function Str2Num(s: string; var i: SmallInt): boolean; overload;
begin
  try
    i := StrToInt(s);
    Result := true;
  except
    i := 0;
    Result := false;
  end;
end;

function Str2Num(s: string; var i: Byte): boolean; overload;
begin
  try
    i := StrToInt(s);
    Result := true;
  except
    i := 0;
    Result := false;
  end;
end;

function Byte2Str8(n: Int64): string;
begin
  Result := StringOfChar(#8, 2);
  asm
    push eax;
    push ebx;
    mov ebx, @Result;
    mov ebx, [ebx];
    mov eax, offset n;
    mov eax, [eax];
    mov [ebx], eax;
    mov eax, offset n;
    mov eax, [eax + 4];
    mov [ebx + 4], eax;
    pop ebx;
    pop eax;
  end;
end;

function Byte2Str4(n: Integer): string;
begin
  Result := StringOfChar(#8, 4);
  asm
    push eax;
    push ebx;
    mov ebx, @Result;
    mov ebx, [ebx];
    mov eax, n;
    mov [ebx], eax;
    pop ebx;
    pop eax;
  end;
end;

function Byte2Str2(n: SmallInt): string;
begin
  Result := StringOfChar(#8, 2);
  asm
    push eax;
    push ebx;
    mov ebx, @Result;
    mov ebx, [ebx];
    mov ax, n;
    cwd;
    mov [ebx], eax;
    pop ebx;
    pop eax;
  end;
end;

function Byte2Str1(n: Byte): string;
begin
  Result := Char(n);
end;

function Str2Byte8(s: string): Int64;
begin
  if length(s) > 0 then
    Result := Int64(s[1])
  else
    Result := 0;
end;

function Str2Byte4(s: string): Integer;
begin
  if length(s) > 0 then
    Result := Integer(s[1])
  else
    Result := 0;
end;

function Str2Byte2(s: string): SmallInt;
begin
  if length(s) > 0 then
    Result := SmallInt(s[1])
  else
    Result := 0;
end;

function Str2Byte1(s: string): Byte;
begin
  if length(s) > 0 then
    Result := Byte(s[1])
  else
    Result := 0;
end;

function IntToHex1(Value: Integer; Digits: Integer): string;
begin
  Result := '0x' + IntToHex(Value, Digits);
end;

function IntToHex2(Value: Integer; Digits: Integer): string;
begin
  Result := '$' + IntToHex(Value, Digits);
end;

{$IFDEF DEBUG_Module_Start_Finish}
initialization
  DEBUGMess(0, UnitName + '.Init');
{$ENDIF}

{$IFDEF DEBUG_Module_Start_Finish}
finalization
  DEBUGMess(0, UnitName + '.Final');
{$ENDIF}

end.

