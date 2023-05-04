import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:dev_connect/Model/ProjectModel.dart';
import 'package:dev_connect/Model/TechModel.dart';
import 'package:dev_connect/Model/UserModel.dart';
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
      List<dynamic> projects = JsonDecoder().convert(res.toString());
      List<ProjectModel> prj = [];

      for (var project in projects) {
        prj.add(projectModelFromJson(JsonEncoder().convert(project)));
      }

      return prj;
    } else {
      return null;
    }
  }

  // service to show interest in project
  Future<void> showInterestInProject(
      String token, String projectID, List<Tech> tech) async {
    var uri = Uri.parse("${dotenv.env['BACKEND']!}user/updateInterest");

    Map<String, String> reqHeaders = {
      "Content-Type": "application/json",
      "auth": token.toString()
    };

    String reqBody = jsonEncode({"project": projectID, "tech": tech});

    var response = await client.post(uri, headers: reqHeaders, body: reqBody);
  }

// service to send join request in project
  Future<void> sendJoinRequest(
      String token, String projectID, String uid) async {
    var uri = Uri.parse("${dotenv.env['BACKEND']!}user/projectInvite");

    Map<String, String> reqHeaders = {
      "Content-Type": "application/json",
      "auth": token.toString()
    };

    String reqBody = jsonEncode({"projectId": projectID, "userId": uid});

    var response = await client.post(uri, headers: reqHeaders, body: reqBody);
  }

// service to list all join requests of the project
  Future<List<UserModel>?> listJoinRequests(
      String token, String projectId) async {
    var uri = Uri.parse("${dotenv.env['BACKEND']!}user/showProjectInvites");

    Map<String, String> reqHeaders = {
      "Content-Type": "application/json",
      "auth": token.toString()
    };

    String reqBody = jsonEncode({"projectId": projectId});

    var response = await client.post(uri, headers: reqHeaders, body: reqBody);

    if (response.statusCode == 200) {
      var res = response.body;
      List<dynamic> users = JsonDecoder().convert(res.toString());
      List<UserModel> prj = [];

      for (var user in users) {
        prj.add(userModelFromJson(JsonEncoder().convert(user)));
      }

      return prj;
    } else {
      return null;
    }
  }

// service to accept the join requests of users for a project
  Future<void> acceptProjectInvite(
      String token, String projectId, String userId) async {
    var uri = Uri.parse("${dotenv.env['BACKEND']!}user/acceptProjectInvite");
    Map<String, String> reqHeaders = {
      "Content-Type": "application/json",
      "auth": token.toString()
    };

    String reqBody = jsonEncode({"userId": userId, "projectId": projectId});

    var response = await client.post(uri, headers: reqHeaders);
  }

  // Service to get all the projects that we have liked
  Future<List<ProjectModel>?> getFavouritesProjectList(String token) async {
    var uri = Uri.parse("${dotenv.env['BACKEND']!}user/getFavProjects");
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

      return prj;
    } else {
      return null;
    }
  }

  // Service to delete the project
  Future<void> deleteProject(String token, String projectId) async {
    var uri = Uri.parse("${dotenv.env['BACKEND']!}user/deleteProject");
    Map<String, String> reqHeaders = {
      "Content-Type": "application/json",
      "auth": token.toString()
    };

    String reqBody = jsonEncode({"projectId": projectId.toString()});

    var response = await client.post(uri, headers: reqHeaders, body: reqBody);

    if (response.statusCode == 200) {
      var res = response.body;
      print(res);
    } else {
      return null;
    }
  }
}
