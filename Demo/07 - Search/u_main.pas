unit u_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, NTADS2;

type
  TForm2 = class(TForm)
    Panel1         : TPanel;
    Label1         : TLabel;
    Edit1          : TEdit;
    Button1        : TButton;
    ListBox1       : TListBox;
    ComboBox1      : TComboBox;
    NTADS21        : TNTADS2;
    Button2        : TButton;
    Label2         : TLabel;
    CheckBox1      : TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure NTADS1Search(sender: TObject; Data, OBJClass: string;
      Count: Int64);
    procedure Button2Click(Sender: TObject);
    procedure NTADS21SearchStart(sender: TObject; Index: Integer);
    procedure NTADS21SearchStop(sender: TObject; Index: Integer);
    procedure NTADS21Search(sender: TObject; Data, OBJClass: string;
      Count: Int64; Index: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
   Ticks  : Int64;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var L : tstringlist;
begin
 if edit1.Text = '' then exit;

 listbox1.Items.Clear;

 try
  Listbox1.Items.BeginUpdate;

  Ticks := GettickCount;
//  L := ntads21.locateobjects (combobox1.Text, edit1.Text);

  listbox1.Items.AddStrings(  L  );
  Listbox1.Items.EndUpdate;

  if l.Count = 0 then
   listbox1.Items.Add( 'Search returned no results' );

  label2.Caption := 'Search time : '+inttostr(gettickcount-ticks)+'ms';
 finally
  l.Free;
 end;

end;

procedure TForm2.Button2Click(Sender: TObject);
begin
 Listbox1.Items.Clear;
 if edit1.Text = '' then exit;
 Ticks := GetTickCount;

 NTADS21.Search.ObjectCatagory := combobox1.Text;

 if checkbox1.Checked then
  NTADS21.Search.SearchPath     := 'GC://'+NTADS21.Info.Forest
 else
  NTADS21.Search.SearchPath     := 'LDAP://'+NTADS21.Info.Forest;

 NTADS21.Search.SearchSubs     := True;
 NTADS21.Search.SearchFilter   := 'CN='+Edit1.Text;

 //This index(42) wil be used in the 'OnSearch' event below...
 if not NTADS21.ExecuteSearch(42) then ShowMessage('Nothing to show . . .');
 label2.Caption := 'Search time : '+inttostr(gettickcount-ticks)+'ms';
end;

procedure TForm2.FormShow(Sender: TObject);
begin
// {$IF CompilerVersion >= 23}
// Showmessage('XE2 or higher');
// {$IFEND}
end;

procedure TForm2.NTADS1Search(sender: TObject; Data, OBJClass: string;
  Count: Int64);
begin
 listbox1.Items.Add(Data);
end;

procedure TForm2.NTADS21Search(sender: TObject; Data, OBJClass: string;
  Count: Int64; Index: Integer);
begin
 case Index of
  42 : Listbox1.Items.Add( Data );
 end;
end;

procedure TForm2.NTADS21SearchStart(sender: TObject; Index: Integer);
begin
 Screen.Cursor := crHourGlass
end;

procedure TForm2.NTADS21SearchStop(sender: TObject; Index: Integer);
begin
 Screen.Cursor := crDefault
end;

end.
