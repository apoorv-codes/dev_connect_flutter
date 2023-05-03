import 'package:dev_connect/Model/ProjectModel.dart';
import 'package:dev_connect/Model/TechModel.dart';
import 'package:dev_connect/Screens/ProjectScreens/ProjectDetailScreen.dart';
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
  late int dur;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      dur = int.parse(widget.projectModel.duration);
    });
  }

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
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.projectModel.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 12),
                          CircleAvatar(
                              radius: 12,
                              child: Text(
                                "${widget.projectModel.owner.split(" ")[0][0]} ",
                                style: const TextStyle(fontSize: 10),
                              )),
                          const SizedBox(width: 4),
                          Text(
                            widget.projectModel.owner,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        alignment: WrapAlignment.start,
                        children: List.generate(
                          widget.projectModel.tech?.length ?? 0,
                          (index) {
                            return Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color.fromARGB(
                                        128, 155, 155, 155)),
                                child: Text(
                                  widget.projectModel.tech![index].name,
                                  style: const TextStyle(fontSize: 10),
                                ));
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                          "Duration: ${((dur / (365 * 24)).round() > 0) ? "${(dur / (365 * 24)).round()} Years" : (dur / (24 * 30)).round() > 0 ? "${(dur / (30 * 24)).round()} Months" : (dur / 24).round() > 0 ? "${(dur / 24).round()} Days" : "$dur Hrs"}")
                    ],
                  ),
                  const Spacer(),
                  (widget.isOwn
                      ? IconButton(
                          onPressed: () {}, icon: const Icon(Icons.more_horiz))
                      : IconButton(
                          onPressed: () {}, icon: const Icon(Icons.favorite))),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProjectDetail(
                                      projectModel: widget.projectModel,
                                    )));
                      },
                      icon: const Icon(Icons.chevron_right)),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
