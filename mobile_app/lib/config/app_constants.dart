class AppConstants {
  static const String appName = 'Supervisi Mabin IASS';
  static const String appVersion = '2.0.0';
  
  // Default API URLs
  static const String defaultLocalUrl = 'http://192.168.1.12/supervisimabin/api.php';
  static const String defaultEmulatorUrl = 'http://10.0.2.2/supervisimabin/api.php';
  static const String defaultProductionUrl = 'https://supervisi.mabin.corefive.my.id/api.php';
  
  // WhatsApp developer
  static const String developerWhatsApp = '6285606373627';

  // Periods
  static const List<String> periods = [
    '1445-1446 H',
    '1446-1447 H',
    '1447-1448 H',
    '1448-1449 H',
    '1449-1450 H',
  ];
  static const String defaultPeriod = '1447-1448 H';

  // Score values
  static const int scoreBaik = 100;
  static const int scoreSedang = 75;
  static const int scoreBuruk = 50;

  static int getScoreValue(String? status) {
    switch (status) {
      case 'Baik':
        return scoreBaik;
      case 'Sedang':
        return scoreSedang;
      case 'Buruk':
        return scoreBuruk;
      default:
        return 0;
    }
  }

  // 14 Supervision items
  static const List<SupervisiItemDef> items = [
    // 1. Administrasi (adm_1 - adm_6)
    SupervisiItemDef(
      id: 'adm_1',
      category: 'administrasi',
      title: 'Buku Tamu',
      description: 'Buku Tamu Umum, Supervisi dan Khusus tersedia dan terisi rapi',
    ),
    SupervisiItemDef(
      id: 'adm_2',
      category: 'administrasi',
      title: 'Visi, Misi & Tujuan',
      description: 'Visi, Misi dan Tujuan Madrasah terpampang dan dipahami',
    ),
    SupervisiItemDef(
      id: 'adm_3',
      category: 'administrasi',
      title: 'RKM',
      description: 'Rencana Kerja Madrasah (RKM) disusun secara terarah',
    ),
    SupervisiItemDef(
      id: 'adm_4',
      category: 'administrasi',
      title: 'RKAM',
      description: 'Rencana Kegiatan & Anggaran Madrasah (RKAM) transparan',
    ),
    SupervisiItemDef(
      id: 'adm_5',
      category: 'administrasi',
      title: 'Struktur Organisasi',
      description: 'Bagan Struktur Organisasi & Rincian Tugas jelas',
    ),
    SupervisiItemDef(
      id: 'adm_6',
      category: 'administrasi',
      title: 'TUPOKSI Madrasah',
      description: 'Penyusunan TUPOKSI Madrasah terdokumentasi dengan baik',
    ),

    // 2. Pendataan Digital (kur_1 - kur_4)
    SupervisiItemDef(
      id: 'kur_1',
      category: 'pendataan',
      title: 'Data Lembaga',
      description: 'Data Lembaga (NSM, Piagam Pendirian, dll) valid di sistem',
    ),
    SupervisiItemDef(
      id: 'kur_2',
      category: 'pendataan',
      title: 'Input Data Murid',
      description: 'Input Data Murid pada Sistem lengkap dan mutakhir',
    ),
    SupervisiItemDef(
      id: 'kur_3',
      category: 'pendataan',
      title: 'Input Data Guru',
      description: 'Input Data Guru & Tenaga Kependidikan terdata lengkap',
    ),
    SupervisiItemDef(
      id: 'kur_4',
      category: 'pendataan',
      title: 'Sahabat Khidmah',
      description: 'Program Sahabat Khidmah terdata dan terorganisir',
    ),

    // 3. KBM & Laporan (loy_1 - loy_4)
    SupervisiItemDef(
      id: 'loy_1',
      category: 'kbm',
      title: 'Input KBM Harian',
      description: 'Input KBM / Jurnal Mengajar Harian aktif berjalan',
    ),
    SupervisiItemDef(
      id: 'loy_2',
      category: 'kbm',
      title: 'Agenda Kegiatan',
      description: 'Agenda Kegiatan Madrasah terlaksana sesuai jadwal',
    ),
    SupervisiItemDef(
      id: 'loy_3',
      category: 'kbm',
      title: 'Input Keuangan',
      description: 'Input Data Keuangan teratur dan akuntabel',
    ),
    SupervisiItemDef(
      id: 'loy_4',
      category: 'kbm',
      title: 'Laporan Bulanan',
      description: 'Laporan Bulanan dikirim tepat waktu kepada UPT',
    ),
  ];
}

class SupervisiItemDef {
  final String id;
  final String category; // 'administrasi', 'pendataan', 'kbm'
  final String title;
  final String description;

  const SupervisiItemDef({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
  });
}

