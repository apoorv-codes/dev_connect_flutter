import 'dart:convert';

import 'package:dev_connect/Model/ProjectModel.dart';
import 'package:dev_connect/Model/TechModel.dart';
import 'package:dev_connect/Model/UserModel.dart';
import 'package:dev_connect/Services/ProjectsServices.dart';
import 'package:dev_connect/widgets/ProjectListItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  List<ProjectModel>? projects = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isLoading = true;
  int page = 1;

  // Function to retrieve all unenrolled projects List

  Future<void> _getProjects() async {
    final SharedPreferences prefs = await _prefs;

    var projectsData = await ProjectService()
        .getExploreProjectList(prefs.getString('token').toString(), page);

    projects = projectsData;
    _isLoading = false;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7699,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            projects != null ? projects!.length + 1 : 0,
            (i) => i == 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: const [
                        Text(
                          "Explore",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )
                : projects != null
                    ? projects!.isNotEmpty
                        ? ProjectListItem(
                            projectModel: projects![i - 1], isOwn: false)
                        : const Text("No Project Uploaded Yet")
                    : const Text("Unable to fetch projects"),
          ),
        ),
      ),
    );
  }
}
