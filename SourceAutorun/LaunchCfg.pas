unit LaunchCfg;

interface

uses
  KOL, AppUtils, AppVars;

procedure DapatkanKonfigurasi;

implementation

procedure DapatkanKonfigurasi;
var
  ini: PIniFile;
begin

  ini:= OpenIniFile(ExtractFilePath(ParamStr(0))+'Launcher.dat');
  try
    ini.Mode:= ifmRead;
    ini.Section:= 'Config';
    UntukSekolah:= ini.ValueString('Sekolah', '<KOSONG>');
    LokasiFoto:= ExtractFilePath(ParamStr(0))+ini.ValueString('Foto', '');
    LokasiVideo:= ExtractFilePath(ParamStr(0))+ini.ValueString('Video', '');
    LokasiDokumentasi:= ExtractFilePath(ParamStr(0))+ini.ValueString('VideoDok', '');
  finally
    ini.Free;
  end;

end;

end.
