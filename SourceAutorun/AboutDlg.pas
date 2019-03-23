unit AboutDlg;

(*==============================================================================

  Quiz Project
  Written by Faris Khowarizmi
  Copyright © Faris Khowarizmi

  Website: http://www.khayalan.web.id
  e-Mail: thekill96@gmail.com

  Program ini dapat dikembangkan secara bebas.
  Penulis tidak bertanggung jawab atas kesalahan yang ditimbulkan oleh program
  ini!

==============================================================================*)

interface

uses
  Windows, Messages, AppVars, SoundMixer;

procedure PanggilAbout;

implementation

function DlgPrc(hWnd, Msg, wParam, lParam: Integer): Boolean; stdcall;
var
  wrc: TRect;
  nx, ny: integer;
begin

  Result:= FALSE;
  case Msg of

    WM_INITDIALOG:
      begin
      GetWindowRect(hWnd, wrc);
      nx:= (GetSystemMetrics(SM_CXFULLSCREEN)-(wrc.Right-wrc.Left)) div 2;
      ny:= (GetSystemMetrics(SM_CYFULLSCREEN)-(wrc.Bottom-wrc.Top)) div 2;
      SetWindowPos(hWnd, 0, nx, ny, 0, 0, SWP_NOSIZE);
      Result:= TRUE;
    end;

    WM_COMMAND:
      begin
      if LOWORD(wParam) = IDOK then
        begin
        EndDialog(hWnd, IDOK);
        PlayMusic(SlapMus, FALSE);
      end;
      Result := TRUE;
    end;

    WM_CLOSE:
      begin
        EndDialog(hWnd, IDCANCEL);
        PlayMusic(SlapMus, FALSE);
        Result := TRUE;
      end;

  end;

end;

procedure PanggilAbout;
begin

  TampilDialog:= TRUE;
  DialogBox(hInstance, PChar('DLG_ABOUT'), MainWnd, @DlgPrc);
  TampilDialog:= FALSE;

end;

end.
