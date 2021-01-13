object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Secure Channel'
  ClientHeight = 270
  ClientWidth = 578
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 64
    Height = 13
    Caption = 'Server name '
  end
  object edt1: TEdit
    Left = 92
    Top = 21
    Width = 145
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 92
    Top = 48
    Width = 145
    Height = 25
    Caption = 'Go'
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 24
    Top = 88
    Width = 513
    Height = 169
    TabOrder = 2
  end
  object NTADS21: TNTADS2
    Logon.Logon = False
    Search.SearchSubs = False
    Lasterror = 0
    Provider = 'LDAP://'
    QuietEnum = False
    SecurityOnly = True
    Left = 32
    Top = 48
  end
end
