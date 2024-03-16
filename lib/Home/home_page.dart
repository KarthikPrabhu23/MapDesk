// ignore_for_file: unused_import, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import "package:flutter/material.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map1/Home/add_room.dart';
import 'package:map1/Home/components/banner_home_widget.dart';
import 'package:map1/Home/components/room_element_widget.dart';
import 'package:map1/Home/components/room_scrollview_widget.dart';
import 'package:map1/Home/profile_page.dart';
import 'package:map1/LoginSignup/components/session_controller.dart';
import 'package:map1/Map/map_loc.dart';
import 'package:map1/Home/home_page.dart';
import 'package:location/location.dart';
import 'package:map1/Map/map_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    // required this.title,
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

  @override
  void initState() {
    super.initState();
    location = Location();
   
    _userLocationRef = FirebaseDatabase.instance.ref().child('User');
    _getCurrentUser();
    _getLocation();
     firestoreLogin();
    _subscribeToLocationChanges();
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
        // desiredAccuracy: LocationAccuracy.high,
        // distanceFilter:
        //     10, // Minimum distance between location updates (in meters)
        );

    // Store location updates in Firestore
    locationStream.listen(
      (Position position) {
        storeUserLocation(
            uid, position.latitude, position.longitude, currEmail);
      },
    );
  }

  Future<void> storeUserLocation(
      String uid, double latitude, double longitude, String currEmail) async {
    print('Inside storeUserLocation');
    try {
      String? emailId = FirebaseAuth.instance.currentUser?.email;

//  Stashed changes
      await firestore.FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(
        {
          'location': {
            'lat': latitude,
            'lng': longitude,
            'timestamp': firestore.FieldValue.serverTimestamp(),
          },
          'emailid': currEmail.toString(),
          'name': ufullname,
          // 'fullname': ufullname,
        },
      );
      print('User location stored ');
    } catch (error) {
      print('Error storing user location: $error');
    }
  }

  void _getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;

    // Check if the user is signed in
    if (auth.currentUser != null) {
      // The user is signed in, you can get the UID
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
        setState(
          () {
            currentLocation = locationData;
          },
        );
        print(locationData);
        print('Latitude is ${locationData.latitude}');
        print('Longitude is ${locationData.longitude}');
        _updateLocationInDatabase(locationData);
      },
    );
  }

  void _updateLocationInDatabase(LocationData locationData) {
    if (currentLocation != null) {
      // print('currUid is');
      print(currUid);

      String userId = currUid.toString(); // Replace with your user ID
      _userLocationRef.child(userId).update(
        {
          'latitude': locationData.latitude,
          'longitude': locationData.longitude,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'TrackNow',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
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
                  backgroundColor: Colors.amber,
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YmVhY2hlc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60'),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: BannerHomeWidget(),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
                  child: Text(
                    'Rooms ',
                    style: TextStyle(
                      fontSize: 27,
                    ),
                  ),
                ),
                RoomScrollView(dbRef: dbRef),
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          iconColor: Colors.blue,
                          backgroundColor:
                              const Color.fromARGB(115, 108, 172, 90)
                          // icon: const Icon(Icons.map_rounded),
                          ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapLoc()),
                        );
                      },
                      child: const Text('Open Map'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          iconColor: Colors.blue,
                          backgroundColor:
                              const Color.fromARGB(115, 108, 172, 90)
                          // icon: const Icon(Icons.map_rounded),
                          ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapScreen()),
                        );
                      },
                      child: const Text('Open Map 2'),
                    ),
                  ],
                ),
                // IconButton(
                //   icon: const Icon(Icons.map),
                //   iconSize: 40,
                //   tooltip: 'Go to Map',
                //   onPressed: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => const MapLoc()),
                //       );
                //   },
                // ),
              ],
            ),
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
                  label: const Text('Add room'),
                ),
              ),
              // FloatingActionButton.extended(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => const MapLoc()),
              //     );
              //   },
              //   icon: const Icon(Icons.map_rounded),
              //   label: const Text('Open Map'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// 'https://images.unsplash.com/photo-1543610892-0b1f7e6d8ac1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTE1fHx1c2VyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60'

// https://images.unsplash.com/photo-1601456713871-996c8765d82c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fGJlYWNoZXN8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60'