import 'package:dev_connect/Screens/AddScreens/AddProjectScreen.dart';
import 'package:dev_connect/Screens/TabScreens/ExploreTabContent/ExploreTab.dart';
import 'package:dev_connect/Screens/TabScreens/FavouriteTabContent/FavouriteTab.dart';
import 'package:dev_connect/Screens/TabScreens/HomeTabContent/HomeTab.dart';
import 'package:dev_connect/Screens/TabScreens/ProjectsTabContent/ProjectTab.dart';
import 'package:dev_connect/Screens/UserAccountScreens/AccountDetailsScreen.dart';
import 'package:dev_connect/Services/UserServices.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _selectedIndex = 0;
  var topBarTitle = "";

  // MARK: Function to get user data from the backend based on the access token and store it in the local storage
  Future<void> getUserData() async {
    final SharedPreferences prefs = await _prefs;

    var userDataResponse = await UserServices()
        .getUserData(await prefs.getString('token').toString());

    if (userDataResponse != null) {
      List<String> intrestList = [];
      List<String> projectList = [];

      for (var intrest in userDataResponse.interest!) {
        intrestList.add(intrest.toString());
      }

      for (var project in userDataResponse.projects!) {
        projectList.add(project);
      }
// user data saved here
      prefs.setString('firstName', userDataResponse.firstName);
      prefs.setString('lastName', userDataResponse.lastName);
      prefs.setString('email', userDataResponse.email);
      prefs.setString('location', userDataResponse.location ?? "");
      prefs.setString('img', userDataResponse.img ?? "");
      prefs.setStringList('interests', intrestList);
      prefs.setStringList('projects', projectList);
      prefs.setString(
          'tech', const JsonEncoder().convert(userDataResponse.tech));
      prefs.setString(
          'createdAt', userDataResponse.createdAt!.toIso8601String());
      prefs.setString(
          'updatedAt', userDataResponse.updatedAt!.toIso8601String());
    }
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

// List of tabs
  static const List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    FavouriteTab(),
    ExploreTab(),
    ProjectTab()
  ];

  static const TAB_NAMES = ["Dev Connect", "Favourite", "Explore", "Projects"];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> logoutUser() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.clear();
  }

  @override
  void initState() {
    // this function loads the user data from backend into the localStorage
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 36),
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
                              image: AssetImage(
                                  "assets/images/devconnect-logo.png"),
                              height: 40,
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
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountDetailsScreen()));
                      },
                      icon: const Icon(
                        Icons.person,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_widgetOptions.elementAt(_selectedIndex)],
              ),
            ],
          ),
        ),

        // Bottom TAB Bar
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  minHeight: MediaQuery.of(context).size.height * 0.5),
              builder: (BuildContext context) {
                return AddProjectScreen();
              },
            );
          },
          shape: CircleBorder(),
          backgroundColor: Colors.yellow.shade400,
          tooltip: 'Increment',
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
          elevation: 2.0,
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.teal.shade900,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.code),
              label: 'Projects',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.teal.shade400,
          selectedItemColor: Colors.tealAccent.shade100,
          enableFeedback: true,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
