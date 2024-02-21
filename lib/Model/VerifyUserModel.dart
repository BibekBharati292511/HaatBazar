import 'dart:convert';

VerifyUserModel VerifyUserModelJson(String str) =>
    VerifyUserModel.fromJson(json.decode(str));

String VerifyUserModelToJson(VerifyUserModel data) => json.encode(data.toJson());

class VerifyUserModel {
  int? id;
  String email;
  String otp;

  VerifyUserModel({
    this.id,
    required this.email,
    required this.otp
  });

  factory VerifyUserModel.fromJson(Map<String, dynamic> json) => VerifyUserModel(
      email: json["email"],
      otp: json["otp"],
      id: json["id"]);

  Map<String, dynamic> toJson() => {
    "email":email,
    "otp":otp,
    'id': id,
  };

  String get Otp => otp;
  String get userEmail=>email;
}