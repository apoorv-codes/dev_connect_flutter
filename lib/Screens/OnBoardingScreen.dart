import 'package:dev_connect/Screens/AuthenticationScreens/LoginScreen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage("assets/images/devconnect-logo.png"),
                  height: 300,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Center(
                  child: Text(
                    "Dev Connect",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Center(
                  child: Text(
                    "Lets Build Together",
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.black),
                      width: 220,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      child: Row(
                        children: const [
                          Text(
                            'Lets Start',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
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
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
