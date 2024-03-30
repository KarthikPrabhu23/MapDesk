// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class Location {
  Location({
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;
}

class User {
  User({
    required this.name,
    required this.username,
    required this.location,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      username: map['username'],
      location: Location(
        lat: map['location']['lat'],
        lng: map['location']['lng'],
      ),
    );
  }

  final Location location;
  final String name;
  final String username;

// Convert a User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'location': {
        'lat': location.lat,
        'lng': location.lng,
      },
    };
  }
}

class Target {
  final Location location;
  final bool completed;
  final String roomName;

  Target({
    required this.completed,
    required this.roomName,
    required this.location,
  });

  factory Target.fromMap(Map<dynamic, dynamic> map) {
    return Target(
      completed: map['completed'],
      roomName: map['roomName'],
      location: Location(
        lat: map['location']['lat'],
        lng: map['location']['lng'],
      ),
    );
  }

// Convert a User object to a Map
  Map<dynamic, dynamic> toMap() {
    return {
      // 'completed': completed,
      'roomName': roomName,
      'location': {
        'lat': location.lat,
        'lng': location.lng,
      },
    };
  }
}

class StreamLocationService {
  static bool _isLocationGranted = false;
  static const LocationSettings _locationSettings =
      LocationSettings(distanceFilter: 1);

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

  static Stream<List<Target>> targetLocCollectionStream() {
    return _firestore.collection('TargetLoc').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Target.fromMap(doc.data())).toList());
  }

  // Check if user exists in Firestore
  static Future<bool> doesUserExist(String uid) async {
    try {
      // Get the document snapshot for the user with the provided UID
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(uid).get();

      // Check if the document exists
      return snapshot.exists;
    } catch (e) {
      // Handle any errors
      print('Error checking user existence: $e');
      return false;
    }
  }

  // Add new user to Firestore
  static Future<void> addNewUser(String uid, User newUser) async {
    try {
      // Convert the user object to a map
      Map<String, dynamic> userData = newUser.toMap();

      // Add the user data to Firestore
      await _firestore.collection('users').doc(uid).set(userData);
    } catch (e) {
      // Handle any errors
      print('Error adding new user: $e');
    }
  }
}
