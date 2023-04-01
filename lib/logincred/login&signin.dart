// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../auth.dart';

class losi extends StatefulWidget {
  const losi({super.key});

  @override
  State<losi> createState() => _losiState();
}

class _losiState extends State<losi> {
  bool login = true;

  String? errormessage = "";

  final emailcontroller = TextEditingController();

  final passwordcontroller = TextEditingController();

  final nameController = TextEditingController();
  var fontcolor = (opacity) => Color.fromRGBO(48, 40, 76, opacity);
  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    nameController.dispose();
    super.dispose();
  }

  clear() {
    nameController.clear();
    passwordcontroller.clear();
    emailcontroller.clear();
  }

  Future<void> signinwithEmailandPassword() async {
    try {
      await auth().signinWithEmailandPassword(
          email: emailcontroller.text.trim(),
          password: passwordcontroller.text.trim());
    } on FirebaseAuthException catch (e) {
      setState(() {
        errormessage = e.message;
      });
    }
  }

  Future<void> createUserwithEmailandPassword() async {
    try {
      await auth().createUserWithEmailandPassword(
          email: emailcontroller.text.trim(),
          password: passwordcontroller.text.trim());
    } on FirebaseAuthException catch (e) {
      setState(() {
        errormessage = e.message;
      });
    }
  }

  String? p;
  Future<void> addUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(emailcontroller.text.trim().toLowerCase())
        .set(
      {
        'name': nameController.text.trim(),
        'email': emailcontroller.text.trim().toLowerCase(),
        'password': passwordcontroller.text.trim(),
        // 'photo': p,
      },
    );
  }

  File? imager;

  String? firstemail;

  // Future imagepicker(ImageSource source) async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: source);
  //     if (image == null) return;
  //     final tempImage = File(image.path);
  //     setState(() => this.imager = tempImage);
  //     final path = 'photo/${emailcontroller.text.trim()}';
  //     print(path);
  //     final ref = FirebaseStorage.instance.ref().child(path).putFile(imager!);
  //     final oncomple = await ref.whenComplete(() => {});
  //     p = await oncomple.ref.getDownloadURL();
  //     print(p);
  //   } on PlatformException catch (e) {
  //     print('Failed to pick the image');
  //   }
  // }

  // snackbar() => ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Color.fromARGB(255, 255, 255, 255),
  //         content: Column(
  //           children: [
  //             selector(Icons.camera, "Camera", ImageSource.camera),
  //             const SizedBox(
  //               height: 12,
  //             ),
  //             selector(Icons.folder, "Gallery", ImageSource.gallery)
  //           ],
  //         ),
  //       ),
  //     );

  // InkWell photo(double height, Image imager, String fromwere) {
  //   return InkWell(
  //     onTap: () {
  //       if (emailcontroller.text.isEmpty) {
  //         setState(() {
  //           firstemail = "Please enter the email first";
  //         });
  //       } else {
  //         snackbar();
  //       }
  //     },
  //     child: Stack(
  //       children: [
  //         ClipOval(
  //           child: imager,
  //         ),
  //         fromwere == "image"
  //             ? const Positioned(
  //                 bottom: 0,
  //                 right: 4,
  //                 child: Icon(
  //                   Icons.add_a_photo_rounded,
  //                   color: Colors.greenAccent,
  //                 ),
  //               )
  //             : const SizedBox(),
  //       ],
  //     ),
  //   );
  // }

  // Widget selector(IconData icon, String field, ImageSource source) {
  //   return GestureDetector(
  //     onTap: () => imagepicker(source),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         const SizedBox(
  //           width: 10,
  //         ),
  //         Icon(
  //           icon,
  //           color: Color.fromARGB(255, 0, 0, 0),
  //         ),
  //         const SizedBox(
  //           width: 20,
  //         ),
  //         Text(
  //           field,
  //           style: TextStyle(color: Colors.black),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget shifting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? 'Dont have an Account?  ' : 'Have an Existing Account?  ',
          style: const TextStyle(
              color: Colors.black38, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        GestureDetector(
          onTap: () => setState(() {
            login = !login;
            clear();
          }),
          child: Text(
            login ? 'Signin' : 'Login',
            style: const TextStyle(
                fontSize: 18,
                letterSpacing: 1,
                color: Color.fromRGBO(248, 97, 146, 1),
                fontWeight: FontWeight.w600,
                fontFamily: 'Acme'),
          ),
        )
      ],
    );
  }

  Widget submitbutton(width, height) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (errormessage == '' ||
              errormessage == 'The email is badly formated') {
            if (login) {
              signinwithEmailandPassword();
              print('done');
            } else {
              createUserwithEmailandPassword();
              addUser();
              print('object');
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(milliseconds: 600),
                content:
                    Text('Hum?$errormessage', textAlign: TextAlign.center)));
            errormessage = "";
          }
        });
      },
      child: Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Color.fromRGBO(255, 211, 223, 1),
                Color.fromRGBO(255, 161, 191, 1)
              ]),
              // border: Border.all(
              //   color: Color.fromRGBO(248, 97, 146, 1),
              // ),
              borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10),
          child: Text(
            login ? 'LOGIN' : 'SIGNIN',
            style: TextStyle(
                fontSize: width * 0.04,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 63, 63, 63)),
          )),
    );
  }

  Widget field(double width, String labeltext, TextEditingController controller,
      TextInputType type, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      width: width * 0.85,
      child: TextField(
        onSubmitted: (value) {
          setState(() {
            if (firstemail != null && controller == emailcontroller) {
              firstemail = null;
            }
          });
        },
        controller: controller,
        cursorColor: fontcolor(1.0),
        scrollPadding: EdgeInsets.zero,
        style: TextStyle(fontSize: width * 0.04),
        keyboardType: type,
        decoration: InputDecoration(
          hintText: labeltext,
          hintStyle:
              TextStyle(color: fontcolor(.5), fontWeight: FontWeight.w500),
          prefixIconColor: fontcolor(.4),
          fillColor: fontcolor(.8),
          border: InputBorder.none,
          prefixIcon: Icon(
            icon,
            size: width * 0.07,
          ),
        ),
      ),
    );
  }

  Widget align(child) {
    return Align(alignment: Alignment.center, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final color = Color.fromRGBO(239, 239, 255, 1);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: color,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.04),
          child: Column(
            children: [
              align(
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Image.asset(
                    'assets/icon/logo.png',
                    width: width * 0.25,
                    height: width * 0.25,
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    login ? 'Welcome back! to ' : 'Welcome to ',
                    style: TextStyle(
                        fontFamily: 'Singni',
                        wordSpacing: 6,
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 53, 53, 53)),
                  ),
                  Text(
                    ' incubateQR'.toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'Singni',
                        wordSpacing: 6,
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(248, 97, 146, 1)),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.08,
              ),
              // login
              //     ? const SizedBox()
              //     : imager == null
              //         ? Stack(
              //             clipBehavior: Clip.none,
              //             children: [
              //               photo(
              //                   height,
              //                   Image.asset(
              //                     'assets/icon/profile.png',
              //                     height: height * 0.1,
              //                   ),
              //                   "asset"),
              //               const Positioned(
              //                 bottom: 0,
              //                 right: -4,
              //                 child: Icon(
              //                   Icons.add_a_photo_rounded,
              //                   color: Color.fromRGBO(248, 97, 146, 1),
              //                 ),
              //               ),
              //             ],
              //           )
              //         : photo(
              //             height,
              //             Image.file(
              //               imager!,
              //               width: height * 0.1,
              //               height: height * 0.1,
              //               fit: BoxFit.cover,
              //             ),
              //             "image"),
              // login
              //     ? const SizedBox()
              //     : SizedBox(
              //         height: height * 0.03,
              //       ),
              login
                  ? const SizedBox()
                  : field(width, 'Enter your name', nameController,
                      TextInputType.text, Icons.person),
              login
                  ? const SizedBox()
                  : SizedBox(
                      height: height * 0.02,
                    ),
              field(
                width,
                'Enter your Email Id',
                emailcontroller,
                TextInputType.emailAddress,
                Icons.mail_outline_rounded,
              ),
              // firstemail == null
              //     ? SizedBox()
              //     : Align(
              //         alignment: Alignment.centerRight,
              //         child: Padding(
              //           padding: EdgeInsets.only(right: width * 0.05),
              //           child: Text(
              //             firstemail!,
              //             style: const TextStyle(
              //                 color: Color.fromARGB(255, 255, 73, 134)),
              //           ),
              //         )),
              SizedBox(
                height: height * 0.02,
              ),
              field(width, "Enter your password", passwordcontroller,
                  TextInputType.visiblePassword, Icons.password_outlined),
              SizedBox(
                height: height * 0.04,
              ),
              align(submitbutton(width, height)),
              SizedBox(
                height: height * 0.05,
              ),
              shifting(),
            ],
          ),
        ),
      )),
    );
  }
}
