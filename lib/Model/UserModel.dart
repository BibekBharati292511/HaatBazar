import 'dart:convert';
import 'dart:ffi';

UserModel UserModelJson(String str) =>
    UserModel.fromJson(json.decode(str));

String UserModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? id;
  String email;
  String firstName;
  String lastName;
  String password;
  Int roleId;

  UserModel({
    this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.roleId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      email: json["email"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      password: json["password"],
      roleId: json["roleId"],
      id: json["id"]);

  Map<String, dynamic> toJson() => {
    "email":email,
    "firstName": firstName,
    "lastName": lastName,
    "password":password,
    "roleId":1,
    'id': id,
  };

  String get firstname => firstName;

  String get lastname => lastName;
  String get userEmail=>email;
  String get userPassword=>password;
  Int get roleid=>roleId;
}