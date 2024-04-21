// This is the new Map with Firestore connection
// ignore_for_file: unused_import, avoid_print
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as AuthPackage;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map1/Home/home_page.dart';
import 'package:map1/LoginSignup/components/widgets.dart';
import 'package:map1/Map/classes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:map1/Map/components/confirmationDialog.dart';
import 'package:map1/Map/components/popup_window.dart';
import 'package:map1/Map/components/target_card.dart';
import 'package:map1/Map/components/target_slider.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:map1/Map/methods/location_util.dart';
import 'package:map1/Map/methods/map_screen_functions.dart';
import 'package:map1/bottom_navigation_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  String currUid = "";

  bool targetSliderToggle = true;
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  late StreamSubscription<Position>? locationStreamSubscription;
  late GoogleMapController mapController;
  Set<Marker> setOfMarkers = {};

  late BitmapDescriptor pinLocationIcon;
  late BitmapDescriptor targetLocationIcon;
  late BitmapDescriptor completeLocationIcon;

  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();

  final Completer<GoogleMapController> _controllerCompleter =
      Completer<GoogleMapController>();

  // late CameraPosition _initialPosition;
  late CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(12.898799, 74.984734), // Default position
    zoom: 10,
  );

  @override
  void dispose() {
    locationStreamSubscription?.cancel();
    mapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    setCustomMapPin();
    locationStream();
    _getCurrentUser();
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _getCurrentUser() {
    AuthPackage.FirebaseAuth auth = AuthPackage.FirebaseAuth.instance;

    // Check if the user is signed in
    if (auth.currentUser != null) {
      String uid = auth.currentUser!.uid;
      print('Current User UID: $uid \n _getCurrentUser');

      currUid = uid;
    } else {
      print('No user signed in');
    }
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), 'lib/images/user.png');

    Uint8List imageData = (await rootBundle.load('lib/images/targetPin.png'))
        .buffer
        .asUint8List();
    targetLocationIcon = BitmapDescriptor.fromBytes(imageData);

    Uint8List imageData2 = (await rootBundle.load('lib/images/completePin.png'))
        .buffer
        .asUint8List();
    completeLocationIcon = BitmapDescriptor.fromBytes(imageData2);
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
              userUid: uid,
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

  Widget targetCard(Target targetElem) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 10),
      child: InkWell(
        onTap: () {
          zoomInMarker(targetElem);
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
                      child: targetElem.completed
                          ? Image.asset(
                              'lib/images/completePin.png',
                              width: 175,
                              height: 172,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'lib/images/targetPin.png',
                              width: 175,
                              height: 172,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                // Content container
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, 
                      crossAxisAlignment:
                          CrossAxisAlignment.start, 
                      children: [
                        Text(
                          targetElem.roomName.toString(),
                          overflow: TextOverflow
                              .ellipsis, 
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          targetElem.roomLocation.toString(),
                          overflow: TextOverflow
                              .ellipsis, 
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white70,
                          ),
                        ),
                        Row(
                          children: targetElem.completed
                              ? [
                                  Column(
                                    children: [
                                      IconButton(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        icon: targetElem.completed
                                            ? const Row(
                                                children: [
                                                  Icon(
                                                    Icons.verified_rounded,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 2),
                                                  Text(
                                                    'Target Visited',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox.shrink(),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ]
                              : [
                                  Column(
                                    children: [
                                      Text(
                                        DateFormat('dd-MM-yyyy hh:mm a').format(
                                            targetElem.deadlineTime.toDate()),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Assignee : ${targetElem.assignedToEmployee}',
                                        overflow: TextOverflow.ellipsis, 
  maxLines: 1, 
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Button container
                IconButton(
                  icon: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  color: Colors.blueAccent,
                  onPressed: () async {
                    zoomInMarker(targetElem);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmationDialog(
                          title: "Have you reached the Target Location",
                          message: "Are you within 10 meters?",
                          gifPath: 'lib/images/LocationCheckGif.gif',
                          onYesPressed: () async {
                            zoomInMarker(targetElem);

                            // Get current position
                            Position currPosition =
                                await Geolocator.getCurrentPosition(
                                    desiredAccuracy: LocationAccuracy.high);

                            // Check if coordinates are close
                            bool reachedTarget = areCoordinatesClose(
                              LatLng(targetElem.location.lat,
                                  targetElem.location.lng),
                              LatLng(currPosition.latitude,
                                  currPosition.longitude),
                            );

                            print(
                                '${targetElem.roomName.toString()} is ${reachedTarget ? 'visited' : 'NOT visited'}');

                            // DISPLAY RESULTS USING PopUp
                            if (reachedTarget) {
                              FirestoreService.updateTargetCompletion(
                                  targetElem.targetUid);
                              FirestoreService.increaseTargetCompletionCount(
                                  currUid);

                              if (mounted) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return PopUpWindow(
                                      onYesPressed: () {},
                                      title: "Task achieved",
                                      message: "Well done!",
                                      gifPath: 'lib/images/TaskReachedGif.gif',
                                    );
                                  },
                                );
                              }
                            } else {
                              if (mounted) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return PopUpWindow(
                                      onYesPressed: () {},
                                      title: "Task not achieved yet",
                                      message:
                                          "Reach within 10 meters to the target location",
                                      gifPath: 'lib/images/NotReachedGif.gif',
                                    );
                                  },
                                );
                              }
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  zoomInMarker(Target targetElem) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(targetElem.location.lat, targetElem.location.lng),
          zoom: 18,
          bearing: 90,
          tilt: 50,
        ),
      ),
    );
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
                            icon: targetLoc.completed == true
                                ? completeLocationIcon
                                : targetLocationIcon,
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
                            // myLocationButtonEnabled: true,
                            // myLocationEnabled: true,
                            trafficEnabled: true,
                            mapType: MapType.hybrid,
                            fortyFiveDegreeImageryEnabled: true,

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
                //   targetSliderToggle: targetSliderToggle,
                //   setOfMarkers: setOfMarkers,
                //   mapController: mapController,
                // ),

                // THIS IS THE SCROLL LOCATIONS ON MAP FEATURE
                Positioned(
                  top: MediaQuery.of(context).size.height - 240,
                  child: SizedBox(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    // child: targetSliderToggle
                    //     ?
                    //  ListView(
                    //     scrollDirection: Axis.horizontal,
                    //     padding: const EdgeInsets.all(9),
                    //     children: setOfMarkers.map(
                    //       (element) {
                    //         // return TargetCard(
                    //         //   markerElement: element,
                    //         //   controller: mapController,
                    //         // );
                    //         return targetCard(element);
                    //       },
                    //     ).toList(),
                    //   )
                    // : const SizedBox(
                    //     height: 1,
                    //     width: 1,
                    //   ),

                    child: StreamBuilder<List<Target>>(
                      stream: FirestoreService.targetLocCollectionStream(),
                      builder: (context, targetSnapshot) {
                        if (targetSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (targetSnapshot.hasError) {
                          return Text('Error: ${targetSnapshot.error}');
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(9),
                            itemCount: targetSnapshot.data!.length,
                            itemBuilder: (context, index) {
                              final targetLoc = targetSnapshot.data![index];
                              return targetCard(targetLoc);
                            },
                          );
                        }
                      },
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
                // crossAxisAlignment: CrossAxisAlignment.,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      nextScreenReplace(context, const MyBottomNavigationBar());
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
                  // FloatingActionButton(
                  //   onPressed: () {
                  //     print("MAP button clicked");
                  //     setState(
                  //       () {
                  //         targetSliderToggle = !targetSliderToggle;
                  //       },
                  //     );
                  //   },
                  //   backgroundColor: const Color.fromARGB(
                  //       255, 42, 40, 65), // Set the background color
                  //   foregroundColor: Colors.white,
                  //   tooltip: 'Second',
                  //   heroTag: 'Second',
                  //   child: const Icon(Icons.control_point_rounded),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
