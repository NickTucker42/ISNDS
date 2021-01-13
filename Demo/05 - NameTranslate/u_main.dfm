object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Name Translate'
  ClientHeight = 394
  ClientWidth = 468
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 55
    Height = 13
    Caption = 'Input name'
  end
  object Label2: TLabel
    Left = 24
    Top = 80
    Width = 61
    Height = 13
    Caption = 'Input format'
  end
  object Label4: TLabel
    Left = 24
    Top = 152
    Width = 69
    Height = 13
    Caption = 'Output format'
  end
  object Label3: TLabel
    Left = 24
    Top = 224
    Width = 30
    Height = 13
    Caption = 'Result'
  end
  object eInName: TEdit
    Left = 24
    Top = 35
    Width = 417
    Height = 21
    TabOrder = 0
  end
  object cbIn: TComboBox
    Left = 24
    Top = 99
    Width = 417
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 1
    Text = ' ADS_NAME_TYPE_1779                    '
    Items.Strings = (
      ' ADS_NAME_TYPE_1779                    '
      ' ADS_NAME_TYPE_CANONICAL             '
      ' ADS_NAME_TYPE_NT4                '
      ' ADS_NAME_TYPE_DISPLAY                 '
      ' ADS_NAME_TYPE_DOMAIN_SIMPLE           '
      ' ADS_NAME_TYPE_ENTERPRISE_SIMPLE       '
      ' ADS_NAME_TYPE_GUID                    '
      ' ADS_NAME_TYPE_UNKNOWN                 '
      ' ADS_NAME_TYPE_USER_PRINCIPAL_NAME    '
      ' ADS_NAME_TYPE_CANONICAL_EX        '
      ' ADS_NAME_TYPE_SERVICE_PRINCIPAL_NAME'
      ' ADS_NAME_TYPE_SID_OR_SID_HISTORY_NAME')
  end
  object cbOut: TComboBox
    Left = 24
    Top = 171
    Width = 417
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 2
    Text = ' ADS_NAME_TYPE_1779                    '
    Items.Strings = (
      ' ADS_NAME_TYPE_1779                    '
      ' ADS_NAME_TYPE_CANONICAL             '
      ' ADS_NAME_TYPE_NT4                '
      ' ADS_NAME_TYPE_DISPLAY                 '
      ' ADS_NAME_TYPE_DOMAIN_SIMPLE           '
      ' ADS_NAME_TYPE_ENTERPRISE_SIMPLE       '
      ' ADS_NAME_TYPE_GUID                    '
      ' ADS_NAME_TYPE_UNKNOWN                 '
      ' ADS_NAME_TYPE_USER_PRINCIPAL_NAME    '
      ' ADS_NAME_TYPE_CANONICAL_EX        '
      ' ADS_NAME_TYPE_SERVICE_PRINCIPAL_NAME'
      ' ADS_NAME_TYPE_SID_OR_SID_HISTORY_NAME')
  end
  object Button1: TButton
    Left = 24
    Top = 353
    Width = 417
    Height = 25
    Caption = 'Translate'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 24
    Top = 243
    Width = 417
    Height = 89
    TabOrder = 4
  end
  object NTADS21: TNTADS2
    Logon.Logon = False
    Search.SearchSubs = False
    Lasterror = 0
    Provider = 'LDAP://'
    QuietEnum = False
    SecurityOnly = True
    Left = 216
    Top = 200
  end
end
