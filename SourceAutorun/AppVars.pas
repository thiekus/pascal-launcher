unit AppVars;

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
  Windows, AppTypes, BundleStruct;

var

  MainWnd: HWND;
  WndBrush: HBRUSH;
  WndRect: TRect;
  SedangJalan: boolean;
  HaveFocus: boolean;
  TampilDialog: boolean;
  QuizBundle: PBundleDefinition;
  OnKey: array[0..255] of boolean;
  NamaPemain: string;
  WaktuMulai: SYSTEMTIME;
  cntmulai: Cardinal;
  sisawaktu: integer;

  // besar window
  WndX, WndY: integer;

  // Options
  FullScreen: Boolean;
  EnableSound: Boolean;
  //SvgaMode: Boolean;

  // Musik
  OpenMus: TMusicSource;
  SlapMus: TMusicSource;
  WhackMus: TMusicSource;

  // Pengaturan Launcher
  UntukSekolah: string;
  LokasiFoto: string;
  LokasiVideo: string;
  LokasiDokumentasi: string;

  // Untuk set lokasi event tiap scene
  ProsIdle: TProsIdle = nil;
  ProsGambar: TProsGambar = nil;
  ProsMouseGerak: TProsMouseGerak = nil;
  ProsKlikKiri: TProsKlikKiri = nil;
  ProsKiborTekan: TProsKiborTekan = nil;
  ProsKiborTahan: TProsKiborTahan = nil;
  ProsKiborLepas: TProsKiborLepas = nil;

implementation

end.
