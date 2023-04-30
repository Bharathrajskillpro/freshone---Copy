import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import 'widgets/recent.dart';
import 'widgets/search.dart';
import 'widgets/topbar.dart';
import 'department/department.dart';

class Home extends StatelessWidget {
  Home({super.key});
  RefreshController _refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isdark = themeProvider.isDark;
    fontcolor(opacity) => !isdark
        ? Color.fromRGBO(239, 241, 255, opacity)
        : Color.fromRGBO(48, 40, 76, opacity);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.only(
          top: height * .04, left: width * 0.05, right: width * 0.05),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            topbar(
              fontcolor: fontcolor,
            ),
            search(fontcolor: fontcolor),
            department(fontcolor: fontcolor),
            recent(fontcolor: fontcolor),
            SizedBox(
              height: height * 0.01,
            )
          ],
        ),
      ),
    );
  }
}
