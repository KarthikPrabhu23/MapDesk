// This is the new Map with Firestore connection

// ignore_for_file: avoid_print

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map1/Home/home_page.dart';
import 'package:map1/Map/classes.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(12.898799, 74.984734), // Default position (e.g., center of the world)
    zoom: 10, // Default zoom level
  );

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late GoogleMapController mapController;

  bool clientsToggle = true;

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Set<Marker> setOfMarkers = {};

  // static const CameraPosition _initialPosition = CameraPosition(
  //   target: LatLng(12.898799, 74.984734), // Antananarivo, Madagascar
  //   zoom: 14.4746,
  // );

  late StreamSubscription<Position>? locationStreamSubscription;

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

  // @override
  // void initState() {
  //   super.initState();
  //   locationStreamSubscription =
  //       StreamLocationService.onLocationChanged?.listen(
  //     (position) async {
  //       await FirestoreService.updateUserLocation(
  //         getCurrentUserUid(), //Hardcoded uid but this is the uid of the connected user when using authentification service
  //         LatLng(position.latitude, position.longitude),
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchtargetLocation();
    locationStreamSubscription =
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

  Widget targetCard(element) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 10),
      child: InkWell(
        onTap: () {
          zoomInMarker(element);
        },
        child: Container(
          height: 100,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: const Color.fromARGB(197, 57, 151, 227)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                element.infoWindow.title.toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  zoomInMarker(element) {
    _controller.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(element.position.latitude, element.position.longitude),
            zoom: 18,
            bearing: 90,
            tilt: 50,
          ),
        ),
      );
    });
  }

  void zoomOutMarker() {
    _controller.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            target: LatLng(12.898799, 74.984734),
            zoom: 16,
          ),
        ),
      );
    });
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
              Positioned(
                top: MediaQuery.of(context).size.height - 240,
                child: SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: clientsToggle
                      ? ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.all(9),
                          children: setOfMarkers.map((element) {
                            if (element.icon ==
                                BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueRed)) {
                              return targetCard(element);
                            } else {
                              return targetCard(element);
                            }
                          }).toList(),
                        )
                      : const SizedBox(
                          height: 1,
                          width: 1,
                        ),
                ),
              ),
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

  @override
  void dispose() {
    super.dispose();
    locationStreamSubscription?.cancel();
  }
}
