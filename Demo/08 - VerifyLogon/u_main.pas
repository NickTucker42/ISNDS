unit u_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NTADS2,ActiveDs_TLB2;

type
  TForm1 = class(TForm)
    Label1           : TLabel;
    eUsername        : TEdit;
    Label2           : TLabel;
    ePassword        : TEdit;
    Button1          : TButton;
    NTADS21          : TNTADS2;
    Memo1            : TMemo;
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
var  User : string;
     l    : tStringlist;
     uobj : iADSUser;
begin
 memo1.Lines.Clear;


 //Uername can be netered 2 ways...
 //1 . DOMAIN\Username
 //2 . Username.
 //Just entering the username will need a search in AD to find it, otherwise
 //we will just try and bind to the user object

 //Quick and dirty looking for '\' in the name
 if pos('\',eusername.Text) = 0 then
 Begin
  //first locate the user in AD.
  Memo1.Lines.Add('Searching for '+eusername.Text);
  l  := NTADS21.locateobjects('user',eUserName.Text,true);

  if l.Count > 0 then
   Memo1.Lines.Add('Found : '+l.Text)
  else
  Begin
   Memo1.Lines.Add('Opps, user not located');
   l.Free;
   exit;
  End;

 //really should check for multiples, I'm assuming only 1 returned.
  user := l[0];
  l.Free;
 End;

 //Now try and bind to the user object with the password supplied.
 //MS likes to see the username in the format Domain\User
 if pos('\',eUsername.Text) > 0 then
 Begin
   NTADS21.Logon.Username := eUsername.Text;
   //Need to convert the "Netbios" name to "LADP"
   user := ntads21.NameTranslate(eUsername.Text,ADS_NAME_TYPE_NT4,ADS_NAME_TYPE_1779)
 End
 else
 NTADS21.Logon.Username :=   //Need to convert the "LDAP" name to "NETBIOS"
               NTADS21.NameTranslate(User,ADS_NAME_TYPE_1779,ADS_NAME_TYPE_NT4);


 NTADS21.Logon.Password := ePassword.Text;
 NTADS21.Logon.Logon    := true;

 Uobj := NTADS21.OpenUser('LDAP://'+User);

 if Uobj <> nil then
  Memo1.Lines.Add('Bind to the user object successful')
 else
 Begin
  memo1.Lines.Add(ntads21.lasterrorS);
  Memo1.Lines.Add('Could not bind to the user.  Check password');
  exit;
 End;

 //Now get the users group memberships
 Memo1.Lines.Add(uobj.FullName);
 l := ntads21.EnumUser(UObj);
 memo1.Lines.Addstrings(l);
 l.Free;

end;

end.
