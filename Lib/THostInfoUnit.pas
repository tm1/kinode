{-----------------------------------------------------------------------------
 Unit Name: THostInfoUnit
 Author:    YoungHacker, mail to : younghac@nsys.by
 Version:   1.0
 Purpose:   Get host info
-----------------------------------------------------------------------------}
unit THostInfoUnit;

interface

type
  THostInfo = class
  private
    FReadHostName: string;
    FReadHostAddress: string;
    FReadHostAddr: LongInt;
    procedure FWriteHostAddr(Addr: LongInt);
  public
    function Initialize: Boolean;
  published
    property HostName: string read FReadHostName;
    property HostAddress: string read FReadHostAddress;
    property HostAddr: LongInt read FReadHostAddr;
  end;

implementation

uses
  SysUtils, WinSock;

const
  BufSize = 255;

function THostInfo.Initialize: Boolean;
var
  Buf: Pointer;
  Host: PHostEnt; { No, don't free it! }
begin
  //- выделить буфер под им€ хоста
  try
    GetMem(Buf, BufSize);
  except
    Result := false;
    Exit;
  end;
  //- получить им€ хоста
  try
    WinSock.GetHostName(Buf, BufSize);
  except
    FreeMem(Buf, BufSize);
    Result := false;
    Exit;
  end;
  //- получить указатель на структуру PHostEnt по имени
  try
    Host := WinSock.GetHostByName(Buf);
  except
    FreeMem(Buf, BufSize);
    Result := false;
    Exit;
  end;
  //- если имени нет то это 127.0.0.1
  if (Char(Buf^) = #0) then
  begin
    FReadHostName := 'Local Host';
  end
  else
  begin
    if Assigned(Host) then
      FReadHostName := PChar(Host^.h_name)
    else
      FReadHostName := '?';
  end;
  //- преобразуем адрес хоста из полученой структуры
  try
    if Host = nil then
      FWriteHostAddr(WinSock.htonl($07000001)) (* 127.0.0.1 *)
    else
      FWriteHostAddr(LongInt(Pointer(Host^.h_addr_list^)^));
  except
    FreeMem(Buf, BufSize);
    Result := false;
    Exit;
  end;
  FreeMem(Buf, BufSize);
  Result := true;
end;

procedure THostInfo.FWriteHostAddr(Addr: LongInt);
var
  A: TInAddr;
begin
  FReadHostAddr := Addr;
  A.S_addr := FReadHostAddr;
  FReadHostAddress := WinSock.inet_ntoa(A);
end;

(*
procedure TForm1.btnGetNameClick(Sender: TObject);
const
  WSOCK11: word = $0101;
var
  P: PChar;
  WSAData: TWSAData;
begin
  {«апросим Winsock версии 1.1}
  if WSAStartup(WSOCK11, WSAData) <> 0 then
  begin
    ShowMessage('WSAStartup failed!');
    Exit;
  end;
  P := AllocMem(100); {надеемс€, что им€ хосте не больше 100 символов :) }
  if gethostname(P, 100) = -1 then
    ShowMessage('ќшибка однако!')
  else
    ShowMessage('»м€ машины: ' + P);
  FreeMem(P, 100); {освободим пам€ть}
  WSACleanup; {«авершим использование Winsock}
end;
*)

end.
