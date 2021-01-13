object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 300
  ClientWidth = 984
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    984
    300)
  PixelsPerInch = 96
  TextHeight = 13
  object lblGroupname: TLabel
    Left = 24
    Top = 8
    Width = 58
    Height = 13
    Caption = 'Group name'
  end
  object eGroupName: TEdit
    Left = 24
    Top = 27
    Width = 481
    Height = 21
    TabOrder = 0
  end
  object btnGo: TButton
    Left = 520
    Top = 27
    Width = 75
    Height = 25
    Caption = 'Go'
    Default = True
    TabOrder = 1
    OnClick = btnGoClick
  end
  object lvUsers: TListView
    Left = 24
    Top = 80
    Width = 929
    Height = 201
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Path'
        Width = 300
      end
      item
        Caption = 'Object type'
        Width = 100
      end
      item
        Caption = 'Created'
        Width = 150
      end
      item
        Caption = 'Modified'
        Width = 150
      end
      item
        Caption = 'Parent'
        Width = 100
      end
      item
        Caption = 'Schema'
        Width = 150
      end
      item
        Caption = 'Nested group'
        Width = 150
      end
      item
        Caption = 'GUID'
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 3
    ViewStyle = vsReport
  end
  object chkRecurse: TCheckBox
    Left = 48
    Top = 54
    Width = 97
    Height = 17
    Caption = 'Recurse'
    TabOrder = 2
  end
  object chkPopinEvent: TCheckBox
    Left = 192
    Top = 56
    Width = 169
    Height = 17
    Caption = 'Populate in the event'
    TabOrder = 4
  end
  object NTADS: TNTADS2
    Logon.Logon = False
    Search.SearchSubs = False
    Lasterror = 0
    Provider = 'LDAP://'
    QuietEnum = False
    OnGroup2Start = NTADSGroup2Start
    OnGroup2Stop = NTADSGroup2Stop
    OnGroup2Enum = NTADSGroup2Enum
    Left = 408
    Top = 128
  end
end
