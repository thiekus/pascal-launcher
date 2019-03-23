unit AppTypes;

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
  Windows, DirectMusic;

type

  TMusicSource = packed record
    Source: IDirectMusicSegment8;
    State: IDirectMusicSegmentState;
    Location: Pointer;
    Size: Cardinal;
  end;

  // Struktur untuk tiap soal kuis
  TJawaban = (jwBelum, jwA, jwB, jwC, jwD, jwKosong);
  TSoalQuiz = packed record
    Nomor: integer;
    Soal: string;
    PilihanSoal: array[0..3] of string;
    JawabanBenar: TJawaban;
    JawabanPmain: TJawaban;
  end;

  // Buat tabel skor
  TSkorList = packed record
    Nama: string;
    Skor: integer;
    Waktu: string;
  end;

  // Tipe event handler game ini
  TProsIdle = procedure;
  TProsGambar = procedure(HndDC: HDC);
  TProsMouseGerak = procedure(Mpos: TPoint);
  TProsKlikKiri = procedure(Mpos: TPoint);
  TProsKiborTekan = procedure(Tombol: integer);
  TProsKiborTahan = procedure(Tombol: integer);
  TProsKiborLepas = procedure(Tombol: integer);

implementation

end.
