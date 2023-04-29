import 'package:dev_connect/Model/ProjectModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProjectListItem extends StatefulWidget {
  final ProjectModel projectModel;
  final bool isOwn;

  const ProjectListItem(
      {Key? key, required this.projectModel, required this.isOwn})
      : super(key: key);

  @override
  State<ProjectListItem> createState() => _ProjectListItemState();
}

class _ProjectListItemState extends State<ProjectListItem> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          width: width * 0.97,
          margin: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.202),
                blurRadius: 4.0,
                spreadRadius: 0.1,
              ),
            ],
          ),
          child: Card(
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Project Name",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          SizedBox(width: 12),
                          CircleAvatar(
                              radius: 12,
                              child: Text(
                                "TE",
                                style: TextStyle(fontSize: 10),
                              )),
                          SizedBox(width: 4),
                          Text(
                            "Project Owner",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          alignment: WrapAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(128, 155, 155, 155)),
                                child: const Text(
                                  "test",
                                  style: TextStyle(fontSize: 10),
                                )),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(128, 155, 155, 155)),
                                child: const Text(
                                  "test",
                                  style: TextStyle(fontSize: 10),
                                )),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(128, 155, 155, 155)),
                                child: const Text(
                                  "test",
                                  style: TextStyle(fontSize: 10),
                                )),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(128, 155, 155, 155)),
                                child: const Text(
                                  "test",
                                  style: TextStyle(fontSize: 10),
                                ))
                          ]),
                      SizedBox(height: 8),
                      Text("Duration: 3 Months")
                    ],
                  ),
                  const Spacer(),
                  widget.isOwn
                      ? IconButton(
                          onPressed: () {}, icon: Icon(Icons.more_horiz))
                      : IconButton(onPressed: () {}, icon: Icon(Icons.favorite))
                ])),
          ),
        )
      ],
    );
  }
}
