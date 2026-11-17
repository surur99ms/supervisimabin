class MadrasahModel {
  final int id;
  final String namaMadrasah;
  final String wilayah;

  MadrasahModel({
    required this.id,
    required this.namaMadrasah,
    required this.wilayah,
  });

  factory MadrasahModel.fromJson(Map<String, dynamic> json) {
    return MadrasahModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      namaMadrasah: json['nama_madrasah'] ?? json['Nama_Madrasah'] ?? '',
      wilayah: json['wilayah'] ?? json['Wilayah'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_madrasah': namaMadrasah,
      'wilayah': wilayah,
    };
  }
}

