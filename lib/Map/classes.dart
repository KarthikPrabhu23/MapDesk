import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class Location {
  final double lat;
  final double lng;

  Location({
    required this.lat,
    required this.lng,
  });
}

class User {
  final String name;
  final Location location;
  User({
    required this.name,
    required this.location,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      location: Location(
        lat: map['location']['lat'],
        lng: map['location']['lng'],
      ),
    );
  }
}

class StreamLocationService {
  static const LocationSettings _locationSettings =
      LocationSettings(distanceFilter: 1);
  static bool _isLocationGranted = false;

  static Stream<Position>? get onLocationChanged {
    if (_isLocationGranted) {
      return Geolocator.getPositionStream(locationSettings: _locationSettings);
    }
    return null;
  }

  static Future<bool> askLocationPermission() async {
    _isLocationGranted = await Permission.location.request().isGranted;
    return _isLocationGranted;
  }
}

class FirestoreService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> updateUserLocation(String userId, LatLng location) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'location': {'lat': location.latitude, 'lng': location.longitude},
      });
    } on FirebaseException catch (e) {
      print('Ann error due to firebase occured $e');
    } catch (err) {
      print('Ann error occured $err');
    }
  }

  static Stream<List<User>> userCollectionStream() {
    return _firestore.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromMap(doc.data())).toList());
  }
}
