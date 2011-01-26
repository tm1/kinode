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
  Font.Name = 'MS Sans Serif'
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
  object SLXPMenu: TXPMenu
    DimLevel = 30
    GrayLevel = 10
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMenuText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    Color = clBtnFace
    IconBackColor = clBtnFace
    MenuBarColor = clBtnFace
    SelectColor = clHighlight
    SelectBorderColor = clHighlight
    SelectFontColor = clMenuText
    DisabledColor = clInactiveCaption
    SeparatorColor = clBtnFace
    CheckedColor = clHighlight
    IconWidth = 24
    DrawSelect = True
    UseSystemColors = True
    OverrideOwnerDraw = False
    Gradient = False
    FlatMenu = True
    AutoDetect = True
    XPControls = [xcMainMenu, xcPopupMenu, xcToolbar, xcControlbar, xcEdit, xcMaskEdit, xcMemo, xcRichEdit, xcRadioButton, xcButton, xcBitBtn, xcSpeedButton, xcPanel, xcGroupBox]
    Active = False
    Left = 88
    Top = 8
  end
end
