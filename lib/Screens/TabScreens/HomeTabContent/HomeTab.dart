import 'dart:async';

import 'package:dev_connect/Model/UserModel.dart';
import 'package:dev_connect/Screens/AuthenticationScreens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _token;

  void _loadData() async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      _token = prefs.getString('token');
    });
  }

// Logout User Function
  Future<bool> logoutUser() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.clear();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Center(
          child: TextButton(
        onPressed: () async {
          if (await logoutUser()) {
            print("Logout successful");
          }
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route route) => false);
        },
        child: Text("Logout"),
      )),
    );
  }
}
