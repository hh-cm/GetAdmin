program GetAdmin;

uses
  Forms, Windows, Dialogs,
  Iobroker in 'Iobroker.pas' {Form1} ,
  AboutForm in 'AboutForm.pas' {frmAbout};

{$R *.res}


begin
  H := CreateMutex(nil, True, 'i3n5s7t99a8l4a56t6o533r');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    showmessage('Dieses Programm läuft bereits');
    Exit;
  end;

  Application.Initialize;
  Application.CreateForm(TServer, Server);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;

end.
