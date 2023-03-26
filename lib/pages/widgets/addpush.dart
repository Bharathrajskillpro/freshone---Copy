import 'package:flutter/material.dart';

import '../addpage.dart';

class addpush extends StatefulWidget {
  @override
  State<addpush> createState() => _addpushState();
}

class _addpushState extends State<addpush> with TickerProviderStateMixin {
  late AnimationController controller;

  Animation<double>? animation;

  var fontcolor = (opacity) => Color.fromRGBO(48, 40, 76, opacity);

  @override
  void initState() {
    // TODO: implement initState
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ScaleTransition(
            scale: animation,
            child: FadeTransition(
              opacity: Tween<double>(begin: 1, end: 0).animate(controller),
              child: addpage(),
            ),
          ),
        ),
      ),
      child: Image.asset(
        'assets/icon/addfloat.png',
        width: width * 0.15,
      ),
    );
  }
}
