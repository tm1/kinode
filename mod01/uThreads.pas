{-----------------------------------------------------------------------------
 Unit Name: uThreads
 Author:    n0mad
 Version:   1.1.6.63
 Creation:  12.10.2002
 Purpose:   Working with threads
 History:
-----------------------------------------------------------------------------}
unit uThreads;

interface
{$I bugger.inc}

uses
  Classes, Comctrls, Bugger;

type
  TGenericThreadProc = procedure(PointerToData: Pointer; var Terminated:
    boolean);
  TGenericThread = class(TThread)
  private
    FProcToInit: TGenericThreadProc;
    FProcToCall: TGenericThreadProc;
    FProcToFinal: TGenericThreadProc;
    FPointerToData: Pointer;
    FForceTerminated: boolean;
    FRunning: boolean;
    function GetRuning: Boolean;
  protected
    procedure Execute; override; // Main thread execution
    procedure ProcInit;
    procedure ProcExecute;
    procedure ProcFinal;
  public
    constructor Create(PriorityLevel: TThreadPriority; ProcToInit, ProcToCall,
      ProcToFinal: TGenericThreadProc; PointerToData: Pointer);
    destructor Destroy; override;
    property Runing: Boolean read GetRuning;
  end;

implementation

uses
  Windows;

const
  UnitName: string = 'uThreads';

constructor TGenericThread.Create(PriorityLevel: TThreadPriority; ProcToInit,
  ProcToCall, ProcToFinal: TGenericThreadProc; PointerToData: Pointer);
begin
  inherited Create(true); // Create thread suspended
  FRunning := true;
  Priority := TThreadPriority(PriorityLevel); // Set Priority Level
  FreeOnTerminate := true; // Thread Free Itself when terminated
  FProcToInit := ProcToInit; // Set reference
  FProcToCall := ProcToCall; // Set reference
  FProcToFinal := ProcToFinal; // Set reference
  FForceTerminated := false;
  FPointerToData := PointerToData;
  if @ProcToCall <> nil then
    Suspended := false // Continue the thread
  else
    FRunning := false;
end;

destructor TGenericThread.Destroy;
begin
  inherited Destroy;
end;

procedure TGenericThread.Execute; // Main execution for thread
begin
  FRunning := true;
  try
    if @FProcToInit <> nil then
      Synchronize(ProcInit);
    while not (Terminated or FForceTerminated) do
    begin
      if @FProcToCall <> nil then
        Synchronize(ProcExecute);
      // if Terminated is true, this loop exits prematurely so the thread will terminate
    end;
    if @FProcToFinal <> nil then
      Synchronize(ProcFinal);
  finally
    // Bad-bad-bad code
    while FRunning do
    begin
      FRunning := false;
      SleepEx(0, false);
    end;
  end;  
end;

procedure TGenericThread.ProcInit;
begin
  if @FProcToInit <> nil then
    FProcToInit(FPointerToData, FForceTerminated);
end;

procedure TGenericThread.ProcExecute;
begin
  if @FProcToCall <> nil then
    FProcToCall(FPointerToData, FForceTerminated);
end;

procedure TGenericThread.ProcFinal;
begin
  if @FProcToFinal <> nil then
    FProcToFinal(FPointerToData, FForceTerminated);
end;

function TGenericThread.GetRuning: Boolean;
begin
  Result := FRunning{ or FForceTerminated};
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
