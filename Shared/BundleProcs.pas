unit BundleProcs;

interface

uses
  BundleStruct;

const
  BundDLL = 'DataBundle.dll';

function AssignReadBundle(BundlePath: PWideChar): PBundleDefinition; stdcall; external BundDLL;
function CreateBundleFile(FileOutput: PWideChar; NumOfFiles: LongInt; WriteCallback: PBundleWriteCallback): boolean; stdcall; external BundDLL;
procedure AssignWriteBundle(BundleSrc: PBundleSource; FilePath: PAnsiChar; AliasName: PChar); stdcall; external BundDLL;
procedure CloseBundle(Bundle: PBundleDefinition); stdcall; external BundDLL;
procedure FreeBundle(Bundle: PBundleDefinition); stdcall; external BundDLL;
function GetFileOnBundle(Bundle: PBundleDefinition; BundleFile: PAnsiChar): LongInt; stdcall; external BundDLL;
function GetFileStruct(Bundle: PBundleDefinition; FileIndex: LongInt): PBundleFile; stdcall; external BundDLL;
procedure SetFileBundlePos(Bundle: PBundleDefinition; FileIndex: LongInt; Position: Int64); stdcall; external BundDLL;
function GetFileBundleSize(Bundle: PBundleDefinition; FileIndex: LongInt): Cardinal; stdcall; external BundDLL;
function ReadBundleBuffer(Bundle: PBundleDefinition; FileIndex: LongInt; var Buf; Size: Cardinal): Boolean; stdcall; external BundDLL;
function ReadBundleFileToMemory(Bundle: PBundleDefinition; FileIndex: LongInt; var ptrloc: Pointer; var Size: Cardinal): boolean; stdcall; external BundDLL;
function VerifyBundleFileChecksum(Bundle: PBundleDefinition; FileIndex: LongInt): boolean; stdcall; external BundDLL;

implementation

end.
