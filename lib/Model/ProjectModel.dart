import 'dart:convert';

import 'package:dev_connect/Model/TechModel.dart';
import 'package:dev_connect/Model/UserModel.dart';

ProjectModel projectModelFromJson(String str) =>
    ProjectModel.fromJson(json.decode(str));

String projectModelToJson(ProjectModel data) => json.encode(data.toJson());

// TODO: we need to add number of members required by the owner
class ProjectModel {
  ProjectModel({
    required this.id,
    required this.name,
    this.tech,
    required this.owner,
    this.users,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String name;
  List<Tech>? tech = [];
  String owner;
  List<UserModel>? users = [];
  String duration;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json["_id"],
        name: json["name"],
        tech: List<Tech>.from(json["tech"] != null
            ? json["tech"].map((x) => Tech.fromJson(x))
            : []),
        owner: json["owner"]["first_name"],
        users: List<UserModel>.from(
            json["users"].map((x) => UserModel.fromJson(x))),
        duration: json["duration"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "tech": List<dynamic>.from(tech!.map((x) => x.toJson())),
        "owner": owner,
        "users": List<dynamic>.from(users!.map((x) => x)),
        "duration": duration,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
