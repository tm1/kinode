object SLForm: TSLForm
  Left = 60
  Top = 60
  Width = 200
  Height = 160
  Caption = 'SLForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SLFormRestorer: TFrmRstr
    RegKey = 'Software\Home(R)\KinoDe\1.2.8'
    Left = 8
    Top = 8
  end
  object SLActionList: TActionList
    Left = 48
    Top = 8
    object SLFullScreen: TAction
      Caption = 'SLFullScreen'
      OnExecute = SLFullScreenExecute
    end
  end
end
