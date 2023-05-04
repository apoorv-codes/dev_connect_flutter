import 'package:dev_connect/Model/UserModel.dart';
import 'package:dev_connect/Services/ProjectsServices.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberListItem extends StatelessWidget {
  final UserModel user;
  String? projectId;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  MemberListItem({super.key, required this.user, this.projectId});

  // accept invite
  Future<void> _acceptInvite() async {
    final SharedPreferences prefs = await _prefs;

    await ProjectService().acceptProjectInvite(
        prefs.getString('token').toString(),
        projectId ?? "",
        user.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 25,
                  child: Text(
                    "${user.firstName.substring(0, 1)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 3,
                      runSpacing: 3,
                      children: List.generate(
                        user.tech?.length ?? 0,
                        (index) {
                          return Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      const Color.fromARGB(128, 155, 155, 155)),
                              child: Text(
                                user.tech![index].name,
                                style: const TextStyle(fontSize: 10),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  _acceptInvite();
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.yellow.shade200,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
