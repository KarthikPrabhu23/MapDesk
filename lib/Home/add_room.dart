// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types, file_names, unused_import
import "package:flutter/material.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/geolocation.dart';
import 'package:map1/Home/home_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map1/Map/place_picker.dart' as place;
import 'package:map1/Map/place_picker.dart';

class AddRoom extends StatefulWidget {
  AddRoom({super.key});

  final String lat = PlacePickerState().lat;
  final String long = PlacePickerState().long;

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final roomName = TextEditingController();
  final roomLocation = TextEditingController();
  
  final String lat = PlacePicker().lat;
  final String long = PlacePicker().long;

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Rooms');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add room'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Create a new room',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: roomName,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Room name',
                  hintText: 'Enter Room name',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: roomLocation,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Room location',
                  hintText: 'Enter Room location',
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: 400,
                child: PlacePicker(),

              ),
              MaterialButton(
                onPressed: () {
                  Map<String, String> roomsMap = {
                    'roomName': roomName.text,
                    'roomLocation': roomLocation.text,
                    // 'location' : _googleMapController. 
                    'latitude' : lat,
                    'longitide': long,
                  };

                  dbRef.push().set(roomsMap);
                },
                color: Colors.blueAccent,
                textColor: Colors.white,
                height: 35,
                child: const Text('Create room'),
              ),
              ElevatedButton(
                child: const Text('Open route'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(title: 'title')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
