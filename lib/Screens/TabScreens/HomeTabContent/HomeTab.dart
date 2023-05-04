import 'dart:async';
import 'dart:convert';

import 'package:dev_connect/Model/ProjectModel.dart';
import 'package:dev_connect/Model/TechModel.dart';
import 'package:dev_connect/Model/UserModel.dart';
import 'package:dev_connect/Screens/AuthenticationScreens/LoginScreen.dart';
import 'package:dev_connect/Services/AuthServices.dart';
import 'package:dev_connect/Services/ProjectsServices.dart';
import 'package:dev_connect/Services/UserServices.dart';
import 'package:dev_connect/widgets/ProjectCardWidget.dart';
import 'package:dev_connect/widgets/ProjectListItemWidget.dart';
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
  List<Tech> _techs = [];
  List<ProjectModel>? projects = [];

  List<ProjectModel>? oProjects = [];
  int page = 1;
  var _token;
  bool _isLoading = true;

  void _loadData() async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      _token = prefs.getString('token');
    });
  }

  // Function to retrieve all unenrolled projects List
  Future<void> _getProjects() async {
    final SharedPreferences prefs = await _prefs;

    var projectsData = await ProjectService()
        .getExploreProjectList(prefs.getString('token').toString(), page);

    oProjects = projectsData;
    _isLoading = false;

    setState(() {});
  }

  // MARK: Function to get user data from the backend based on the access token and store it in the local storage
  Future<void> _getUserData() async {
    final SharedPreferences prefs = await _prefs;

    var projectsData = await UserServices()
        .getUserProjects(prefs.getString('token').toString());

    projects = projectsData;

    _isLoading = false;
    setState(() {});
  }

  Future<void> _getAllTech() async {
    var techs = await AuthService().getAllTechs();

    if (techs != null) {
      setState(() {
        _techs = techs.sublist(0, 10);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getProjects();
    _getAllTech();
    _getUserData();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7699,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: const [
                    Text(
                      "Top Techs",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    Spacer()
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: _techs != null
                    ? _techs.isNotEmpty
                        ? List.generate(_techs.length, (tech) {
                            return Chip(
                              label: Text(_techs[tech].name),
                            );
                          })
                        : [
                            const Center(
                                child: Text(
                              "You have not shown interest in any tech yet",
                            ))
                          ]
                    : [const Center(child: Text("Unable to Fetch Interests"))],
              ),
              const SizedBox(
                height: 26,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: const [
                    Text(
                      "Recents",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    Spacer()
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              // Project Section Body
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: projects != null
                      ? projects!.isNotEmpty
                          ? List.generate(3, (project) {
                              return ProjectCard(
                                  projectModel: projects![project]);
                            })
                          : [
                              const Center(
                                child: Text(
                                  "No Projects created or joined yet",
                                ),
                              ),
                            ]
                      : [const Center(child: Text("Unable to Fetch Projects"))],
                ),
              ),

              const SizedBox(
                height: 26,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: const [
                    Text(
                      "Recommendations",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    Spacer()
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    3,
                    (i) => oProjects != null
                        ? oProjects!.isNotEmpty
                            ? ProjectListItem(
                                projectModel: oProjects![i], isOwn: false)
                            : const Text("No Project Uploaded Yet")
                        : const Text("Unable to fetch projects"),
                  ),
                ),
              ),
              const SizedBox(
                height: 26,
              ),
            ],
          )),
    );
  }
}
