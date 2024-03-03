// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types, file_names, unused_import, avoid_print
import "package:flutter/material.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/geolocation.dart';
import 'package:map1/Home/home_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//  File to choose target location on map and add it to the realtime database

class AddRoom extends StatefulWidget {
  const AddRoom({super.key});

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  List<Marker> allMarkers = [];
  late DatabaseReference dbRef;
  String lat = "";
  String long = "";
  List<Marker> myMarker = [];
  final roomLocation = TextEditingController();
  final roomName = TextEditingController();

  static const CameraPosition _cecLocation =
      CameraPosition(target: LatLng(12.898799, 74.984734), zoom: 15);

  // ignore: unused_field
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Rooms');
    // Firestore.instance.collection('Target');
  }

  _handleTap(LatLng tappedPoint) {
    (tappedPoint);

    lat = tappedPoint.latitude.toString();
    long = tappedPoint.longitude.toString();

    setState(
      () {
        myMarker = [];
        myMarker.add(
          Marker(
            markerId: MarkerId(tappedPoint.toString()),
            position: tappedPoint,
            infoWindow:
                const InfoWindow(title: 'Target', snippet: 'Choose a target'),
            draggable: true,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add room'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                // const SizedBox(
                //   height: 10,
                // ),
                // const Text(
                //   'Create a new room',
                //   style: TextStyle(
                //     fontSize: 20,
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextField(
                    controller: roomName,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Room name',
                      hintText: 'Enter Room name',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextField(
                    controller: roomLocation,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Room location',
                      hintText: 'Enter Room location',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Tap on the map below to choose a target location',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 440,
                  // child: PlacePicker(),
                  child: GoogleMap(
                    initialCameraPosition: _cecLocation,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    markers: Set.from(myMarker),
                    onTap: _handleTap,
                    mapType: MapType.normal,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Map<String, String> roomsMap = {
                      'roomName': roomName.text,
                      'roomLocation': roomLocation.text,
                      'latitude': lat,
                      'longitude': long,
                    };

                    dbRef.push().set(roomsMap);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()),
                    );
                  },
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  height: 35,
                  child: const Text('Create room'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
