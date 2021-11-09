object Server: TServer
  Left = 488
  Top = 277
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'GetAdmin'
  ClientHeight = 475
  ClientWidth = 744
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000330077000000000000000000000000003B077070000000000000
    000000000000BB807007000000000000000000000300B0007000700000000000
    00000000330070070700070000000000000000003B0700700070007000000000
    00000000BB800700000700070000000000000300B00070000000700070000000
    0000330070070000000007000700000000003B07007000000000007007000000
    0000BB800700000000000007070000000300B000700000000070000077000000
    330070070000000007000000803300003B070070000000000000000800330000
    BB8007000000000000000080BBBB0300B000700000000070000008000BB03300
    70070000000707000000803300003B070070000000707000000800330000BB80
    07000000070700000080BBBB0000B000700000000070000008000BB000007007
    0000000007000000803300000000707000007770000000080033000000008700
    0007070700000080BBBB00000000080000077777000008000BB0000000000080
    0007070700008033000000000000000800007770000800330000000000000000
    800000000080BBBB00000000000000000800000008000BB00000000000000000
    0080000080330000000000000000000000080008003300000000000000000000
    00008080BBBB00000000000000000000000008000BB00000000000000000FFFF
    33FFFFFF21FFFFFF00FFFFFB007FFFF3003FFFF2001FFFF0000FFFB00007FF30
    0003FF200003FF000003FB000003F3000000F2000000F0000010B00000393000
    000F2000000F0000010F0000039F000000FF000000FF000010FF800039FFC000
    0FFFE0000FFFF0010FFFF8039FFFFC00FFFFFE00FFFFFF10FFFFFFB9FFFF}
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label13: TLabel
    Left = 688
    Top = 71
    Width = 28
    Height = 13
    Cursor = crHandPoint
    Caption = 'About'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnClick = Label13Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 456
    Width = 744
    Height = 19
    Panels = <
      item
        Width = 100
      end
      item
        Width = 540
      end
      item
        Width = 100
      end>
  end
  object GroupBox4: TGroupBox
    Left = 0
    Top = 88
    Width = 747
    Height = 369
    Caption = 'Command list'
    TabOrder = 5
    object Label9: TLabel
      Left = 193
      Top = 18
      Width = 66
      Height = 13
      Caption = 'PATH or URL'
    end
    object Label6: TLabel
      Left = 6
      Top = 18
      Width = 56
      Height = 13
      Caption = 'COMMAND'
    end
    object Label10: TLabel
      Left = 484
      Top = 18
      Width = 74
      Height = 13
      Caption = 'PARAMETERS'
    end
    object Label11: TLabel
      Left = 617
      Top = 18
      Width = 61
      Height = 13
      Caption = 'SHOW CMD'
    end
    object ScrollBox1: TScrollBox
      Left = 0
      Top = 37
      Width = 745
      Height = 340
      VertScrollBar.Tracking = True
      TabOrder = 0
      OnMouseWheelDown = ScrollBox1MouseWheelDown
      OnMouseWheelUp = ScrollBox1MouseWheelUp
    end
  end
  object GroupBox2: TGroupBox
    Left = 192
    Top = 0
    Width = 177
    Height = 81
    Caption = 'Simple API'
    TabOrder = 3
    object Label7: TLabel
      Left = 9
      Top = 23
      Width = 13
      Height = 13
      Caption = 'IP:'
    end
    object Label8: TLabel
      Left = 8
      Top = 48
      Width = 22
      Height = 13
      Caption = 'Port:'
    end
    object SimpleAPI_IP: TEdit
      Left = 40
      Top = 20
      Width = 130
      Height = 21
      Hint = 'The IP address of the SimpleAPI IOBroker'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'ip SimpleAPI'
    end
    object SimpleAPI_Port: TEdit
      Left = 40
      Top = 44
      Width = 50
      Height = 21
      Hint = 'The port is running the SimpleAPI of IOBroker'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = 'port SimpleAPI'
    end
  end
  object BtnSave: TButton
    Left = 670
    Top = 8
    Width = 70
    Height = 25
    Hint = 'Save'
    Caption = 'Save'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = BtnSaveClick
  end
  object BitBtn17: TBitBtn
    Left = 670
    Top = 42
    Width = 70
    Height = 25
    Hint = 'Exit the program'
    Caption = 'Quit'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = BitBtn17Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 0
    Width = 177
    Height = 81
    Caption = 'Server'
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 13
      Height = 13
      Caption = 'IP:'
      Transparent = False
    end
    object Label2: TLabel
      Left = 8
      Top = 50
      Width = 22
      Height = 13
      Caption = 'Port:'
    end
    object MainServer: TEdit
      Left = 37
      Top = 21
      Width = 130
      Height = 21
      Hint = 'IP address of your computer'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'MainServer'
    end
    object MainServerPort: TEdit
      Left = 38
      Top = 45
      Width = 50
      Height = 21
      Hint = 'Port that will run GetAdmin'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = 'MainServerPort'
    end
  end
  object GroupBox3: TGroupBox
    Left = 376
    Top = 0
    Width = 281
    Height = 81
    Caption = 'Options'
    TabOrder = 4
    object Label5: TLabel
      Left = 152
      Top = 22
      Width = 76
      Height = 13
      Caption = 'Number of lines:'
    end
    object StartUp: TCheckBox
      Left = 9
      Top = 38
      Width = 120
      Height = 19
      Hint = 'Add to Startup'
      Caption = 'StartUp'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object ToTray: TCheckBox
      Left = 9
      Top = 22
      Width = 136
      Height = 17
      Hint = 'Minimize to tray at program startup'
      Caption = 'Minimize on Tray'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object Count1: TEdit
      Left = 235
      Top = 18
      Width = 33
      Height = 18
      Hint = 'The number of lines of commands (max 100)'
      Constraints.MaxHeight = 18
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = 'Count1'
    end
    object Language: TComboBox
      Left = 184
      Top = 45
      Width = 84
      Height = 21
      Hint = 'Language'
      Style = csDropDownList
      DropDownCount = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Items.Strings = (
        '???????'
        'English'
        'Deutsch')
    end
  end
  object IdHTTPServer1: TIdHTTPServer
    Bindings = <>
    OnCommandGet = IdHTTPServer1CommandGet
    Left = 264
    Top = 328
  end
  object CoolTrayIcon1: TCoolTrayIcon
    CycleInterval = 0
    Hint = 'GetAdmin'
    Icon.Data = {
      0000010001002020100000000000E80200001600000028000000200000004000
      0000010004000000000080020000000000000000000000000000000000000000
      000000008000008000000080800080000000800080008080000080808000C0C0
      C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
      000000000000330077000000000000000000000000003B077070000000000000
      000000000000BB807007000000000000000000000300B0007000700000000000
      00000000330070070700070000000000000000003B0700700070007000000000
      00000000BB800700000700070000000000000300B00070000000700070000000
      0000330070070000000007000700000000003B07007000000000007007000000
      0000BB800700000000000007070000000300B000700000000070000077000000
      330070070000000007000000803300003B070070000000000000000800330000
      BB8007000000000000000080BBBB0300B000700000000070000008000BB03300
      70070000000707000000803300003B070070000000707000000800330000BB80
      07000000070700000080BBBB0000B000700000000070000008000BB000007007
      0000000007000000803300000000707000007770000000080033000000008700
      0007070700000080BBBB00000000080000077777000008000BB0000000000080
      0007070700008033000000000000000800007770000800330000000000000000
      800000000080BBBB00000000000000000800000008000BB00000000000000000
      0080000080330000000000000000000000080008003300000000000000000000
      00008080BBBB00000000000000000000000008000BB00000000000000000FFFF
      33FFFFFF21FFFFFF00FFFFFB007FFFF3003FFFF2001FFFF0000FFFB00007FF30
      0003FF200003FF000003FB000003F3000000F2000000F0000010B00000393000
      000F2000000F0000010F0000039F000000FF000000FF000010FF800039FFC000
      0FFFE0000FFFF0010FFFF8039FFFFC00FFFFFE00FFFFFF10FFFFFFB9FFFF}
    IconVisible = True
    IconIndex = 0
    PopupMenu = PopupMenu1
    MinimizeToTray = True
    OnDblClick = CoolTrayIcon1DblClick
    OnMouseUp = CoolTrayIcon1MouseUp
    Left = 336
    Top = 328
  end
  object PopupMenu1: TPopupMenu
    AutoPopup = False
    Left = 400
    Top = 328
    object N2: TMenuItem
      Caption = 'Show'
      OnClick = N2Click
    end
    object N1: TMenuItem
      Caption = 'Exit'
      OnClick = N1Click
    end
  end
  object IdHTTP1: TIdHTTP
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentRangeInstanceLength = -1
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 208
    Top = 328
  end
  object OpenDialog1: TOpenDialog
    Left = 456
    Top = 328
  end
end
