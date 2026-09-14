class UserModel {
  final String id;
  final String phone;
  final String? name;
  final String role;

  UserModel({
    required this.id,
    required this.phone,
    this.name,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'],
      role: json['role'] ?? 'client',
    );
  }
}
