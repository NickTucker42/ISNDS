object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Verify Logon'
  ClientHeight = 418
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    426
    418)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 52
    Height = 13
    Caption = 'User Name'
  end
  object Label2: TLabel
    Left = 32
    Top = 80
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object eUsername: TEdit
    Left = 32
    Top = 43
    Width = 345
    Height = 21
    TabOrder = 0
    TextHint = 'Enter your username'
  end
  object ePassword: TEdit
    Left = 32
    Top = 99
    Width = 345
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
    TextHint = 'Enter your password'
  end
  object Button1: TButton
    Left = 32
    Top = 136
    Width = 345
    Height = 41
    Caption = 'Log on'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 215
    Width = 393
    Height = 186
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssBoth
    TabOrder = 3
    WordWrap = False
  end
  object NTADS21: TNTADS2
    Logon.Logon = False
    Search.SearchSubs = False
    Lasterror = 0
    Provider = 'LDAP://'
    QuietEnum = False
    SecurityOnly = True
    Left = 184
    Top = 8
  end
end
