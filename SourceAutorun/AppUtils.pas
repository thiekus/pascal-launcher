unit AppUtils;

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
  Windows, AppVars, AppStrings, KOL, KOLPng, BundleProcs, BundleStruct;

procedure LepaskanEvent;
procedure ReloadGambar;
function ExtractFilePath(sFile: string): string;
function AspectRatio(SourceW, SourceH, MaxW, MaxH: integer): TRect;
function MuatBitmapRes(NamaRes: string): HBITMAP;
function MuatBitmapFile(NamaFile: string): HBITMAP;
function MuatPngFile(NamaFile: string): PPngObject;
function MuatPngBundel(BundleDef: PBundleDefinition; Index: integer): PPngObject;
function BuatRect(Kiri, Atas, Kanan, Bawah: integer): TRect;
function DateTime2Str(Time: SYSTEMTIME): string;
function InRange(const AValue, AMin, AMax: Integer): Boolean;
function FormatStr(Src: string; Args: array of const): string;
function TickKeWaktu(Tc: Cardinal): string;

implementation

procedure LepaskanEvent;
begin
  @ProsIdle:= nil;
  @ProsGambar:= nil;
  @ProsMouseGerak:= nil;
  @ProsKlikKiri:= nil;
  @ProsKiborTekan:= nil;
  @ProsKiborTahan:= nil;
  @ProsKiborLepas:= nil;
end;

procedure ReloadGambar;
begin

  InvalidateRect(MainWnd, nil, FALSE);
  
end;

function ExtractFilePath(sFile: string): string;
var
  i: Integer;
begin
  Result := '';
  if (sFile <> '') then begin
    for i := Length(sFile) downto 1 do begin
      if (sFile[i] = '\') or (sFile[i] = ':') then begin
        Result := Copy(sFile, 1, i);
        Break;
      end;
    end;
  end;
end;

function AspectRatio(SourceW, SourceH, MaxW, MaxH: integer): TRect;
// Based on
// http://www.efg2.com/Lab/ImageProcessing/AspectRatio.htm
var
  Half: integer;
  WH: integer;
begin

  if (SourceW <= 0) or (SourceH <= 0) or (MaxW <= 0) or (MaxH <= 0) then
    Exit;

  if (SourceW / SourceH) < (MaxW / MaxH) then
    begin

    // Stretch Height to match.
    Result.Top    := 0;
    Result.Bottom := MaxH;

    // Adjust and center Width.
    WH := MulDiv(MaxH, SourceW, SourceH);
    Half:= (MaxW - WH) div 2;

    Result.Left  := Half;
    Result.Right := Result.Left + WH;

  end
  else
    begin

    // Stretch Width to match.
    Result.Left    := 0;
    Result.Right   := MaxW;

    // Adjust and center Height.
    WH := MulDiv(MaxW, SourceH, SourceW);
    Half := (MaxH - WH) div 2;

    Result.Top    := Half;
    Result.Bottom := Result.Top + WH;

  end;

end;

function MuatBitmapRes(NamaRes: string): HBITMAP;
begin
  Result:= LoadImage(hInstance, PChar(NamaRes), IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION + LR_DEFAULTSIZE);
end;

function MuatBitmapFile(NamaFile: string): HBITMAP;
begin
  Result:= LoadImage(hInstance, PChar(NamaFile), IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE + LR_CREATEDIBSECTION + LR_DEFAULTSIZE);
end;

function MuatPngFile(NamaFile: string): PPngObject;
begin

  Result:= NewPngObject;
  Result.LoadFromFile(NamaFile);

end;

function MuatPngBundel(BundleDef: PBundleDefinition; Index: integer): PPngObject;
const
  bufsz = $4000;
var
  bndf: PStream;
  ptrl: Pointer;
  sz, sr, bsbf: Cardinal;
begin

  Result:= NewPngObject;
  bndf:= NewMemoryStream;
  try
    sz:= GetFileBundleSize(BundleDef, Index); // cari besar bundel terpilih
    bndf.Size:= sz;
    SetFileBundlePos(BundleDef, Index, 0); // jangan lupa ke offset awal bundel
    sr:= 0;
    bndf.Position:= 0;
    GetMem(ptrl, bufsz);
    try
      while sr < sz do
        begin
        if sz-sr > bufsz then
          bsbf:= bufsz
        else
          bsbf:= sz-sr;
        ReadBundleBuffer(BundleDef, Index, ptrl^, bsbf);
        bndf.Write(ptrl^, bsbf);
        sr:= sr+bsbf;
      end;
    finally
      FreeMem(ptrl, bufsz);
    end;
    bndf.Position:= 0;
    Result.LoadFromStream(bndf);
  finally
    bndf.Free;
  end;

end;

function BuatRect(Kiri, Atas, Kanan, Bawah: integer): TRect;
begin
  Result.Left:= Kiri;
  Result.Top:= Atas;
  Result.Right:= Kanan;
  Result.Bottom:= Bawah;
end;

function DateTime2Str(Time: SYSTEMTIME): string;
var
  d, m, h, mi, s: string;
begin

  d:= Int2Str(Time.wDay);
  if Time.wDay < 10 then
    d:= '0'+d;

  m:= Int2Str(Time.wMonth);
  if Time.wMonth < 10 then
    m:= '0'+m;

  h:= Int2Str(Time.wHour);
  if Time.wHour < 10 then
    h:= '0'+h;

  mi:= Int2Str(Time.wMinute);
  if Time.wMinute < 10 then
    mi:= '0'+mi;

  s:= Int2Str(Time.wSecond);
  if Time.wSecond < 10 then
    s:= '0'+s;

  Result:= FormatStr(Qz_dtm, [d, m, Int2Str(Time.wYear), h, mi, s]);

end;

// InRange basis dari FastCode. Lebih cepat dari Math bawaan delphi 2007 kebawah
function InRange(const AValue, AMin, AMax: Integer): Boolean;
var
  A,B: Boolean;
begin
  A := (AValue >= AMin);
  B := (AValue <= AMax);
  Result := B and A;
end;

function FormatStr(Src: string; Args: array of const): string;
var
  buf: PChar;
begin
  if FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER + FORMAT_MESSAGE_FROM_STRING + FORMAT_MESSAGE_ARGUMENT_ARRAY, PChar(Src), 0, 0, @buf, SizeOf(buf), @Args) > 0 then
    Result:= buf
  else
    Result:= '';
  LocalFree(Cardinal(buf));
end;

function TickKeWaktu(Tc: Cardinal): string;
var
  h, m, s: integer;
  sh, sm, ss: string;
begin

  h:= Tc div 3600000;
  Tc:= Tc - (h * 3600000);
  m:= Tc div 60000;
  Tc:= Tc - (m * 60000);
  s:= Tc div 1000;

  sh:= Int2Str(h);
  if h < 10 then
    sh:= '0'+sh;

  sm:= Int2Str(m);
  if m < 10 then
    sm:= '0'+sm;

  ss:= Int2Str(s);
  if s < 10 then
    ss:= '0'+ss;

  Result:= FormatStr(Qz_gtm, [sh, sm, ss]);

end;


end.
