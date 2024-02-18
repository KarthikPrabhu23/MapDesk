import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map1/Map/classes.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}


class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-18.9216855, 47.5725194),// Antananarivo, Madagascar LatLng 🇲🇬
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
          'Rg02sZk3exNyTfmQxXR6', //Hardcoded uid but this is the uid of the connected user when using authentification service
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
      // stream: FirebaseFirestore.instance.collection('users').snapshots(),
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