object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Search form'
  ClientHeight = 440
  ClientWidth = 622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 622
    Height = 65
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 11
      Width = 114
      Height = 13
      Caption = 'Search for (*=wildcard)'
    end
    object Label2: TLabel
      Left = 16
      Top = 40
      Width = 72
      Height = 13
      Caption = 'Search time : 0'
    end
    object Edit1: TEdit
      Left = 144
      Top = 8
      Width = 201
      Height = 21
      TabOrder = 0
    end
    object Button1: TButton
      Left = 528
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Search 1'
      Default = True
      TabOrder = 1
      OnClick = Button1Click
    end
    object ComboBox1: TComboBox
      Left = 368
      Top = 8
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = 'user'
      Items.Strings = (
        'user'
        'group'
        'computer')
    end
    object Button2: TButton
      Left = 528
      Top = 37
      Width = 75
      Height = 25
      Caption = 'Search 2'
      TabOrder = 3
      OnClick = Button2Click
    end
    object CheckBox1: TCheckBox
      Left = 440
      Top = 42
      Width = 82
      Height = 17
      Caption = 'Use a GC'
      TabOrder = 4
    end
  end
  object ListBox1: TListBox
    Left = 0
    Top = 65
    Width = 622
    Height = 375
    Align = alClient
    ItemHeight = 13
    TabOrder = 1
  end
  object NTADS21: TNTADS2
    Logon.Logon = False
    Search.SearchSubs = False
    Lasterror = 0
    Provider = 'LDAP://'
    QuietEnum = False
    OnSearch = NTADS21Search
    OnSearchStart = NTADS21SearchStart
    OnSearchStop = NTADS21SearchStop
    Left = 352
    Top = 184
  end
end
