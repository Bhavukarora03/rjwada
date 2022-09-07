import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:rjwada/UI/pages/authentication_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? prefs;

  Future<bool> checkValidation() async {
    prefs = await SharedPreferences.getInstance();
    return prefs!.containsKey('uid');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkValidation(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool intro = snapshot.data!;
          return AnimatedSplashScreen(
            animationDuration: const Duration(milliseconds: 1),
            backgroundColor: const Color(0xff0c9bfb),
            nextScreen: intro ? const HomeScreen() : const AuthenticatonPage(),
            splash: Image.asset("assets/images/splash.jpeg"),
          );
        } else {
          return const FittedBox();
        }
      },
    );
  }
}
