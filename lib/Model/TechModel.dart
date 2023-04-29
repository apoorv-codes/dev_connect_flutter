// To parse this JSON data, do
//
//     final tech = techFromJson(jsonString);

import 'dart:convert';

List<Tech> techFromJson(String str) =>
    List<Tech>.from(json.decode(str).map((x) => Tech.fromJson(x)));

String techToJson(List<Tech> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tech {
  Tech({
    required this.id,
    required this.name,
    this.isSelected,
    this.score,
    this.v,
    this.slug,
  });

  String id;
  String name;
  int? v = 0;
  bool? isSelected = false;
  int? score = 0;
  String? slug = "";

  factory Tech.fromJson(Map<String, dynamic> json) => Tech(
        id: json["_id"],
        name: json["name"],
        score: json["score"],
        isSelected: json["isSelected"],
        v: json["__v"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "score": score,
        "__v": v,
        "isSelected": isSelected,
        "slug": slug,
      };
}
