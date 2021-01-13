object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 122
  ClientWidth = 455
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
    Width = 48
    Height = 13
    Caption = 'Username'
  end
  object eUsername: TEdit
    Left = 78
    Top = 21
    Width = 355
    Height = 21
    TabOrder = 0
    Text = 'CN=Auser,OU=SomeOU,DC=SomeDomain,DC=NET'
  end
  object btnOpenuser: TButton
    Left = 78
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Open User'
    TabOrder = 1
    OnClick = btnOpenuserClick
  end
  object NTADS21: TNTADS2
    Logon.Logon = False
    Search.SearchSubs = False
    Lasterror = 0
    Provider = 'LDAP://'
    QuietEnum = False
    Left = 192
    Top = 64
  end
end
