// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_const_constructors

import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import '../mainShift/home.dart';

class splash extends StatelessWidget {
  const splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: AnimatedSplashScreen(
        splashIconSize: MediaQuery.of(context).size.height,
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/logo.png',
              width: width * 0.5,
            ),
          ],
        ),
        pageTransitionType: PageTransitionType.fade,
        splashTransition: SplashTransition.fadeTransition,
        animationDuration: Duration(milliseconds: 500),
        duration: 2000,
        backgroundColor: Colors.grey.shade50,
        nextScreen: home(),
      ),
    );
  }
}
