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

  Future<void> addUser() async {
    final path = 'photo/${emailcontroller.text.trim()}';
    final ref = FirebaseStorage.instance.ref().child(path);
    final wait = ref.putFile(image!);
    final oncomple = await wait.whenComplete(() => {});
    final p = await oncomple.ref.getDownloadURL();
    print(p);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(emailcontroller.text.trim().toLowerCase())
        .set(
      {
        'name': nameController.text.trim(),
        'email': emailcontroller.text.trim().toLowerCase(),
        'password': passwordcontroller.text.trim(),
        'photo': p,
      },
    );
  }

  File? image;

  Future imagepicker(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final tempImage = File(image.path);
      setState(() => this.image = tempImage);
    } on PlatformException catch (e) {
      print('Failed to pick the image');
    }
  }

  snackbar() => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 109, 109, 109),
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

  InkWell photo(double height, Image imager, String fromwere) {
    return InkWell(
      onTap: () => snackbar(),
      child: Stack(
        children: [
          ClipOval(
            child: imager,
          ),
          fromwere == "image"
              ? const Positioned(
                  bottom: 0,
                  right: 4,
                  child: Icon(
                    Icons.add_a_photo_rounded,
                    color: Colors.greenAccent,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
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
            color: Colors.white,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(field),
        ],
      ),
    );
  }

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
                color: Color.fromARGB(255, 102, 227, 189),
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
                Color.fromARGB(255, 240, 255, 250),
                Color.fromARGB(255, 194, 255, 233)
              ]),
              border: Border.all(
                color: Color.fromARGB(255, 87, 222, 184),
              ),
              borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10),
          child: Text(
            login ? 'LOGIN' : 'SIGNIN',
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.w600,
            ),
          )),
    );
  }

  TextField field(double width, String labeltext,
      TextEditingController controller, TextInputType type, IconData icon) {
    return TextField(
      controller: controller,
      cursorColor: fontcolor(1.0),
      scrollPadding: EdgeInsets.zero,
      style: TextStyle(fontSize: width * 0.04),
      keyboardType: type,
      decoration: InputDecoration(
        labelText: labeltext,
        labelStyle:
            TextStyle(color: fontcolor(.5), fontWeight: FontWeight.w500),
        prefixIconColor: fontcolor(.4),
        fillColor: fontcolor(.8),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: fontcolor(.9)),
            borderRadius: BorderRadius.circular(12),
            gapPadding: 6),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: fontcolor(.2)),
            borderRadius: BorderRadius.circular(8),
            gapPadding: 6),
        focusColor: fontcolor(.9),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: fontcolor(.5)),
            borderRadius: BorderRadius.circular(2),
            gapPadding: 6),
        contentPadding: EdgeInsets.zero,
        prefixIcon: Icon(
          icon,
          size: width * 0.07,
        ),
      ),
    );
  }

  Widget align(child) {
    return Align(alignment: Alignment.center, child: child);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.02),
          child: Column(
            children: [
              align(
                Image.asset(
                  'assets/icon/logo.png',
                  width: width * 0.6,
                ),
              ),
              SizedBox(height: height * 0.03),
              Text(
                login
                    ? 'Welcome Back! Glad to see you, Again!'.toUpperCase()
                    : 'Welcome to incubateqr ! have a nice journey'
                        .toUpperCase(),
                style: TextStyle(
                    fontFamily: 'EBGaramond',
                    wordSpacing: 6,
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 53, 53, 53)),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              login
                  ? const SizedBox()
                  : image == null
                      ? photo(
                          height,
                          Image.asset(
                            'assets/icon/profile.png',
                            height: height * 0.1,
                          ),
                          "asset")
                      : photo(
                          height,
                          Image.file(
                            image!,
                            width: height * 0.1,
                            height: height * 0.1,
                            fit: BoxFit.cover,
                          ),
                          "image"),
              login
                  ? const SizedBox()
                  : SizedBox(
                      height: height * 0.02,
                    ),
              login
                  ? const SizedBox()
                  : field(width, 'Enter your name', nameController,
                      TextInputType.text, Icons.person),
              login
                  ? const SizedBox()
                  : SizedBox(
                      height: height * 0.02,
                    ),
              field(width, 'Enter your Email Id', emailcontroller,
                  TextInputType.emailAddress, Icons.mail_outline_rounded),
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
