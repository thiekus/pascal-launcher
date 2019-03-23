library DataBundle;

(*==============================================================================

  Khayalan Data Bundle
  Since 7 Juli 2013 
  Written by Faris Khowarizmi
  Copyright © Khayalan Software 2013-2014

  Website: http://www.khayalan.web.id
  e-Mail: thekill96@gmail.com

  Program ini dapat dikembangkan secara bebas.
  Penulis tidak bertanggung jawab atas kesalahan yang ditimbulkan oleh program
  ini!

==============================================================================*)

uses
  Windows,
  BundleStruct in '..\Shared\BundleStruct.pas';

{$R *.res}
{$R BundRes.res}

//=== RTL milik Delphi - untuk mengurangi depedensi SysUtils! ==================

type
  LongRec = packed record
    Lo, Hi: Word;
  end;

function FileExists(const FileName: String): Boolean;

  function FileAge(const FileName: String): Integer;
  var
    Handle: THandle;
    FindData: _WIN32_FIND_DATA;
    LocalFileTime: TFileTime;
  begin
    Handle := FindFirstFile(PChar(FileName), FindData);
    if Handle <> INVALID_HANDLE_VALUE then
    begin
      Windows.FindClose(Handle);
      if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
      begin
        FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
        if FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi,
          LongRec(Result).Lo) then Exit;
      end;
    end;
    Result := -1;
  end;

begin
  Result := FileAge(FileName) <> -1;
end;

function ExtractFileExt(const FileName: string): string;
var
  i: Integer;
  r: string;
begin
  r:= '';
  for i:= Length(FileName) to 1 do
    begin
    r:= FileName[i]+r;
    if FileName[i] = '.' then
      Break;
  end;
  Result:= r;
end;

function ExtractFileName(const FileName: string): string;
var
  i: Integer;
  r: string;
begin
  r:= '';
  for i:= Length(FileName) downto 1 do
    begin
    if FileName[i] = '\' then
      Break;
    r:= FileName[i]+r;
  end;
  Result:= r;
end;

//==============================================================================

procedure CalcCRC32(p:  pointer; ByteCount:  DWORD; var CRCValue:  DWORD);
const
    table:  array[0..255] of dword =
   ($00000000, $77073096, $EE0E612C, $990951BA,
    $076DC419, $706AF48F, $E963A535, $9E6495A3,
    $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988,
    $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91,
    $1DB71064, $6AB020F2, $F3B97148, $84BE41DE,
    $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC,
    $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
    $3B6E20C8, $4C69105E, $D56041E4, $A2677172,
    $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
    $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940,
    $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
    $26D930AC, $51DE003A, $C8D75180, $BFD06116,
    $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
    $2802B89E, $5F058808, $C60CD9B2, $B10BE924,
    $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,

    $76DC4190, $01DB7106, $98D220BC, $EFD5102A,
    $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433,
    $7807C9A2, $0F00F934, $9609A88E, $E10E9818,
    $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
    $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
    $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
    $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C,
    $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
    $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2,
    $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
    $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
    $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
    $5005713C, $270241AA, $BE0B1010, $C90C2086,
    $5768B525, $206F85B3, $B966D409, $CE61E49F,
    $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4,
    $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,

    $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A,
    $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
    $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8,
    $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1,
    $F00F9344, $8708A3D2, $1E01F268, $6906C2FE,
    $F762575D, $806567CB, $196C3671, $6E6B06E7,
    $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC,
    $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
    $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252,
    $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
    $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60,
    $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
    $CB61B38C, $BC66831A, $256FD2A0, $5268E236,
    $CC0C7795, $BB0B4703, $220216B9, $5505262F,
    $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04,
    $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,

    $9B64C2B0, $EC63F226, $756AA39C, $026D930A,
    $9C0906A9, $EB0E363F, $72076785, $05005713,
    $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38,
    $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21,
    $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E,
    $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
    $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
    $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
    $A00AE278, $D70DD2EE, $4E048354, $3903B3C2,
    $A7672661, $D06016F7, $4969474D, $3E6E77DB,
    $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0,
    $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
    $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6,
    $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
    $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D);

var
  i:  DWORD;
  q:  ^BYTE;
begin
  q := p;
  for   i := 0 TO ByteCount-1 do begin
    CRCvalue := (CRCvalue shr 8)  xor
    Table[ q^ xor (CRCvalue and $000000FF) ];
    inc(q)
  end;
end;

function TruncateToMaxChars(Inp: string): string;
var
  Ext: string;
  TruncStr: string;
begin

  Ext:= ExtractFileExt(Inp);
  TruncStr:= Copy(Inp, 1, MaxBundleNameLength-1-Length(Ext));
  Result:= TruncStr+'~'+Ext;

end;

function AssignReadBundle(BundlePath: PWideChar): PBundleDefinition; stdcall;
var
  TempHn: Cardinal;
  NoCard: Cardinal;
  BunHdr: TBundleHeader;
  SizeMemBun: Cardinal;
  ptr: PBundleDefinition;
  copyPtr: PBundleFile;
  x: integer;
begin

  TempHn:= CreateFileW(BundlePath, GENERIC_READ, 0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if TempHn <> INVALID_HANDLE_VALUE then
    begin
    SetFilePointer(TempHn, 0, nil, FILE_BEGIN);
    if GetFileSize(TempHn, nil) >= SizeOf(TBundleHeader) then
      begin
      ReadFile(TempHn, BunHdr, SizeOf(BunHdr), NoCard, nil);
      if BunHdr.BundleId = BundHeaderString then
        if BunHdr.FileOnBundle > 0 then
          begin
          SizeMemBun:= SizeOf(TBundleDefinition)+(BunHdr.FileOnBundle*SizeOf(TBundleFile));
          GetMem(ptr, SizeMemBun);
          ZeroMemory(ptr, SizeMemBun);
          ptr.BundleHandle:= TempHn;
          ptr.FileOnBundle:= BunHdr.FileOnBundle;
          ptr.SizeOfMem:= SizeMemBun;
          copyPtr:= Pointer(Cardinal(ptr)+SizeOf(TBundleDefinition));
          for x:= 0 to BunHdr.FileOnBundle-1 do
            begin
            ReadFile(TempHn, copyPtr^, SizeOf(TBundleFile), NoCard, nil);
            copyPtr:= Pointer(Cardinal(copyPtr)+SizeOf(TBundleFile));
          end;
          Result:= ptr;
          Exit;
        end;
    end;
    CloseHandle(TempHn);
    Result:= nil;
  end
  else
    Result:= nil;

end;

function CreateBundleFile(FileOutput: PWideChar; NumOfFiles: LongInt; WriteCallback: PBundleWriteCallback): boolean; stdcall;
var
  Buf: PChar;
  TempHn, TempIn: Cardinal;
  HeaderSize: LongInt;
  Mem: Pointer;
  Headerp: PBundleHeader;
  Filep: PBundleFile;
  NoCard: Cardinal;
  ReadSrc: Cardinal;
  ReadBin: Cardinal;
  FSz: Cardinal;
  Filepath: PAnsiChar;
  Filename: string;
  Namemod: TBundleFileName;
  x: integer;
  Ps: Int64;
  CRCVal: Cardinal;
  BunSrc: PBundleSource;
begin

  TempHn:= CreateFileW(FileOutput, GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if TempHn <> INVALID_HANDLE_VALUE then
    begin
    HeaderSize:= SizeOf(TBundleHeader)+(SizeOf(TBundleFile)*NumOfFiles);
    GetMem(Buf, BundMemBuffer);
    GetMem(Mem, HeaderSize);
    GetMem(BunSrc, SizeOf(TBundleSource));
    try
      ZeroMemory(Buf, BundMemBuffer);
      ZeroMemory(Mem, HeaderSize);
      ZeroMemory(BunSrc, SizeOf(TBundleSource));
      Headerp:= Mem;
      Headerp^.BundleId:= BundHeaderString;
      Headerp^.Version:= BundleVersion;
      Headerp^.FileOnBundle:= NumOfFiles;
      Headerp^.SizeOfList:= HeaderSize-SizeOf(TBundleHeader);
      WriteFile(TempHn, Mem^, HeaderSize, NoCard, nil);
      Ps:= Int64(HeaderSize);
      for x:= 0 to NumOfFiles-1 do
        begin
        Filep:= Pointer(LongInt(Mem)+SizeOf(TBundleHeader)+(SizeOf(TBundleFile)*x));
        //WriteCallback^(@BunSrc, x+1); => with this get error :p
        asm
          mov eax, x
          add eax, 1
          push eax
          mov eax, dword ptr[BunSrc]
          push eax
          call WriteCallback
        end;
        Filepath:= BunSrc^.FilePath;
        if FileExists(Filepath) then
          begin
          if BunSrc^.AliasName <> nil then
            Filename:= BunSrc^.AliasName
          else
            Filename:= ExtractFileName(Filepath);
          if Length(Filename) > MaxBundleNameLength then
            FileName:= TruncateToMaxChars(Filename);
          Filep^.BundleNameSize:= Byte(Length(Filename));
          ZeroMemory(@Namemod, SizeOf(TBundleFileName));
          CopyMemory(@Namemod, PAnsiChar(Filename), Length(Filename));
          Filep^.BundleName:= Namemod;
          Filep^.BundlePos:= Ps;
          TempIn:= CreateFileA(Filepath, GENERIC_READ, 0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
          if TempIn <> INVALID_HANDLE_VALUE then
            try
              SetFilePointer(TempIn, 0, nil, FILE_BEGIN);
              FSz:= GetFileSize(TempIn, nil);
              ReadSrc:= 0;
              CRCVal:= $FFFFFFFF;
              while ReadSrc < FSz do
                begin
                if FSz-ReadSrc > BundMemBuffer then
                  ReadBin:= BundMemBuffer
                else
                  ReadBin:= FSz-ReadSrc;
                ReadFile(TempIn, Buf^, ReadBin, NoCard, nil);
                CalcCRC32(Buf, ReadBin, CRCVal);
                WriteFile(TempHn, Buf^, ReadBin, NoCard, nil);
                ReadSrc:= ReadSrc + ReadBin;
                Ps:= Ps + Int64(ReadBin);
              end;
              Filep^.BundleSize:= FSz;
              Filep^.BundleCRC32:= not CRCVal;
            finally
              CloseHandle(TempIn);
            end;
        end;
      end;
      SetFilePointer(TempHn, 0, nil, FILE_BEGIN);
      Headerp^.SizeOfBundle:= Ps-Int64(HeaderSize);
      WriteFile(TempHn, Mem^, HeaderSize, NoCard, nil);
    finally
      if BunSrc <> nil then
        begin
        if BunSrc^.FilePath <> nil then
          FreeMem(BunSrc^.FilePath, BunSrc^.FilePathLength);
        if BunSrc^.AliasName <> nil then
          FreeMem(BunSrc^.AliasName, BunSrc^.AliasNameLength);
      end;
      FreeMem(Mem, HeaderSize);
      FreeMem(Buf, BundMemBuffer);
      FreeMem(BunSrc, SizeOf(TBundleSource));
    end;
    CloseHandle(TempHn);
    Result:= TRUE;
  end
  else
    Result:= FALSE;

end;

procedure AssignWriteBundle(BundleSrc: PBundleSource; FilePath: PAnsiChar; AliasName: PChar); stdcall;
var
  flen, alen: Cardinal;
begin

  if BundleSrc^.FilePath <> nil then
    begin
    FreeMem(BundleSrc^.FilePath, BundleSrc^.FilePathLength);
    BundleSrc^.FilePathLength:= 0;
  end;

  if BundleSrc^.AliasName <> nil then
    begin
    FreeMem(BundleSrc^.AliasName, BundleSrc^.AliasNameLength);
    BundleSrc^.AliasNameLength:= 0;
  end;

  flen:= Length(FilePath)+1;
  GetMem(BundleSrc^.FilePath, flen);
  CopyMemory(BundleSrc^.FilePath, FilePath, flen);
  BundleSrc^.FilePathLength:= flen;

  if AliasName <> nil then
    begin
    alen:= Length(AliasName)+1;
    GetMem(BundleSrc^.AliasName, alen);
    CopyMemory(BundleSrc^.AliasName, AliasName, alen);
    BundleSrc^.AliasNameLength:= alen;
  end
  else
    begin
    BundleSrc^.AliasName:= nil;
    BundleSrc^.AliasNameLength:= 0;
  end;

end;

procedure CloseBundle(Bundle: PBundleDefinition); stdcall;
begin
  CloseHandle(Bundle^.BundleHandle);
end;

procedure FreeBundle(Bundle: PBundleDefinition); stdcall;
begin
  FreeMem(Bundle, Bundle.SizeOfMem);
end;

function GetFileStruct(Bundle: PBundleDefinition; FileIndex: LongInt): PBundleFile; stdcall;
begin

  if (FileIndex >= 0) and (FileIndex < Bundle^.FileOnBundle) then
    Result:= Pointer(LongInt(Bundle)+SizeOf(TBundleDefinition)+(FileIndex*SizeOf(TBundleFile)))
  else
    Result:= nil;

end;
function GetFileOnBundle(Bundle: PBundleDefinition; BundleFile: PAnsiChar): LongInt; stdcall;
var
  x: integer;
  FileFound: boolean;
  frec: PBundleFile;
  name: string;
  DestName: string;
begin

  DestName:= BundleFile;
  if Length(DestName) > MaxBundleNameLength then
    DestName:= TruncateToMaxChars(BundleFile);
  x:= 0;
  FileFound:= FALSE;
  Result:= -1;
  while (x < Bundle.FileOnBundle) and (not FileFound) do
    begin
    frec:= GetFileStruct(Bundle, x);
    SetLength(name, frec^.BundleNameSize+1);
    name:= frec^.BundleName;
    if lstrcmp(PChar(DestName), PChar(name)) = 0 then
      begin
      Result:= x;
      FileFound:= TRUE;
    end;
    Inc(x);
  end;

end;

procedure SetFileBundlePos(Bundle: PBundleDefinition; FileIndex: LongInt; Position: Int64); stdcall;
var
  FileBun: PBundleFile;
  RealPos: Int64;
  Low64, High64: LongInt;
begin

  FileBun:= GetFileStruct(Bundle, FileIndex);
  RealPos:= FileBun^.BundlePos+Position;
  Low64:= LongInt(RealPos);
  High64:= LongInt(Int64(RealPos) shr 32);
  SetFilePointer(Bundle.BundleHandle, Low64, @High64, FILE_BEGIN);

end;

function GetFileBundleSize(Bundle: PBundleDefinition; FileIndex: LongInt): Cardinal; stdcall;
begin

  Result:= GetFileStruct(Bundle, FileIndex)^.BundleSize;

end;

function ReadBundleBuffer(Bundle: PBundleDefinition; FileIndex: LongInt; var Buf; Size: Cardinal): Boolean; stdcall;
var
  NumRead: Cardinal;
begin

  Result:= ReadFile(Bundle^.BundleHandle, Buf, Size, NumRead, nil);

end;

function ReadBundleFileToMemory(Bundle: PBundleDefinition; FileIndex: LongInt; var ptrloc: Pointer; var Size: Cardinal): boolean; stdcall;
var
  BunStr: PBundleFile;
  rpos, rbsize: Cardinal;
  buptr: Pointer;
begin

  BunStr:= GetFileStruct(Bundle, FileIndex);
  if BunStr <> nil then
    begin
    SetFileBundlePos(Bundle, FileIndex, 0);
    GetMem(buptr, BunStr^.BundleSize);
    Size:= BunStr^.BundleSize;
    ptrloc:= buptr;
    rpos:= 0;
    while rpos < BunStr^.BundleSize do
      begin
      if BunStr^.BundleSize-rpos > BundMemBuffer then
        rbsize:= BundMemBuffer
      else
        rbsize:= BunStr^.BundleSize-rpos;
      ReadBundleBuffer(Bundle, FileIndex, buptr^, rbsize);
      buptr:= Pointer(Cardinal(buptr)+rbsize);
      rpos:= rpos + rbsize;
    end;
  end;

  Result:= TRUE;

end;

function VerifyBundleFileChecksum(Bundle: PBundleDefinition; FileIndex: LongInt): boolean; stdcall;
var
  BunFile: PBundleFile;
  rbsize, fsize, npos, crcval: Cardinal;
  Buf: PChar;
begin

  BunFile:= GetFileStruct(Bundle, FileIndex);
  fsize:= BunFile^.BundleSize;
  SetFileBundlePos(Bundle, FileIndex, 0);
  GetMem(Buf, BundMemBuffer);
  npos:= 0;
  crcval:= $FFFFFFFF;
  while npos < fsize do
    begin
    if fsize - npos > BundMemBuffer then
      rbsize:= BundMemBuffer
    else
      rbsize:= fsize - npos;
    ReadBundleBuffer(Bundle, FileIndex, Buf^, rbsize);
    CalcCRC32(Buf, rbsize, crcval);
    npos:= npos + rbsize;
  end;
  FreeMem(Buf, BundMemBuffer);
  Result:= (not crcval) = BunFile^.BundleCRC32;

end;


exports
  AssignReadBundle,
  CreateBundleFile,
  AssignWriteBundle,
  CloseBundle,
  FreeBundle,
  GetFileStruct,
  GetFileOnBundle,
  SetFileBundlePos,
  GetFileBundleSize,
  ReadBundleBuffer,
  ReadBundleFileToMemory,
  VerifyBundleFileChecksum;


begin
end.
