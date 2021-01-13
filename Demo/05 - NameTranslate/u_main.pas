unit u_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,ActiveDs_TLB2, NTADS2;

Const
  NetBios = 3;
  LDAP    = 1;
  Can     = 2;
  GUID    = 7;
  UPN     = 9;
  Display = 4;

type
  TForm2 = class(TForm)
    Label1     : TLabel;
    eInName    : TEdit;
    Label2     : TLabel;
    cbIn       : TComboBox;
    Label4     : TLabel;
    cbOut      : TComboBox;
    Label3     : TLabel;
    Button1    : TButton;
    Memo1      : TMemo;
    NTADS21    : TNTADS2;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var iin, oout  : integer;
begin
 if eInName.Text = '' then
 Begin
  if messageDlg('Return everyone?',mtconfirmation,[mbyes,mbno],0) = mrNo then
   showmessage('Wise choice')
   else
   Showmessage('ha, yea right - Don''t think so!');
  exit;
 End;

{
NetBios            (Domain\User)
LDAP               (cn=username,dc=mydomain,dc=net)
Canonical          (mydomain.com/Username)
Display name       (Jim Bob)
UPN                (username@mydomain.com)
GUID               (You figure it out)
}
 case cbin.ItemIndex of
  0 : iin := NetBios;
  1 : iin := LDAP;
  2 : iin := Can;
  3 : iin := Display;
  4 : iin := UPN;
  5 : iin := GUID;
 end;

 case cbOut.ItemIndex of
  0 : oout := NetBios;
  1 : oout := LDAP;
  2 : oout := Can;
  3 : oout := Display;
  4 : oout := UPN;
  5 : oout := GUID;
 end;

 memo1.Lines.Clear;

 try
  memo1.Lines.Add (ntads21.NameTranslate(eInName.Text,cbin.ItemIndex+1,cbOut.ItemIndex+1) );
 except
  on e : exception do
   memo1.Lines.Add(e.Message);
 end;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
 eInName.Text := ntads21.Info.Username;
end;

end.
