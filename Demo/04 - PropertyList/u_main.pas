unit u_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NTADS2,ActiveDs_TLB2,Vcl.StdCtrls,
  Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Label1         : TLabel;
    eObjectName    : TEdit;
    btnGoforit: TButton;
    NTADS21        : TNTADS2;
    ListView1: TListView;
    procedure btnGoforitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


//CN=njgroup_1,OU=users,ou=new jersey,DC=iss,DC=NET
procedure TForm1.btnGoforitClick(Sender: TObject);
var l  : tstringlist;
    li : tListitem;
  I: Integer;
begin
 Listview1.Items.Clear;

 l := NTADS21.GetPropertyList(eObjectName.Text,true);

 if l.Count > 0 then
 Begin
  for I := 0 to l.Count-1 do
  Begin
   li := listview1.Items.Add;
   li.Caption := l[i];
   li.GroupID := 0;
  End;
 End;

 l.Free;

 l := NTADS21.GetPropertyList(eObjectName.Text,false);

 if l.Count > 0 then
 Begin
  for I := 0 to l.Count-1 do
  Begin
   li := listview1.Items.Add;
   li.Caption := l[i];
   li.GroupID := 1;
  End;
 End;

 l.Free;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
 eObjectName.Text := NTADS21.Info.Username;
end;

end.
