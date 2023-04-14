import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.message,
    required this.user,
  });

  String message;
  List<User> user;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    message: json["message"],
    user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
  };
}

class User {
  User({
    this.id,
    this.email,
    this.password,
    this.role,
    this.status,
    this.token
  });

  int? id;
  String? email;
  String? password;
  String? role;
  String? status;
  String? token;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    password: json["password"],
    role: json["role"],
    status: json["status"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "password": password,
    "role": role,
    "status": status,
    "token": token,
  };
}
