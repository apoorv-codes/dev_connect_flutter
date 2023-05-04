import 'package:dev_connect/Model/UserModel.dart';
import 'package:dev_connect/widgets/MemberListItem.dart';
import 'package:flutter/material.dart';

class ProjectInvites extends StatefulWidget {
  final List<UserModel>? users;
  const ProjectInvites({Key? key, required this.users}) : super(key: key);

  @override
  State<ProjectInvites> createState() => _ProjectInvitesState();
}

class _ProjectInvitesState extends State<ProjectInvites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 36.0),
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
                  const Material(
                    type: MaterialType.transparency,
                    child: Text(
                      "Join Requests",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.users != null
                      ? List.generate(
                          widget.users!.length ?? 0,
                          (i) => MemberListItem(user: widget.users![i]),
                        )
                      : [],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
