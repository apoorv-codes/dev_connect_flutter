import 'package:dev_connect/Model/ProjectModel.dart';
import 'package:dev_connect/Screens/ProjectScreens/ProjectDetailScreen.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel projectModel;

  ProjectCard({super.key, required this.projectModel});

  @override
  Widget build(BuildContext context) {
    var dur = int.parse(projectModel.duration);
    return Container(
      width: 240,
      height: 230,
      margin: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(70, 70, 70, 0.302),
              blurRadius: 4.0,
              spreadRadius: 0.1,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    projectModel.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${(DateTime.now().difference(projectModel.createdAt).inDays).toString()} Days Ago",
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Wrap(
                  spacing: 3,
                  runSpacing: 3,
                  children: List.generate(
                    projectModel.tech?.length ?? 0,
                    (index) {
                      return Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color.fromARGB(128, 155, 155, 155)),
                          child: Text(
                            projectModel.tech![index].name,
                            style: const TextStyle(fontSize: 10),
                          ));
                    },
                  ),
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                      "Duration: ${((dur / (365 * 24)).round() > 0) ? "${(dur / (365 * 24)).round()} Years" : (dur / (24 * 30)).round() > 0 ? "${(dur / (30 * 24)).round()} Months" : (dur / 24).round() > 0 ? "${(dur / 24).round()} Days" : "$dur Hrs"}"),
                ],
              ),
              // Card action
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.message_rounded)),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectDetail(
                            projectModel: projectModel,
                            isOwn: true,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Details"),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
