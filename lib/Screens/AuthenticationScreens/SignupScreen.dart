import 'package:dev_connect/Screens/AuthenticationScreens/LoginScreen.dart';
import 'package:dev_connect/Screens/AuthenticationScreens/SelectTechScreen.dart';
import 'package:dev_connect/Screens/TabScreens/TabsScreen.dart';
import 'package:dev_connect/Services/AuthServices.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _isSignupComplete = true;

  bool _validate = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  Future<void> signupUser(
      String firstName, String lastName, String email, String password) async {
    final SharedPreferences prefs = await _prefs;
    // Obtain shared preferences.
    var signupResponse =
        await AuthService().signupUser(firstName, lastName, email, password);

    if (signupResponse != null) {
      // Saving User Data to local storage
      await prefs.setString('firstName', signupResponse.firstName);
      await prefs.setString('lastName', signupResponse.lastName);
      await prefs.setString('email', signupResponse.email);
      await prefs.setString('token', signupResponse.token!);

      _isSignupComplete = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: !_isSignupComplete,
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
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
              const SizedBox(height: 30),
              TextFormField(
                autocorrect: false,
                enableSuggestions: false,
                controller: firstNameController,
                onChanged: (val) {
                  // validateEmail(val);
                },
                decoration: const InputDecoration(
                  // errorText: _validate ? null : _errorMessage,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  hintText: 'First Name',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                autocorrect: false,
                enableSuggestions: false,
                controller: lastNameController,
                onChanged: (val) {
                  // validateEmail(val);
                },
                decoration: const InputDecoration(
                  // errorText: _validate ? null : _errorMessage,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  hintText: 'Last Name',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                autocorrect: false,
                enableSuggestions: false,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) {},
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
                  onPressed: () async {
                    setState(() {
                      _isSignupComplete = false;
                    });

                    await signupUser(
                        firstNameController.text.toString(),
                        lastNameController.text.toString(),
                        emailController.text.toString(),
                        passwordController.text.toString());

                    if (_isSignupComplete) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelectTechScreen()));
                    } else {
                      print("SignUp Error");
                    }
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.yellow),
                    width: 220,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    child: Row(
                      children: const [
                        Text(
                          'Continue',
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.east,
                          color: Colors.black,
                        )
                      ],
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an Account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text("Login"))
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
