unit u_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NTADS2, Vcl.ExtCtrls, Vcl.StdCtrls,ActiveDs_TLB2,
  ActiveX, AxCtrls,Vcl.Imaging.jpeg;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    edtUser: TEdit;
    Image1: TImage;
    NTADS21: TNTADS2;
    btnGet: TButton;
    btnsetPicture: TButton;
    btnLoad: TButton;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnsetPictureClick(Sender: TObject);
  private
    procedure StreamToVariant(Stream: TMemoryStream; var v: OleVariant);
    procedure VariantToStream(const v: olevariant; Stream: TMemoryStream);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.VariantToStream (const v : olevariant;
                                   Stream : TMemoryStream);
 var
   p : pointer;
 begin
   Stream.Position := 0;
   Stream.Size := VarArrayHighBound (v, 1) - VarArrayLowBound(v,  1) + 1;
   p := VarArrayLock (v);
   Stream.Write (p^, Stream.Size);
   VarArrayUnlock (v);
   Stream.Position := 0;
 end;

 procedure TForm1.StreamToVariant (Stream : TMemoryStream; var v : OleVariant);
 var
   p : pointer;
 begin
   v := VarArrayCreate ([0, Stream.Size - 1], varByte);
   p := VarArrayLock (v);
   Stream.Position := 0;
   Stream.Read (p^, Stream.Size);
   VarArrayUnlock (v);
 end;

procedure TForm1.btnGetClick(Sender: TObject);
var Userobj : iadsuser;
    Stream  : TMemoryStream;
    graphic : TGraphic;
begin
 Userobj := NTADS21.OpenUser( edtUser.Text );
 if Userobj = nil then
  Begin
   ShowMessage('Could not open that user');
   Exit;
  End;

  Stream := TMemoryStream.Create;
  VariantToStream(Userobj.Picture,Stream);

  //assume a JPG other formats you will have to convert . . examine the first few bytes to determine type.
  //is it's already a bitmap then you can skip the "graphic" bit.
  graphic := TJPEGImage.Create;
  graphic.LoadFromStream(stream);

  Image1.Picture.Bitmap.Assign(graphic);
  Stream.Free;
  graphic.Free;

end;

procedure TForm1.btnLoadClick(Sender: TObject);
begin
 if OpenDialog1.Execute then
 Begin
  Image1.Picture.LoadFromFile(OpenDialog1.FileName);
 End;
end;

procedure TForm1.btnsetPictureClick(Sender: TObject);
var Userobj : iadsuser;
    Stream  : TMemoryStream;
    graphic : TGraphic;
    Olv     : OleVariant;
begin

 //I HAVE NOT TESTED THIS PROCEDURE!!
 //You might need to fiddle with it.
 //It compiles though :-)

 Userobj := NTADS21.OpenUser( edtUser.Text );
 if Userobj = nil then
  Begin
   ShowMessage('Could not open that user');
   Exit;
  End;

  Stream := TMemoryStream.Create;

  try
   Image1.Picture.Bitmap.SaveToStream(stream);
   StreamToVariant(Stream,Olv);
   Userobj.Picture := Olv;

   Userobj.SetInfo;  //not sure if this is needed but cannot hurt.
  except
   on e : Exception do
    ShowMessage(e.Message);
  end;

  Stream.Free;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 edtUser.Text := NTADS21.Info.Username;
end;

end.
