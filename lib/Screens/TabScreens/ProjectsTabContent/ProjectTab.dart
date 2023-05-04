import 'package:dev_connect/Model/ProjectModel.dart';
import 'package:dev_connect/Model/TechModel.dart';
import 'package:dev_connect/Services/UserServices.dart';
import 'package:dev_connect/widgets/ProjectListItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectTab extends StatefulWidget {
  const ProjectTab({super.key});

  @override
  State<ProjectTab> createState() => _ProjectTabState();
}

class _ProjectTabState extends State<ProjectTab> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isLoading = true;
  List<ProjectModel>? projects = [];

// MARK: Function to get user data from the backend based on the access token and store it in the local storage
  Future<void> _getProjects() async {
    final SharedPreferences prefs = await _prefs;

    var projectsData = await UserServices()
        .getUserProjects(prefs.getString('token').toString());

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
                          "Projects",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )
                : projects != null
                    ? projects!.isNotEmpty
                        ? ProjectListItem(
                            projectModel: projects![i - 1], isOwn: true)
                        : const Text("No Project Uploaded Yet")
                    : const Text("Unable to fetch projects"),
          ),
        ),
      ),
    );
  }
}
