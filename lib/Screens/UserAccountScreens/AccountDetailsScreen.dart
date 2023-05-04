import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dev_connect/Model/ProjectModel.dart';
import 'package:dev_connect/Model/TechModel.dart';
import 'package:dev_connect/Model/UserModel.dart';
import 'package:dev_connect/Screens/AuthenticationScreens/LoginScreen.dart';
import 'package:dev_connect/Screens/AuthenticationScreens/SelectTechScreen.dart';
import 'package:dev_connect/Services/UserServices.dart';
import 'package:dev_connect/widgets/ProjectCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

// <============================== Widget Starts Here ==========================>

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _isLoading = true;

  var firstName = "First",
      lastName = "Last",
      email = "last.first@gmail.com",
      location = "location",
      img = "img";
  List<String>? interests = [];
  List<ProjectModel>? projects = [];
  List<Tech> techs = [];
  DateTime createdAt = DateTime.now(), updatedAt = DateTime.now();

// Logout User Function
  Future<bool> logoutUser() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.clear();
  }

  // MARK: Function to get user data from the backend based on the access token and store it in the local storage
  Future<void> _getUserData() async {
    final SharedPreferences prefs = await _prefs;

    var projectsData = await UserServices()
        .getUserProjects(prefs.getString('token').toString());

    projects = projectsData;
    for (var tech in JsonDecoder().convert(prefs.getString('tech')!)) {
      techs.add(Tech(
          name: tech['name'] ?? "",
          score: tech['score'] ?? "",
          id: tech['id'] ?? ""));
    }

    _isLoading = false;
    setState(() {});
  }

  Future<void> _loadUser() async {
    final SharedPreferences prefs = await _prefs;

    firstName = prefs.getString('firstName') ?? "";
    lastName = prefs.getString('lastName') ?? "";
    email = prefs.getString('email') ?? "";
    location = prefs.getString('location') ?? "";
    img = prefs.getString('img') ?? "";
    interests = prefs.getStringList('interests');
    createdAt = DateTime.parse(prefs.getString('createdAt')!);
    updatedAt = DateTime.parse(prefs.getString('updatedAt')!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 36.0),
        child: Column(
          children: [
            Padding(
              //Custom Top Bar
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                  Hero(
                    tag: "logo",
                    child: Material(
                      type: MaterialType.transparency,
                      child: Row(
                        children: const [
                          Image(
                            image:
                                AssetImage("assets/images/devconnect-logo.png"),
                            height: 40,
                          ),
                          Text(
                            "Dev Connect",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () async {
                        if (await logoutUser()) {
                          print("Logout successful");
                        }
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (Route route) => false);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.power_settings_new),
                          SizedBox(
                            width: 2,
                          ),
                          Text("Logout"),
                        ],
                      ))
                ],
              ),
            ),

            // page Body starts here
            Container(
              height: MediaQuery.of(context).size.height - 124,
              child: ModalProgressHUD(
                inAsyncCall: _isLoading,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      // Basic details
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _isLoading
                              ? []
                              : [
                                  CircleAvatar(
                                    radius: 40,
                                    child: Text(
                                      "${firstName.substring(0, 1)}${lastName.substring(0, 1)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$firstName $lastName",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Text(location,
                                          style: const TextStyle(fontSize: 12))
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 20,
                                      ))
                                ],
                        ),
                      ),

                      // Account details
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            Row(
                              children: [Text(email)],
                            ),
                            Row(
                              children: [
                                Text(
                                    "User since ${createdAt.month} ${createdAt.year}"),
                              ],
                            )
                          ],
                        ),
                      ),

                      // Techs followed by user
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                children: [
                                  // Tech Section Header
                                  Row(children: [
                                    const Text(
                                      "Tech",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.more_horiz)),
                                  ]),
                                  // Tech Section Body
                                  Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: techs != null
                                        ? techs.isNotEmpty
                                            ? List.generate(techs.length,
                                                (tech) {
                                                return Chip(
                                                  label: Text(techs[tech].name),
                                                  avatar: Text(techs[tech]
                                                      .score
                                                      .toString()),
                                                );
                                              })
                                            : [
                                                Center(
                                                    child: Column(
                                                  children: [
                                                    const Text(
                                                        "You have not shown interest in any tech yet"),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          SelectTechScreen()));
                                                        },
                                                        child: const Text(
                                                            "Select Techs"))
                                                  ],
                                                ))
                                              ]
                                        : [
                                            const Center(
                                                child: Text(
                                                    "Unable to Fetch Interests"))
                                          ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                children: [
                                  // Projects Section Header
                                  Row(children: [
                                    const Text(
                                      "Projects",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.more_horiz)),
                                  ]),
                                  // Project Section Body
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: projects != null
                                          ? projects!.isNotEmpty
                                              ? List.generate(projects!.length,
                                                  (project) {
                                                  return ProjectCard(
                                                      projectModel:
                                                          projects![project]);
                                                })
                                              : [
                                                  const Center(
                                                      child: Text(
                                                    "No Projects created or joined yet",
                                                  ))
                                                ]
                                          : [
                                              const Center(
                                                  child: Text(
                                                      "Unable to Fetch Projects"))
                                            ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
