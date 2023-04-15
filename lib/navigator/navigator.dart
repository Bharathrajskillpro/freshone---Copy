import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/addPage/Add.dart';
import '/collabPage/collab.dart';
import '../homePage/home.dart';
import '../theme/colors.dart';
import '../theme/theme.dart';

class navigator extends StatefulWidget {
  @override
  State<navigator> createState() => _navigatorState();
}

class _navigatorState extends State<navigator> {
  final List<Widget> widgetList = [Add(), Home(), Collab()];

  int index = 1;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isdark = themeProvider.isDark;
    var backGrad = !isdark ? colors.backgroundDark : colors.backgroundLight;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    fontColor(opacity) => !isdark
        ? colors.textColorDark(opacity)
        : colors.textColorLight(opacity);
    return Container(
      decoration: BoxDecoration(gradient: backGrad),
      child: WillPopScope(
        onWillPop: () async {
          if (index == 1) {
            return true;
          } else {
            setState(() {
              index = 1;
            });
            return false;
          }
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
                border: Border.all(color: fontColor(.1)),
                borderRadius: BorderRadius.circular(12),
                color: fontColor(.05)),
            margin: EdgeInsets.only(
                bottom: height * 0.02, left: width * 0.08, right: width * 0.08),
            child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: index,
                onTap: (value) {
                  setState(() {
                    index = value;
                  });
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedIconTheme: IconThemeData(size: width * 0.09),
                unselectedIconTheme: IconThemeData(size: width * 0.075),
                selectedLabelStyle: const TextStyle(fontSize: 0),
                unselectedFontSize: 0,
                items: [
                  navBarItem(
                    icon: Icons.add_box_rounded,
                    state: 0,
                  ),
                  navBarItem(
                    icon: Icons.home_rounded,
                    state: 1,
                  ),
                  navBarItem(
                    icon: Icons.people_alt_rounded,
                    state: 2,
                  ),
                ]),
          ),
          body: SafeArea(
            child: IndexedStack(
              index: index,
              children: widgetList,
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem navBarItem({
    required IconData icon,
    required int state,
  }) {
    return BottomNavigationBarItem(
      backgroundColor: Colors.transparent,
      icon: index == state
          ? ShaderMask(
              shaderCallback: (Rect rect) => colors.gradiant.createShader(rect),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            )
          : Icon(icon, color: const Color.fromARGB(255, 84, 86, 133)),
      label: '',
    );
  }
}
