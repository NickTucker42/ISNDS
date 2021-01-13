object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 122
  ClientWidth = 474
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
    Width = 58
    Height = 13
    Caption = 'Group name'
  end
  object Label2: TLabel
    Left = 24
    Top = 48
    Width = 45
    Height = 13
    Caption = 'Comment'
  end
  object eGroupname: TEdit
    Left = 104
    Top = 21
    Width = 355
    Height = 21
    TabOrder = 0
    Text = 'CN=AGroupr,OU=SomeOU,DC=SomeDomain,DC=NET'
  end
  object btnOpenuser: TButton
    Left = 104
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Set'
    TabOrder = 1
    OnClick = btnOpenuserClick
  end
  object eComment: TEdit
    Left = 104
    Top = 45
    Width = 355
    Height = 21
    TabOrder = 2
  end
  object NTADS21: TNTADS2
    Logon.Logon = False
    Search.SearchSubs = False
    Lasterror = 0
    Provider = 'LDAP://'
    QuietEnum = False
    Left = 352
    Top = 80
  end
end
