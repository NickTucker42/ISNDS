object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 331
  ClientWidth = 552
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 19
    Width = 22
    Height = 13
    Caption = 'User'
  end
  object Image1: TImage
    Left = 48
    Top = 96
    Width = 217
    Height = 217
    Center = True
    Stretch = True
  end
  object edtUser: TEdit
    Left = 48
    Top = 16
    Width = 481
    Height = 21
    TabOrder = 0
  end
  object btnGet: TButton
    Left = 48
    Top = 48
    Width = 75
    Height = 25
    Caption = 'get Picture'
    TabOrder = 1
    OnClick = btnGetClick
  end
  object btnsetPicture: TButton
    Left = 176
    Top = 48
    Width = 75
    Height = 25
    Caption = 'set Picture'
    TabOrder = 2
    OnClick = btnsetPictureClick
  end
  object btnLoad: TButton
    Left = 280
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 3
    OnClick = btnLoadClick
  end
  object NTADS21: TNTADS2
    Logon.Logon = False
    Search.SearchSubs = False
    Lasterror = 0
    Provider = 'LDAP://'
    QuietEnum = False
    SecurityOnly = True
    Left = 352
    Top = 96
  end
  object OpenDialog1: TOpenDialog
    Filter = 'JPG|*.jpg'
    Left = 312
    Top = 168
  end
end
