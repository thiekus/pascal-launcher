object frmMain: TfrmMain
  Left = 192
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Bundle / Debundler'
  ClientHeight = 390
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pgMain: TPageControl
    Left = 0
    Top = 0
    Width = 505
    Height = 390
    ActivePage = tbBun
    Align = alClient
    TabOrder = 0
    object tbBun: TTabSheet
      Caption = 'Bundle'
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 95
        Height = 13
        Caption = 'Output of bundle file'
      end
      object Label2: TLabel
        Left = 8
        Top = 88
        Width = 85
        Height = 13
        Caption = 'List of bundled file'
      end
      object edtOutp: TEdit
        Left = 8
        Top = 24
        Width = 473
        Height = 21
        TabOrder = 0
      end
      object Button1: TButton
        Left = 408
        Top = 48
        Width = 75
        Height = 25
        Caption = 'Browse'
        TabOrder = 1
        OnClick = Button1Click
      end
      object lstBun: TListBox
        Left = 8
        Top = 104
        Width = 481
        Height = 209
        ItemHeight = 13
        TabOrder = 2
      end
      object Button2: TButton
        Left = 8
        Top = 328
        Width = 75
        Height = 25
        Caption = 'Add'
        TabOrder = 3
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 88
        Top = 328
        Width = 75
        Height = 25
        Caption = 'Clear'
        TabOrder = 4
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 360
        Top = 328
        Width = 123
        Height = 25
        Caption = 'Bundle!'
        TabOrder = 5
        OnClick = Button4Click
      end
      object prbBund: TProgressBar
        Left = 8
        Top = 56
        Width = 265
        Height = 17
        TabOrder = 6
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'DeBundle'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label3: TLabel
        Left = 8
        Top = 8
        Width = 76
        Height = 13
        Caption = 'Input file Bundle'
      end
      object Label4: TLabel
        Left = 8
        Top = 72
        Width = 66
        Height = 13
        Caption = 'List on bundle'
      end
      object edtInp: TEdit
        Left = 8
        Top = 24
        Width = 481
        Height = 21
        TabOrder = 0
      end
      object Button5: TButton
        Left = 408
        Top = 48
        Width = 75
        Height = 25
        Caption = 'Open'
        TabOrder = 1
        OnClick = Button5Click
      end
      object lsBuni: TListBox
        Left = 8
        Top = 88
        Width = 473
        Height = 241
        ItemHeight = 13
        TabOrder = 2
      end
    end
  end
  object bunSv: TSaveDialog
    DefaultExt = '*.kbd'
    Filter = 'Khayalan Bundle (*.kbd)|*.kbd'
    Left = 348
    Top = 240
  end
  object blbOp: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 124
    Top = 272
  end
  object bunOp: TOpenDialog
    DefaultExt = '*.kbd'
    Filter = 'Khayalan Bundle (*.kbd)|*.kbd'
    Left = 404
    Top = 88
  end
end
