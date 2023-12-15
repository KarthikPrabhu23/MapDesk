// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:map1/Home/add_room.dart';
import 'package:map1/Home/home_page.dart';
import 'package:map1/LoginSignup/login_page.dart';
import 'package:map1/LoginSignup/signup_page.dart';
import 'package:map1/LoginSignup/signup_widget.dart';
import 'package:map1/Map/map_loc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Map1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage()
      // home: AddRoom(),
      // home: MapLoc(),
      // home: const SignUpWidget(),
      // home: const SignUp(),
      home: LoginPage(),
    );
  }
}

