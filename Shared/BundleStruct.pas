unit BundleStruct;

interface

const
  BundHeaderString = 'KBUND';
  // cara penomoran versi seperti "xx.xxx.xxx"
  BundleVersion = $01000093;
  MaxBundleNameLength = 46;
  BundMemBuffer = $4000;

type

  TBundleFileName = array[0..MaxBundleNameLength-1] of char;
  PBundleFileName = ^TBundleFileName;

  TBundleHeader = record
    BundleId: array[0..4] of char; // Muat "KBUND"
    Version: Cardinal; // contoh: $100 untuk versi "1.0"
    FileOnBundle: LongInt;
    SizeOfList: Cardinal;
    SizeOfBundle: Int64;
    Resv1: Cardinal;
    Resv2: Cardinal;
    Padd: array[0..2] of char;
  end;
  PBundleHeader = ^TBundleHeader;

  TBundleFile = record
    BundleNameSize: Byte;
    BundleName: TBundleFileName;
    BundleNameEsc: Byte; // harus 0!
    BundlePos: Int64;
    BundleSize: Cardinal;
    BundleCRC32: Cardinal;
  end;
  PBundleFile = ^TBundleFile;

  TBundleDefinition = record
    BundleHandle: Cardinal;
    FileOnBundle: LongInt;
    SizeOfMem: Cardinal;
  end;
  PBundleDefinition = ^TBundleDefinition;

  TBundleSource = record
    FilePath: PChar;
    FilePathLength: Cardinal;
    AliasName: PChar;
    AliasNameLength: Cardinal;
  end;
  PBundleSource = ^TBundleSource;

  TBundleWriteCallback = procedure(CallerSrc: PBundleSource; count: LongInt); stdcall;
  PBundleWriteCallback = ^TBundleWriteCallback;

implementation

end.
