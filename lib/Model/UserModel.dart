// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'TechModel.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.token,
    this.location,
    this.img,
    this.interest,
    this.projects,
    this.tech,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String firstName;
  String lastName;
  String email;
  String? token;
  String? location;
  String? img;
  List<dynamic>? interest = [];
  List<dynamic>? projects = [];
  List<Tech>? tech = [];
  DateTime? createdAt;
  DateTime? updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        token: json["token"] ?? "",
        location: json["location"],
        img: json["img"] != null
            ? UserImage.fromJson(json["img"]).getImageURL()
            : "",
        interest: List<dynamic>.from(
            json["interest"] != null ? json["interest"].map((x) => x) : []),
        projects: List<dynamic>.from(
            json["projects"] != null ? json["projects"].map((x) => x) : []),
        tech: List<Tech>.from(json["tech"] != null
            ? json["tech"].map((x) => Tech.fromJson(x))
            : []),
        createdAt: DateTime.parse(json["createdAt"] != null
            ? json["createdAt"]
            : DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json["updatedAt"] != null
            ? json["updatedAt"]
            : DateTime.now().toIso8601String()),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "token": token,
        "location": location,
        "img": img,
        "interest": List<dynamic>.from(interest!.map((x) => x)),
        "projects": List<dynamic>.from(projects!.map((x) => x)),
        "tech": List<dynamic>.from(tech!.map((x) => x.toJson())),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}

class UserImage {
  UserImage(
      {required this.id,
      required this.name,
      required this.path,
      this.createdAt,
      this.updatedAt});

  String id;
  String name;
  String path;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory UserImage.fromJson(Map<String, dynamic> json) => UserImage(
        name: json["name"],
        path: json["path"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"] != null
            ? json["createdAt"]
            : DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json["updatedAt"] != null
            ? json["updatedAt"]
            : DateTime.now().toIso8601String()),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "path": path,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };

  String getImageURL() {
    String backend = dotenv.env['BACKEND']!;
    backend = backend.substring(0, backend.length - 1);
    return "${backend}${this.path}/${this.name}";
  }
}
