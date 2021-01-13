object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Is Nested'
  ClientHeight = 259
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    546
    259)
  PixelsPerInch = 96
  TextHeight = 13
  object lblUsername: TLabel
    Left = 24
    Top = 16
    Width = 48
    Height = 13
    Caption = 'Username'
  end
  object lblGroup: TLabel
    Left = 24
    Top = 56
    Width = 29
    Height = 13
    Caption = 'Group'
  end
  object edtUserName: TEdit
    Left = 88
    Top = 13
    Width = 321
    Height = 21
    TabOrder = 0
  end
  object edtGroupName: TEdit
    Left = 88
    Top = 53
    Width = 321
    Height = 21
    TabOrder = 1
  end
  object btnTest: TButton
    Left = 456
    Top = 51
    Width = 75
    Height = 25
    Caption = 'Test'
    Default = True
    TabOrder = 2
    OnClick = btnTestClick
  end
  object lstUsers: TListBox
    Left = 8
    Top = 96
    Width = 523
    Height = 145
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 3
  end
  object ntads1: TNTADS2
    Logon.Logon = False
    Search.SearchSubs = False
    Lasterror = 0
    Provider = 'LDAP://'
    QuietEnum = False
    OnGroup2Start = ntads1Group2Start
    OnGroup2Stop = ntads1Group2Stop
    OnGroup2Enum = ntads1Group2Enum
    Left = 424
    Top = 16
  end
end
