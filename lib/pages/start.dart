import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme.dart';
import 'add/addpush.dart';
import 'department/department.dart';
import 'widgets/recent.dart';
import 'widgets/search.dart';
import 'widgets/topbar.dart';

class start extends StatelessWidget {
  start({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isdark = themeProvider.isDark;
    fontcolor(opacity) => !isdark
        ? Color.fromRGBO(239, 241, 255, opacity)
        : Color.fromRGBO(48, 40, 76, opacity);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: addpush(),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isdark
                  ? const [
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromRGBO(235, 235, 255, 1)
                    ]
                  : const [
                      Color.fromRGBO(63, 64, 100, 1),
                      Color.fromRGBO(34, 34, 61, 1)
                    ],
            ),
          ),
          padding: EdgeInsets.only(
              top: height * .02, left: width * 0.05, right: width * 0.05),
          child: SafeArea(
            child: Column(
              children: [
                topbar(
                  fontcolor: fontcolor,
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                search(fontcolor: fontcolor),
                SizedBox(
                  height: height * 0.04,
                ),
                department(fontcolor: fontcolor),
                SizedBox(
                  height: height * 0.04,
                ),
                recent(fontcolor: fontcolor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
