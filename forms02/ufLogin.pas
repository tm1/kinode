{-----------------------------------------------------------------------------
 Unit Name: ufLogin
 Author:    n0mad
 Version:   1.2.8.x
 Creation:  09.05.2004
 Purpose:   Login dialog
 History:
-----------------------------------------------------------------------------}
unit ufLogin;

interface

{$I kinode01.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Mask,
  ExtCtrls, Buttons, SLForms;

type
  Tfm_Login = class(TSLForm)
    cmb_UserName: TComboBox;
    med_Password: TMaskEdit;
    lbl_UserName: TLabel;
    lbl_Password: TLabel;
    bt_OK: TButton;
    bt_Cancel: TButton;
    lbl_HostInfo: TLabel;
    ed_HostInfo: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure bt_OKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function acLoginShowModal(Sender: TObject): integer;

var
  fm_Login: Tfm_Login;

implementation

uses
  Bugger, udCommon, uhCommon, urCommon, ufSplash, StrConsts;

const
  UnitName: string = 'ufLogin';

var
  sMessage: string;

{$R *.DFM}

function acLoginShowModal(Sender: TObject): integer;
const
  ProcName: string = 'acLoginShowModal';
begin
  // --------------------------------------------------------------------------
  // Вход пользователя
  // --------------------------------------------------------------------------
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  // Result := mrCancel;
  try
    Application.CreateForm(Tfm_Login, fm_Login);
    DEBUGMessEnh(0, UnitName, ProcName, fm_Login.Name + '.ShowModal');
    Result := fm_Login.ShowModal;
  finally
    fm_Login.Free;
    fm_Login := nil;
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Login.FormCreate(Sender: TObject);
begin
  // if Assigned(FormRestorer) and (FormRestorer is TFrmRstr) then
  //   FormRestorer.RegKey := 'Software\Home(R)\KinoDe\1.2.8';
  bt_OK.ModalResult := mrNone;
  bt_Cancel.ModalResult := mrCancel;
end;

procedure Tfm_Login.FormActivate(Sender: TObject);
const
  ProcName: string = 'fm_Login.FormActivate';
var
  idx, vUserKod: integer;
  vUserName: string;
  HostName: string;
  HostAddress: string;
  HostAddr: LongInt;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  cmb_UserName.Enabled := false;
  med_Password.Enabled := false;
  med_Password.Text := '';
  bt_OK.Enabled := false;
  Update;
  if GetHostInfoEx(HostName, HostAddress, HostAddr) then
    ed_HostInfo.Text := '' + HostName + ' [' + HostAddress + ']'
  else
    ed_HostInfo.Text := 'localhost:127.0.0.1';
  bt_OK.ModalResult := mrNone;
  bt_Cancel.ModalResult := mrCancel;
  with cmb_UserName, dm_Common do
  begin
    Clear;
    Update;
    try
      ds_DBUser.Close;
      ds_DBUser.Prepare;
      {
      DEBUGMessEnh(0, UnitName, ProcName, 'ds_DBUser.SelectSQL = (' + ds_DBUser.SelectSQL.Text +
        ')');
      }
      ds_DBUser.Open;
      Combo_Load_DBUser(ds_DBUser, Items);
    except
      on E: Exception do
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
        DEBUGMessEnh(0, UnitName, ProcName, 'Exception during load DB user list.');
        DBLastError1 := E.Message;
      end;
    end;
    SetForegroundWindow(Self.Handle);
    if ds_DBUser.Active then
      ds_DBUser.Close;
    if Items.Count > 0 then
    begin
      cmb_UserName.Enabled := true;
      med_Password.Enabled := true;
      med_Password.Text := '';
      if med_Password.Enabled then
        med_Password.SetFocus;
      bt_OK.Enabled := true;
      if LoadLastUser(vUserKod, vUserName) then
      begin
        idx := Items.IndexOf(vUserName);
        if idx = -1 then
        begin
          idx := Items.IndexOfObject(TObject(vUserKod));
          if idx = -1 then
          begin
            idx := 0;
          end;
        end;
        ItemIndex := idx;
      end
      else
        ItemIndex := 0;
    end
    else
    begin
      sMessage := 'Error!!! >> There is no users.';
      AddToLog2(sMessage, true, false);
      DEBUGMessEnh(0, UnitName, ProcName, sMessage);
      MessageBox(0, PChar('---   There is no users   ---' + c_CRLF +
        'Нет пользователей. Обратитесь к админу.'), 'Load error', MB_ICONERROR);
    end;
    if Assigned(OnChange) then
      OnChange(Self);
  end;
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

procedure Tfm_Login.bt_OKClick(Sender: TObject);
const
  ProcName: string = 'bt_OKClick';
var
  tDBUser_Kod: Integer;
  tDBUser_Nam, tDBUser_Pass: string;
  tSession_ID: Int64;
  tError_Kod: Integer;
  tError_Text: string;
begin
  DEBUGMessEnh(1, UnitName, ProcName, '->');
  // --------------------------------------------------------------------------
  bt_OK.ModalResult := mrNone;
  bt_Cancel.ModalResult := mrCancel;
  with cmb_UserName do
    if ItemIndex >= 0 then
    begin
      tDBUser_Kod := integer(Items.Objects[ItemIndex]);
      tDBUser_Nam := Items[ItemIndex];
      tDBUser_Pass := med_Password.Text;
      if AuthenticateUser(tDBUser_Kod, tDBUser_Nam, tDBUser_Pass, tSession_ID, tError_Kod,
        tError_Text) then
      begin
        Global_Session_ID := tSession_ID;
        sMessage := 'User "' + tDBUser_Nam + '" is authenticated.';
        AddToLog2(sMessage, true, false);
        DEBUGMessEnh(0, UnitName, ProcName, sMessage);
        med_Password.Text := '';
        try
          SaveLastUser(tDBUser_Kod, tDBUser_Nam);
        except
          on E: Exception do
          begin
            DEBUGMessEnh(0, UnitName, ProcName, 'Error is [' + E.Message + ']');
            DEBUGMessEnh(0, UnitName, ProcName, 'Cannot save last user to inifile.');
          end;
        end;
        Close;
      end
      else
      begin
        DEBUGMessEnh(0, UnitName, ProcName, 'Login failure for "' + tDBUser_Nam + '"');
        MessageBox(0, PChar('---   Login failure   ---' + c_CRLF +
          'Вроде бы все правильно, но войти не получается.'
          + c_CRLF + 'А ошибка вот такая:' + c_CRLF + c_Separator_20 + c_CRLF
          + 'Код ошибки = ' + IntToStr(tError_Kod) + ';' + c_CRLF + tError_Text),
          'Access denied.', MB_ICONERROR);
        med_Password.Text := '';
        if med_Password.Enabled then
          med_Password.SetFocus;
      end;
    end
    else
      MessageBox(0, PChar('---   There is no users   ---' + c_CRLF +
        'Нет пользователей. Обратитесь к админу.'), 'Load error', MB_ICONERROR);
  // --------------------------------------------------------------------------
  DEBUGMessEnh(-1, UnitName, ProcName, '<-');
end;

end.

