unit u_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NTADS2,ActiveDs_TLB2,Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Label1         : TLabel;
    eGroupname     : TEdit;
    btnOpenuser    : TButton;
    NTADS21        : TNTADS2;
    Label2         : TLabel;
    eComment       : TEdit;
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
var Group : iadsGroup;
begin
 Group := NTADS21.OpenGroup('LDAP://'+eGroupname.Text);

 if Group <> Nil then
 Begin
  if eComment.Text = '' then
  Group.PutEx(ADS_Property_Clear,'Description','')
  else
  Group.Description := eComment.Text;

  Group.SetInfo;
 End
 else
 ShowMessage('That group could not be found!'+#10#13+#10#13+eGroupname.Text);

end;

end.
