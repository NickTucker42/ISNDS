unit u_main;

{

Just a very simple example of an AD browser....



}

interface

uses
  {$IF CompilerVersion >= 23}    //XE2 and higher
  Vcl.StdCtrls,winapi.windows,
  {$ELSE}
  StdCtrls,Windows,
  {$IFEND}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls,   ImgList,
  ToolWin, NTDSBrowser2, NTADS2,ActiveDs_TLB2, System.ImageList;

type
  TForm2 = class(TForm)
    StatusBar1         : TStatusBar;
    Splitter1          : TSplitter;
    ImageList1         : TImageList;
    ToolBar1           : TToolBar;
    tbUsers            : TToolButton;
    tbGroup            : TToolButton;
    tbComp             : TToolButton;
    ToolButton4        : TToolButton;
    tbOther            : TToolButton;
    ToolButton1        : TToolButton;
    ListView1          : TListView;
    NTADS21            : TNTADS2;
    NTDSBrowser21      : TNTDSBrowser2;
    Memo1              : TMemo;
    ToolButton2: TToolButton;
    CheckBox1: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure NTDSBrowser1GetIndex(sender: TObject; ObjType: tObjTypes;
      Node: TTreeNode; var ImageIndex: Integer);
    procedure NTDSListView1Click(Sender: TObject);
    procedure NTDSBrowser1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure NTDSBrowser1WorkDone(sender: TObject);
    procedure NTADS21EnumStart(sender: TObject; Index: Integer);
    procedure NTADS21EnumStop(sender: TObject; Index: Integer);
    procedure NTADS21Enum(sender: TObject; OBJ: rObjData; Count: Int64;
      Index: Integer; var Abort, Keep: Boolean);
    procedure NTDSBrowser21Change(Sender: TObject; Node: TTreeNode);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.CheckBox1Click(Sender: TObject);
begin
 if Checkbox1.Checked then
  NTDSBrowser21.ListView := nil
 else
  NTDSBrowser21.ListView := Listview1;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
 tbUsers.Down := true;
 tbGroup.Down := true;
 tbComp.Down  := true;
 tbOther.Down := true;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
 NTDSBrowser21.adddomains(ntads21.Info.Forest);
 if NTDSBrowser21.Items.Count > 0 then NTDSBrowser21.Items[0].Expand(false);
end;

procedure TForm2.NTADS21Enum(sender: TObject; OBJ: rObjData; Count: Int64;
  Index: Integer; var Abort, Keep: Boolean);
begin

 Keep := false;
 case obj.ClassIndex of
  ord(objUser)      : if tbUsers.Down  then Keep := true;
  ord(objGroup)     : if tbGroup.Down  then Keep := true;
  ord(objComputer)  : if tbComp.Down   then Keep := true;
  else                if tbOther.Down  then Keep := true;
 end;

 statusbar1.Panels[1].Text := inttostr(count);

 if count mod 100 = 0 then
  application.ProcessMessages;
end;

procedure TForm2.NTADS21EnumStart(sender: TObject; Index: Integer);
begin
 Screen.Cursor := crhourglass;
end;

procedure TForm2.NTADS21EnumStop(sender: TObject; Index: Integer);
begin
 Screen.Cursor := crDefault;
end;

procedure TForm2.NTDSBrowser1Click(Sender: TObject);
begin
 statusbar1.Panels[0].Text := NTDSBrowser21.GetRoute( NTDSBrowser21.Selected );
end;

procedure TForm2.NTDSBrowser1GetIndex(sender: TObject; ObjType: tObjTypes;
  Node: TTreeNode; var ImageIndex: Integer);
begin

 case (ObjType) of
  objContainer          : ImageIndex := 0 ;
  objOrganizationalUnit : ImageIndex := 1 ;
  objUser               : ImageIndex := 2 ;
  objGroup              : ImageIndex := 3 ;
  objComputer           : ImageIndex := 4 ;
  else                    ImageIndex := 5 ;
 end;

end;

procedure TForm2.NTDSBrowser1WorkDone(sender: TObject);
begin
 statusbar1.Panels[1].Text := inttostr(ListView1.Items.Count);
end;

procedure TForm2.NTDSBrowser21Change(Sender: TObject; Node: TTreeNode);
begin
 memo1.Lines.Clear;
 memo1.Lines.Add('Name'+chr(9)+ NTDSBrowser21.CurrentObject.Name);
 memo1.Lines.Add('Path'+chr(9)+ NTDSBrowser21.CurrentObject.ADSPath);
 memo1.Lines.Add('Class'+chr(9)+ NTDSBrowser21.CurrentObject.Class_);
 memo1.Lines.Add('GUID'+chr(9)+ NTDSBrowser21.CurrentObject.GUID);
 memo1.Lines.Add('Parent'+chr(9)+ NTDSBrowser21.CurrentObject.Parent);
end;

procedure TForm2.NTDSListView1Click(Sender: TObject);
var ts      : string;
    ADsObj  : IAds;
begin
 if ListView1.Selected = nil then exit;

 ts :=  NTDSBrowser21.GetRoute( NTDSBrowser21.Selected );
 ts :=  ListView1.Selected.Caption+','+ ts ;
 statusbar1.Panels[0].Text := ts;

 //Get some info on what was clicked...
 ADsObj := NTADS21.OpenIADS('LDAP://'+ts);

 if ADSObj <> nil then
  statusbar1.Panels[1].Text := 'ADS Class = '+AdsObj.Class_+' created '+
       datetimetostr(NTADS21.GetPropertyValue(adsobj,'whenCreated')) +' changed '+
       datetimetostr(NTADS21.GetPropertyValue(adsobj,'whenChanged'));

 ADsObj := nil;
end;

procedure TForm2.ToolButton1Click(Sender: TObject);
begin
 NTDSBrowser21.Refresh(true);
end;

end.
