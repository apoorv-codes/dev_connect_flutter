import 'package:flutter/material.dart';

class ProjectDetail extends StatefulWidget {
  const ProjectDetail({Key? key}) : super(key: key);

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Project Detail Screen"),
      ),
    );
  }
}
