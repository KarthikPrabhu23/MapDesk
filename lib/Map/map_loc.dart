// ignore_for_file: unused_import
import 'package:firebase_database/ui/firebase_animated_list.dart';
import "package:flutter/material.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map1/Home/add_room.dart';
import 'package:map1/Map/map_loc.dart';
import 'package:map1/Home/home_page.dart';

class MapLoc extends StatefulWidget {
  const MapLoc({super.key});

  @override
  State<MapLoc> createState() => _MapLocState();
}

class _MapLocState extends State<MapLoc> {
  static const CameraPosition _CEClocation =
      CameraPosition(target: LatLng(12.898799, 74.984734), zoom: 15);

  late GoogleMapController mapController;

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Set<Marker> targetLocation = {};

  @override
  void initState() {
    super.initState();

    // dbRef.onValue.listen((event) {
    //   print('inside initState\n');
    //   print(event.snapshot.value);
    // });

    _fetchtargetLocation();
  }

  _fetchtargetLocation() {
    databaseReference.child('Rooms').get().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;

      values.forEach((key, values) {
        targetLocation.add(Marker(
          markerId: MarkerId(key),
          position: LatLng(
            double.parse(values['latitude'].toString()),
            double.parse(values['longitude'].toString()),
          ),
          infoWindow: InfoWindow(
            title: values['roomName'].toString(),
            snippet: values['roomLocation'].toString(),
          ),
        ));
      });

      setState(() {
        // targetLocation = targetLocation;
      });
    });

    return targetLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: GoogleMap(
                  onMapCreated: onMapCreated,
                  initialCameraPosition: _CEClocation,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  // targetLocation: Set.from(_targetLocation),

                  markers: targetLocation,
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(30, 65, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()),
                    );
                  },
                  // icon: const Icon(Icons.home),
                  child: const Icon(Icons.arrow_back_ios_new),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
