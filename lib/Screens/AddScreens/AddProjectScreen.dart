import 'package:dev_connect/Model/TechModel.dart';
import 'package:dev_connect/Screens/AuthenticationScreens/SelectTechScreen.dart';
import 'package:dev_connect/Services/AuthServices.dart';
import 'package:dev_connect/Services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> durations = <String>['hours', 'days', 'months', 'years'];

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectDurationController = TextEditingController();
  String durationUnit = durations.first;

  List<Tech> _techs = [];
  List<Tech> _selectedTech = [];

  Future<void> _createProject(List<Tech> selectedTechs) async {
    final SharedPreferences prefs = await _prefs;
    var dur = int.parse(projectDurationController.text);

    if (durationUnit == durations[1]) {
      dur = dur * 24;
    } else if (durationUnit == durations[2]) {
      dur = dur * 24 * 30;
    } else if (durationUnit == durations.last) {
      dur = dur * 24 * 356;
    }

    await UserServices().createProjects(prefs.getString('token').toString(),
        projectNameController.text, selectedTechs, dur.toString());
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: TextButton(
                  onPressed: () {
                    if (_techs.length != 0)
                      _techs.removeRange(0, _techs.indexOf(_techs.last));
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Text(
                  "Add Projects",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextButton(
                    onPressed: () {
                      _createProject(_selectedTech);
                      if (_techs.length != 0)
                        _techs.removeRange(0, _techs.indexOf(_techs.last));
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: const Center(
                        child: Text(
                          "Add",
                          style: TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  autocorrect: true,
                  enableSuggestions: true,
                  controller: projectNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    hintText: 'Project Name',
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        autocorrect: false,
                        enableSuggestions: false,
                        controller: projectDurationController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          hintText: 'Duration',
                        ),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButton<String>(
                        value: durationUnit,
                        elevation: 16,
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            durationUnit = value!;
                          });
                        },
                        items: durations
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    )),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.52,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
                                          _techs[tech].isSelected =
                                              !(_techs[tech].isSelected ??
                                                  false);
                                        });
                                        if (!_selectedTech
                                            .contains(_techs[tech])) {
                                          _selectedTech.add(_techs[tech]);
                                        } else {
                                          _selectedTech.remove(_techs[tech]);
                                        }
                                      },
                                      selected:
                                          _techs[tech].isSelected ?? false,
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
                                const Center(
                                    child: Text("Unable to Fetch Interests"))
                              ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
