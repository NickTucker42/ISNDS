unit u_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NTADS2;

type
  TForm1 = class(TForm)
    NTADS21: TNTADS2;
    Label1: TLabel;
    edt1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin

 Memo1.Lines.Add(edt1.Text+' is talking to '+ NTADS21.GetSucureChannel(edt1.Text) );

end;

end.
