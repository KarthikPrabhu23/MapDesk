// This is the new Map with Firestore connection

// ignore_for_file: avoid_print, unused_import

import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map1/Home/home_page.dart';
import 'package:map1/Map/classes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:map1/Map/target_card.dart';
import 'package:map1/Map/target_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  bool clientsToggle = true;
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  late StreamSubscription<Position>? locationStreamSubscription;
  late GoogleMapController mapController;
  Set<Marker> setOfMarkers = {};

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(
        12.898799, 74.984734), // Default position (e.g., center of the world)
    zoom: 10, // Default zoom level
  );

  @override
  void dispose() {
    super.dispose();
    locationStreamSubscription?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchtargetLocation();

    locationStream();
  }

  StreamSubscription<Position>? locationStream() {
    return locationStreamSubscription =
      StreamLocationService.onLocationChanged?.listen(
    (position) async {
      String uid = getCurrentUserUid();

      // Check if user exists in Firestore
      bool userExists = await FirestoreService.doesUserExist(uid);

      if (userExists) {
        // Update user location
        await FirestoreService.updateUserLocation(
            uid, LatLng(position.latitude, position.longitude));
      } else {
        // Add new user to Firestore
        await FirestoreService.addNewUser(
          uid,
          User(
            name: 'New User', // Provide a default name for new users
            location: Location(
              lat: position.latitude,
              lng: position.longitude,
            ),
          ),
        );
      }
    },
  );
  }

  String getCurrentUserUid() {
    var user = auth.FirebaseAuth.instance.currentUser;
    String uid;

    if (user != null) {
      uid = user.uid;
      print('Current user UID: $uid');
    } else {
      uid = "no uid found";
      print('No user is currently signed in.');
    }

    print(uid);

    return uid;
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      );
    });
  }

  _fetchtargetLocation() {
    databaseReference.child('Rooms').get().then(
      (DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;

        values.forEach(
          (key, values) {
            setOfMarkers.add(
              Marker(
                markerId: MarkerId(key),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
                position: LatLng(
                  double.parse(values['latitude'].toString()),
                  double.parse(values['longitude'].toString()),
                ),
                infoWindow: InfoWindow(
                  title: values['roomName'].toString(),
                  snippet: values['roomLocation'].toString(),
                ),
              ),
            );
          },
        );

        setState(
          () {
            clientsToggle = true;
          },
        );
      },
    );

    return setOfMarkers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height - 44,
                child: StreamBuilder<List<User>>(
                  stream: FirestoreService.userCollectionStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No data available'),
                      );
                    }

                    // final Set<Marker> markers = {};
                    for (var i = 0; i < snapshot.data!.length; i++) {
                      final user = snapshot.data![i];
                      setOfMarkers.add(
                        Marker(
                          markerId: MarkerId('${user.name} position $i'),
                          icon: user.name == 'stephano'
                              ? BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueRed,
                                )
                              : BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueYellow,
                                ),
                          // icon: markerIcon,
                          infoWindow: InfoWindow(
                            title: user.name.toString(),
                            snippet: user.name.toString(),
                          ),
                          position:
                              LatLng(user.location.lat, user.location.lng),
                          onTap: () => {},
                        ),
                      );
                    }
                    return GoogleMap(
                      initialCameraPosition: _initialPosition,
                      markers: setOfMarkers,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    );
                  },
                ),
              ),

              // THIS IS THE SCROLL LOCATIONS ON MAP FEATURE
              TargetSlider(clientsToggle: clientsToggle, setOfMarkers: setOfMarkers, controller: _controller),
            ],
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(30, 65, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()),
                    );
                  },
                  // icon: const Icon(Icons.home),
                  child: const Icon(Icons.arrow_back_ios_new),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}