// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types, file_names, unused_import, avoid_print, non_constant_identifier_names
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
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
  late double lat;
  late double long;
  bool completed = false;
  List<Marker> myMarker = [];
  final roomLocation = TextEditingController();
  final roomName = TextEditingController();
  final tInfo = TextEditingController();

  static const CameraPosition _cecLocation =
      CameraPosition(target: LatLng(12.898799, 74.984734), zoom: 15);

  // ignore: unused_field
  late GoogleMapController _mapController;
  // late TimeOfDay selectedTime;

  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Rooms');

    selectedTime = TimeOfDay.now();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  _handleTap(LatLng tappedPoint) {
    (tappedPoint);

    lat = tappedPoint.latitude;
    long = tappedPoint.longitude;

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

  Future<void> _selectTimeDate(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(3),
            child: Column(
              children: [
                SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextField(
                    controller: roomName,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Task name',
                      hintText: 'Enter Task name',
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextField(
                    controller: roomLocation,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Task location',
                      hintText: 'Enter Task location',
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextField(
                    controller: tInfo,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Information',
                      hintText: 'Enter target information',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.0),
                  child: Row(
                    children: [
                      Text(
                        'Deadline time for the task : ${selectedTime.format(context)}',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                          width:
                              6),
                      IconButton(
                        onPressed: () => _selectTime(context),
                        icon: Icon(
                            Icons.access_time), // Use your desired icon here
                        tooltip: 'Select Time',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.0),
                  child: Row(
                    children: [
                      Text(
                        'Deadline date for the task : ${DateFormat.yMMMd().format(selectedDate)}',
                        style: TextStyle(fontSize: 15),
                      ),

                      SizedBox(
                          width:
                              6),
                      IconButton(
                        onPressed: () => _selectDate(context),
                        icon: Icon(
                            Icons.calendar_month), // Use your desired icon here
                        tooltip: 'Select Date',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Tap on the map below to choose a target location',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    fontSize: 12,
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
                    onMapCreated: (GoogleMapController Addcontroller) {
                      _mapController = Addcontroller;
                    },
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Map<dynamic, dynamic> roomsMap = {
                      'roomName': roomName.text,
                      'roomLocation': roomLocation.text,
                      'latitude': lat,
                      'longitude': long,
                      'completed': false,
                      'targetInfo': tInfo.text,
                    };

                    dbRef.push().set(roomsMap);

                    DateTime now = DateTime.now();
                    DateTime selectedDateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    DateTime dateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    print("FIRESTORE to store TARGETLOC");
                    FirebaseFirestore.instance
                        .collection('TargetLoc')
                        .doc()
                        .set(
                      {
                        'roomName': roomName.text,
                        'roomLocation': roomLocation.text,
                        'completed': false,
                        'targetInfo': tInfo.text,
                        'location': {
                          'lat': lat,
                          'lng': long,
                        },
                        // 'deadlineTime': Timestamp.fromDate(selectedDateTime),
                        'deadlineTime': dateTime,
                      },
                    );
                    Navigator.pop(context);
                  },
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  height: 35,
                  child: const Text('Create Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
