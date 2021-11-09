unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ShellAPI, jpeg;

type
  TAbout = class(TForm)
    BtnOK: TBitBtn;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    version: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image1: TImage;
    procedure BtnOKClick(Sender: TObject);
    procedure Label6MouseEnter(Sender: TObject);
    procedure Label6MouseLeave(Sender: TObject);
    procedure Label6Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  About: TAbout;

implementation

uses Iobroker;

{$R *.dfm}

procedure TAbout.BtnOKClick(Sender: TObject);
begin
  Close;
  ModalResult := mrOK;
end;

procedure TAbout.Label6MouseEnter(Sender: TObject);
begin
  Label6.Font.Color := clred;
end;

procedure TAbout.Label6MouseLeave(Sender: TObject);
begin
Label6.Font.Color := clBlue;
end;

procedure TAbout.Label6Click(Sender: TObject);
begin
ShellExecute(Application.Handle, nil, 'http://instalator.ru/', nil, nil,SW_SHOWNOACTIVATE);
end;



end.
