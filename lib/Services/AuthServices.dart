import 'dart:convert';

import 'package:dev_connect/Model/TechModel.dart';
import 'package:dev_connect/Model/UserModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Service to Login User
  Future<UserModel?> loginUser(String email, String password) async {
    var client = http.Client();

    var uri = Uri.parse("${dotenv.env["BACKEND"]!}auth/login");
    Map<String, String> reqHeaders = {"Content-Type": "application/json"};
    String reqBody = jsonEncode({"email": email, "password": password});

    var response = await client.post(uri, headers: reqHeaders, body: reqBody);

    if (response.statusCode == 200) {
      var res = response.body;
      return userModelFromJson(res);
    } else {
      return null;
    }
  }

  // Service to Register User
  Future<UserModel?> signupUser(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    var client = http.Client();

    var uri = Uri.parse("${dotenv.env["BACKEND"]!}auth/register");
    Map<String, String> reqHeaders = {"Content-Type": "application/json"};
    String reqBody = jsonEncode({
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password
    });

    var response = await client.post(uri, headers: reqHeaders, body: reqBody);
    if (response.statusCode == 200) {
      return loginUser(email, password);
    }
  }

  // Service to retrieve all the techs on the platform with out user token using HOME CONTROLLER
  Future<List<Tech>?> getAllTechs() async {
    var client = http.Client();

    var uri = Uri.parse("${dotenv.env["BACKEND"]!}home/interests");
    Map<String, String> reqHeaders = {"Content-Type": "application/json"};

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      return techFromJson(response.body);
    }
  }
}
