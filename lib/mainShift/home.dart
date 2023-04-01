import 'package:flutter/material.dart';

import '../loginCRED/login&signin.dart';
import '/pages/start.dart';
import '../auth.dart';

class home extends StatelessWidget {
  home({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print(auth().currentUser!.email);
          return start();
        } else {
          return losi();
        }
      },
    );
  }
}
