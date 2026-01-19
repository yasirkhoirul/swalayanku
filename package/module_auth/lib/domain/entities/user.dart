class User {
  final String email;
  final String password;

  const User(this.email, this.password);
}

class UserSignup {
  final String email;
  final String password;
  final String nama;
  final String role;

  const UserSignup({
    required this.email,
    required this.password,
    required this.nama,
    this.role = 'user',
  });
}

class UserInfo {
  final String uid;
  final String email;
  final String nama;
  final String role;

  const UserInfo({
    required this.uid,
    required this.email,
    required this.nama,
    required this.role,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      uid: json['uid'] as String,
      email: json['email'] as String,
      nama: json['nama'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'nama': nama,
      'role': role,
    };
  }

  bool get isAdmin => role == 'admin';
  bool get isKasir => role == 'kasir';
  bool get isUser => role == 'user';
}