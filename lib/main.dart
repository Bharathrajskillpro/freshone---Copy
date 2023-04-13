// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import './theme/theme.dart';
import 'package:provider/provider.dart';
import '/splash/splash.dart';

int? isviewed;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // fix the orientation to portrait only
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // makes the task bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // app start
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final provider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: 'incubateQR',
          themeMode: provider.themeMode,
          theme: themeShifter.lighttheme,
          darkTheme: themeShifter.darktheme,
          debugShowCheckedModeBanner: false,
          home: splash(),
        );
      },
    );
  }
}
