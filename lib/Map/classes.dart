// ignore_for_file: avoid_print, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
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
  final String name;
  final String username;
  final Location location;
  final String userUid;
  final String? userEmail;
  final int? targetCompletionCount;


  User({
    required this.name,
    required this.username,
    required this.location,
    required this.userUid,
    this.userEmail,
    this.targetCompletionCount,
  });

  factory User.fromMap(String docId, Map<dynamic, dynamic> map) {
    return User(
      userUid : docId,
      name: map['name'],
      username: map['username'],
      location: Location(
        lat: map['location']['lat'],
        lng: map['location']['lng'],
      ),
      userEmail : map['email'],
      targetCompletionCount : map['targetCompletionCount'],
    );
  }

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
  final bool completed;
  final String roomName;
  final String roomLocation;
  final String targetInfo;
  final Location location;
  final String targetUid;
  final Timestamp deadlineTime;
  final String deadlineCompletedAt;
  final String assignedToEmployeeID;
  final String assignedToEmployee;

  Target({
    required this.roomLocation,
    required this.targetInfo,
    required this.deadlineTime,
    required this.completed,
    required this.roomName,
    required this.location,
    required this.targetUid,
    required this.deadlineCompletedAt,
    required this.assignedToEmployeeID,
    required this.assignedToEmployee,
  });

  factory Target.fromMap(String docId, Map<dynamic, dynamic> map) {
    return Target(
      targetUid: docId,
      completed: map['completed'],
      deadlineTime: map['deadlineTime'],
      location: Location(
        lat: map['location']['lat'],
        lng: map['location']['lng'],
      ),
      roomName: map['roomName'],
      roomLocation: map['roomLocation'],
      targetInfo: map['targetInfo'],
      deadlineCompletedAt: map['deadlineCompletedAt'],
      assignedToEmployeeID: map['assignedToEmployeeID'],
      assignedToEmployee: map['assignedToEmployee'],
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
  static final FirebaseFirestore _firebasefirestore =
      FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

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

  static Future<void> updateTargetCompletion(String userId) async {
    try {
      DateTime currentTime = DateTime.now();
      String formattedDate =
          DateFormat('dd-MM-yyyy   hh:mm a').format(currentTime);
      print("$formattedDate is the currentTime");


      await _firestore.collection('TargetLoc').doc(userId).update({
        'completed': true,
        'deadlineCompletedAt': formattedDate.toString(),
      });
    } on FirebaseException catch (e) {
      print('Ann error due to firebase occured $e');
    } catch (err) {
      print('Ann error occured $err');
    }
  }

  static Future<void> increaseTargetCompletionCount(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'targetCompletionCount': FieldValue.increment(1),
      });
    } on FirebaseException catch (e) {
      print('Ann error due to firebase occured $e');
    } catch (err) {
      print('Ann error occured $err');
    }
  }

  static Stream<List<User>> userCollectionStream() {
    return _firestore.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromMap(doc.id, doc.data())).toList());
  }

  static Stream<List<Target>> targetLocCollectionStream() {
    return _firestore.collection('TargetLoc').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => Target.fromMap(doc.id, doc.data()))
            .toList());
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
