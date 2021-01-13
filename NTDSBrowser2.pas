unit NTDSBrowser2;

{
//==============================================================================
 [AUTHOR]
   Author name     = Nick Tucker
   Author e-mail   = Nick@Infinites.com
   Author web site = http://www.infinites.com

 [TNTBrowser]
   Version = V 1.5.0.0
   Copyright © 2004 - 2013 by Nick Tucker

This Source Code Form is subject to the terms of the Mozilla Public License,
v. 2.0. You can obtain one at http://mozilla.org/MPL/2.0/.

//==============================================================================
 [About]

NTADS was created so I could uses Delphi to interact with Active Directory.
This work was originally just meant for me and the code may be dirty here and
there but for the most part it does work.  I am sure there is great room for
improvement so if you have any fixes or additions please let me know instead
of keeping it to yourself :) I am more than happy to include additions into the
"official" version on my website and give you credit where credit it due.

If you do use NTADS in your applications I would certainly appreciate a mention
in your "About" dialog.

NTADS if free for use in commercial application as long as credit is given with
a link to my website.


The original component was developed with D6 and later used in D2005.  I did
update it when D2009 came out but I have not done anywork to change anything to
use some of the newer methods that D2009 or XE/2 has.

Nick Tucker
May 2012.

//==============================================================================
History:

 May 2012  V 1.5.0.0
   +  First release as "Open Source"

 March 2013 V3.0.0.0
   +  Complete rewrite.
   +  Renamed to NTADS2

//==============================================================================
}


interface

uses
{$IF CompilerVersion >= 23}    //XE2 and higher
  System.SysUtils, System.Classes,system.Variants,vcl.Controls,vcl.ComCtrls,
  Winapi.windows,
{$ELSE}
  SysUtils, Classes,Variants,Controls,ComCtrls,Windows,
{$IFEND}
  ntads2,ActiveDs_TLB2;


type tGetIndex = Procedure (sender : tObject ;ObjType:tObjtypes;Node:tTreenode;
                              Var ImageIndex:integer) of object;

type tWorkDone  = Procedure(sender : tObject) of object;
type tWorkStart = Procedure(sender : tObject) of object;

//When deleting a node be sure to delete the tTreeData object if it exists.
//Use the DeleteNode method where possible.
type tTreeData = class
      ADSPath     : String;
      ClassIndex  : Integer;
     end;

type tCurrentObject = class(TPersistent)
           Private
            FName    : String;
            FClass_  : String;
            FGUID    : String;
            FADsPath : String;
            FParent  : String;
            FSchema  : String;
            FIndex   : Integer;
           Published
            Property Name         : String  read Fname     write Fname;
            Property Class_       : String  read FClass_   write FClass_;
            Property GUID         : String  read FGUID     write FGUID;
            Property ADSPath      : String  read FADSPath  write FADSPath;
            Property Parent       : String  read FParent   write FParent;
            Property Schema       : String  read FSchema   write FSchema;
            Property ClassIndex   : Integer read FIndex    write FIndex;
     end;

type
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  TNTDSBrowser2 = class(TTreeView)
  private
    { Private declarations }
   _NTADS2                 : tNTADS2;
   _ListView               : tlistview;
   GetIndex                : tGetIndex;
   WorkDone                : tWorkDone;
   WorkStart               : tWorkStart;
   FCurrentObject          : tCurrentObject;
  protected
    { Protected declarations }
  public
    { Public declarations }
    Busy : Boolean;
    Constructor Create(aowner : tComponent) ; Override;
    Destructor  Destroy; Override;
    Procedure   adddomains(Path : string);
    Procedure   NodeExpanding(Sender: TObject; Node: TTreeNode;var AllowExpansion: Boolean);
    procedure   NodeCollapsed(Sender: TObject; Node: TTreeNode);
    Procedure   addobjects2(Node:ttreenode;Cont:boolean);
    Function    GetRoute(Node:tTreeNode):String;
    Procedure   Change(Node:tTreenode); Override;
    Procedure   Refresh(Expand:boolean);
    Procedure   DeleteNode(Node:tTreenode);
  published
    Property NTADS2            : tNTADS2        Read _NTADS2        Write _NTADS2;
    Property ListView          : tlistview      Read _ListView      Write _ListView;
    Property OnGetIndex        : tGetIndex      read GetIndex       write Getindex;
    Property OnWorkDone        : tWorkDone      read workdone       write Workdone;
    Property OnWorkStart       : tWorkStart     read workstart      write Workstart;
    Property CurrentObject     : tCurrentObject Read FCurrentObject write FCurrentObject;
    { Published declarations }
    property Align;
    property Anchors;
    property AutoExpand;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property ChangeDelay;
    property Color;
    property Ctl3D;
    property Constraints;
    property DragKind;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property HotTrack;
    property Images;
    property Indent;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property RightClickSelect;
    property RowSelect;
    property ShowButtons;
    property ShowHint;
    property ShowLines;
    property ShowRoot;
    property SortType;
    property StateImages;
    property TabOrder;
    property TabStop default True;
    property ToolTips;
    property Visible;
    property OnAdvancedCustomDraw;
    property OnAdvancedCustomDrawItem;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnCollapsed;
    property OnCollapsing;
    property OnCompare;
    property OnContextPopup;
    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnDblClick;
    property OnDeletion;
    property OnDragDrop;
    property OnDragOver;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpanding;
    property OnExpanded;
    property OnGetImageIndex;
    property OnGetSelectedIndex;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    { Items must be published after OnGetImageIndex and OnGetSelectedIndex }
    property Items;

  end;



implementation



Constructor TNTDSBrowser2.Create(aowner : tComponent) ;
Begin
 Inherited Create(aOwner);
 OnExpanding := NodeExpanding;
 OnCollapsed := NodeCollapsed;
 Busy        := false;
 FCurrentObject := TCurrentObject.Create;
 FCurrentObject.FName  := 'No one home';
 FCurrentObject.FIndex := -1;
end;

procedure TNTDSBrowser2.DeleteNode(Node: tTreenode);
begin
 if node.Data <> nil then
  tTreeData(node).Free;
 Node.Free;
end;

Destructor TNTDSBrowser2.Destroy;
var i : Integer;
Begin

 for I := 0 to self.Items.Count -1 do
  if self.Items[i].Data <> nil then
   tTreeData(self.Items[i].Data).Free;

 FCurrentObject.Free;
 Inherited Destroy;
end;

Procedure TNTDSBrowser2.adddomains(Path : string);
var list   : tstringlist;
    cnt    : integer;
    tn,rn  : ttreenode;
    iindex : integer;
    Data   : tTreeData;
Begin
 list := tstringlist.create;
 list.assign(ntads2.getdomains(path,false));

 if list.count > 0 then
  for cnt := 0 to list.count-1 do
  Begin
   if cnt = 0 then
    Begin
     Data := tTreeData.Create;
     Data.ADSPath    := list[cnt];
     Data.ClassIndex := 27;
     iindex          := 27;
     rn := items.addObject(nil,List[cnt],Data);
     if assigned(getindex) then GetIndex(Self,objContainer,tn,iindex);
     rn.imageindex  := iindex;
     rn.SelectedIndex := iindex;
     rn.haschildren := true;
    end
    else
    Begin
     Data := tTreeData.Create;
     Data.ADSPath    := list[cnt];
     Data.ClassIndex := 27;
     iindex          := 27;
     tn  := items.addchildObject(rn,copy(list[cnt],1,pos(',',list[cnt])-1),Data);
     if assigned(getindex) then GetIndex(Self,objContainer,tn,iindex);
     tn.imageindex  := iindex;
     tn.SelectedIndex := iindex;
     tn.haschildren := true;
    end;
  end;

  //add any root level objects
  AddObjects2(rn,True);

end;

Function TNTDSBrowser2.GetRoute(Node:tTreeNode):String;
var ts : string;
Begin
 result := '';
 ts := '';
 while node <> nil do
 Begin
  ts := ts+','+Node.text;
  node := node.parent;
 end;
 if ts <> '' then if ts[1] = ',' then system.delete(ts,1,1);
 result := ts;
end;

procedure TNTDSBrowser2.NodeExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
Begin
 if (node.Count = 0)  then
   AddObjects2(node,True);
  Inherited;
end;

Procedure  TNTDSBrowser2.addobjects2(Node:ttreenode;Cont:boolean);
var tn       : ttreenode;
    l        : tstringlist;
    i        : integer;
    i2       : Integer;
    iindex   : integer;
    li       : tlistitem;
    OU       : IADsContainer;
    Data     : tTreeData;
    ADSPath  : String;
    NodeName : string;
    ts       : string;

    Procedure addobjecttolist(objclass :  tObjTypes; objname: string);
    begin

     if _listview <> nil then
     Begin
      system.delete(objname,1,3);  //Remove CN=
      li := _listview.items.add;
      li.caption := objname;
      if assigned(getindex) then GetIndex(Self,objclass,nil,iindex);
      li.imageindex := iindex;
     End
     else
      begin
       Data := tTreeData.Create;
       Data.ADSPath    := objname+','+ADSPath;
       Data.ClassIndex := ord(objClass);

       system.delete(objname,1,3);
       tn := items.addchildObject(node,objname,data);
       tn.haschildren := False;
       iindex := Data.ClassIndex;
       if assigned(getindex) then GetIndex(Self,objclass,tn,iindex);
       tn.imageindex  := iindex;
       tn.SelectedIndex := iindex;
      end;
    end;

begin
 tn := node;
 if tn = nil then exit;
 iindex := -1;

 if assigned(WorkStart) then WorkStart(self);

 if _listview <> nil then
 Begin
  _listview.Items.BeginUpdate;
  _Listview.Items.Clear;
 end;

 Data    := Node.Data;
 ADSPath := Data.ADSPath;


 OU := NTADS2.OpenContainer('LDAP://'+ADSPath);

 if OU = nil then exit;

 l := tstringlist.Create;
 NTADS2.EnumerateContainer(OU,maxint,L);

 for I := 0 to l.Count - 1 do
 Begin
  ts := l[i];
  system.delete(ts,1,7);
  ts := copy(ts,1,pos(',',ts)-1);
//    case ntads2.getclassindex(tobjdata(l.objects[i]).Class_) of
//      i2 := strtointdef(copy(l[i],pos(':',l[i])+1,maxint),-1);
     i2 := ord(ntads2.GetClassIndex(NTADS2.GetClass(l[i] ) ) );
     case i2 of
      ord(objinfrastructureUpdate),
      ord(objLostandFound),
      ord(objmsExchSystemObjectsContainer),
      ord(objBuiltinDomain),
      ord(objOrganizationalUnit),
      ord(objContainer)             :
        if Cont then
        Begin
         Data := tTreeData.Create;
         Data.ADSPath    := ts+','+ADSPath; //   copy(l[i],1,pos(':',l[i])-1)+','+ADSPath;
         Data.ClassIndex := i2;

         NodeName := ts;//  copy(l[i],1,pos(':',l[i])-1);
         System.Delete(NodeName,1,3);

         tn := items.addchildObject(node,NodeName,Data);
         iindex := Data.ClassIndex;
         tn.haschildren := true;
         if assigned(getindex) then
                                GetIndex(Self,objOrganizationalUnit,tn,iindex);
         tn.imageindex  := iindex;
         tn.SelectedIndex := iindex;

        End;
        else
//        if not cont then
//          addobjecttolist( tOBJTypes(i2) , copy(l[i],1,pos(':',l[i])-1));
          addobjecttolist( tOBJTypes(i2) , ts);
     end;

 End;

 if _listview <> nil then _listview.Items.EndUpdate;
 ClearEnumList(l);
 l.Free;
  if assigned(WorkDone) then WorkDone(self);
end;

procedure TNTDSBrowser2.NodeCollapsed(Sender: TObject; Node: TTreeNode);
begin
 Inherited;
end;

Procedure TNTDSBrowser2.Change(Node:tTreenode);
var ADS     : iADS;
    Data    : tTreeData;
Begin
 FCurrentObject.FADSPath     := '';
 FCurrentObject.FIndex       := -1;
 FCurrentObject.FClass_      := '';
 FCurrentObject.FParent      := '';
 FCurrentObject.FGUID        := '';
 FCurrentObject.FName        := '';

 Data := Node.Data;
 if Data <> nil then
  begin
  ADS := _NTADS2.OpenIADS('LDAP://'+Data.ADSPath);
  if ADS <> nil then
  Begin
   FCurrentObject.FADSPath     := ADS.ADsPath;
   FCurrentObject.FClass_      := ADS.Class_;
   FCurrentObject.FIndex       := ord(_NTADS2.GetClassIndex(ADS.Class_));
   FCurrentObject.FParent      := ADS.Parent;
   FCurrentObject.FGUID        := ADS.GUID;
   FCurrentObject.FName        := ADS.Name;
  End;
 end;

 if (node.Count = 0)  then
  addobjects2(node,false);
 Inherited;
end;

Procedure TNTDSBrowser2.Refresh(Expand:boolean);
var tn : tTreeNode;
Begin

 tn := self.Selected.getFirstChild;
 while tn <> nil do
 Begin
  if tn.Data <> nil then tTreeData(tn.Data).Free;
  tn := self.Selected.GetNextChild(tn);
 End;

 self.Items.BeginUpdate;
 Self.Selected.DeleteChildren;
 self.Items.EndUpdate;

 addobjects2(self.Selected,false);
 if Expand then self.Selected.Expand(false);

End;

end.
