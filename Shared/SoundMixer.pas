unit SoundMixer;

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
  Windows, AppUtils, ActiveX, DirectMusic, AppTypes, BundleProcs, BundleStruct;

  function MixerInit(FocusWnd: HWND; HWEnable: Boolean): Boolean;
  procedure MixerClose;
  procedure LoadSegmentFromFile(Path: string; var src: TMusicSource);
  procedure LoadSegmentFromBundle(BundleDef: PBundleDefinition; BundleIndex: integer; var src: TMusicSource);
  procedure UnloadSegment(src: TMusicSource);
  procedure PlayMusic(src: TMusicSource; Loop: boolean);
  procedure StopMusic(src: TMusicSource);
  procedure RegIntroMusic(intm: TMusicSource);

implementation

var
  NyalakanSound: boolean;
  SPerformance: IDirectMusicPerformance8;
  SLoader: IDirectMusicLoader8;
  SAudioPath: IDirectMusicAudioPath;
  RegisterIntro: TMusicSource;

function MixerInit(FocusWnd: HWND; HWEnable: Boolean): Boolean;
begin

  NyalakanSound:= HWEnable;
  if not HWEnable then
    begin
    Result:= FALSE;
    Exit;
  end;

  CoCreateInstance(CLSID_DirectMusicPerformance,
                   nil,
                   CLSCTX_INPROC,
                   IID_IDirectMusicPerformance8,
                   SPerformance);

  CoCreateInstance(CLSID_DirectMusicLoader,
                   nil,
                   CLSCTX_INPROC,
                   IID_IDirectMusicLoader8,
                   SLoader);

  SPerformance.InitAudio(nil,
                         nil,
                         FocusWnd,
                         DMUS_APATH_SHARED_STEREOPLUSREVERB,
                         64,
                         DMUS_AUDIOF_ALL,
                         nil);

  SPerformance.CreateStandardAudioPath(DMUS_APATH_SHARED_STEREOPLUSREVERB,
                                       64,
                                       TRUE,
                                       SAudioPath);

  Result:= TRUE;

end;

procedure MixerClose;
begin

  if not NyalakanSound then
    Exit;

  //SLoader.CollectGarbage;
  //SPerformance.CloseDown;
  SAudioPath:= nil;
  SPerformance:= nil;
  SLoader:= nil;

end;

procedure LoadSegmentFromFile(Path: string; var src: TMusicSource);
var
  objdesc: TDMus_ObjectDesc;
  fh: THandle;
  FileSize: Cardinal;
  ptr: Pointer;
  buffer: array[0..$FFFF] of char;
  bsize, n, cb, cnt: Cardinal;
begin

  if not NyalakanSound then
    Exit;

  FillChar(src, SizeOf(TMusicSource), 0);
  FillChar(objdesc, SizeOf(objdesc), 0);
  fh:= CreateFileA(PChar(Path), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if fh <> 0 then
    begin
    SetFilePointer(fh, 0, nil, FILE_BEGIN);
    FileSize:= GetFileSize(fh, nil);
    objdesc.dwSize:= SizeOf(TDMus_ObjectDesc);
    objdesc.dwValidData:= DMUS_OBJ_CLASS or DMUS_OBJ_MEMORY;
    objdesc.guidClass:= CLSID_DirectMusicSegment;
    objdesc.llMemLength:= FileSize;
    src.Size:= FileSize;
    GetMem(ptr, FileSize);
    objdesc.pbMemData:= ptr;
    src.Location:= ptr;
    BSize:= SizeOf(buffer);
    cnt:= FileSize;
    while cnt <> 0 do
      begin
      if cnt > BSize then
        N:= BSize
      else
        N:= cnt;
      ReadFile(fh, buffer, N, cb, nil);
      CopyMemory(ptr, @buffer, N);
      ptr:= pointer(cardinal(ptr)+N);
      Dec(cnt, N);
    end;
    CloseHandle(fh);
    SLoader.GetObject(objdesc,
                      IID_IDirectMusicSegment8,
                      src.Source);
    src.Source.Download(SAudioPath);

  end;

end;

procedure LoadSegmentFromBundle(BundleDef: PBundleDefinition; BundleIndex: integer; var src: TMusicSource);
var
  objdesc: TDMus_ObjectDesc;
  FileSize: Cardinal;
  ptr: Pointer;
  buffer: array[0..$FFFF] of char;
  bsize, n, cnt: Cardinal;
begin

  if not NyalakanSound then
    Exit;

  FillChar(src, SizeOf(TMusicSource), 0);
  FillChar(objdesc, SizeOf(objdesc), 0);
  SetFileBundlePos(BundleDef, BundleIndex, 0);

  FileSize:= GetFileBundleSize(BundleDef, BundleIndex);
  objdesc.dwSize:= SizeOf(TDMus_ObjectDesc);
  objdesc.dwValidData:= DMUS_OBJ_CLASS or DMUS_OBJ_MEMORY;
  objdesc.guidClass:= CLSID_DirectMusicSegment;
  objdesc.llMemLength:= FileSize;
  src.Size:= FileSize;
  GetMem(ptr, FileSize);
  objdesc.pbMemData:= ptr;
  src.Location:= ptr;
  BSize:= SizeOf(buffer);
  cnt:= FileSize;
  while cnt <> 0 do
    begin
    if cnt > BSize then
      N:= BSize
    else
      N:= cnt;
    ReadBundleBuffer(BundleDef, BundleIndex, buffer, N);
    CopyMemory(ptr, @buffer, N);
    ptr:= pointer(cardinal(ptr)+N);
    Dec(cnt, N);
  end;

  SLoader.GetObject(objdesc,
                    IID_IDirectMusicSegment8,
                    src.Source);
  src.Source.Download(SAudioPath);

end;

procedure UnloadSegment(src: TMusicSource);
begin

  if not NyalakanSound then
    Exit;

  SPerformance.StopEx(src.Source, 0, 0);
  src.Source.Unload(SPerformance);
  SLoader.ReleaseObjectByUnknown(src.Source);
  src.Source:= nil;
  FreeMem(src.Location, src.Size);

end;

procedure PlayMusic(src: TMusicSource; Loop: boolean);
begin

  if not NyalakanSound then
    Exit;

  if SPerformance.IsPlaying(RegisterIntro.Source, nil) = S_OK then
    Exit;

  if SPerformance.IsPlaying(src.Source, nil) = S_OK then
    SPerformance.StopEx(src.Source, 0, 0);

  if Loop then
    src.Source.SetRepeats(DMUS_SEG_REPEAT_INFINITE)
  else
    src.Source.SetRepeats(0);

  SPerformance.PlaySegmentEx(src.Source,
                             nil,
                             nil,
                             DMUS_SEGF_SECONDARY,
                             0,
                             @src.State,
                             nil,
                             SAudioPath);

end;

procedure StopMusic(src: TMusicSource);
begin
  SPerformance.StopEx(src.Source, 0, 0);
end;

procedure RegIntroMusic(intm: TMusicSource);
begin
  RegisterIntro:= intm;
end;

end.
