program GetAdmin;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms, Windows, Dialogs,
  Iobroker in 'Iobroker.pas' {Form1} ,
  Unit2 in 'Unit2.pas' {About};

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
  Application.Run;

end.
