unit u_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NTADS2,ActiveDs_TLB2,Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Label1         : TLabel;
    eUsername      : TEdit;
    btnOpenuser    : TButton;
    NTADS21        : TNTADS2;
    procedure btnOpenuserClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnOpenuserClick(Sender: TObject);
var User : iADSUser;
begin
 User := NTADS21.OpenUser('LDAP://'+eUsername.Text);

 if user <> Nil then
 Begin
   ShowMessage('That user was found!'+#10#13+#10#13+eUsername.Text);
  //Do something here
 End
 else
 ShowMessage('That user could not be found!'+#10#13+#10#13+eUsername.Text);

end;

end.
