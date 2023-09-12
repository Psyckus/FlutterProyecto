// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  String username;
  String password;
  String nombreCliente;

  Login({
    this.username,
    this.password,
    this.nombreCliente,
  });

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        username: json["username"],
        password: json["password"],
        nombreCliente: json["nombreCliente"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "nombreCliente": nombreCliente,
      };
}
