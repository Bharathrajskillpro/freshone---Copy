import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshone/auth.dart';
import 'package:freshone/pages/widgets/back.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../../theme/theme.dart';

class profile extends StatefulWidget {
  profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

bool imageLoaded = false;

class _profileState extends State<profile> {
  String? p;
  File? imager;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future imagepicker(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final tempImage = File(image.path);

      setState(() {
        this.imager = tempImage;
        imageLoaded = true;
      });
      final path = 'photo/${auth().currentUser!.email}';
      print(path);
      final ref = FirebaseStorage.instance.ref().child(path).putFile(imager!);
      final oncomple = await ref.whenComplete(() => {});
      final downloadedPath = await oncomple.ref.getDownloadURL();
      print(p);
      setState(() {
        p = downloadedPath;
      });
    } on PlatformException catch (e) {
      print('Failed to pick the image');
    }
  }

  Widget selector(IconData icon, String field, ImageSource source) {
    return GestureDetector(
      onTap: () => imagepicker(source),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 10,
          ),
          Icon(
            icon,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            field,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  snackbar() => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          content: Column(
            children: [
              selector(Icons.camera, "Camera", ImageSource.camera),
              const SizedBox(
                height: 12,
              ),
              selector(Icons.folder, "Gallery", ImageSource.gallery)
            ],
          ),
        ),
      );
  InkWell photo(
    double width,
    String path,
    String email,
    Color Function(dynamic opacity) fontcolor,
  ) {
    return InkWell(
      onTap: () {
        snackbar();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: imager != null
                ? Image.file(
                    imager!,
                    fit: BoxFit.cover,
                    width: width * 0.3,
                    height: width * .3,
                  )
                : Image.network(
                    path,
                    fit: BoxFit.cover,
                    width: width * 0.3,
                    height: width * .3,
                  ),
          ),
          Positioned(
            bottom: 0,
            right: -16,
            child: Icon(
              Icons.add_a_photo_rounded,
              size: width * 0.08,
              color: fontcolor(1.0),
            ),
          ),
        ],
      ),
    );
  }

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
              top: height * .04, left: width * 0.05, right: width * 0.05),
          child: SafeArea(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth().currentUser!.email)
                  .get()
                  .asStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final dataMap = snapshot.data!.data()!.entries.toList();
                  final name = dataMap
                      .firstWhere((element) => element.key == 'name')
                      .value;
                  final email = auth().currentUser!.email;
                  final password = dataMap
                      .firstWhere((element) => element.key == 'password')
                      .value;
                  p = dataMap
                      .firstWhere((element) => element.key == 'photo')
                      .value;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context, imager),
                            child: Container(
                                child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: width * 0.07,
                              color: fontcolor(1.0),
                            )),
                          ),
                          Image.asset(
                            !isdark
                                ? 'assets/icon/moon.png'
                                : 'assets/icon/sun.png',
                            width: width * .1,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.035,
                      ),
                      RippleAnimation(
                        color: fontcolor(.8),
                        repeat: true,
                        minRadius: 50,
                        ripplesCount: 6,
                        child: photo(
                          width,
                          p!,
                          email!,
                          fontcolor,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: fontcolor(1.0),
                            fontSize: width * 0.045),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        email,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: fontcolor(.8),
                            fontSize: width * 0.04),
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      field(
                        fromWhere: 'name',
                        header: "Change Name",
                        name: name,
                        width: width,
                        prefix: Icons.person,
                        fontcolor: fontcolor,
                        controller: nameController,
                        suffix: Icon(
                          Icons.edit,
                          size: width * 0.07,
                          color: fontcolor(.5),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      field(
                        fromWhere: 'password',
                        header: "Change Password",
                        name: password,
                        width: width,
                        prefix: Icons.password_rounded,
                        fontcolor: fontcolor,
                        controller: passwordController,
                        suffix: Icon(
                          Icons.edit,
                          size: width * 0.07,
                          color: fontcolor(.5),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          auth().signout();
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          elevation: MaterialStatePropertyAll(6),
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(
                                horizontal: width * 0.08, vertical: 10),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            isdark
                                ? Colors.white
                                : Color.fromRGBO(63, 64, 100, 1),
                          ),
                        ),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                              color: fontcolor(1.0),
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.045),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.1,
                      )
                    ],
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget field(
      {required String fromWhere,
      required String header,
      required String name,
      required double width,
      required IconData prefix,
      required Color Function(dynamic opacity) fontcolor,
      required TextEditingController controller,
      required Widget suffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: fontcolor(1.0),
              fontSize: width * .045),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          margin: const EdgeInsets.only(top: 10),
          width: width * 0.85,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [fontcolor(.05), fontcolor(.1)]),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: fontcolor(.2)),
          ),
          child: Row(
            children: [
              Icon(
                prefix,
                size: width * 0.07,
                color: fontcolor(.5),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  autocorrect: true,
                  controller: controller,
                  onSubmitted: (val) {
                    setState(() {
                      print('done');
                      if (val.isNotEmpty) {
                        var toChange = FirebaseFirestore.instance
                            .collection('users')
                            .doc(auth().currentUser!.email);
                        if (fromWhere == 'name') {
                          toChange.update({'name': controller.text.trim()});
                        } else if (fromWhere == 'password') {
                          auth().changePassword(
                              email: auth().currentUser!.email,
                              oldPassword: name,
                              newPassword: controller.text.trim());
                          toChange.update({'password': controller.text.trim()});
                        }
                      }
                    });
                  },
                  style: TextStyle(
                      color: fontcolor(.8),
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: "Recent: " + name,
                    hintStyle: TextStyle(
                        color: fontcolor(0.5),
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500),
                    contentPadding: const EdgeInsets.all(0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              suffix
            ],
          ),
        ),
      ],
    );
  }
}
