unit SuppMode;

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

interface

uses
  Windows, Messages, AppVars, AppUtils, AppStrings, AboutDlg, SoundMixer,
  AppConst, KOL, KOLPng, BundleProcs, ShellAPI;

procedure Support_Free;
procedure BuatSupport;

implementation

uses
  IntroMode;

var
  SudahBukaSupport: boolean = FALSE;
  BgScene: PPngObject;
  bm_Scene: BITMAP;

//==============================================================================

procedure Support_Free;
begin
  if SudahBukaSupport then
    begin
    BgScene.Free;
  end;
end;

//==============================================================================

procedure Support_Gambar(HndDC: HDC);
var
  mdc: HDC;
  BgBmp: PBitmap;
  o_scne: HGDIOBJ;
begin

  mdc:= CreateCompatibleDC(HndDC);
  BgBmp:= NewDIBBitmap(bm_Scene.bmWidth, bm_Scene.bmHeight, pf24Bit);
  BgBmp.Assign(BgScene.Bitmap);
  o_scne:= SelectObject(mdc, BgBmp.Handle);

  BitBlt(HndDC, 0, 0, WndW, WndH, mdc, 0, 0, SRCCOPY);

  SelectObject(mdc, o_scne);
  DeleteObject(o_scne);
  DeleteDC(mdc);

  BgBmp.Free;

end;

//==============================================================================

procedure Support_Exit;
begin

  PlayMusic(SlapMus, FALSE);
  BuatIntro;

end;

//==============================================================================

procedure Support_KlikKiri(Mpos: TPoint);
begin

  Support_Exit;

end;

//==============================================================================

procedure Support_KiborTekan(Tombol: integer);
begin

  if Tombol = VK_RETURN then
    Support_Exit;
    
end;

//==============================================================================

procedure BuatSupport;
begin

  if not SudahBukaSupport then
    begin

    //Load semua gambar yang penting...
    BgScene:= MuatPngBundel(QuizBundle, GetFileOnBundle(QuizBundle, PChar('supp.png')));
    GetObject(BgScene.Bitmap.Handle, SizeOf(BITMAP), @bm_Scene);
    SudahBukaSupport:= TRUE;

  end;

  //Daftarkan event-event untuk Intro
  LepaskanEvent;
  @ProsGambar:= @Support_Gambar;
  @ProsKlikKiri:= @Support_KlikKiri;
  @ProsKiborTekan:= @Support_KiborTekan;

  ReloadGambar;

end;

end.
