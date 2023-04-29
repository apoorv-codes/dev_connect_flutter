import 'package:dev_connect/Model/TechModel.dart';
import 'package:dev_connect/Screens/TabScreens/TabsScreen.dart';
import 'package:dev_connect/Services/AuthServices.dart';
import 'package:dev_connect/Services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectTechScreen extends StatefulWidget {
  const SelectTechScreen({super.key});

  @override
  State<SelectTechScreen> createState() => _SelectTechScreenState();
}

class _SelectTechScreenState extends State<SelectTechScreen> {
  // MARK: Function to get all tech on the platform for user to select
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<Tech> _techs = [];
  List<Tech> _selectedTech = [];

  Future<void> _selectTechs() async {
    final SharedPreferences prefs = await _prefs;
    await UserServices()
        .selectTechs(prefs.getString('token').toString(), _selectedTech);
  }

  Future<void> _getAllTech() async {
    var techs = await AuthService().getAllTechs();

    if (techs != null) {
      setState(() {
        _techs = techs;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllTech();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 56, left: 8, right: 8, bottom: 12),
        child: Column(
          children: [
            Padding(
              //Custom Top Bar
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Hero(
                    tag: "logo",
                    child: Material(
                      type: MaterialType.transparency,
                      child: Row(
                        children: const [
                          Image(
                            image:
                                AssetImage("assets/images/devconnect-logo.png"),
                            height: 40,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Dev Connect",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const TabsScreen()),
                            (Route route) => false);
                      },
                      child: Row(
                        children: const [
                          SizedBox(
                            width: 2,
                          ),
                          Text("Skip"),
                          Icon(Icons.chevron_right),
                        ],
                      ))
                ],
              ),
            ),
            const Text(
              "Select technologies you are interested in: ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: _techs != null
                      ? _techs.isNotEmpty
                          ? List.generate(_techs.length, (tech) {
                              return FilterChip(
                                onSelected: (value) {
                                  setState(() {
                                    _techs[tech].isSelected = !(_techs[tech].isSelected ?? false);
                                  });
                                  if (!_selectedTech.contains(_techs[tech])) {
                                    _selectedTech.add(_techs[tech]);
                                  } else {
                                    _selectedTech.remove(_techs[tech]);
                                  }
                                },
                                selected: _techs[tech].isSelected ?? false,
                                label: Text(_techs[tech].name),
                              );
                            })
                          : [
                              const Center(
                                  child: Text(
                                "You have not shown interest in any tech yet",
                              ))
                            ]
                      : [
                          const Center(child: Text("Unable to Fetch Interests"))
                        ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextButton(
                  onPressed: () async {
                    await _selectTechs();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const TabsScreen()),
                        (Route route) => false);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.black),
                    width: 180,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    child: Row(
                      children: const [
                        Text(
                          'Finish',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.east,
                          color: Colors.white,
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
