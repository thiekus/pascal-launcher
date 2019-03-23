program PasLauncher;

(*==============================================================================

  Pascal Launcher Project
  Written by Faris Khowarizmi
  Copyright © Faris Khowarizmi

  Website: http://www.khayalan.web.id
  e-Mail: thekill96@gmail.com

  Program ini dapat dikembangkan secara bebas.
  Penulis tidak bertanggung jawab atas kesalahan yang ditimbulkan oleh program
  ini!

==============================================================================*)

{.$APPTYPE CONSOLE}

uses
  ScaleMM2,
  Windows,
  Messages,
  ActiveX,
  Variants,
  BundleProcs,
  BundleStruct,
  SoundMixer,
  AppStrings in 'AppStrings.pas',
  AppConst in 'AppConst.pas',
  AppRes in 'APPRES.pas',
  IntroMode in 'IntroMode.pas',
  AppVars in 'AppVars.pas',
  AppUtils in 'AppUtils.pas',
  AppTypes in 'AppTypes.pas',
  LaunchCfg in 'LaunchCfg.pas',
  SponsMode in 'SponsMode.pas',
  MpatMode in 'MpatMode.pas',
  SuppMode in 'SuppMode.pas';

{.$R RES\QEXT.RES}
{$R *.RES}
{$R RES\QRES.RES}
{$R RES\XP-THEME.RES}

//=== Bagian WindowProc dari Game ==============================================

function WndProc(HWnd: HWND; uMsg: Cardinal; WParam: Cardinal; LParam: Cardinal): LResult; stdcall;
var
  DiHandle: Boolean;
  wdc: HDC;
  ps: PAINTSTRUCT;
  npos: TPoint;
  WName: WideString;
begin

  Result:= 0;
  DiHandle:= FALSE;

  case uMsg of

    WM_CREATE:
      begin

        WName:= AnsiToUTF8(ExtractFilePath(ParamStr(0))+'PasRes.kbd');
        QuizBundle:= AssignReadBundle(PWideChar(WName));

        MixerInit(MainWnd, EnableSound);
        LoadSegmentFromBundle(QuizBundle, GetFileOnBundle(QuizBundle, PChar('whack.wav')), WhackMus);
        LoadSegmentFromBundle(QuizBundle, GetFileOnBundle(QuizBundle, PChar('slap.wav')), SlapMus);
        LoadSegmentFromBundle(QuizBundle, GetFileOnBundle(QuizBundle, PChar('opening.wav')), OpenMus);

        RegIntroMusic(OpenMus);
        PlayMusic(OpenMus, FALSE);

        DapatkanKonfigurasi;

        BuatIntro;
        DiHandle:= TRUE;
        Result:= 1;

      end;

    WM_DESTROY:
      begin

        UnLoadSegment(WhackMus);
        UnLoadSegment(SlapMus);
        UnLoadSegment(OpenMus);
        MixerClose;

        DeleteObject(WndBrush);

        if QuizBundle <> nil then
          begin
          CloseBundle(QuizBundle);
          FreeBundle(QuizBundle);
        end;

        Intro_Free;
        Sponsor_Free;
        Mpat_Free;
        Support_Free;

        DiHandle:= TRUE;
        Result:= 1;

      end;

    WM_CLOSE:
      begin
        SedangJalan:= FALSE;
        DiHandle:= TRUE;
        Result:= 1;
      end;

    WM_SETFOCUS:
      begin
        HaveFocus:= TRUE;
        DiHandle:= TRUE;
        Result:= 1;
      end;

    WM_KILLFOCUS:
      begin
        HaveFocus:= FALSE;
        DiHandle:= TRUE;
        Result:= 1;
      end;

    WM_DISPLAYCHANGE:
      begin
        ReloadGambar;
        DiHandle:= TRUE;
        Result:= 0;
      end;

    WM_CHAR:
      begin
        //if @ProsKiborTekan <> nil then
        //  ProsKiborTekan(WParam);
        DiHandle:= TRUE;
        Result:= 1;
      end;

    WM_KEYDOWN:
      begin
        if @ProsKiborTahan <> nil then
          ProsKiborTahan(WParam);
        if @ProsKiborTekan <> nil then
          OnKey[WParam]:= TRUE;
        DiHandle:= TRUE;
        Result:= 1;
      end;

    WM_KEYUP:
      begin
        if @ProsKiborLepas <> nil then
          ProsKiborLepas(WParam);
        if @ProsKiborTekan <> nil then
          if OnKey[WParam] then
            begin
            OnKey[WParam]:= FALSE;
            ProsKiborTekan(WParam);
          end;
        DiHandle:= TRUE;
        Result:= 1;
      end;

    WM_MOVE:
      begin
        WndX:= LoWord(LParam);
        WndY:= LParam shr 16;
        DiHandle:= TRUE;
        Result:= 1;
      end;

    WM_MOUSEMOVE:
      begin
        if @ProsMouseGerak <> nil then
          begin
          npos.X:= LoWord(LParam)+WndX;
          npos.Y:= (LParam shr 16)+Cardinal(WndY);
          ProsMouseGerak(npos);
        end;
        DiHandle:= TRUE;
        Result:= 1;
    end;

    WM_LBUTTONDOWN:
      begin
        if @ProsKlikKiri <> nil then
          begin
          npos.X:= LoWord(LParam)+WndX;
          npos.Y:= (LParam shr 16)+Cardinal(WndY);
          ProsKlikKiri(npos);
        end;
        DiHandle:= TRUE;
        Result:= 1;
    end;

    WM_SIZE:
      begin
        UpdateWindow(MainWnd);
        DiHandle:= TRUE;
        Result:= 1;
      end;

    WM_PAINT:
      begin
        if @ProsGambar <> nil then
          begin
          wdc:= BeginPaint(MainWnd, ps);
          try
            ProsGambar(wdc);
          finally
            EndPaint(MainWnd, ps);
          end;
        end;
        //ValidateRect(MainWnd, nil);
        DiHandle:= TRUE;
        Result:= 0;
      end;

  end;

  if not DiHandle then
    Result:= DefWindowProc(HWnd, uMsg, WParam, LParam);

end;

//=== Memproses pesan ==========================================================

procedure MessageLoop;
var
  Msg: TMsg;
begin

  SedangJalan:= TRUE;

  while SedangJalan do
    begin

    GetMessage(Msg, MainWnd, 0, 0);
    TranslateMessage(Msg);
    DispatchMessage(Msg);

    if @ProsIdle <> nil then
      ProsIdle;

  end;

  DestroyWindow(MainWnd);

end;

//=== Buat jendela untuk aplikasi ==============================================

procedure BuatJendela;
const
  MainIco = 'MAINICON';
  MainCur = 'CUR_MAIN';
var
  wc: TWndClass;
  crect, drect: TRect;
  nx, ny, nw, nh: integer;
begin

  WndBrush:= CreateSolidBrush(0);
  wc.style:= CS_HREDRAW or CS_VREDRAW or CS_OWNDC;
  wc.lpfnWndProc:= @WndProc;
  wc.cbClsExtra:= 0;
  wc.cbWndExtra:= 0;
  wc.hInstance:= HInstance;
  wc.hIcon:= 0;
  wc.hCursor:= 0;
  wc.hbrBackground:= WndBrush;
  wc.lpszMenuName:= nil;
  wc.lpszClassName:= PChar(ClsName);

  if RegisterClass(wc) = 0 then
    begin
    MessageBox(0, PChar(Err_Regclass), PChar(Cap_Err), MB_ICONERROR);
    Halt;
  end;

  MainWnd:= CreateWindowEx(0,
                           PChar(ClsName),
                           PChar(AppName),
                           WS_CAPTION + WS_SYSMENU + WS_MINIMIZEBOX,
                           0,
                           0,
                           WndW,
                           WndH,
                           0,
                           0,
                           HInstance,
                           nil);

  if MainWnd = 0 then
    begin
    MessageBox(0, PChar(Err_Crtmwnd), PChar(Cap_Err), MB_ICONERROR);
    Halt;
  end;

  SetClassLong(MainWnd, GCL_HICON, LoadIcon(HInstance, MainIco));
  SetClassLong(MainWnd, GCL_HCURSOR, LoadCursor(HInstance, MainCur));
  GetWindowRect(MainWnd, WndRect);
  GetClientRect(MainWnd, crect);
  GetClientRect(GetDesktopWindow, drect);

  nw:= WndW+(WndW-(crect.Right-crect.Left));
  nh:= WndH+(WndH-(crect.Bottom-crect.Top));
  nx:= ((drect.Right-drect.Left)-nw) div 2;
  ny:= ((drect.Bottom-drect.Top)-nh) div 2;

  if ny < 0 then
    ny:= 0;

  SetWindowPos(MainWnd, HWND_TOP, nx, ny, nw, nh, 0);
  UpdateWindow(MainWnd);
  ShowWindow(MainWnd, SW_SHOW);

end;

//=== Baca parameter yang masuk ke game ========================================

procedure BacaParameter;
var
  i: integer;
  par: string;
begin
  FullScreen:= FALSE;//TRUE;
  EnableSound:= TRUE;
  if ParamCount > 0 then
    begin
    for i:= 1 to ParamCount do
      begin
      par:= ParamStr(i);
      //if par = '-wnd' then
      //  FullScreen:= FALSE;
      if par = '-nsd' then
        EnableSound:= FALSE;
    end;
  end;
end;

//==============================================================================

var
  AppMutx: THandle;
  RunWnd: HWND;
begin

  AppMutx:= CreateMutex(nil, TRUE, PChar(AppGUID));
  if GetLastError = ERROR_ALREADY_EXISTS then
    begin
    RunWnd:= FindWindow(PChar(ClsName), PChar(AppName));
    if RunWnd <> 0 then
      begin
      ShowWindow(RunWnd, SW_SHOW);
      SetForegroundWindow(RunWnd);
    end
    else
      MessageBox(0, PChar(Err_IsRunWd), PChar(Cap_Err), MB_ICONERROR);
    Halt;
  end;

  CoInitialize(nil);

  try

    BacaParameter;
    BuatJendela;
    MessageLoop;

  finally

    CoUninitialize;
    ReleaseMutex(AppMutx);

  end;

end.
