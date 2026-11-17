class SupervisorModel {
  final int id;
  final String username;
  final String namaSupervisor;
  final String wilayahTugas;
  final String? fotoProfil;
  final String? createdAt;

  SupervisorModel({
    required this.id,
    required this.username,
    required this.namaSupervisor,
    required this.wilayahTugas,
    this.fotoProfil,
    this.createdAt,
  });

  factory SupervisorModel.fromJson(Map<String, dynamic> json) {
    return SupervisorModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      username: json['username'] ?? '',
      namaSupervisor: json['nama_supervisor'] ?? '',
      wilayahTugas: json['wilayah_tugas'] ?? '',
      fotoProfil: json['foto_profil'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'nama_supervisor': namaSupervisor,
      'wilayah_tugas': wilayahTugas,
      'foto_profil': fotoProfil,
      'created_at': createdAt,
    };
  }
}

