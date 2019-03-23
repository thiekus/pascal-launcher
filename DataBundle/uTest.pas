unit uTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, BundleStruct, BundleProcs;

type
  TfrmMain = class(TForm)
    pgMain: TPageControl;
    tbBun: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    edtOutp: TEdit;
    Button1: TButton;
    Label2: TLabel;
    lstBun: TListBox;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    bunSv: TSaveDialog;
    blbOp: TOpenDialog;
    Label3: TLabel;
    edtInp: TEdit;
    Button5: TButton;
    Label4: TLabel;
    lsBuni: TListBox;
    bunOp: TOpenDialog;
    prbBund: TProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }

    BunRead: PBundleDefinition;

  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure BunMakeCallback(CallerSrc: PBundleSource; count: LongInt); stdcall;
begin

  frmMain.prbBund.Position:= frmMain.prbBund.Position + 1;
  frmMain.prbBund.Update;
  Application.ProcessMessages;
  AssignWriteBundle(CallerSrc, PAnsiChar(frmMain.lstBun.Items[count-1]), nil);

end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  bunSv.FileName:= edtOutp.Text;
  if bunSv.Execute then
    edtOutp.Text:= bunSv.FileName;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  if blbOp.Execute then
    lstBun.Items.AddStrings(blbOp.Files);
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
  lstBun.Items.Clear;
end;

procedure TfrmMain.Button4Click(Sender: TObject);
var
  ph: WideString;
begin

  prbBund.Max:= lstBun.Items.Count;
  ph:= AnsiToUTF8(edtOutp.Text);
  CreateBundleFile(PWideChar(ph), lstBun.Items.Count, @BunMakeCallback);
  prbBund.Position:= 0;
  Beep;

end;

procedure TfrmMain.Button5Click(Sender: TObject);
var
  ph: WideString;
  ps: integer;
begin

  bunOp.FileName:= edtInp.Text;
  if bunOp.Execute then
    begin
    edtInp.Text:= bunOp.FileName;
    ph:= AnsiToUTF8(bunOp.FileName);
    BunRead:= AssignReadBundle(PWideChar(ph));
    lsBuni.Items.Clear;
    for ps:= 0 to BunRead^.FileOnBundle-1 do
      begin
      lsBuni.Items.Add('Name: '+GetFileStruct(BunRead, ps)^.BundleName);
      lsBuni.Items.Add('Size: '+IntToStr(GetFileStruct(BunRead, ps)^.BundleSize));
      lsBuni.Items.Add('Offset: '+IntToHex(GetFileStruct(BunRead, ps)^.BundlePos, 16));
      lsBuni.Items.Add('CRC32: '+IntToHex(GetFileStruct(BunRead, ps)^.BundleCRC32, 8));
      if VerifyBundleFileChecksum(BunRead, ps) then
        lsBuni.Items.Add('File verification OK!')
      else
        lsBuni.Items.Add('File verification error!');
      lsBuni.Items.Add('');
    end;
    CloseBundle(BunRead);
    Freebundle(BunRead);
  end;

end;

end.
