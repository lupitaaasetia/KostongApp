class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;

  UserModel({required this.id, required this.name, required this.email, this.phone, this.avatar});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'],
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
    );
  }
}
