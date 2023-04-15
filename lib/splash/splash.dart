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
        splashIconSize: height,
        splash: Container(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icon/logo.png',
                width: width * 0.3,
              ),
              SizedBox(
                height: height * 0.1,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: 'incubate',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.07)),
                  TextSpan(
                      text: 'QR',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w800,
                          fontSize: width * 0.08))
                ]),
              )
            ],
          ),
        ),
        pageTransitionType: PageTransitionType.fade,
        splashTransition: SplashTransition.fadeTransition,
        animationDuration: Duration(milliseconds: 500),
        duration: 3000,
        backgroundColor: Colors.grey.shade50,
        nextScreen: home(),
      ),
    );
  }
}
