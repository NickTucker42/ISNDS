unit u_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NTADS2;

type
  TForm1 = class(TForm)
    lblUsername         : TLabel;
    edtUserName         : TEdit;
    lblGroup            : TLabel;
    edtGroupName        : TEdit;
    ntads1              : TNTADS2;
    btnTest             : TButton;
    lstUsers: TListBox;
    procedure FormShow(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure ntads1Group2Enum(sender: TObject; AObject: tObjData;
      Index: Integer; var Abort: Boolean);
    procedure ntads1Group2Start(sender: TObject);
    procedure ntads1Group2Stop(sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnTestClick(Sender: TObject);
begin
 lstUsers.Items.Clear;

 if ntads1.IsMemberOfNested( edtGroupName.Text, edtUserName.Text  ) then
 Begin
  ShowMessage('YES!');
  ntads1.GroupMembers2(edtGroupName.Text,1,true);
 End
 else
  ShowMessage('So sorry');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 edtUserName.Text   := ntads1.Info.Username;
 edtGroupName.Text  := ntads1.Info.SDomain+'\Domain Admins';
 edtGroupName.Text  := ntads1.Normalizename(edtGroupName.Text);
end;

procedure TForm1.ntads1Group2Enum(sender: TObject; AObject: tObjData;
  Index: Integer; var Abort: Boolean);
begin
 lstUsers.Items.Add( AObject.ADsPath+'           found in '+Aobject.Data1 );
end;

procedure TForm1.ntads1Group2Start(sender: TObject);
begin
 Cursor := crHourGlass;
end;

procedure TForm1.ntads1Group2Stop(sender: TObject);
begin
 Cursor := crDefault;
end;

end.
