import 'package:flutter/material.dart';
import 'package:freshone/navigator/navigator.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../loginCRED/login&signin.dart';
import '../auth.dart';

class home extends StatelessWidget {
  home({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotateMultiple,
                  colors: [
                    Color.fromARGB(255, 165, 214, 255),
                    Color.fromARGB(255, 246, 192, 255),
                    Color.fromARGB(255, 255, 199, 217)
                  ],
                  strokeWidth: 2,
                  backgroundColor: Colors.white,
                  pathBackgroundColor: Colors.white),
            ),
          );
        }
        if (snapshot.hasData) {
          return navigator();
        } else {
          return losi();
        }
      },
    );
  }
}
