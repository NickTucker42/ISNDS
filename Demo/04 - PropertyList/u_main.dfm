object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 332
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    500
    332)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 61
    Height = 13
    Caption = 'Object name'
  end
  object eObjectName: TEdit
    Left = 104
    Top = 21
    Width = 355
    Height = 21
    TabOrder = 0
    Text = 'CN=AGroupr,OU=SomeOU,DC=SomeDomain,DC=NET'
  end
  object btnGoforit: TButton
    Left = 104
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Get'
    TabOrder = 1
    OnClick = btnGoforitClick
  end
  object ListView1: TListView
    Left = 8
    Top = 79
    Width = 481
    Height = 242
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        AutoSize = True
        Caption = 'Property'
      end>
    Groups = <
      item
        Header = 'Mandatory'
        GroupID = 0
        State = [lgsNormal, lgsCollapsible]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end
      item
        Header = 'Optional'
        GroupID = 1
        State = [lgsNormal, lgsCollapsible]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end>
    GroupView = True
    TabOrder = 2
    ViewStyle = vsReport
  end
  object NTADS21: TNTADS2
    Logon.Logon = False
    Search.SearchSubs = False
    Lasterror = 0
    Provider = 'LDAP://'
    QuietEnum = False
    SecurityOnly = True
    Left = 208
    Top = 176
  end
end
