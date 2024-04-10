// ignore_for_file: avoid_print, unused_import

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map1/Chat/chat_screen.dart';
import 'package:map1/TargetSelectPage/add_room.dart';
import 'package:map1/Home/components/banner_home_widget.dart';
import 'package:map1/Home/components/room_scrollview_widget.dart';
import 'package:map1/Home/profile_page.dart';
import 'package:location/location.dart';
import 'package:map1/Map/map_screen.dart';
import 'package:map1/Record/record.dart';
import 'package:map1/components/helper.dart';
import 'package:map1/components/my_button.dart';
import 'package:map1/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  final String title = "Home";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currEmail = "";
  String currUid = "";
  LocationData? currentLocation;
  var currentUser = FirebaseAuth.instance.currentUser;
  Query dbRef = FirebaseDatabase.instance.ref().child('Rooms');
  late Location location;
  String ufullname = "Default";

  late DatabaseReference _userLocationRef;

  Future<String?> loggedInUsername = HelperFunctions.getUserNameFromSF();

  @override
  void initState() {
    super.initState();
    location = Location();
    _userLocationRef = FirebaseDatabase.instance.ref().child('User');
    _getCurrentUser();
    _getLocation();
    firestoreLogin();
    _subscribeToLocationChanges();

    printUsername();
  }

  void printUsername() async {
    final username = await loggedInUsername;
    print("LoggedInUsername is: $username");
  }

  Future<void> firestoreLogin() async {
    print('Inside firestoreLogin');
    try {
      // Once signed in, start tracking the user's location
      startLocationTracking(currUid);
    } catch (error) {
      print('Error Storing to Firestore  ');
    }
  }

  Future<void> startLocationTracking(String uid) async {
    print('Inside startLocationTracking');

    // Start listening for location updates
    final locationStream = Geolocator.getPositionStream(
        // locationSettings: LocationAccuracy.high,
        // LocationAccuracyStatusValue = 'Precise',
        // distanceFilter:
        //     10, // Minimum distance between location updates (in meters)
        );

    // Store location updates in Firestore
    locationStream.listen(
      (Position position) {
        try {
          storeUserLocation(
              uid, position.latitude, position.longitude, currEmail);
        } catch (e) {
          print('An error occurred inside locationStream: $e');
        }
      },
    );
  }

  Future<void> storeUserLocation(
      String uid, double latitude, double longitude, String currEmail) async {
    print('Inside storeUserLocation');
    try {
      await firestore.FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({
        'location': {
          'lat': latitude,
          'lng': longitude,
        },
        'name': "Default",
      });
      print('User location updated ');
    } catch (error) {
      print('Error storing user location: $error');
    }
  }

  void _getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;

    // Check if the user is signed in
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      print('Current User UID: $uid \n _getCurrentUser');

      currUid = uid;
    } else {
      print('No user signed in');
    }
  }

  Future<void> _getLocation() async {
    try {
      LocationData locationData = await location.getLocation();
      setState(
        () {
          currentLocation = locationData;
        },
      );
      _updateLocationInDatabase(locationData);
    } catch (e) {
      print('Error: $e');
    }
  }

  void _subscribeToLocationChanges() {
    location.onLocationChanged.listen(
      (LocationData locationData) {
        if (!mounted) return; // Check if widget is mounted before setState
        setState(() {
          currentLocation = locationData;
        });
        print(locationData);
        print('Latitude is ${locationData.latitude}');
        print('Longitude is ${locationData.longitude}');
        _updateLocationInDatabase(locationData);
      },
    );
  }

  void _updateLocationInDatabase(LocationData locationData) {
    if (currentLocation != null) {
      print('currUid is $currUid');

      String userId = currUid.toString();
      _userLocationRef.child(userId).update(
        {
          'latitude': locationData.latitude,
          'longitude': locationData.longitude,
        },
      );
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _subscribeToLocationChanges();
  //   _getLocation();
  //   _getCurrentUser();
  //   firestoreLogin();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          automaticallyImplyLeading: false,
          toolbarHeight: 82,
          title: const Text(
            'TrackNow',
            style: TextStyle(
              fontSize: 31,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 28.0),
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: Color.fromARGB(222, 21, 30, 132),
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60'),
                    //   backgroundImage: NetworkImage(
                    //       HelperFunctions.getUserDPurlSF()),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(18.0),
              //   child: TopBarFb3(
              //     title: 'Welcome back,',
              //     upperTitle: loggedInUsername.toString(),
              //   ),
              // ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                child: BannerHomeWidget(),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
                child: Text(
                  'Target visits',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                  ),
                ),
              ),
              RoomScrollView(dbRef: dbRef),
              MyButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapScreen()),
                  );
                },
                buttonIcon: Icons.map,
                buttonText: 'Open Map',
              ),
              MyButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RecordLog()),
                  );
                },
                buttonIcon: Icons.book,
                buttonText: 'Record Logs',
              ),
              MyButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                },
                buttonIcon: Icons.book,
                buttonText: 'Chat Screen',
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddRoom()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Add Task',
                    style: TextStyle(
                      fontFamily: 'YourCustomFont',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopBarFb3 extends StatelessWidget {
  final String title;
  final String upperTitle;

  const TopBarFb3({required this.title, required this.upperTitle, Key? key})
      : super(key: key);

  final primaryColor = const Color(0xff4338CA);
  final secondaryColor = const Color(0xff6D28D9);
  final accentColor = const Color(0xffffffff);
  final backgroundColor = const Color(0xffffffff);
  final errorColor = const Color(0xffEF4444);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle, // Ensure rectangular shape
        borderRadius: const BorderRadius.all(
          Radius.circular(18),
        ),
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.normal)),
            Text(upperTitle,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}


// 'https://images.unsplash.com/photo-1543610892-0b1f7e6d8ac1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTE1fHx1c2VyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60'

// https://images.unsplash.com/photo-1601456713871-996c8765d82c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fGJlYWNoZXN8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60'