import 'package:dev_connect/Model/ProjectModel.dart';
import 'package:dev_connect/widgets/ProjectListItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final List<ProjectModel> _projects = [
    ProjectModel(
        id: "1",
        name: "Test",
        owner: "Apoorv",
        duration: "2",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 1),
    ProjectModel(
        id: "1",
        name: "Test",
        owner: "Apoorv",
        duration: "2",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 1),
    ProjectModel(
        id: "1",
        name: "Test",
        owner: "Apoorv",
        duration: "2",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 1),
    ProjectModel(
        id: "1",
        name: "Test",
        owner: "Apoorv",
        duration: "2",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 1),
    ProjectModel(
        id: "1",
        name: "Test",
        owner: "Apoorv",
        duration: "2",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 1),
    ProjectModel(
        id: "1",
        name: "Test",
        owner: "Apoorv",
        duration: "2",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 1),
    ProjectModel(
        id: "1",
        name: "Test",
        owner: "Apoorv",
        duration: "2",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 1),
    ProjectModel(
        id: "1",
        name: "Test",
        owner: "Apoorv",
        duration: "2",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 1),
    ProjectModel(
        id: "1",
        name: "Test",
        owner: "Apoorv",
        duration: "2",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 1),
    ProjectModel(
        id: "1",
        name: "Test",
        owner: "Apoorv",
        duration: "2",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 1),
    ProjectModel(
        id: "1",
        name: "Test",
        owner: "Apoorv",
        duration: "2",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 1),
    ProjectModel(
        id: "1",
        name: "Test",
        owner: "Apoorv",
        duration: "2",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 1)
  ];

  Future<void> _getProjects() async {
    // var projectsData = await
  }

  @override
  void initState() {
    super.initState();
    _getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - (220),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            _projects.length,
            (i) => i == 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Explore",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  )
                : ProjectListItem(
                    projectModel: _projects[i], isOwn: i % 2 == 0),
          ),
        ),
      ),
    );
  }
}
