unit AboutForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ShellAPI, jpeg;

type
  TfrmAbout = class(TForm)
    BtnOK: TBitBtn;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    version: TLabel;
    Label5: TLabel;
    Image1: TImage;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

uses Iobroker;

{$R *.dfm}

end.
