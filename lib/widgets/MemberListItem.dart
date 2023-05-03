import 'package:dev_connect/Model/UserModel.dart';
import 'package:flutter/material.dart';

class MemberListItem extends StatelessWidget {
  final UserModel user;

  const MemberListItem({super.key, required this.user});

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
                      spacing: 8,
                      children: [
                        for (final tech in user.tech!)
                          Chip(
                            label: Text(tech.name),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                onPressed: () {},
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
