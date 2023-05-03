import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:dev_connect/Model/ProjectModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ProjectService {
  var client = http.Client();

  // Service to retrieve other Projects on the platform
  Future<List<ProjectModel>?> getExploreProjectList(
      String token, int page) async {
    var uri = Uri.parse("${dotenv.env['BACKEND']!}user/projects/${page}");
    Map<String, String> reqHeaders = {
      "Content-Type": "application/json",
      "auth": token.toString()
    };

    var response = await client.get(uri, headers: reqHeaders);

    if (response.statusCode == 200) {
      var res = response.body;
      print(res);
      List<dynamic> projects = JsonDecoder().convert(res.toString());
      List<ProjectModel> prj = [];

      for (var project in projects) {
        prj.add(projectModelFromJson(JsonEncoder().convert(project)));
      }
      print("$prj");

      return prj;
    } else {
      return null;
    }
  }

  // Service to delete the project
}
