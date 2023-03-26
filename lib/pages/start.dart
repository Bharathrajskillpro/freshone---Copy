import 'package:flutter/material.dart';

import 'widgets/collaborator.dart';
import 'widgets/addpush.dart';
import 'widgets/department.dart';
import 'widgets/recent.dart';
import 'widgets/search.dart';
import 'widgets/topbar.dart';

class start extends StatelessWidget {
  start({super.key});

  var fontcolor = (opacity) => Color.fromRGBO(48, 40, 76, opacity);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: addpush(),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 241, 235, 252),
                Color.fromARGB(255, 255, 255, 255)
              ],
            ),
          ),
          padding: EdgeInsets.only(
              top: height * .02, left: width * 0.04, right: width * 0.04),
          child: SafeArea(
            child: Column(
              children: [
                topbar(
                  fontcolor: fontcolor,
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                search(fontcolor: fontcolor),
                SizedBox(
                  height: height * 0.02,
                ),
                department(fontcolor: fontcolor),
                SizedBox(
                  height: height * 0.02,
                ),
                recent(fontcolor: fontcolor),
                SizedBox(
                  height: height * 0.02,
                ),
                // Collaborator(fontcolor: fontcolor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
