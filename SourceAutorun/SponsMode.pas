unit SponsMode;

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
  AppConst, KOL, KOLPng, BundleProcs, ShellAPI, MpatMode;

procedure Sponsor_Free;
procedure BuatSponsor;

implementation

var
  SudahBukaSpons: boolean = FALSE;
  BgScene: PPngObject;
  bm_Scene: BITMAP;

//==============================================================================

procedure Sponsor_Free;
begin
  if SudahBukaSpons then
    begin
    BgScene.Free;
  end;
end;

//==============================================================================

procedure Spons_Gambar(HndDC: HDC);
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

procedure Spons_Exit;
begin

  PlayMusic(SlapMus, FALSE);
  BuatMediaPartner;

end;

//==============================================================================

procedure Spons_KlikKiri(Mpos: TPoint);
begin

  Spons_Exit;

end;

//==============================================================================

procedure Spons_KiborTekan(Tombol: integer);
begin

  if Tombol = VK_RETURN then
    Spons_Exit;
    
end;

//==============================================================================

procedure BuatSponsor;
begin

  if not SudahBukaSpons then
    begin

    //Load semua gambar yang penting...
    BgScene:= MuatPngBundel(QuizBundle, GetFileOnBundle(QuizBundle, PChar('spons.png')));
    GetObject(BgScene.Bitmap.Handle, SizeOf(BITMAP), @bm_Scene);
    SudahBukaSpons:= TRUE;

  end;

  //Daftarkan event-event untuk Intro
  LepaskanEvent;
  @ProsGambar:= @Spons_Gambar;
  @ProsKlikKiri:= @Spons_KlikKiri;
  @ProsKiborTekan:= @Spons_KiborTekan;

  ReloadGambar;

end;

end.
