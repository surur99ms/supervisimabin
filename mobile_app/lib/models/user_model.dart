class UserModel {
  final int? id;
  final String username;
  final String name;
  final String role; // 'admin' or 'supervisor'
  final String? foto;

  UserModel({
    this.id,
    required this.username,
    required this.name,
    required this.role,
    this.foto,
  });

  bool get isAdmin => role == 'admin';
  bool get isSupervisor => role == 'supervisor';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'supervisor',
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'role': role,
      'foto': foto,
    };
  }
}

