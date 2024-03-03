// ignore_for_file: unused_import, avoid_print

// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import "package:flutter/material.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map1/Home/add_room.dart';
import 'package:map1/Home/profile_page.dart';
import 'package:map1/LoginSignup/components/session_controller.dart';
// import 'package:map1/Map/classes.dart';
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

  // final String? roomName;
  // final String? roomLocation;
  // const roomElement(Map room, {super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Rooms');

  LocationData? currentLocation;
  late DatabaseReference _userLocationRef;
  late Location location;
  String currUid = "";
  String currEmail = "";
  String ufullname = "Default";

  var currentUser = FirebaseAuth.instance.currentUser;


  void _getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;

    // Check if the user is signed in
    if (auth.currentUser != null) {
      // The user is signed in, you can get the UID
      String uid = auth.currentUser!.uid;
      print('Current User UID: $uid \n _getCurrentUser');

      currUid = uid;
    } else {
      // No user is signed in
      print('No user signed in');
    }
  }

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
    locationStream.listen((Position position) {
      storeUserLocation(uid, position.latitude, position.longitude, currEmail);
    });
  }

  Future<void> storeUserLocation(
      String uid, double latitude, double longitude, String currEmail) async {
    print('Inside storeUserLocation');
    try {
      // Store the user's location in Firestore
      await firestore.FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({
        'location': {
          'lat': latitude,
          'lng': longitude,
          'timestamp': firestore.FieldValue.serverTimestamp(),
        },
        'emailid': currEmail.toString(),
        'name': ufullname,
        // 'fullname': ufullname,
      });
      print('User location stored ');
    } catch (error) {
      print('Error storing user location: $error');
    }
  }

  Future<void> _getLocation() async {
    try {
      LocationData locationData = await location.getLocation();
      setState(() {
        currentLocation = locationData;
      });
      _updateLocationInDatabase(locationData);
    } catch (e) {
      print('Error: $e');
    }
  }

  void _subscribeToLocationChanges() {
    location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        currentLocation = locationData;
      });
      print(locationData);
      print('Latitude is${locationData.latitude}');
      print('Longitude is${locationData.longitude}');
      _updateLocationInDatabase(locationData);
    });
  }

  void _updateLocationInDatabase(LocationData locationData) {
    if (currentLocation != null) {
      // print('currUid is');
      print(currUid);

      String userId = currUid.toString(); // Replace with your user ID
      _userLocationRef.child(userId).update({
        'latitude': locationData.latitude,
        'longitude': locationData.longitude,
      });
    }
  }

  // UNTOUCHED

// UNTOUCHED
  Widget roomElement({required Map room}) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 0, 8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapLoc()),
                );
              },
              child: Container(
                width: 180,
                height: 334,
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x430F1113),
                      offset: Offset(0, 1),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: room['roomName'],
                        transitionOnUserGestures: true,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://www.google.com/maps/d/u/0/thumbnail?mid=1A4gtHz4iHLjSs1S_fI_f__3baxs&hl=en_US',
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                        child: Text(
                          // 'Room Name',
                          room['roomName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // ignore: prefer_const_constructors
                            Text(
                              '1.',
                            ),
                            Text(
                              // 'roomLocation',
                              room['roomLocation'],
                            ),
                          ],
                        ),
                      ),
                      const Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(4, 4, 0, 0),
                            child: Text(
                              'More info',
                            ),
                          ),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                            size: 24,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Container(
                    width: double.infinity,
                    height: 230,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.network(
                          'https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YmVhY2hlc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                        ).image,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x250F1113),
                          offset: Offset(0, 1),
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0x430F1113),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 70, 0),
                              child: Text(
                                'Some text to write here',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                              child: Text(
                                'Active users',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 8, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 4, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.network(
                                        'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                                        width: 44,
                                        height: 44,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 4, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.network(
                                        'https://images.unsplash.com/photo-1533689476487-034f57831a58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTA4fHx1c2VyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                                        width: 44,
                                        height: 44,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 4, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.network(
                                        'https://www.google.com/maps/d/u/0/thumbnail?mid=1A4gtHz4iHLjSs1S_fI_f__3baxs&hl=en_US',
                                        width: 44,
                                        height: 44,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 12, 0, 0),
                              child: TextButton(
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(255, 0, 140, 255)),
                                ),
                                onPressed: () {
                                  // print('Button pressed ...');
                                },
                                child: const Text(
                                  'Button 1',
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                  child: Container(
                    width: double.infinity,
                    height: 360,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 215, 206, 180),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 5),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          // CONTENT STARTS

                          SizedBox(
                            // width: double.infinity,
                            width: 500,
                            height: 300,
                            child: FirebaseAnimatedList(
                              scrollDirection: Axis.horizontal,
                              query: dbRef.orderByChild("roomName"),
                              itemBuilder: (BuildContext context,
                                  DataSnapshot snapshot,
                                  Animation<double> animation,
                                  int index) {
                                Map room = snapshot.value as Map;

                                room['key'] = snapshot.key;

                                return roomElement(room: room);
                              },
                            ),
                          ),

                          // CONTENT ENDS
                        ],
                      ),
                    ),
                  ),
                ),
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