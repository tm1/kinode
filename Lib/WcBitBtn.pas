unit WcBitBtn;

interface

uses
  Classes,
  Graphics,
  Buttons,
  Imglist,
  ActnList;

type

  TWc_BitBtn = class(TBitBtn)
  protected
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    property Caption;
  public
    constructor Create(AOwner: TComponent); override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('n0mad Controls', [TWc_BitBtn]);
end;

{ TWc_BitBtn }

constructor TWc_BitBtn.Create(AOwner: TComponent);
begin
  inherited;
  Caption := '';
end;

procedure TWc_BitBtn.ActionChange(Sender: TObject; CheckDefaults: Boolean);

  procedure CopyImage(ImageList: TCustomImageList; Index: Integer);
  begin
    with Glyph do
    begin
      Width := ImageList.Width;
      Height := ImageList.Height;
      Canvas.Brush.Color := clFuchsia; //! for lack of a better color
      Canvas.FillRect(Rect(0, 0, Width, Height));
      ImageList.Draw(Canvas, 0, 0, Index);
    end;
  end;

begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      { Copy image from action's imagelist }
      if (ActionList <> nil) and (ActionList.Images <> nil) and
        (ImageIndex >= 0) and (ImageIndex < ActionList.Images.Count) then
        CopyImage(ActionList.Images, ImageIndex);
      Self.Caption := '';
    end;
end;

initialization

end.

