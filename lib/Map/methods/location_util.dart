// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class LocationState with ChangeNotifier {
  late CameraPosition _currentPosition;

  CameraPosition get currentPosition => _currentPosition;

  Future<void> updateCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _currentPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.0,
    );
    notifyListeners();
  }
}

class LocationUtils {
  static Future<void> getCurrentLocation(BuildContext context) async {
    await Provider.of<LocationState>(context, listen: false)
        .updateCurrentPosition();
  }

  static CameraPosition getCurrentPosition(BuildContext context) {
    return Provider.of<LocationState>(context, listen: false).currentPosition;
  }

  static String getCurrentUserUid() {
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
}
