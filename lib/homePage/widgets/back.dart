import 'package:flutter/material.dart';

class back extends StatelessWidget {
  const back({
    super.key,
    required this.width,
    required this.fontcolor,
  });

  final double width;
  final Color Function(dynamic opacity) fontcolor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
          child: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: width * 0.07,
        color: fontcolor(1.0),
      )),
    );
  }
}
