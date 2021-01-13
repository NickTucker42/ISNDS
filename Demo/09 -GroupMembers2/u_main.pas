unit u_main;

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.ComCtrls, Vcl.StdCtrls, NTADS2,
  System.Generics.Collections;

type
  TForm1 = class(TForm)
    lblGroupname          : TLabel;
    eGroupName            : TEdit;
    btnGo                 : TButton;
    lvUsers               : TListView;
    NTADS                 : TNTADS2;
    chkRecurse            : TCheckBox;
    chkPopinEvent         : TCheckBox;
    procedure btnGoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NTADSGroup2Start(sender: TObject);
    procedure NTADSGroup2Stop(sender: TObject);
    procedure NTADSGroup2Enum(sender: TObject; AObject: tObjData;
      Index: Integer; var Abort: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnGoClick(Sender: TObject);
var members : tObjectList<NTADS2.tObjData>;
    Member  : NTADS2.tObjData;
    item    : TListItem;
begin
 lvUsers.Items.Clear;

 eGroupName.Text := NTADS.Normalizename(eGroupName.Text);

 lvUsers.Items.Clear;

 members :=  NTADS.GroupMembers2(eGroupName.Text,42,chkRecurse.Checked);

 if not chkPopinEvent.Checked then
 Begin

   for member in members do
   begin
    item := lvUsers.Items.Add;
    item.Caption := Member.ADsPath;
    item.SubItems.Add(Member.Class_+' ('+ IntToStr(Member.ClassIndex)+')' );
    item.SubItems.Add( DateTimeToStr( Member.Created ));
    item.SubItems.Add( DateTimeToStr( Member.Modified ));
    item.SubItems.Add( Member.Parent );
    item.SubItems.Add( Member.Schema );
    item.SubItems.Add( Member.Data1);
    item.SubItems.Add( Member.GUID );

   end;
 End;

 members.Free;

 end;

procedure TForm1.FormShow(Sender: TObject);
begin
 eGroupName.Text := NTADS.Info.SDomain+'\Domain Admins';
end;

procedure TForm1.NTADSGroup2Enum(sender: TObject; AObject: tObjData;
  Index: Integer; var Abort: Boolean);
var item : TListItem;
begin
 //access to each object as it is found can be done here instead of waiting
 //for the complete function to finish.
 //set abort to true to cancel the operation

  if chkPopinEvent.Checked then
  Begin
    item := lvUsers.Items.Add;
    item.Caption := AObject.ADsPath;
    item.SubItems.Add(AObject.Class_+' ('+ IntToStr(AObject.ClassIndex)+')' );
    item.SubItems.Add( DateTimeToStr( AObject.Created ));
    item.SubItems.Add( DateTimeToStr( AObject.Modified ));
    item.SubItems.Add( AObject.Parent );
    item.SubItems.Add( AObject.Schema );
    item.SubItems.Add( AObject.Data1);
    item.SubItems.Add( AObject.GUID );
    Application.ProcessMessages;
  End;

end;

procedure TForm1.NTADSGroup2Start(sender: TObject);
begin
 Screen.Cursor := crHourGlass;
 btnGo.Enabled := false;
end;

procedure TForm1.NTADSGroup2Stop(sender: TObject);
begin
 Screen.Cursor := crdefault;
 btnGo.Enabled := true;
end;

end.
