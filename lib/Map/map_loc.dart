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
  static const CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(12.898799, 74.984734), zoom: 15);

  late GoogleMapController mapController;
  List<Marker> targetLocation = [];

  @override
  void initState() {
    super.initState();
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
                  initialCameraPosition: _kGooglePlex,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  markers: Set.from(targetLocation),
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
