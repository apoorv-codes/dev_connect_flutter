import 'dart:math';

import 'package:dev_connect/Model/ProjectModel.dart';
import 'package:dev_connect/Model/TechModel.dart';
import 'package:dev_connect/Model/UserModel.dart';
import 'package:dev_connect/Screens/ProjectScreens/projectInvites.dart';
import 'package:dev_connect/Services/ProjectsServices.dart';
import 'package:dev_connect/widgets/MemberListItem.dart';
import 'package:dev_connect/widgets/ProjectListItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectDetail extends StatefulWidget {
  const ProjectDetail(
      {Key? key, required this.projectModel, required this.isOwn})
      : super(key: key);
  final ProjectModel projectModel;
  final bool isOwn;

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<UserModel>? users = [];
  bool _isLoading = false;
  late int dur;

// Join projects
  Future<void> _joinInProject() async {
    final SharedPreferences prefs = await _prefs;

    await ProjectService().sendJoinRequest(
        prefs.getString('token').toString(),
        widget.projectModel.id.toString() ?? "",
        prefs.getString('uid').toString());
  }

// Get invitations list
  Future<void> _getInvitedUsers() async {
    final SharedPreferences prefs = await _prefs;

    var userList = await ProjectService().listJoinRequests(
        prefs.getString('token').toString(),
        widget.projectModel.id.toString() ?? "");

    users = userList;
    setState(() {});
  }

// delete project
  Future<void> _deleteProject() async {
    final SharedPreferences prefs = await _prefs;

    await ProjectService().deleteProject(prefs.getString('token').toString(),
        widget.projectModel.id.toString() ?? "");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getInvitedUsers();
    setState(() {
      dur = int.parse(widget.projectModel.duration);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 36),
        child: Column(
          children: [
            Padding(
              //Custom Top Bar
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                  Material(
                    type: MaterialType.transparency,
                    child: Text(
                      widget.projectModel.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Spacer(),
                  widget.isOwn
                      ? PopupMenuButton(
                          icon: const Icon(Icons
                              .menu), //don't specify icon if you want 3 dot menu
                          color: Colors.yellow,
                          itemBuilder: (context) => [
                            PopupMenuItem<int>(
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "Edit",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 0,
                              onTap: () {
                                _deleteProject();
                              },
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.delete_forever,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (item) => {print(item)},
                        )
                      : const SizedBox(
                          width: 0,
                        ),
                ],
              ),
            ),

            // page Body starts here
            Container(
              height: MediaQuery.of(context).size.height * 0.86,
              child: ModalProgressHUD(
                inAsyncCall: _isLoading,
                child: Column(
                  children: [
                    Row(
                      children: [
                        //Project Owner
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                  radius: 12,
                                  child: Text(
                                    "${widget.projectModel.owner.split(" ")[0][0]}",
                                    style: const TextStyle(fontSize: 10),
                                  )),
                              const SizedBox(width: 4),
                              Text(
                                widget.projectModel.owner,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),

                        Spacer(),

                        //Project created at
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8),
                          child: Row(
                            children: [
                              Text(
                                "Created at: ${widget.projectModel.createdAt.day}/${widget.projectModel.createdAt.month}/${widget.projectModel.createdAt.year}",
                                style: const TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Techs details
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: widget.projectModel.tech != null
                            ? widget.projectModel.tech!.isNotEmpty
                                ? List.generate(
                                    widget.projectModel.tech!.length, (tech) {
                                    return Chip(
                                      label: Text(
                                          widget.projectModel.tech![tech].name),
                                    );
                                  })
                                : [
                                    const Text(
                                        "No tech has been selected for this project")
                                  ]
                            : [
                                const Center(
                                    child: Text("Unable to Fetch techs"))
                              ],
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    //Project Duration
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Text(
                              "Duration:  ${((dur / (365 * 24)).round() > 0) ? "${(dur / (365 * 24)).round()} Years" : (dur / (24 * 30)).round() > 0 ? "${(dur / (30 * 24)).round()} Months" : (dur / 24).round() > 0 ? "${(dur / 24).round()} Days" : "$dur Hrs"}")
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Text(
                            "Members",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              widget.isOwn
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProjectInvites(
                                          users: users ?? [],
                                        ),
                                      ),
                                    )
                                  : _joinInProject();
                            },
                            icon: const Icon(
                              Icons.add_circle_outline_rounded,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //  Members List
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.55,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.projectModel != null
                                ? List.generate(
                                    widget.projectModel.users?.length ?? 0,
                                    (i) => MemberListItem(
                                        user: widget.projectModel.users?[i] ??
                                            UserModel(
                                                firstName: "firstName",
                                                lastName: "lastName",
                                                email: "email"),
                                        projectId:
                                            widget.projectModel.id.toString()),
                                  )
                                : [],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
