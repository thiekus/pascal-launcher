unit IntroMode;

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
  AppConst, KOL, KOLPng, BundleProcs, ShellAPI, SponsMode;

var
  MenuSelectedIndex: integer = 0;

procedure Intro_Free;
procedure BuatIntro;

implementation

const
  INM_1 : TRect = (Left:364; Top:56; Right:298; Bottom:48);
  INM_2 : TRect = (Left:364; Top:104; Right:298; Bottom:48);
  INM_3 : TRect = (Left:364; Top:152; Right:298; Bottom:48);
  INM_4 : TRect = (Left:364; Top:200; Right:298; Bottom:48);
  INM_5 : TRect = (Left:364; Top:248; Right:298; Bottom:48);
  INM_6 : TRect = (Left:364; Top:298; Right:298; Bottom:48);

  INM_7 : TRect = (Left:364; Top:376; Right:298; Bottom:48);
  INM_8 : TRect = (Left:364; Top:424; Right:298; Bottom:48);

  Brngd : TRect = (Left:36; Top:456; Right:200; Bottom:48);

  MaxIndex = 7;

var
  SudahBukaIntro: boolean = FALSE;
  BgIntro: PPngObject;
  bm_Intro: BITMAP;

//==============================================================================

procedure Intro_Free;
begin
  if SudahBukaIntro then
    begin
    BgIntro.Free;
  end;
end;

//==============================================================================

function Intro_CekMenu(Mpos: TPoint): integer;
var
  mne: array[0..MaxIndex] of TRect;
  f: integer;
begin

  Result:= -1;
  mne[0]:= BuatRect(INM_1.Left+WndX, INM_1.Top+WndY, INM_1.Right+INM_1.Left+WndX, INM_1.Bottom+INM_1.Top+WndY);
  mne[1]:= BuatRect(INM_2.Left+WndX, INM_2.Top+WndY, INM_2.Right+INM_2.Left+WndX, INM_2.Bottom+INM_2.Top+WndY);
  mne[2]:= BuatRect(INM_3.Left+WndX, INM_3.Top+WndY, INM_3.Right+INM_3.Left+WndX, INM_3.Bottom+INM_3.Top+WndY);
  mne[3]:= BuatRect(INM_4.Left+WndX, INM_4.Top+WndY, INM_4.Right+INM_4.Left+WndX, INM_4.Bottom+INM_4.Top+WndY);
  mne[4]:= BuatRect(INM_5.Left+WndX, INM_5.Top+WndY, INM_5.Right+INM_5.Left+WndX, INM_5.Bottom+INM_5.Top+WndY);
  mne[5]:= BuatRect(INM_6.Left+WndX, INM_6.Top+WndY, INM_6.Right+INM_6.Left+WndX, INM_6.Bottom+INM_6.Top+WndY);
  mne[6]:= BuatRect(INM_7.Left+WndX, INM_7.Top+WndY, INM_7.Right+INM_7.Left+WndX, INM_7.Bottom+INM_7.Top+WndY);
  mne[7]:= BuatRect(INM_8.Left+WndX, INM_8.Top+WndY, INM_8.Right+INM_8.Left+WndX, INM_8.Bottom+INM_8.Top+WndY);

  for f:= 0 to MaxIndex do
    if InRange(Mpos.X, mne[f].Left, mne[f].Right) and InRange(Mpos.Y, mne[f].Top, mne[f].Bottom) then
      Result:= f;

end;

//==============================================================================

procedure Intro_PilihMenu(index: integer);
var
  TampilPetunjuk: boolean;
begin

  if (index >= 0) and (index <= MaxIndex) then
    begin
    StopMusic(OpenMus);
    PlayMusic(SlapMus, FALSE);
  end;

  case index of
    0: ShellExecute(0, 'open', PChar(LokasiFoto), '', '', SW_SHOWNORMAL);
    1: ShellExecute(0, 'open', PChar(LokasiVideo), '', '', SW_SHOWNORMAL);
    2: ShellExecute(0, 'open', PChar(LokasiDokumentasi), '', '', SW_SHOWNORMAL);
    4: BuatSponsor;
    3: ShellExecute(0, 'open', PChar('http://pascal.fajarharapan.sch.id'), '', '', SW_SHOWNORMAL);
    5: ShellExecute(0, 'open', PChar(ExtractFilePath(ParamStr(0))), '', '', SW_SHOWNORMAL);
    6: PanggilAbout;
    7: PostMessage(MainWnd, WM_CLOSE, 0, 0);
  end;

end;

//==============================================================================

procedure Intro_Gambar(HndDC: HDC);
var
  mdc: HDC;
  BgBmp: PBitmap;
  o_intro, o_dfnt, o_brfn: HGDIOBJ;
  mnu_rect: array[0..MaxIndex] of TRect;
  mnu_text: array[0..MaxIndex] of string;
  brngdv: TRect;
  RectBayang: TRect;
  mi: integer;
  MnuFnt, BrngFnt: HFONT;
begin

  mdc:= CreateCompatibleDC(HndDC);
  BgBmp:= NewDIBBitmap(bm_Intro.bmWidth, bm_Intro.bmHeight, pf24Bit);
  BgBmp.Assign(BgIntro.Bitmap);
  o_intro:= SelectObject(mdc, BgBmp.Handle);

  MnuFnt:= CreateFont(30, 0, 0, 0, FW_DONTCARE, 0, 0, 0, DEFAULT_CHARSET,
                      OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, ANTIALIASED_QUALITY,
                      0, 'Comic Sans MS');
  o_dfnt:= SelectObject(mdc, MnuFnt);

  SetBkMode(mdc, TRANSPARENT);

  mnu_rect[0]:= INM_1;
  mnu_rect[1]:= INM_2;
  mnu_rect[2]:= INM_3;
  mnu_rect[3]:= INM_4;
  mnu_rect[4]:= INM_5;
  mnu_rect[5]:= INM_6;
  mnu_rect[6]:= INM_7;
  mnu_rect[7]:= INM_8;

  mnu_text[0]:= Mn_1;
  mnu_text[1]:= Mn_2;
  mnu_text[2]:= Mn_3;
  mnu_text[3]:= Mn_4;
  mnu_text[4]:= Mn_5;
  mnu_text[5]:= Mn_6;
  mnu_text[6]:= Mn_7;
  mnu_text[7]:= Mn_8;

  for mi:= 0 to MaxIndex do
    begin

    // Membuat bayangan teks jadi lebih cantik :)
    RectBayang:= mnu_rect[mi];
    RectBayang.Left:= RectBayang.Left+2;
    RectBayang.Top:= RectBayang.Top+2;
    RectBayang.Right:= RectBayang.Right+2;
    RectBayang.Bottom:= RectBayang.Bottom+2;

    SetTextColor(mdc, w_Bayangan);
    DrawText(mdc, PChar(mnu_text[mi]), -1, RectBayang, DT_SINGLELINE + DT_NOCLIP);

    // Baru buat teks aslinya
    if mi = MenuSelectedIndex then
      SetTextColor(mdc, w_TombolMenu_aktif) // kalo itu dipilih, warna kuning
    else
      SetTextColor(mdc, w_TombolMenu); // kalo gak, warna putih
    DrawText(mdc, PChar(mnu_text[mi]), -1, mnu_rect[mi], DT_SINGLELINE + DT_NOCLIP);

  end;

  BrngFnt:= CreateFont(16, 0, 0, 0, FW_DONTCARE, 0, 0, 0, DEFAULT_CHARSET,
                      OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, ANTIALIASED_QUALITY,
                      FW_BOLD, 'Arial');
  o_brfn:= SelectObject(mdc, BrngFnt);
  brngdv:= brngd;
  SetTextColor(mdc, w_TombolMenu);
  DrawText(mdc, PChar(UntukSekolah), -1, brngdv, DT_SINGLELINE + DT_NOCLIP);

  BitBlt(HndDC, 0, 0, WndW, WndH, mdc, 0, 0, SRCCOPY);

  SelectObject(mdc, o_intro);
  DeleteObject(o_intro);
  SelectObject(mdc, o_dfnt);
  DeleteObject(o_dfnt);
  SelectObject(mdc, o_brfn);
  DeleteObject(o_brfn);
  DeleteDC(mdc);

  BgBmp.Free;

end;

//==============================================================================

procedure Intro_MouseGerak(Mpos: TPoint);
var
  idx: integer;
begin

  idx:= Intro_CekMenu(Mpos);
  if (idx >= 0) and (idx <= MaxIndex) and (idx <> MenuSelectedIndex) then
    begin
    MenuSelectedIndex:= idx;
    PlayMusic(WhackMus, FALSE);
    ReloadGambar;
  end;

end;

//==============================================================================

procedure Intro_KlikKiri(Mpos: TPoint);
var
  idx: integer;
begin

  idx:= Intro_CekMenu(Mpos);
  Intro_PilihMenu(idx);

end;

//==============================================================================

procedure Intro_KiborTahan(Tombol: integer);
begin

  case Tombol of
    VK_UP : Dec(MenuSelectedIndex);
    VK_DOWN : Inc(MenuSelectedIndex);
  end;

  if (Tombol = VK_UP) or (Tombol = VK_DOWN) then
    begin

    if MenuSelectedIndex < 0 then
      MenuSelectedIndex:= MaxIndex
    else
    if MenuSelectedIndex > MaxIndex then
      MenuSelectedIndex:= 0;

    ReloadGambar;

  end;

end;

//==============================================================================

procedure Intro_KiborTekan(Tombol: integer);
begin

  if Tombol = VK_RETURN then
    Intro_PilihMenu(MenuSelectedIndex)
  else
  if (Tombol = VK_UP) or (Tombol = VK_DOWN) then
    PlayMusic(WhackMus, FALSE);

end;

//==============================================================================

procedure BuatIntro;
begin

  if not SudahBukaIntro then
    begin

    //Load semua gambar yang penting...
    BgIntro:= MuatPngBundel(QuizBundle, GetFileOnBundle(QuizBundle, PChar('intro_bg.png')));
    GetObject(BgIntro.Bitmap.Handle, SizeOf(BITMAP), @bm_Intro);
    SudahBukaIntro:= TRUE;

  end;

  //Daftarkan event-event untuk Intro
  LepaskanEvent;
  @ProsGambar:= @Intro_Gambar;
  @ProsMouseGerak:= @Intro_MouseGerak;
  @ProsKlikKiri:= @Intro_KlikKiri;
  @ProsKiborTahan:= @Intro_KiborTahan;
  @ProsKiborTekan:= @Intro_KiborTekan;

  ReloadGambar;

end;

end.
