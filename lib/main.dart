// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:map1/TargetSelectPage/add_room.dart';
import 'package:map1/Home/home_page.dart';
import 'package:map1/LoginSignup/login_page.dart';
import 'package:map1/LoginSignup/signup_page.dart';
import 'package:map1/Map/map_loc.dart';
import 'package:map1/app_constants.dart';
import 'package:map1/components/helper.dart';
import 'package:map1/my_colors.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

const String appName = "MapDesk";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: Constants.apiKey,
      appId: Constants.appId,
      messagingSenderId: Constants.messagingSenderId,
      projectId: Constants.projectId,
    ));
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // TODO:
  // FirebaseAppCheck.instance.activate(webRecaptchaSiteKey: 'YOUR_RECAPTCHA_SITE_KEY');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        isSignedIn = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        primaryColor: MyColors.ButtonBlue,
        // scaffoldBackgroundColor: Color(0xFFE7F6FF),
        colorScheme: ColorScheme.fromSeed(seedColor: MyColors.ButtonBlue),
        useMaterial3: true,
      ),
      // home: const MyHomePage()
      // home: AddRoom(),
      // home: MapLoc(),
      // home: const SignUpWidget(),
      // home: const SignUp(),
      home: LoginPage(),

      // home: isSignedIn ? MyHomePage() : LoginPage(),
    );
  }
}
