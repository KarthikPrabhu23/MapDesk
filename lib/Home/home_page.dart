
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map1/Home/add_room.dart';
import 'package:map1/Home/components/banner_home_widget.dart';
import 'package:map1/Home/components/room_scrollview_widget.dart';
import 'package:map1/Home/profile_page.dart';
import 'package:location/location.dart';
import 'package:map1/Map/map_screen.dart';
import 'package:map1/Record/record.dart';

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
      // locationSettings: LocationAccuracy.high,
      // LocationAccuracyStatusValue = 'Precise',
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
      await firestore.FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({
        'location': {
          'lat': latitude,
          'lng': longitude,
          'timestamp': firestore.FieldValue.serverTimestamp(),
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
  void dispose(){
    super.dispose();
    // _subscribeToLocationChanges();
    // _getLocation();
    // _getCurrentUser();
    firestoreLogin();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'TrackNow',
            style: TextStyle(
              fontSize: 31,
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                              colors: [Color(0xff4338CA), Color(0xff6D28D9)])),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          alignment: Alignment.center,
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(
                                  right: 45, left: 45, top: 15, bottom: 15)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MapScreen()),
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize
                              .min, // Restrict size based on content
                          children: [
                            Icon(
                              Icons.map_rounded,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              "Open Map",
                              style: TextStyle(
                                  color: Color(0xffffffff), fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [Color(0xff4338CA), Color(0xff6D28D9)],
                        ),
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          alignment: Alignment.center,
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(
                                  right: 45, left: 45, top: 15, bottom: 15)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RecordLog()),
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize
                              .min, // Restrict size based on content
                          children: [
                            Icon(
                              Icons.book_rounded,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              "Record Log",
                              style: TextStyle(
                                  color: Color(0xffffffff), fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
                  label: const Text('Add room'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 'https://images.unsplash.com/photo-1543610892-0b1f7e6d8ac1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTE1fHx1c2VyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60'

// https://images.unsplash.com/photo-1601456713871-996c8765d82c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fGJlYWNoZXN8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60'