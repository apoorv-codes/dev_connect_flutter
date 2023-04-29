import 'dart:developer';
import 'dart:ffi';
import 'package:dev_connect/Model/UserModel.dart';
import 'package:dev_connect/Screens/AuthenticationScreens/SignupScreen.dart';
import 'package:dev_connect/Screens/TabScreens/TabsScreen.dart';
import 'package:dev_connect/Services/AuthServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String _errorMessage = '';
  bool _validate = false;

  var _isLoggedIn = true;

// MARK: Function to call login API and save user data to storage on successful login
  Future<void> loginUser(String email, String password) async {
    final SharedPreferences prefs = await _prefs;
    // Obtain shared preferences.
    var loginResponse = await AuthService().loginUser(email, password);

    if (loginResponse != null) {
      // Saving User Data to local storage
      await prefs.setString('firstName', loginResponse.firstName);
      await prefs.setString('lastName', loginResponse.lastName);
      await prefs.setString('email', loginResponse.email);
      await prefs.setString('token', loginResponse.token!);

      _isLoggedIn = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: !_isLoggedIn,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage("assets/images/devconnect-logo.png"),
                  height: 100,
                ),
                const Text("Dev Connect",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                const SizedBox(height: 30),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) {
                    validateEmail(val);
                  },
                  decoration: const InputDecoration(
                    // errorText: _validate ? null : _errorMessage,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: _validate
                        ? () async {
                            setState(() {
                              _isLoggedIn = false;
                            });

                            if (emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              await loginUser(emailController.text.toString(),
                                  passwordController.text.toString());
                            } else {}
                            if (_isLoggedIn) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TabsScreen()));
                            } else {
                              print("Login Error");
                            }
                          }
                        : null,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.black),
                      width: 220,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      child: const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an Account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()));
                        },
                        child: const Text("Sign Up"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email can not be empty";
        _validate = false;
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
        _validate = false;
      });
    } else {
      setState(() {
        _errorMessage = "";
        _validate = true;
      });
    }
  }
}
