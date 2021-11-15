{ TODO : Refactor }
unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellApi, IdBaseComponent, IdComponent,
  IdCustomHTTPServer, IdHTTPServer, INIfiles, ComCtrls, Buttons,
  Menus, Registry, tlhelp32, IdTCPConnection, IdTCPClient,
  IdHTTP, ExtCtrls, IdContext, IdCustomTCPServer, Vcl.AppEvnts;

type
  TfrmMain = class(TForm)
    IdHTTPServer1: TIdHTTPServer;
    btnSave: TButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    IdHTTP1: TIdHTTP;
    btnClose: TBitBtn;
    OpenDialog1: TOpenDialog;
    gbServer: TGroupBox;
    MainServer: TEdit;
    lblServerIP: TLabel;
    lblServerPort: TLabel;
    MainServerPort: TEdit;
    gbSimpleApi: TGroupBox;
    lblSimpleApiIP: TLabel;
    SimpleAPI_IP: TEdit;
    SimpleAPI_Port: TEdit;
    lblSimpleApiPort: TLabel;
    gbOptions: TGroupBox;
    StartUp: TCheckBox;
    ToTray: TCheckBox;
    gbCommandList: TGroupBox;
    lblPath: TLabel;
    lblCommand: TLabel;
    lblParameters: TLabel;
    lblShowCommand: TLabel;
    ScrollBox1: TScrollBox;
    lblAbout: TLabel;
    StatusBar: TStatusBar;
    lblNumberOfLines: TLabel;
    Count1: TEdit;
    Language: TComboBox;
    TrayIcon: TTrayIcon;
    procedure FormCreate(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure btnSaveClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure ClickerOpenpath(Sender: TObject);
    procedure ClickTedit(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure lblAboutClick(Sender: TObject);
    procedure ScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure CoolTrayIcon1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SysCommand;
    procedure TrayIconDblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  private
    { Private declarations }
  public
    function EXE_Running(FileName: string; bFullpath: Boolean): Boolean;
    procedure GetRunProcess(ProcesList: TStringList);
  end;

var
  frmMain: TfrmMain;
  H: THandle;
  path, command, param, showas: Array of TEdit;
  openpath: Array of TBitBtn;
  indexOpenpath: byte;
  indexClickTedit: Integer;
  ProcesList: TStringList;
  version, Runexe, NotRun_exe, Incoming: String;
  rez: TModalResult;

implementation

uses
  AboutForm;

{$R *.dfm}

Function SetPrivilege(aPrivilegeName: String; aEnabled: Boolean): Boolean;
Var
  hToken: THandle;
  tkp: TTokenPrivileges;
  ReturnLength: Cardinal;
Begin
  Result := False;
  if OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
  begin
    LookupPrivilegeValue(nil, 'SeShutdownPrivilege', tkp.Privileges[0].Luid);
    tkp.PrivilegeCount := 1;
    tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    Result := AdjustTokenPrivileges(hToken, False, tkp, 0, nil, ReturnLength);
  End;
  CloseHandle(hToken);
End;

procedure Autorun(Flag: Boolean; NameParam, path: String);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    if Flag then
    begin
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False);
      Reg.WriteString(NameParam, path);
    end
    else
    begin
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False);
      Reg.DeleteValue(NameParam);
    end;
  finally
    FreeAndNil(Reg);
  end;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  IdHTTPServer1.Active := False;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  appINI: TIniFile;
  CmdStr, PathStr, paramStr, showasStr: String;
  m, step, Count: Integer;
  Hint_Command, Hint_Path, Hint_Param, Hint_Showas, Ver, Ready, Hint_Openpath, MinTray, StrtUp, NumLin, Option, Serv, Lst, Save, bQuit, ListCmd, Listpath, Listparam, Listshow, ServerHint, SerportHint, SimpleHint, SimportHint, NumLinHint, MinTrayHint, StrtUpHint, SaveHint, bQuitHint: String;
  frmAbout: TfrmAbout;
begin
  version := '2.6';

  if not FileExists(ExtractFilePath(Application.ExeName) + 'GetAdmin.ini') then
  begin
    frmAbout := TfrmAbout.Create(self);
    try
      frmAbout.version.Caption := version;
      frmAbout.Label5.AutoSize := False;
      frmAbout.Label5.Caption := 'The program is delivered by a principle "AS IS". No warranty is not attached and is not provided. You use this software at your own risk.' + ' The author will not be responsible for any loss or corruption of data, any loss of profit during use or misuse of this software.';
      frmAbout.ShowModal;
    finally
      FreeAndNil(frmAbout);
    end;
  end;

  appINI := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  Language.ItemIndex := StrToInt(appINI.ReadString('Properties', 'Lang', '1'));

  if Language.ItemIndex = 2 then
  begin
    Hint_Command := 'Der Befehl zum Starten der Anwendung';
    Hint_Path := 'Anwendung (z.B C:\windows\notepad.exe) oder URL (diese wird in Ihrem Standardbrowser geцffnet).';
    Hint_Showas := 'SW_SHOWNORMAL' + #13 + 'SW_SHOWMINIMIZED' + #13 + 'SW_SHOWMAXIMIZED' + #13 + 'SW_RESTORE';
    Ver := 'Ver. ';
    Incoming := 'Eingehender Befehl: ';
    Ready := 'Bereit...';
    Hint_Openpath := 'Wдhlen Sie den Pfad zur Datei';
    Hint_Param := 'Startparameter.' + #13 + 'Beispiel: ' + #13 + '/play' + #13 + '/rand' + #13 + '/exit';
    NotRun_exe := ' ist nicht gestartet oder wurde nicht gefunden!';
    Runexe := ' ist gestartet!';
    MinTray := 'Minimiert starten';
    StrtUp := 'Mit Windows starten';
    NumLin := 'Anzahl Zeilen:';
    Option := 'Optionen';
    Serv := 'Server';
    Lst := 'Befehlsliste';
    Save := 'Speichern';
    bQuit := 'Beenden';
    ListCmd := 'BEFEHL';
    Listpath := 'PFAD oder URL';
    Listparam := 'PARAMETER';
    Listshow := 'ANZEIGE PARAMETER';
    ServerHint := 'IP Adresse dieses Computers';
    SerportHint := 'Port fьr GetAdmin';
    SimpleHint := 'IP Adresse fьr die SimpleAPI IOBroker';
    SimportHint := 'Port fьr die SimpleAPI vom IOBroker';
    NumLinHint := 'Anzahl der Befehle (Max. 100)';
    MinTrayHint := 'Programm wird minimiert gestartet.';
    StrtUpHint := 'Wird Automatisch mit Windows gestartet';
    SaveHint := 'Speichern';
    bQuitHint := 'Programm beenden';
  end;
  if Language.ItemIndex = 1 then
  begin
    Hint_Command := 'The command to start the application';
    Hint_Path := 'The path to the startup file, you can specify the URL of the page (it opens in your default browser)';
    Hint_Showas := 'SW_SHOWNORMAL' + #13 + 'SW_SHOWMINIMIZED' + #13 + 'SW_SHOWMAXIMIZED' + #13 + 'SW_RESTORE';
    Ver := 'Ver. ';
    Incoming := 'Incoming: ';
    Ready := 'Ready...';
    Hint_Openpath := 'Select the path to the file';
    Hint_Param := 'Startup Options.' + #13 + 'For example, for foobar2000:' + #13 + '/play' + #13 + '/rand' + #13 + '/exit';
    NotRun_exe := ' Not running or was not found!';
    Runexe := ' Running!';
    MinTray := 'Minimize on Tray';
    StrtUp := 'StartUp';
    NumLin := 'Number of lines:';
    Option := 'Options';
    Serv := 'Server';
    Lst := 'Command list';
    Save := 'Save';
    bQuit := 'Quit';
    ListCmd := 'COMMAND';
    Listpath := 'PATH or URL';
    Listparam := 'PARAMETERS';
    Listshow := 'SHOW CMD';
    ServerHint := 'IP address of your computer';
    SerportHint := 'Port that will run GetAdmin';
    SimpleHint := 'The IP address of the SimpleAPI IOBroker';
    SimportHint := 'The port is running the SimpleAPI of IOBroker';
    NumLinHint := 'The number of lines of commands (max 100)';
    MinTrayHint := 'Minimize to tray at program startup';
    StrtUpHint := 'Add to Startup';
    SaveHint := 'Save';
    bQuitHint := 'Exit the program';
  end;
  if Language.ItemIndex = 0 then
  begin
    Hint_Command := 'Команда для запуска приложения';
    Hint_Path := 'Путь до файла или URL (URL откроется в браузере по-умолчанию)';
    Hint_Showas := 'SW_SHOWNORMAL' + #13 + 'SW_SHOWMINIMIZED' + #13 + 'SW_SHOWMAXIMIZED' + #13 + 'SW_RESTORE';
    Ver := 'Версия: ';
    Ready := 'Готов...';
    Hint_Openpath := 'Выбрать файл';
    Hint_Param := 'Параметры запуска.' + #13 + 'Например для foobar2000:' + #13 + '/play' + #13 + '/rand' + #13 + '/exit';
    NotRun_exe := ' Не запущен или не найден!';
    Runexe := ' Запущен!';
    MinTray := 'Сворачивать в трей';
    StrtUp := 'Автозагрузка';
    NumLin := 'Кол-во команд:';
    Option := 'Дополнительно';
    Serv := 'Сервер';
    Lst := 'Список команд';
    Save := 'Сохранить';
    bQuit := 'Выход';
    ListCmd := 'КОМАНДА';
    Listpath := 'ПУТЬ ДО ФАЙЛА ИЛИ URL';
    Listparam := 'ПАРАМЕТРЫ';
    Listshow := 'РЕЖИМ ЗАПУСКА';
    lblShowCommand.Left := 620;
    ServerHint := 'IP адрес вашего компьютера';
    SerportHint := 'Порт на котором будет запущен GetAdmin';
    SimpleHint := 'IP адрес сервера SimpleAPI из IOBroker';
    SimportHint := 'Порт на котором запущен SimpleAPI из IOBroker';
    NumLinHint := 'Количество строк в таблице команд (макс. 100)';
    MinTrayHint := 'Сворачивать в трей при запуске';
    StrtUpHint := 'Загружаться вместе с Windows';
    SaveHint := 'Сохранить настройки';
    bQuitHint := 'Выход из программы';
    Incoming := 'Команда: ';
  end;

  ToTray.Caption := MinTray;
  ToTray.Hint := MinTrayHint;
  StartUp.Caption := StrtUp;
  StartUp.Hint := StrtUpHint;
  lblNumberOfLines.Caption := NumLin;
  gbOptions.Caption := Option;
  gbServer.Caption := Serv;
  gbCommandList.Caption := Lst;
  btnSave.Caption := Save;
  btnSave.Hint := SaveHint;
  btnClose.Caption := bQuit;
  btnClose.Hint := bQuitHint;
  lblCommand.Caption := ListCmd;
  lblPath.Caption := Listpath;
  lblParameters.Caption := Listparam;
  lblShowCommand.Caption := Listshow;
  MainServer.Hint := ServerHint;
  MainServerPort.Hint := SerportHint;
  SimpleAPI_IP.Hint := SimpleHint;
  SimpleAPI_Port.Hint := SimportHint;
  Count1.Hint := NumLinHint;

  StatusBar.Panels[0].Text := Ver + version;
  StatusBar.Panels[1].Text := Incoming;
  StatusBar.Panels[2].Text := Ready;
  PathStr := '';
  CmdStr := '';
  paramStr := '';
  showasStr := 'SW_SHOWNORMAL';

  SetLength(command, StrToInt(appINI.ReadString('Properties', 'Count', '10000')) + 1000);
  SetLength(path, StrToInt(appINI.ReadString('Properties', 'Count', '10000')) + 1000);
  SetLength(openpath, StrToInt(appINI.ReadString('Properties', 'Count', '10000')) + 1000);
  SetLength(param, StrToInt(appINI.ReadString('Properties', 'Count', '10000')) + 1000);
  SetLength(showas, StrToInt(appINI.ReadString('Properties', 'Count', '10000')) + 1000);

  try
    MainServerPort.Text := appINI.ReadString('Properties', 'Port', '8585');
    MainServer.Text := appINI.ReadString('Properties', 'BaseURL', 'IP address');
    if (appINI.ReadString('Properties', 'AutoStart', '0') = '0') then
    begin
      StartUp.Checked := False;
      Autorun(False, 'Server', Application.ExeName);
    end
    else
    begin
      StartUp.Checked := true;
      Autorun(true, 'Server', Application.ExeName);
    end;
    if (appINI.ReadString('Properties', 'ToTray', '0') = '0') then
      ToTray.Checked := False
    else
    begin
      ToTray.Checked := true;
      PostMessage(Handle, WM_SysCommand, SC_MINIMIZE, 0);
    end;
    SimpleAPI_IP.Text := appINI.ReadString('Properties', 'SimpleAPI_IP', PathStr);
    SimpleAPI_Port.Text := appINI.ReadString('Properties', 'SimpleAPI_Port', PathStr);
    Count1.Text := appINI.ReadString('Properties', 'Count', '20');
    if (StrToInt(Count1.Text) > 100) then
      Count1.Text := '100';

    step := 20;
    Count := StrToInt(Count1.Text);

    for m := 0 to (Count - 1) do
    begin
      command[m] := TEdit.Create(Owner);
      command[m].Top := (m * step) + 0;
      command[m].Left := 0;
      command[m].Height := 21;
      command[m].Width := 59;
      command[m].OnDblClick := ClickTedit;
      command[m].Hint := Hint_Command;
      command[m].ShowHint := true;
      command[m].Text := appINI.ReadString('Commands', 'Command_' + IntToStr(m), CmdStr);
      path[m] := TEdit.Create(Owner);
      path[m].Top := (m * step) + 0;
      path[m].Left := 59;
      path[m].Height := 21;
      path[m].Width := 354;
      path[m].OnDblClick := ClickTedit;
      path[m].Hint := Hint_Path;
      path[m].ShowHint := true;
      path[m].Text := appINI.ReadString('Commands', 'Path_' + IntToStr(m), PathStr);
      openpath[m] := TBitBtn.Create(Owner);
      openpath[m].Top := (m * step) + 5;
      openpath[m].Left := 414;
      openpath[m].Height := 16;
      openpath[m].Width := 19;
      openpath[m].Caption := '...';
      openpath[m].Font.Style := [fsBold];
      openpath[m].Hint := Hint_Openpath;
      openpath[m].ShowHint := true;
      openpath[m].Cursor := crHandPoint;
      openpath[m].OnClick := ClickerOpenpath;
      param[m] := TEdit.Create(Owner);
      param[m].Top := (m * step) + 0;
      param[m].Left := 437;
      param[m].Height := 21;
      param[m].Width := 179;
      param[m].Hint := Hint_Param;
      param[m].ShowHint := true;
      param[m].OnDblClick := ClickTedit;
      param[m].Text := appINI.ReadString('Commands', 'Param_' + IntToStr(m), paramStr);
      showas[m] := TEdit.Create(Owner);
      showas[m].Top := (m * step) + 0;
      showas[m].Left := 608;
      showas[m].Height := 21;
      showas[m].Width := 115;
      showas[m].Hint := Hint_Showas;
      showas[m].ShowHint := true;
      showas[m].OnDblClick := ClickTedit;
      showas[m].Text := appINI.ReadString('Commands', 'Show_' + IntToStr(m), 'SW_SHOWNORMAL');
      ScrollBox1.InsertControl(command[m]);
      ScrollBox1.InsertControl(path[m]);
      ScrollBox1.InsertControl(openpath[m]);
      ScrollBox1.InsertControl(param[m]);
      ScrollBox1.InsertControl(showas[m]);
    end;

  finally
    appINI.Free;
  end;
  IdHTTPServer1.DefaultPort := StrToInt(MainServerPort.Text);
  IdHTTPServer1.Active := true;

end;

procedure TfrmMain.IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  name, value, ProcListResponse, NameFile: string;
  I, n, m, showCmd, flagkey: Integer;
  hSnapShot: THandle;
  ProcInfo: TProcessEntry32;
  ProcesList, key: TStringList;
  HotKey: Array of byte;
const
  DISPLAY_SWITCH: String = 'displayswitch.exe';
begin
  { TODO : Wozu wird das hier nochmal gemacht? }
  if Language.ItemIndex = 1 then
  begin
    NotRun_exe := ' Not running or was not found!';
    Runexe := ' Running!';
    Incoming := 'Incoming: ';
  end;
  if Language.ItemIndex = 0 then
  begin
    NotRun_exe := ' Не запущен или не найден!';
    Runexe := ' Запущен!';
    Incoming := 'Команда: ';
  end;

  SetLength(HotKey, 10);
  for I := 0 to ARequestInfo.Params.Count - 1 do
  begin
    Name := ARequestInfo.Params.Names[I];
    value := ARequestInfo.Params.ValueFromIndex[I];
    showCmd := 9;
    flagkey := 0;
    StatusBar.Panels[1].Text := Incoming + value;
    if Name = 'cmd' then
    begin
      for m := 0 to (StrToInt(Count1.Text) - 1) do
      begin
        if value = command[m].Text then
        begin
          if (showas[m].Text = 'SW_SHOWNORMAL') then
            showCmd := 1;
          if (showas[m].Text = 'SW_HIDE') then
            showCmd := 0;
          if (showas[m].Text = 'SW_MAXIMIZE') then
            showCmd := 3;
          if (showas[m].Text = 'SW_MINIMIZE') then
            showCmd := 6;
          if (showas[m].Text = 'SW_RESTORE') then
            showCmd := 9;
          if (showas[m].Text = 'SW_SHOW') then
            showCmd := 5;
          if (showas[m].Text = 'SW_SHOWDEFAULT') then
            showCmd := 10;
          if (showas[m].Text = 'SW_SHOWMAXIMIZED') then
            showCmd := 3;
          if (showas[m].Text = 'SW_SHOWMINIMIZED') then
            showCmd := 2;
          if (showas[m].Text = 'SW_SHOWMINNOACTIVE') then
            showCmd := 7;
          if (showas[m].Text = 'SW_SHOWNA') then
            showCmd := 8;
          if (showas[m].Text = 'SW_SHOWNOACTIVATE') then
            showCmd := 4;
          ShellExecute(frmMain.Handle, 'open', Pchar(path[m].Text), Pchar(param[m].Text), nil, showCmd);
          NameFile := ExtractFileName(path[m].Text);
          if EXE_Running(NameFile, False) then
            AResponseInfo.ContentText := '<html>Ok!<p>' + path[m].Text + '</p></html>'
          else
            AResponseInfo.ContentText := '<html>Error!<p>' + path[m].Text + '</p></html>';
          Break;
        end;
      end;
      if value = 'shutdown' then
      begin
        SetPrivilege('SeShutdownPrivilege', true);
        ExitWindowsEx(EWX_SHUTDOWN or ewx_force, 0);
        Break;
      end;
      if value = 'poweroff' then
      begin
        SetPrivilege('SeShutdownPrivilege', true);
        ExitWindowsEx(EWX_POWEROFF or ewx_force, 0);
        Break;
      end;
      if value = 'logoff' then
      begin
        SetPrivilege('SeShutdownPrivilege', true);
        ExitWindowsEx(EWX_LOGOFF or ewx_force, 0);
        Break;
      end;
      if value = 'reboot' then
      begin
        SetPrivilege('SeShutdownPrivilege', true);
        ExitWindowsEx(EWX_REBOOT or ewx_force, 0);
        Break;
      end;
      if value = 'forceifhung' then
      begin
        SetPrivilege('SeShutdownPrivilege', true);
        ExitWindowsEx(EWX_FORCEIFHUNG or ewx_force, 0);
        Break;
      end;

      if value = 'process' then
      begin
        ProcesList := TStringList.Create;
        hSnapShot := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
        if (hSnapShot <> THandle(-1)) then
        begin
          ProcInfo.dwSize := SizeOf(ProcInfo);
          if (Process32First(hSnapShot, ProcInfo)) then
          begin
            while (Process32Next(hSnapShot, ProcInfo)) do
              ProcesList.Add(ProcInfo.szExeFile);
          end;
          CloseHandle(hSnapShot);
        end;
        for n := 1 to ProcesList.Count - 1 do
        begin
          ProcListResponse := ProcListResponse + ProcesList[n] + ';';
        end;
        AResponseInfo.ContentText := '<html>' + ProcListResponse + '</html>';
        Break;
      end;

      if value = 'monitor1' then
      begin
        WinExec(PAnsiChar('displayswitch.exe /external'), SW_SHOW);
        Break;
      end;
      if value = 'monitor2' then
      begin
        WinExec(PAnsiChar('displayswitch.exe /internal'), SW_SHOW);
        Break;
      end;
      if value = 'monitorclone' then
      begin
        WinExec(PAnsiChar('displayswitch.exe /clone'), SW_SHOW);
        Break;
      end;
      if value = 'monitorextend' then
      begin
        WinExec(PAnsiChar('displayswitch.exe /extend'), SW_SHOW);
        Break;
      end;
    end;
    if Name = 'chk' then
    begin
      if value <> '' then
      begin
        value := value + '.exe';
        if EXE_Running(value, False) then
          AResponseInfo.ContentText := '<html>' + value + Runexe + '<p>true</p></html>'
        else
          AResponseInfo.ContentText := '<html>' + value + NotRun_exe + '<p>false</p></html>';

        Break;
      end;
    end;

    if Name = 'key' then
    begin
      if value <> '' then
      begin
        key := TStringList.Create;
        try
          key.Delimiter := '+';
          key.DelimitedText := value;
        finally

          for n := 0 to key.Count - 1 do
          begin
            if key[n] = 'CTRL' then
              HotKey[n] := $A2;

            if key[n] = 'RCTRL' then
              HotKey[n] := $A3;

            if key[n] = 'ALT' then
              HotKey[n] := $A4;

            if key[n] = 'RALT' then
              HotKey[n] := $A5;

            if key[n] = 'SHIFT' then
              HotKey[n] := $A0;

            if key[n] = 'RSHIFT' then
              HotKey[n] := $A1;

            if key[n] = 'WIN' then
              HotKey[n] := $5B;

            if key[n] = 'RWIN' then
              HotKey[n] := $5C;

            if key[n] = 'ESC' then
              HotKey[n] := $1B;

            if key[n] = 'ENT' then
              HotKey[n] := $0D;

            if key[n] = 'DEL' then
              HotKey[n] := $2E;

            if key[n] = 'INS' then
              HotKey[n] := $2D;

            if key[n] = 'VOLUP' then
              HotKey[n] := $AF;

            if key[n] = 'VOLDN' then
              HotKey[n] := $AE;

            if key[n] = 'MUTE' then
              HotKey[n] := $AD;

            if key[n] = 'NEXT' then
              HotKey[n] := $B0;

            if key[n] = 'PREV' then
              HotKey[n] := $B1;

            if key[n] = 'PLAY' then
              HotKey[n] := $B3;

            if key[n] = 'STOP' then
              HotKey[n] := $B2;

            if key[n] = 'BACK' then
              HotKey[n] := $08;

            if key[n] = 'SPACE' then
              HotKey[n] := $20;

            if key[n] = 'TAB' then
              HotKey[n] := $09;

            if key[n] = 'NUMP' then
              HotKey[n] := $6B;

            if key[n] = 'NUMS' then
              HotKey[n] := $6F;

            if key[n] = 'NUMD' then
              HotKey[n] := $6E;

            if key[n] = 'NUM*' then
              HotKey[n] := $6A;

            if key[n] = 'NUMM' then
              HotKey[n] := $6D;

            if key[n] = 'NUML' then
              HotKey[n] := $90;

            if key[n] = 'CAPS' then
              HotKey[n] := $14;

            if key[n] = 'END' then
              HotKey[n] := $23;

            if key[n] = 'HOME' then
              HotKey[n] := $24;

            if key[n] = 'PGDN' then
              HotKey[n] := $22;

            if key[n] = 'PGUP' then
              HotKey[n] := $21;

            if key[n] = 'SCRL' then
              HotKey[n] := $91;

            if key[n] = 'PRNTSCR' then
              HotKey[n] := $2C;

            if key[n] = 'SLEEP' then
              HotKey[n] := $5F;

            if key[n] = 'DOWN' then
              HotKey[n] := $28;

            if key[n] = 'UP' then
              HotKey[n] := $26;

            if key[n] = 'LEFT' then
              HotKey[n] := $25;

            if key[n] = 'RIGHT' then
              HotKey[n] := $27;

            if key[n] = 'F1' then
              HotKey[n] := $70;

            if key[n] = 'F2' then
              HotKey[n] := $71;

            if key[n] = 'F3' then
              HotKey[n] := $72;

            if key[n] = 'F4' then
              HotKey[n] := $73;

            if key[n] = 'F5' then
              HotKey[n] := $74;

            if key[n] = 'F6' then
              HotKey[n] := $75;

            if key[n] = 'F7' then
              HotKey[n] := $76;

            if key[n] = 'F8' then
              HotKey[n] := $77;

            if key[n] = 'F9' then
              HotKey[n] := $78;

            if key[n] = 'F10' then
              HotKey[n] := $79;

            if key[n] = 'F11' then
              HotKey[n] := $7A;

            if key[n] = 'F12' then
              HotKey[n] := $7B;

            if key[n] = 'F13' then
              HotKey[n] := $7C;

            if key[n] = 'F14' then
              HotKey[n] := $7D;

            if key[n] = 'F15' then
              HotKey[n] := $7E;

            if key[n] = 'F16' then
              HotKey[n] := $7F;

            if key[n] = 'F17' then
              HotKey[n] := $80;

            if key[n] = 'F18' then
              HotKey[n] := $81;

            if key[n] = 'F19' then
              HotKey[n] := $82;

            if key[n] = 'F20' then
              HotKey[n] := $83;

            if key[n] = 'F21' then
              HotKey[n] := $84;

            if key[n] = 'F22' then
              HotKey[n] := $85;

            if key[n] = 'F23' then
              HotKey[n] := $86;

            if key[n] = 'F24' then
              HotKey[n] := $87;

            if key[n] = 'NUM0' then
              HotKey[n] := $60;

            if key[n] = 'NUM1' then
              HotKey[n] := $61;

            if key[n] = 'NUM2' then
              HotKey[n] := $62;

            if key[n] = 'NUM3' then
              HotKey[n] := $63;

            if key[n] = 'NUM4' then
              HotKey[n] := $64;

            if key[n] = 'NUM5' then
              HotKey[n] := $65;

            if key[n] = 'NUM6' then
              HotKey[n] := $66;

            if key[n] = 'NUM7' then
              HotKey[n] := $67;

            if key[n] = 'NUM8' then
              HotKey[n] := $68;

            if key[n] = 'NUM9' then
              HotKey[n] := $69;

            if key[n] = '0' then
              HotKey[n] := $30;

            if key[n] = '1' then
              HotKey[n] := $31;

            if key[n] = '2' then
              HotKey[n] := $32;

            if key[n] = '3' then
              HotKey[n] := $33;

            if key[n] = '4' then
              HotKey[n] := $34;

            if key[n] = '5' then
              HotKey[n] := $35;

            if key[n] = '6' then
              HotKey[n] := $36;

            if key[n] = '7' then
              HotKey[n] := $37;

            if key[n] = '8' then
              HotKey[n] := $38;

            if key[n] = '9' then
              HotKey[n] := $39;

            if key[n] = 'A' then
              HotKey[n] := $41;

            if key[n] = 'B' then
              HotKey[n] := $42;

            if key[n] = 'C' then
              HotKey[n] := $43;

            if key[n] = 'D' then
              HotKey[n] := $44;

            if key[n] = 'E' then
              HotKey[n] := $45;

            if key[n] = 'F' then
              HotKey[n] := $46;

            if key[n] = 'G' then
              HotKey[n] := $47;

            if key[n] = 'H' then
              HotKey[n] := $48;

            if key[n] = 'I' then
              HotKey[n] := $49;

            if key[n] = 'J' then
              HotKey[n] := $4A;

            if key[n] = 'K' then
              HotKey[n] := $4B;

            if key[n] = 'L' then
              HotKey[n] := $4C;

            if key[n] = 'M' then
              HotKey[n] := $4D;

            if key[n] = 'N' then
              HotKey[n] := $4E;

            if key[n] = 'O' then
              HotKey[n] := $4F;

            if key[n] = 'P' then
              HotKey[n] := $50;

            if key[n] = 'Q' then
              HotKey[n] := $51;

            if key[n] = 'R' then
              HotKey[n] := $52;

            if key[n] = 'S' then
              HotKey[n] := $53;

            if key[n] = 'T' then
              HotKey[n] := $54;

            if key[n] = 'U' then
              HotKey[n] := $55;

            if key[n] = 'V' then
              HotKey[n] := $56;

            if key[n] = 'W' then
              HotKey[n] := $57;

            if key[n] = 'X' then
              HotKey[n] := $58;

            if key[n] = 'Y' then
              HotKey[n] := $59;

            if key[n] = 'Z' then
              HotKey[n] := $5A;
          end;
          if key.Count = 1 then
          begin
            keybd_event(HotKey[0], 0, 0, 0);
            keybd_event(HotKey[0], 0, KEYEVENTF_KEYUP, 0);
            flagkey := 1;
          end;
          if (key.Count = 2) and ((HotKey[0] = $A0) or (HotKey[0] = $A1) or (HotKey[0] = $A2) or (HotKey[0] = $A3) or (HotKey[0] = $A4) or (HotKey[0] = $A5) or (HotKey[0] = $5B) or (HotKey[0] = $5C)) then
          begin
            keybd_event(HotKey[0], 0, 0, 0);
            keybd_event(HotKey[1], 0, 0, 0);
            keybd_event(HotKey[1], 0, KEYEVENTF_KEYUP, 0);
            keybd_event(HotKey[0], 0, KEYEVENTF_KEYUP, 0);
            flagkey := 1;
          end;
          if (key.Count = 3) and ((HotKey[0] = $A0) or (HotKey[0] = $A1) or (HotKey[0] = $A2) or (HotKey[0] = $A3) or (HotKey[0] = $A4) or (HotKey[0] = $A5) or (HotKey[0] = $5B) or (HotKey[0] = $5C)) and ((HotKey[1] = $A0) or (HotKey[1] = $A1) or (HotKey[1] = $A2) or (HotKey[1] = $A3) or (HotKey[1] = $A4) or (HotKey[1] = $A5) or (HotKey[1] = $5B) or (HotKey[1] = $5C)) then
          begin
            keybd_event(HotKey[0], 0, 0, 0);
            keybd_event(HotKey[1], 0, 0, 0);
            keybd_event(HotKey[2], 0, 0, 0);
            keybd_event(HotKey[2], 0, KEYEVENTF_KEYUP, 0);
            keybd_event(HotKey[1], 0, KEYEVENTF_KEYUP, 0);
            keybd_event(HotKey[0], 0, KEYEVENTF_KEYUP, 0);
            flagkey := 1;
          end;
          if (key.Count = 4) and ((HotKey[0] = $A0) or (HotKey[0] = $A1) or (HotKey[0] = $A2) or (HotKey[0] = $A3) or (HotKey[0] = $A4) or (HotKey[0] = $A5) or (HotKey[0] = $5B) or (HotKey[0] = $5C)) and ((HotKey[1] = $A0) or (HotKey[1] = $A1) or (HotKey[1] = $A2) or (HotKey[1] = $A3) or (HotKey[1] = $A4) or (HotKey[1] = $A5) or (HotKey[1] = $5B) or (HotKey[1] = $5C)) and
            ((HotKey[2] = $A0) or (HotKey[2] = $A1) or (HotKey[2] = $A2) or (HotKey[2] = $A3) or (HotKey[2] = $A4) or (HotKey[2] = $A5) or (HotKey[2] = $5B) or (HotKey[2] = $5C)) then
          begin
            keybd_event(HotKey[0], 0, 0, 0);
            keybd_event(HotKey[1], 0, 0, 0);
            keybd_event(HotKey[2], 0, 0, 0);
            keybd_event(HotKey[3], 0, 0, 0);
            keybd_event(HotKey[3], 0, KEYEVENTF_KEYUP, 0);
            keybd_event(HotKey[2], 0, KEYEVENTF_KEYUP, 0);
            keybd_event(HotKey[1], 0, KEYEVENTF_KEYUP, 0);
            keybd_event(HotKey[0], 0, KEYEVENTF_KEYUP, 0);
            flagkey := 1;
          end;
          if flagkey = 1 then
          begin
            AResponseInfo.ContentText := '<html>Ok!' + value + '<p>true</p></html>';
            flagkey := 0;
          end
          else
          begin
            AResponseInfo.ContentText := '<html>Error!' + value + '<p>false</p></html>';
            flagkey := 0;
          end;
          key.Free
        end;
      end;

    end;
  end;
end;

procedure TfrmMain.btnSaveClick(Sender: TObject);
var
  appINI: TIniFile;
  HTTP: TIdHTTP;
  Port, Host: String;
  a: Integer;
begin
  HTTP := TIdHTTP.Create(nil);
  Port := MainServerPort.Text;
  Host := MainServer.Text;
  ReleaseMutex(H);
  CloseHandle(H);
  if (SimpleAPI_IP.Text <> '') and (SimpleAPI_Port.Text <> '') then
  begin
    HTTP.get('http://' + SimpleAPI_IP.Text + ':' + SimpleAPI_Port.Text + '/set/GetAdmin.Host?value=' + Host + '&prettyPrint');
    HTTP.get('http://' + SimpleAPI_IP.Text + ':' + SimpleAPI_Port.Text + '/set/GetAdmin.Port?value=' + Port + '&prettyPrint');
  end;
  appINI := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  IdHTTPServer1.Active := False;
  try
    appINI.WriteString('Properties', 'Lang', IntToStr(Language.ItemIndex));
    appINI.WriteString('Properties', 'Port', MainServerPort.Text);
    appINI.WriteString('Properties', 'BaseURL', MainServer.Text);
    if (StartUp.Checked) then
      appINI.WriteString('Properties', 'AutoStart', '1')
    else
    begin
      appINI.WriteString('Properties', 'AutoStart', '0');
    end;
    if (ToTray.Checked) then
      appINI.WriteString('Properties', 'ToTray', '1')
    else
    begin
      appINI.WriteString('Properties', 'ToTray', '0');
    end;
    appINI.WriteString('Properties', 'SimpleAPI_IP', SimpleAPI_IP.Text);
    appINI.WriteString('Properties', 'SimpleAPI_Port', SimpleAPI_Port.Text);
    if (StrToInt(Count1.Text) > 100) then
      Count1.Text := '100';
    appINI.WriteString('Properties', 'Count', Count1.Text);
    for a := 0 to ((StrToInt(Count1.Text)) - 1) do
    begin
      appINI.WriteString('Commands', 'Command_' + IntToStr(a), command[a].Text);
      appINI.WriteString('Commands', 'Path_' + IntToStr(a), path[a].Text);
      appINI.WriteString('Commands', 'Param_' + IntToStr(a), param[a].Text);
      if (showas[a].Text <> '') then
      begin
        appINI.WriteString('Commands', 'show_' + IntToStr(a), showas[a].Text);
      end
      else
      begin
        appINI.WriteString('Commands', 'show_' + IntToStr(a), 'SW_SHOWNORMAL');
      end;
    end;

  finally
    HTTP.Free;
    appINI.Free;
  end;
  ShellExecute(Application.Handle, 'open', Pchar(Application.ExeName), '', nil, SW_SHOW);
  Application.Terminate;
end;

procedure TfrmMain.ClickerOpenpath(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to (StrToInt(Count1.Text) - 1) do
    if Sender = openpath[I] then
      indexOpenpath := I;
  if OpenDialog1.Execute then
    path[indexOpenpath].Text := OpenDialog1.FileName;
end;

procedure TfrmMain.ClickTedit(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to (StrToInt(Count1.Text) - 1) do
  begin
    if Sender = command[I] then
    begin
      command[I].SelectAll;
    end;
    if Sender = path[I] then
    begin
      path[I].SelectAll;
    end;
    if Sender = param[I] then
    begin
      param[I].SelectAll;
    end;
    if Sender = showas[I] then
    begin
      showas[I].SelectAll;
    end;
  end;
end;

procedure TfrmMain.N1Click(Sender: TObject);
begin
  IdHTTPServer1.Active := False;
  Close;
end;

procedure TfrmMain.N2Click(Sender: TObject);
begin
  frmMain.Show;
  Application.Restore;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  N1Click(nil);
end;

procedure TfrmMain.GetRunProcess(ProcesList: TStringList);
var
  hSnapShot: THandle;
  ProcInfo: TProcessEntry32;
begin
  ProcesList := TStringList.Create;
  hSnapShot := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if ProcesList = nil then
    Exit;
  if (hSnapShot <> THandle(-1)) then
  begin
    ProcInfo.dwSize := SizeOf(ProcInfo);
    if (Process32First(hSnapShot, ProcInfo)) then
    begin
      while (Process32Next(hSnapShot, ProcInfo)) do
        ProcesList.Add(ProcInfo.szExeFile);
    end;
    CloseHandle(hSnapShot);
  end;
end;

function TfrmMain.EXE_Running(FileName: string; bFullpath: Boolean): Boolean;
var
  I: Integer;
  hSnapShot: THandle;
  ProcInfo: TProcessEntry32;
begin
  try
    ProcesList := TStringList.Create;
    hSnapShot := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hSnapShot <> THandle(-1)) then
    begin
      ProcInfo.dwSize := SizeOf(ProcInfo);
      if (Process32First(hSnapShot, ProcInfo)) then
      begin
        while (Process32Next(hSnapShot, ProcInfo)) do
          ProcesList.Add(ProcInfo.szExeFile);
      end;
      CloseHandle(hSnapShot);
    end;
    Result := False;
    if ProcesList = nil then
      Exit;
    for I := 0 to ProcesList.Count - 1 do
    begin
      if not bFullpath then
      begin
        if CompareText(ExtractFileName(ProcesList.Strings[I]), FileName) = 0 then
          Result := true
      end
      else if CompareText(ProcesList.Strings[I], FileName) = 0 then
        Result := true;
      if Result then
        Break;
    end;
  finally
    ProcesList.Free;
  end;
end;

procedure TfrmMain.lblAboutClick(Sender: TObject);
var
  frmAbout: TfrmAbout;
begin
  frmAbout := TfrmAbout.Create(self);
  try
    frmAbout.version.Caption := version;
    frmAbout.Label5.AutoSize := False;

    { TODO : Neues About Fenster? }
    if Language.ItemIndex in [1, 2] then
    begin
      frmAbout.Label5.Caption := 'The program is delivered by a principle "AS IS". No warranty is not attached and is not provided. You use this software at your own risk.' + ' The author will not be responsible for any loss or corruption of data, any loss of profit during use or misuse of this software.';
    end;
    if Language.ItemIndex = 0 then
    begin
      frmAbout.Label5.Caption := 'Программа поставляется по принципу "КАК ЕСТЬ" ("AS IS").Никаких гарантий не прилагается и не предусматривается. Вы используете это программное обеспечение на свой страх и риск.' + ' Автор не будет отвечать ни за какие потери или искажения данных, любую упущенную выгоду в процессе использования или неправильного использования этого программного обечпечения.';
    end;

    frmAbout.ShowModal;
  finally
    FreeAndNil(frmAbout);
  end;
end;

procedure TfrmMain.ScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position + 4;
end;

procedure TfrmMain.ScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position - 4;
end;

procedure TfrmMain.TrayIconDblClick(Sender: TObject);
begin
  TrayIcon.Visible := False;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TfrmMain.CoolTrayIcon1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    PopupMenu1.Popup(X, Y);
end;

procedure TfrmMain.WMSysCommand(var Msg: TWMSysCommand);
begin
  if (Msg.CmdType and $FFF0 = SC_MINIMIZE) then
  begin
    Hide();
    WindowState := wsMinimized;

    TrayIcon.Visible := true;
    TrayIcon.Animate := true;
  end
  else
    inherited;
end;

end.
