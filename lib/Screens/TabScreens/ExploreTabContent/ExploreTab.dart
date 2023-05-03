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
  final List<ProjectModel> _projects = [
    ProjectModel(
        id: "1",
        name: "Full",
        owner: "Apoorv",
        duration: "2",
        tech: [
          Tech(id: "1", name: "tech"),
          Tech(id: "2", name: "tech"),
          Tech(id: "3", name: "tech")
        ],
        users: [
          UserModel(
              firstName: "Apoorv",
              lastName: "Verma",
              email: "apoorv@gmail.com",
              tech: [
                Tech(id: "1", name: "tech"),
                Tech(id: "2", name: "tech"),
                Tech(id: "3", name: "tech")
              ]),
          UserModel(
              firstName: "Apoorv",
              lastName: "Verma",
              email: "apoorv@gmail.com",
              tech: [
                Tech(id: "1", name: "tech"),
                Tech(id: "2", name: "tech"),
                Tech(id: "3", name: "tech")
              ]),
          UserModel(
              firstName: "Apoorv",
              lastName: "Verma",
              email: "apoorv@gmail.com",
              tech: [
                Tech(id: "1", name: "tech"),
                Tech(id: "2", name: "tech"),
                Tech(id: "3", name: "tech")
              ]),
          UserModel(
              firstName: "Apoorv",
              lastName: "Verma",
              email: "apoorv@gmail.com",
              tech: [
                Tech(id: "1", name: "tech"),
                Tech(id: "2", name: "tech"),
                Tech(id: "3", name: "tech")
              ]),
          UserModel(
              firstName: "Apoorv",
              lastName: "Verma",
              email: "apoorv@gmail.com",
              tech: [
                Tech(id: "1", name: "tech"),
                Tech(id: "2", name: "tech"),
                Tech(id: "3", name: "tech")
              ]),
          UserModel(
              firstName: "Apoorv",
              lastName: "Verma",
              email: "apoorv@gmail.com",
              tech: [
                Tech(id: "1", name: "tech"),
                Tech(id: "2", name: "tech"),
                Tech(id: "3", name: "tech")
              ]),
          UserModel(
              firstName: "Apoorv",
              lastName: "Verma",
              email: "apoorv@gmail.com",
              tech: [
                Tech(id: "1", name: "tech"),
                Tech(id: "2", name: "tech"),
                Tech(id: "3", name: "tech")
              ]),
          UserModel(
              firstName: "Apoorv",
              lastName: "Verma",
              email: "apoorv@gmail.com",
              tech: [
                Tech(id: "1", name: "tech"),
                Tech(id: "2", name: "tech"),
                Tech(id: "3", name: "tech")
              ]),
          UserModel(
              firstName: "Apoorv",
              lastName: "Verma",
              email: "apoorv@gmail.com",
              tech: [
                Tech(id: "1", name: "tech"),
                Tech(id: "2", name: "tech"),
                Tech(id: "3", name: "tech")
              ]),
          UserModel(
              firstName: "Apoorv",
              lastName: "Verma",
              email: "apoorv@gmail.com",
              tech: [
                Tech(id: "1", name: "tech"),
                Tech(id: "2", name: "tech"),
                Tech(id: "3", name: "tech")
              ]),
          UserModel(
              firstName: "Apoorv",
              lastName: "Verma",
              email: "apoorv@gmail.com",
              tech: [
                Tech(id: "1", name: "tech"),
                Tech(id: "2", name: "tech"),
                Tech(id: "3", name: "tech")
              ]),
          UserModel(
              firstName: "Apoorv",
              lastName: "Verma",
              email: "apoorv@gmail.com",
              tech: [
                Tech(id: "1", name: "tech"),
                Tech(id: "2", name: "tech"),
                Tech(id: "3", name: "tech")
              ])
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 1),
    ProjectModel(
        id: "2",
        name: "Test",
        owner: "Apoorv",
        duration: "2",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 1),
  ];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int page = 1;
  Future<void> _getProjects() async {
    final SharedPreferences prefs = await _prefs;

    var exploreProjects = ProjectService()
        .getExploreProjectList(await prefs.getString('token').toString(), page);
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
            _projects.length + 1,
            (i) => i == 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: const [
                        Text(
                          "Explore",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  )
                : ProjectListItem(
                    projectModel: _projects[i - 1], isOwn: (i - 1) % 2 == 0),
          ),
        ),
      ),
    );
  }
}
