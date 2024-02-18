import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map1/Map/classes.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
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

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _initialPosition = CameraPosition(
    target:
        LatLng(12.898799, 74.984734), // Antananarivo, Madagascar LatLng 🇲🇬
    zoom: 14.4746,
  );

  late StreamSubscription<Position>? locationStreamSubscription;

  @override
  void initState() {
    super.initState();
    locationStreamSubscription =
        StreamLocationService.onLocationChanged?.listen(
      (position) async {
        await FirestoreService.updateUserLocation(
          getCurrentUserUid(), //Hardcoded uid but this is the uid of the connected user when using authentification service
          LatLng(position.latitude, position.longitude),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<User>>(
        stream: FirestoreService.userCollectionStream(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final Set<Marker> markers = {};
          for (var i = 0; i < snapshot.data!.length; i++) {
            final user = snapshot.data![i];
            markers.add(
              Marker(
                markerId: MarkerId('${user.name} position $i'),
                icon: user.name == 'stephano'
                    ? BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      )
                    : BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueYellow,
                      ),
                position: LatLng(user.location.lat, user.location.lng),
                onTap: () => {},
              ),
            );
          }
          return GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    locationStreamSubscription?.cancel();
  }
}
