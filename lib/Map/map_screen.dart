// This is the new Map with Firestore connection
// ignore_for_file: unused_import, avoid_print
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map1/Map/classes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:map1/Map/components/custom_info_window.dart';
import 'package:map1/Map/components/target_card.dart';
import 'package:map1/Map/components/target_slider.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:map1/Map/methods/location_util.dart';

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

  late BitmapDescriptor pinLocationIcon;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final Completer<GoogleMapController> _controllerCompleter =
      Completer<GoogleMapController>();

  // late CameraPosition _initialPosition;
  late CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(12.898799, 74.984734), // Default position
    zoom: 10,
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
    // _fetchtargetLocation();
    fetchTargetLocDataFromFirestore();
    setCustomMapPin();
    locationStream();
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), 'lib/images/user.png');
  }

  StreamSubscription<Position>? locationStream() {
    return locationStreamSubscription =
        StreamLocationService.onLocationChanged?.listen(
      (position) async {
        String uid = LocationUtils.getCurrentUserUid();

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
              username: '',
            ),
          );
        }
      },
    );
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
                icon: values['completed'] == true
                    ? BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue)
                    : BitmapDescriptor.defaultMarkerWithHue(
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
            // clientsToggle = true;
          },
        );
      },
    );

    return setOfMarkers;
  }

  Future fetchTargetLocDataFromFirestore() async {
    // List<Marker> setOfMarkers = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('TargetLoc').get();

      querySnapshot.docs.forEach((doc) {
        setOfMarkers.add(
          Marker(
            markerId: MarkerId(doc.id),
            icon: doc['completed'] == true
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue)
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
            position: LatLng(
              double.parse(doc['location']['lat'].toString()),
              double.parse(doc['location']['lng'].toString()),
            ),
            infoWindow: InfoWindow(
              title: doc['roomName'].toString(),
              snippet: doc['roomLocation'].toString(),
            ),
          ),
        );
      });

      print("Data fetched from TargetLoc");

      return setOfMarkers;
    } catch (error) {
      print('Error fetching data from Firestore: $error');
      return []; // Return an empty list if an error occurs
    }
  }

  Widget targetCard(element) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 10),
      child: InkWell(
        onTap: () {
          zoomInMarker(element);
        },
        child: Container(
          height: 160,
          width: 325,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            // color: const Color.fromARGB(197, 57, 151, 227),
            color: const Color.fromARGB(255, 142, 134, 227),
          ),
          child: Card(
            color: const Color(0xff4338CA),
            elevation: 5.0, // Add some shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Set rounded corners
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Space elements evenly
              children: [
                // Image container
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: 100, // Set image container width
                    height:
                        100, // Set image container height (same as card height)
                    child: ClipRRect(
                      // Clip rounded corners for image
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YmVhY2hlc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                        cacheWidth: 175,
                        cacheHeight: 175,
                        fit: BoxFit.cover, // Adjust fit if needed
                      ),
                    ),
                  ),
                ),
                // Content container
                Expanded(
                  // Expand to fill remaining space
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Add some padding
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Align content vertically
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to left
                      children: [
                        Text(
                          element.infoWindow.title.toString(),
                          style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          element.infoWindow.snippet.toString(),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white70,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              onPressed: () {
                                zoomInMarker(element);
                              },
                              icon: const Row(
                                children: [
                                  Icon(
                                    Icons.verified_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 2),
                                  // Text(
                                  //   'Reached',
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //     fontSize:
                                  //         12, // Adjust the font size as needed
                                  //   ),
                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Button container
                IconButton(
                  icon: const Icon(
                    Icons.car_crash_rounded,
                    color: Colors.white,
                  ), // Replace with your desired icon
                  onPressed: () {
                    // Handle button press event
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  zoomInMarker(element) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(element.position.latitude, element.position.longitude),
          zoom: 18,
          bearing: 90,
          tilt: 50,
        ),
      ),
    );
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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height - 44,
                  child: StreamBuilder<List<Target>>(
                    stream: FirestoreService.targetLocCollectionStream(),
                    builder: (context, targetSnapshot) {
                      if (targetSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!targetSnapshot.hasData ||
                          targetSnapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No data available'),
                        );
                      }

                      // final Set<Marker> markers = {};
                      for (var i = 0; i < targetSnapshot.data!.length; i++) {
                        final targetLoc = targetSnapshot.data![i];
                        setOfMarkers.add(
                          Marker(
                            markerId:
                                MarkerId('${targetLoc.roomName} position $i'),
                            infoWindow: InfoWindow(
                              title: targetLoc.roomName,
                              snippet: targetLoc.roomName,
                              onTap: () {
                                print('Target Info window tapped!');
                              },
                            ),
                            position: LatLng(
                                targetLoc.location.lat, targetLoc.location.lng),
                          ),
                        );
                      }

                      // User's streamBuilder
                      return StreamBuilder<List<User>>(
                        stream: FirestoreService.userCollectionStream(),
                        builder: (userContext, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!userSnapshot.hasData ||
                              userSnapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('No data available'),
                            );
                          }

                          // final Set<Marker> markers = {};
                          for (var i = 0; i < userSnapshot.data!.length; i++) {
                            final user = userSnapshot.data![i];
                            setOfMarkers.add(
                              Marker(
                                markerId: MarkerId('${user.name} position $i'),
                                icon: pinLocationIcon,
                                infoWindow: InfoWindow(
                                  title: user.username,
                                  snippet: user.name,
                                ),
                                position: LatLng(
                                    user.location.lat, user.location.lng),
                                // onTap: () {
                                //   print('Marker id is :');
                                //   print('${user.name} position $i');
                                // },
                              ),
                            );
                          }
                          return GoogleMap(
                            initialCameraPosition: _initialPosition,
                            markers: setOfMarkers,

                            // trafficEnabled: true,
                            // mapType: MapType.hybrid,
                            // fortyFiveDegreeImageryEnabled : true,

                            onMapCreated: (GoogleMapController controller) {
                              mapController = controller;
                              if (!_controllerCompleter.isCompleted) {
                                _controllerCompleter.complete(controller);
                              }
                            },

                            // ----

                            // ---
                          );
                        },
                      );
                    },
                  ),
                ),

                // THIS IS THE SCROLL LOCATIONS ON MAP FEATURE
                // TargetSlider(
                //   clientsToggle: clientsToggle,
                //   setOfMarkers: setOfMarkers,
                //   mapController: mapController,
                // ),

                // THIS IS THE SCROLL LOCATIONS ON MAP FEATURE
                Positioned(
                  top: MediaQuery.of(context).size.height - 240,
                  child: SizedBox(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    child: 
                    // clientsToggle
                    //     ? 
                        ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(9),
                            children: setOfMarkers.map(
                              (element) {
                                return targetCard(element);
                              },
                            ).toList(),
                          )
                        // : const SizedBox(
                        //     height: 1,
                        //     width: 1,
                        //   ),
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
                // crossAxisAlignment: CrossAxisAlignment.,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor:
                        const Color(0xff4338CA), // Set the background color
                    foregroundColor: Colors.white,
                    tooltip: 'First',
                    heroTag: 'First',
                    child: const Icon(Icons.arrow_back_ios_new),
                  ),
                  const SizedBox(
                    height: 460,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      print("MAP button clicked");
                    },
                    backgroundColor: const Color.fromARGB(
                        255, 42, 40, 65), // Set the background color
                    foregroundColor: Colors.white,
                    tooltip: 'Second',
                    heroTag: 'Second',
                    child: const Icon(Icons.control_point_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
