import 'package:dev_connect/Screens/OnBoardingScreen.dart';
import 'package:dev_connect/Screens/TabScreens/TabsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  runApp(MaterialApp(
    title: "Dev Connect",
    theme: ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      // scaffoldBackgroundColor: Colors.white,
      colorSchemeSeed: Colors.blue,
      appBarTheme: const AppBarTheme(
        color: Colors.white,
      ),
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      colorSchemeSeed: Colors.blue,
      appBarTheme: const AppBarTheme(
        color: Colors.black,
      ),
    ),
    home: token != null ? const TabsScreen() : const OnboardingScreen(),
  ));
}


// [ ] projects
// [ ] updateInterest
// [ ] deleteProject
// [ ] projectInvite
// [ ] acceptProjectInvite
// [ ] recommandUser
// [x] createProject
// [x] showInterest
// [x] getTech
// [x] getCreatedPrjects
// [x] getUser
// [-] updateProject
// [-] upload
// [-] updateProfile
// [-] changePassword
// [-] dashboard