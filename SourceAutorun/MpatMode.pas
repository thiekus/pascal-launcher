unit MpatMode;

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
  AppConst, KOL, KOLPng, BundleProcs, ShellAPI, SuppMode;

procedure Mpat_Free;
procedure BuatMediaPartner;

implementation

var
  SudahBukaMedia: boolean = FALSE;
  BgScene: PPngObject;
  bm_Scene: BITMAP;

//==============================================================================

procedure Mpat_Free;
begin
  if SudahBukaMedia then
    begin
    BgScene.Free;
  end;
end;

//==============================================================================

procedure Mpat_Gambar(HndDC: HDC);
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

procedure Mpat_Exit;
begin

  PlayMusic(SlapMus, FALSE);
  BuatSupport;

end;

//==============================================================================

procedure Mpat_KlikKiri(Mpos: TPoint);
begin

  Mpat_Exit;

end;

//==============================================================================

procedure Mpat_KiborTekan(Tombol: integer);
begin

  if Tombol = VK_RETURN then
    Mpat_Exit;
    
end;

//==============================================================================

procedure BuatMediaPartner;
begin

  if not SudahBukaMedia then
    begin

    //Load semua gambar yang penting...
    BgScene:= MuatPngBundel(QuizBundle, GetFileOnBundle(QuizBundle, PChar('mpat.png')));
    GetObject(BgScene.Bitmap.Handle, SizeOf(BITMAP), @bm_Scene);
    SudahBukaMedia:= TRUE;

  end;

  //Daftarkan event-event untuk Intro
  LepaskanEvent;
  @ProsGambar:= @Mpat_Gambar;
  @ProsKlikKiri:= @Mpat_KlikKiri;
  @ProsKiborTekan:= @Mpat_KiborTekan;

  ReloadGambar;

end;

end.
