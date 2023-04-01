import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshone/auth.dart';
import 'package:freshone/pages/profile/profilepage.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/physics.dart';

import '../../theme/theme.dart';

class topbar extends StatefulWidget {
  topbar({
    super.key,
    required this.fontcolor,
  });

  final Color Function(dynamic opacity) fontcolor;

  @override
  State<topbar> createState() => _topbarState();
}

class _topbarState extends State<topbar> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  var top = -20.0;
  late Animation<double> animate;
  String? email = auth().currentUser!.email;
  bool lightOn = false;
  File? localimage;

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    controller.addListener(() {
      setState(() {
        top = animate.value;
        print(animate.value);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void runAnimation() {
    animate = Tween<double>(begin: top, end: -20.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.bounceOut,
    ));

    controller.reset();
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isdark = themeProvider.isDark;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get()
          .asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final entries = snapshot.data!.data()!.entries;
          final name =
              entries.firstWhere((element) => element.key == 'name').value;
          final path =
              entries.firstWhere((element) => element.key == 'photo').value;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromRGBO(233, 210, 149, 1),
                                  Color.fromRGBO(250, 170, 87, 1),
                                  Color.fromRGBO(250, 97, 215, 1),
                                  Color.fromRGBO(253, 127, 17, 1)
                                ])),
                        child: Text(
                          name[0].toString().toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.055),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'welcome',
                        style: TextStyle(
                            color: widget.fontcolor(0.5),
                            fontWeight: FontWeight.w500,
                            fontSize: width * 0.045),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                            color: widget.fontcolor(1.0),
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.055),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      final image = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => profile()));
                      setState(() {
                        localimage = image;
                      });
                    },
                    child: Container(
                      height: width * 0.16,
                      width: width * 0.16,
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: widget.fontcolor(1.0), width: 2),
                          image: localimage != null
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(localimage!))
                              : DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(path))),
                    ),
                  )
                ],
              ),
              Positioned(
                  right: width * 0.15,
                  top: top,
                  child: GestureDetector(
                    onPanDown: (details) {
                      controller.stop();
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        if (top >= 22) {
                          runAnimation();
                        } else {
                          top = (details.localPosition.dy / 4.0);
                        }
                      });
                    },
                    onPanEnd: (details) {
                      if (top >= 20) {
                        runAnimation();
                        setState(() {
                          lightOn = !lightOn;
                          final provider = Provider.of<ThemeProvider>(context,
                              listen: false);
                          provider.toggleTheme(!lightOn);
                        });
                      }
                      print('down');
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          bottom: -10,
                          left: -10,
                          child: Container(
                            height: height * .1,
                            width: height * .1,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(200, 255, 255, 255),
                                    blurRadius: 90)
                              ],
                              gradient: RadialGradient(colors: [
                                Color.fromARGB(100, 255, 255, 255),
                                Color.fromARGB(50, 255, 255, 255),
                                Color.fromARGB(5, 255, 255, 255),
                                Color.fromARGB(1, 255, 255, 255),
                              ]),
                            ),
                          ),
                        ),
                        Image.asset(
                          !lightOn
                              ? 'assets/icon/off light.png'
                              : 'assets/icon/on light.png',
                          height: height * 0.15,
                        ),
                      ],
                    ),
                  ))
            ],
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
