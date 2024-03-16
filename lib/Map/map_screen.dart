// This is the new Map with Firestore connection

// ignore_for_file: avoid_print, unused_import

import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map1/Home/home_page.dart';
import 'package:map1/Map/classes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:map1/Map/components/target_card.dart';
import 'package:map1/Map/components/target_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:typed_data';
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

  final Completer<GoogleMapController> _controllerCompleter =
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
              profilepic: 'testing',
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


//  zoomInMarker(element) {
//     _controller.future.then((controller) {
//       controller.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target:
//                 LatLng(element.position.latitude, element.position.longitude),
//             zoom: 18,
//             bearing: 90,
//             tilt: 50,
//           ),
//         ),
//       );
//     });
//   }

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

  Future<Uint8List?> forLoadingNetworkImage(String path) async {
    final completer = Completer<ImageInfo>();
    var image = NetworkImage(path);

    image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) => completer.complete(info)));

    final imageInfo = await completer.future;
    final byteData =
        await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
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

                    // Create a list to store the futures of marker creation
                    List<Future<Marker>> markerFutures = [];

                    // Iterate through each user to create marker futures
                    for (var i = 0; i < snapshot.data!.length; i++) {
                      final user = snapshot.data![i];
                      markerFutures.add(_createMarkerAsync(user));
                    }

                    // Wait for all marker futures to complete
                    return FutureBuilder<List<Marker>>(
                      future: Future.wait(markerFutures),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Error loading markers'),
                          );
                        }

                        // Once all marker futures are completed, add the markers to the map
                        final markers = snapshot.data!;
                        return GoogleMap(
                          initialCameraPosition: _initialPosition,
                          markers: Set<Marker>.from(markers),
                          onMapCreated: (GoogleMapController controller) {
                            if (!_controllerCompleter.isCompleted) {
              _controllerCompleter.complete(controller);
            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Future<Uint8List?> _loadImageAndCreateMarker(String profilePicUrl) async {
  //   Uint8List? image = await forLoadingNetworkImage(profilePicUrl);

  //   final ui.Codec imageCodecMarker = await ui.instantiateImageCodec(
  //     image!.buffer.asUint8List(),
  //     targetHeight: 110,
  //     targetWidth: 110,
  //   );

  //   final ui.FrameInfo frameInfo = await imageCodecMarker.getNextFrame();

  //   final ByteData? byteData =
  //       await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);

  //   final Uint8List imageMarkerResized = byteData!.buffer.asUint8List();

  //   return imageMarkerResized;
  // }

// Future<Uint8List?> _loadImageAndCreateMarker(String profilePicUrl) async {
//   Completer<Uint8List?> completer = Completer();
  
//   // Load the image from the network
//   CachedNetworkImageProvider(profilePicUrl).resolve(
//     ImageConfiguration(),
//   ).addListener(
//     ImageStreamListener((ImageInfo info, bool _) async {
//       ui.Image image = info.image;
//       ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//       if (byteData != null) {
//         Uint8List imageData = byteData.buffer.asUint8List();
//         completer.complete(imageData);
//       } else {
//         completer.completeError('Failed to load image data.');
//       }
//     }),
//   );

//   return completer.future;
// }


Future<Uint8List?> _loadImageAndCreateMarker(String profilePicUrl) async {
  HttpClient httpClient = HttpClient();
  Uint8List? imageData;

  try {
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(profilePicUrl));
    HttpClientResponse response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      ByteData? byteData = await response.fold<ByteData?>(null, (ByteData? previous, List<int> chunk) {
        if (previous == null) {
          return ByteData(chunk.length)..buffer.asUint8List().setAll(0, chunk);
        } else {
          Uint8List newList = Uint8List(previous.lengthInBytes + chunk.length);
          newList.setAll(0, previous.buffer.asUint8List());
          newList.setAll(previous.lengthInBytes, chunk);
          return ByteData.view(newList.buffer);
        }
      });

      if (byteData != null) {
        ui.Image? image = await decodeImageFromList(byteData.buffer.asUint8List());
        if (image != null) {
          imageData = await image.toByteData(format: ui.ImageByteFormat.png)?.then((byteData) => byteData!.buffer.asUint8List());
        }
      }
    }
  } catch (error) {
    print('Error loading image: $error');
  } finally {
    httpClient.close();
  }

  return imageData;
}


// Future<Uint8List?> _loadImageAndCreateMarker(String profilePicUrl) async {
//   try {
//     http.Response response = await http.get(Uri.parse(profilePicUrl));

//     if (response.statusCode == 200) {
//       Uint8List imageData = response.bodyBytes;
//       ui.Image image = await decodeImageFromList(imageData);

//       if (image != null) {
//         ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//         if (byteData != null) {
//           return byteData.buffer.asUint8List();
//         }
//       }
//     }
//   } catch (e) {
//     print('Error loading image: $e');
//   }

//   return null;
// }

// Define a function to create a marker asynchronously
  Future<Marker> _createMarkerAsync(User user) async {
    final String profilePicUrl = user.profilepic;
    final Uint8List? image = await forLoadingNetworkImage(profilePicUrl);

    final ui.Codec imageCodecMarker = await ui.instantiateImageCodec(
      image!.buffer.asUint8List(),
      targetHeight: 110,
      targetWidth: 110,
    );

    final ui.FrameInfo frameInfo = await imageCodecMarker.getNextFrame();

    final ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);

    final Uint8List imageMarkerResized = byteData!.buffer.asUint8List();

    return Marker(
      markerId: MarkerId('${user.name} position'),
      // icon: BitmapDescriptor.fromBytes(imageMarkerResized),
      icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
        title: user.name.toString(),
        snippet: user.name.toString(),
      ),
      position: LatLng(user.location.lat, user.location.lng),
      onTap: () {},
    );
  }

  Widget _buildMapWithMarkers() {
    return StreamBuilder<List<User>>(
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

        // Create a list to store the markers
        List<Marker> markers = [];

        BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);

        // Iterate through each user to create markers
        // for (var i = 0; i < snapshot.data!.length; i++) {
        //   final user = snapshot.data![i];
        //   final String profilePicUrl = user.profilepic;

        //   // Load image and create marker asynchronously
        //   Future<Uint8List?> markerIconFuture =
        //       _loadImageAndCreateMarker(profilePicUrl);

        // }

        return GoogleMap(
          initialCameraPosition: _initialPosition,
          markers: Set<Marker>.from(markers),
          onMapCreated: (GoogleMapController controller) {
            _controllerCompleter.complete(controller);
          },
        );
      },
    );
  }
}