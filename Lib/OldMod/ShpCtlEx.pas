{-----------------------------------------------------------------------------
 Unit Name: ShpCtlEx.pas
 Author:    n0mad
 Version:   1.1.7.83
 Creation:  29.08.2003
 Purpose:   Shape Controls
 History:
-----------------------------------------------------------------------------}
unit ShpCtlEx;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  ExtCtrls,
  ShpCtrl,
  Math,
  Buttons,
  Imglist,
  ActnList;

const
  Serial_Max_Len = 250;

type

  {
  0 = scFree - 'Свободно',
  1 = scBroken - 'Сломано',
  2 = scReserved - 'Зарезервировано',
  3 = scPrepared - 'Помечено для действия',
  4 = scFixed - 'Продано',
  5 = scFixedNoCash - 'Продано за б/н',
  6 = scFixedCheq - 'Продано`'
  }
  TOperRec = record
    fOper_Kod: Integer;
    fOper_Repert: Integer;
    fOper_Repert_Date: TDate;
    fOper_Repert_Zal: Integer;
    fOper_Repert_Seans: Integer;
    fOper_Repert_Film: Integer;
    fOper_Repert_Tariff: Integer;
    fOper_Zal_Place: Integer;
    fOper_Place_Row: Integer;
    fOper_Place_Col: Integer;
    fOper_Ticket: Integer;
    fTicket_Nam: string[Serial_Max_Len];
    fOper_Sum: Integer;
    fOper_Timestamp1: TDateTime;
    fOper_Timestamp2: TDateTime;
    fOper_State_Ch: Integer;
    fOper_State_History: Integer;
    fOper_State_Restored: Boolean;
    fOper_State_Printed: Boolean;
    fOper_Misc_Serial: string[Serial_Max_Len];
    fOper_Misc_Inviter: Integer;
    fOper_Misc_Group: Integer;
    fOper_Misc_Card: Integer;
    fOper_Misc_Reason: Integer;
    fOper_Session: Int64;
    fSession_Host: string[Serial_Max_Len];
    fSession_Dbuser: Integer;
    fDbuser_Nam: string[Serial_Max_Len];
  end;

  TTicketControlEx = class(TSpeedShapeControl)
  private
    FOperData: TOperRec;
    FOnChangeTicketType: TNotifyEvent;
    FOnChangeUsedByNet: TNotifyEvent;
    procedure SetOperData(const Value: TOperRec);
    procedure SetTicket_Kod(const Value: Integer);
    procedure SetTicket_Repert(const Value: Integer);
    procedure SetRow(const Value: Integer);
    procedure SetColumn(const Value: Integer);
    procedure SetTicketType(const Value: Integer);
    procedure SetTimeStamp1(const Value: TDateTime);
    procedure SetTimeStamp2(const Value: TDateTime);
    procedure SetTicket_Sesssion(const Value: Int64);
  protected
    procedure DrawButtonText(TextBounds: TRect; ButtonText: string; BiDiFlags:
      LongInt); override;
    procedure ChangeState; override;
    procedure ChangeTicketType; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
  published
    property OperData: TOperRec read FOperData write SetOperData;
    property TicketKod: Integer read FOperData.fOper_Kod write SetTicket_Kod
      default 0;
    property TicketRepert: Integer read FOperData.fOper_Repert write
      SetTicket_Repert default 0;
    property Row: Integer read FOperData.fOper_Place_Row write SetRow
      default 0;
    property Column: Integer read FOperData.fOper_Place_Col write SetColumn
      default 0;
    property TicketType: Integer read FOperData.fOper_Ticket write SetTicketType
      default 0;
    property TimeStamp1: TDateTime read FOperData.fOper_TimeStamp1 write
      SetTimeStamp1;
    property TimeStamp2: TDateTime read FOperData.fOper_TimeStamp2 write
      SetTimeStamp2;
    property TicketSession: Int64 read FOperData.fOper_Session write
      SetTicket_Sesssion;
    property OnChangeTicketType: TNotifyEvent read FOnChangeTicketType write
      FOnChangeTicketType;
    property OnChangeUsedByNet: TNotifyEvent read FOnChangeUsedByNet write
      FOnChangeUsedByNet;
  end;

  TEnumHS = (hsDisabled, hsHybrid, hsEnabled);

  {
const
  s_clReserved: string = 'clReserved=';
  clReserved: TColor = 12582911;
  clTrackReserved: TColor = 16744512;
  s_HSettting: string = 'HSettting=';
  HSettting: TEnumHS = hsEnabled;
  s_Global_Row_Show: string = 'Global_Row_Show=';
  Global_Row_Show: boolean = true;
  }

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('n0mad Controls', [TTicketControlEx]);
end;

{ TTicketControlEx }

constructor TTicketControlEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOperData.fOper_Kod := 0;
  FOperData.fOper_Kod := 0;
  FOperData.fOper_Repert := 0;
  FOperData.fOper_Repert_Date := Now;
  FOperData.fOper_Repert_Zal := 0;
  FOperData.fOper_Repert_Seans := 0;
  FOperData.fOper_Repert_Film := 0;
  FOperData.fOper_Repert_Tariff := 0;
  FOperData.fOper_Zal_Place := 0;
  FOperData.fOper_Place_Row := 0;
  FOperData.fOper_Place_Col := 0;
  FOperData.fOper_Ticket := 0;
  FOperData.fTicket_Nam := '';
  FOperData.fOper_Sum := 0;
  FOperData.fOper_Timestamp1 := Now;
  FOperData.fOper_Timestamp2 := Now;
  FOperData.fOper_State_Ch := 0;
  FOperData.fOper_State_History := 0;
  FOperData.fOper_State_Restored := false;
  FOperData.fOper_State_Printed := false;
  FOperData.fOper_Misc_Serial := '';
  FOperData.fOper_Misc_Inviter := 0;
  FOperData.fOper_Misc_Group := 0;
  FOperData.fOper_Misc_Card := 0;
  FOperData.fOper_Misc_Reason := 0;
  FOperData.fOper_Session := 0;
  FOperData.fSession_Host := '';
  FOperData.fSession_Dbuser := 0;
  FOperData.fDbuser_Nam := '';
  //
  FOnChangeTicketType := nil;
  FOnChangeUsedByNet := nil;
end;

destructor TTicketControlEx.Destroy;
begin
  inherited Destroy;
end;

procedure TTicketControlEx.DrawButtonText(TextBounds: TRect; ButtonText: string;
  BiDiFlags: Integer);
var
  Bounds: TRect;
  W, H: integer;
begin
  W := (TextBounds.Right - TextBounds.Left);
  H := (TextBounds.Bottom - TextBounds.Top);
  W := W div 3;
  if FShape in [stEllipse, stCircle] then
    H := H div 3
  else
    H := H div 2;
  if Global_Row_Show then
  begin
    Bounds.Left := TextBounds.Left;
    Bounds.Top := TextBounds.Top;
    Bounds.Right := TextBounds.Right - W;
    Bounds.Bottom := TextBounds.Bottom - H;
    inherited DrawButtonText(Bounds, IntToStr(FOperData.fOper_Place_Row),
      BiDiFlags);
  end;
  Bounds.Left := TextBounds.Left + W;
  Bounds.Top := TextBounds.Top + H;
  Bounds.Right := TextBounds.Right;
  Bounds.Bottom := TextBounds.Bottom;
  inherited DrawButtonText(Bounds, IntToStr(FOperData.fOper_Place_Col),
    BiDiFlags);
end;

procedure TTicketControlEx.SetOperData(const Value: TOperRec);
begin
  if (FOperData.fOper_Kod <> Value.fOper_Kod)
    or (FOperData.fOper_Repert <> Value.fOper_Repert)
    or (FOperData.fOper_Repert_Date <> Value.fOper_Repert_Date)
    or (FOperData.fOper_Repert_Zal <> Value.fOper_Repert_Zal)
    or (FOperData.fOper_Repert_Seans <> Value.fOper_Repert_Seans)
    or (FOperData.fOper_Repert_Film <> Value.fOper_Repert_Film)
    or (FOperData.fOper_Repert_Tariff <> Value.fOper_Repert_Tariff)
    or (FOperData.fOper_Zal_Place <> Value.fOper_Zal_Place)
    or (FOperData.fOper_Place_Row <> Value.fOper_Place_Row)
    or (FOperData.fOper_Place_Col <> Value.fOper_Place_Col)
    or (FOperData.fOper_Ticket <> Value.fOper_Ticket)
    or (FOperData.fTicket_Nam <> Value.fTicket_Nam)
    or (FOperData.fOper_Sum <> Value.fOper_Sum)
    or (FOperData.fOper_Timestamp1 <> Value.fOper_Timestamp1)
    or (FOperData.fOper_Timestamp2 <> Value.fOper_Timestamp2)
    or (FOperData.fOper_State_Ch <> Value.fOper_State_Ch)
    or (FOperData.fOper_State_History <> Value.fOper_State_History)
    or (FOperData.fOper_State_Restored <> Value.fOper_State_Restored)
    or (FOperData.fOper_State_Printed <> Value.fOper_State_Printed)
    or (FOperData.fOper_Misc_Serial <> Value.fOper_Misc_Serial)
    or (FOperData.fOper_Misc_Inviter <> Value.fOper_Misc_Inviter)
    or (FOperData.fOper_Misc_Group <> Value.fOper_Misc_Group)
    or (FOperData.fOper_Misc_Card <> Value.fOper_Misc_Card)
    or (FOperData.fOper_Misc_Reason <> Value.fOper_Misc_Reason)
    or (FOperData.fOper_Session <> Value.fOper_Session)
    or (FOperData.fSession_Host <> Value.fSession_Host)
    or (FOperData.fSession_Dbuser <> Value.fSession_Dbuser)
    or (FOperData.fDbuser_Nam <> Value.fDbuser_Nam) then
  begin
    if (FOperData.fOper_Kod <> Value.fOper_Kod) and (TC_State = scFree) then
    begin
      FOperData.fOper_Kod := Value.fOper_Kod;
      ChangeState;
    end;
    FOperData := Value;
    ChangeTicketType;
    Invalidate;
  end;
end;

procedure TTicketControlEx.SetTicket_Kod(const Value: Integer);
begin
  FOperData.fOper_Kod := Value;
end;

procedure TTicketControlEx.SetTicket_Repert(const Value: Integer);
begin
  FOperData.fOper_Repert := Value;
end;

procedure TTicketControlEx.SetRow(const Value: Integer);
begin
  if Value <> FOperData.fOper_Place_Row then
  begin
    FOperData.fOper_Place_Row := Value;
    Invalidate;
  end;
end;

procedure TTicketControlEx.SetColumn(const Value: Integer);
begin
  if Value <> FOperData.fOper_Place_Col then
  begin
    FOperData.fOper_Place_Col := Value;
    Invalidate;
  end;
end;

procedure TTicketControlEx.SetTicketType(const Value: Integer);
begin
  if FOperData.fOper_Ticket <> Value then
  begin
    FOperData.fOper_Ticket := Value;
    FOperData.fTicket_Nam := '';
    ChangeTicketType;
    Invalidate;
  end;
end;

procedure TTicketControlEx.SetTimeStamp1(const Value: TDateTime);
begin
  FOperData.fOper_Timestamp1 := Value;
end;

procedure TTicketControlEx.SetTimeStamp2(const Value: TDateTime);
begin
  FOperData.fOper_Timestamp2 := Value;
end;

procedure TTicketControlEx.SetTicket_Sesssion(const Value: Int64);
begin
  FOperData.fOper_Session := Value;
end;

procedure TTicketControlEx.Click;
begin
  if (TC_State in [scPrepared]) then
    Selected := not Selected;
  inherited Click;
end;

procedure TTicketControlEx.ChangeState;
begin
  if TC_State in [scFree] then
  begin
    FOperData.fOper_Kod := 0;
    FOperData.fOper_Repert := 0;
    FOperData.fOper_Repert_Date := Now;
    FOperData.fOper_Repert_Zal := 0;
    FOperData.fOper_Repert_Seans := 0;
    FOperData.fOper_Repert_Film := 0;
    FOperData.fOper_Repert_Tariff := 0;
    FOperData.fOper_Zal_Place := 0;
    // FOperData.fOper_Place_Row := 0;
    // FOperData.fOper_Place_Col := 0;
    FOperData.fOper_Ticket := 0;
    FOperData.fTicket_Nam := '';
    FOperData.fOper_Sum := 0;
    FOperData.fOper_Timestamp1 := Now;
    FOperData.fOper_Timestamp2 := Now;
    FOperData.fOper_State_Ch := 0;
    FOperData.fOper_State_History := 0;
    FOperData.fOper_State_Restored := false;
    FOperData.fOper_State_Printed := false;
    FOperData.fOper_Misc_Serial := '';
    FOperData.fOper_Misc_Inviter := 0;
    FOperData.fOper_Misc_Group := 0;
    FOperData.fOper_Misc_Card := 0;
    FOperData.fOper_Misc_Reason := 0;
    FOperData.fOper_Session := 0;
    FOperData.fSession_Host := '';
    FOperData.fSession_Dbuser := 0;
    FOperData.fDbuser_Nam := '';
  end;
  if TC_State in [scReserved] then
  begin
    if FOperData.fOper_Session = 0 then
    begin
      //
    end;
  end;
  if TC_State in [scPrepared] then
  begin
    FSelected := true;
    if FOperData.fOper_Session = 0 then
    begin
      FOperData.fOper_Timestamp1 := Now;
      FOperData.fOper_Timestamp2 := Now;
    end;
  end;
  if TC_State in [scFixed, scFixedNoCash, scFixedCheq] then
  begin
    if FOperData.fOper_Session = 0 then
    begin
      //
    end;
  end;
  inherited ChangeState;
end;

procedure TTicketControlEx.ChangeTicketType;
begin
  if Assigned(FOnChangeTicketType) then
    FOnChangeTicketType(Self);
end;

initialization
  length(s_clReserved + s_HSettting + s_Global_Row_Show);

end.

