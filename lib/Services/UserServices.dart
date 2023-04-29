import 'dart:convert';
import 'dart:ffi';

import 'package:dev_connect/Model/ProjectModel.dart';
import 'package:dev_connect/Model/TechModel.dart';
import 'package:dev_connect/Model/UserModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

class UserServices {
  var client = http.Client();
  // Service to Retrieve User data and save it to local Storage
  Future<UserModel?> getUserData(String token) async {
    var uri = Uri.parse("${dotenv.env['BACKEND']!}user/getUser");
    Map<String, String> reqHeaders = {
      "Content-Type": "application/json",
      "auth": token.toString()
    };

    var response = await client.get(uri, headers: reqHeaders);

    if (response.statusCode == 200) {
      var res = response.body;
      print(res);
      return userModelFromJson(res);
    } else {
      return null;
    }
  }

// Retrieves the Projects created by the user
  Future<List<ProjectModel>?> getUserProjects(String token) async {
    var uri = Uri.parse("${dotenv.env['BACKEND']!}user/getCreatedPrjects");
    Map<String, String> reqHeaders = {
      "Content-Type": "application/json",
      "auth": token.toString()
    };

    var response = await client.get(uri, headers: reqHeaders);

    if (response.statusCode == 200) {
      var res = response.body;
      List<dynamic> projects = JsonDecoder().convert(res.toString());
      List<ProjectModel> prj = [];

      for (var project in projects) {
        prj.add(projectModelFromJson(JsonEncoder().convert(project)));
      }

      // print("$prj");

      return prj;
    } else {
      return null;
    }
  }

  // Selects the technologies on the initial Signup on the application
  Future<void> selectTechs(String token, List<Tech> selectedTechs) async {
    var uri = Uri.parse("${dotenv.env['BACKEND']!}user/showInterest");

    Map<String, String> reqHeaders = {
      "Content-Type": "application/json",
      "auth": token.toString()
    };

    String reqBody = jsonEncode({"id": token, "tech": selectedTechs});

    var response = await client.post(uri, headers: reqHeaders, body: reqBody);
  }

  // Create new projects
  Future<void> createProjects(
      String token, String name, List<Tech> tech, String duration) async {
    var uri = Uri.parse("${dotenv.env['BACKEND']!}user/createProject");

    Map<String, String> reqHeaders = {
      "Content-Type": "application/json",
      "auth": token.toString()
    };
    String reqBody = jsonEncode(
        {"id": token, "name": name, "tech": tech, "duration": duration});

    var response = await client.post(uri, headers: reqHeaders, body: reqBody);

    if (response.statusCode == 200) {
      var res = response.body;
      print(res);
    } else {
      return null;
    }
  }
}
