import 'package:dev_connect/Model/ProjectModel.dart';
import 'package:dev_connect/Model/TechModel.dart';
import 'package:dev_connect/Screens/ProjectScreens/ProjectDetailScreen.dart';
import 'package:dev_connect/Services/ProjectsServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late int dur;
  bool liked = false;

  Future<void> _likeProject() async {
    final SharedPreferences prefs = await _prefs;
    List<Tech> tech = widget.projectModel.tech ?? [];

    liked = true;

    await ProjectService().showInterestInProject(
        prefs.getString('token').toString(),
        widget.projectModel.id.toString() ?? "",
        tech);
    setState(() {});
  }

  Future<void> _loadProject() async {
    final SharedPreferences prefs = await _prefs;
    List<String> likedPrj = prefs.getStringList("interests") ?? [];
    String projectID = widget.projectModel.id.toString();

    setState(() {
      liked = likedPrj.contains(projectID);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProject();
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
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(widget.projectModel.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                          ),
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
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Wrap(
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
                      ),
                      const SizedBox(height: 8),
                      Text(
                          "Duration: ${((dur / (365 * 24)).round() > 0) ? "${(dur / (365 * 24)).round()} Years" : (dur / (24 * 30)).round() > 0 ? "${(dur / (30 * 24)).round()} Months" : (dur / 24).round() > 0 ? "${(dur / 24).round()} Days" : "$dur Hrs"}")
                    ],
                  ),
                  const Spacer(),
                  (widget.isOwn
                      ? PopupMenuButton(
                          itemBuilder: (context) => [
                                PopupMenuItem<int>(
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.edit,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "Edit",
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 0,
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.delete_forever,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "Delete",
                                      ),
                                    ],
                                  ),
                                ),
                              ])
                      : IconButton(
                          onPressed: () {
                            _likeProject();
                          },
                          icon: const Icon(Icons.favorite),
                          color: liked ? Colors.red : Colors.grey,
                        )),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProjectDetail(
                                      projectModel: widget.projectModel,
                                      isOwn: widget.isOwn,
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
