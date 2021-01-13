unit u_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,NTADS2,ActiveDs_TLB2, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Label1          : TLabel;
    eGroupname      : TEdit;
    btnOpenGroup    : TButton;
    NTADS21         : TNTADS2;
    procedure btnOpenGroupClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnOpenGroupClick(Sender: TObject);
var Group : iADSGroup;
begin
 Group := NTADS21.OpenGroup('LDAP://'+eGroupname.Text);

 if Group <> Nil then
 Begin
   ShowMessage('That group was found!'+#10#13+#10#13+eGroupname.Text);
  //Do something here
 End
 else
 ShowMessage('That group could not be found!'+#10#13+#10#13+eGroupname.Text);


end;

end.
