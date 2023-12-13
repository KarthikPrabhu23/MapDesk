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
  static const CameraPosition _cecLocation =
      CameraPosition(target: LatLng(12.898799, 74.984734), zoom: 15);

  late GoogleMapController mapController;

  bool clientsToggle = true;

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
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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
        clientsToggle = true;
      });
    });

    return targetLocation;
  }

  Widget targetCard(element) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 10),
      child: InkWell(
        onTap: () {
          zoomInMarker(element);
        },
        child: Container(
          height: 100,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: const Color.fromARGB(197, 57, 151, 227)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                element.infoWindow.title.toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  zoomInMarker(element) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(element.position.latitude, element.position.longitude),
          zoom: 18,
          bearing: 90,
          tilt: 50,
        ),
      ),
    );
  }

  zoomOutMarker() {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: LatLng(12.898799, 74.984734),
          zoom: 16,
        ),
      ),
    );
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
                  onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                  initialCameraPosition: _cecLocation,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  trafficEnabled: true,
                  mapToolbarEnabled: true,
                  mapType: MapType.normal,

                  markers: targetLocation,
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height - 200,
                  child: SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: clientsToggle
                        ? ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(9),
                            children: targetLocation.map((element) {
                              return targetCard(element);
                            }).toList(),
                          )
                        : const SizedBox(
                            height: 1,
                            width: 1,
                          ),
                  ))
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


// SizedBox(
                      //   height: 150,
                      //   child: Column(
                          
                      //       children: [
                      //         IconButton(
                      //           onPressed: zoomOutMarker,
                      //           icon: const Icon(Icons.adjust_rounded),
                      //         ),
                      //         ListView(
                      //           scrollDirection: Axis.horizontal,
                      //           padding: const EdgeInsets.all(9),
                      //           children: targetLocation.map((element) {
                      //             return targetCard(element);
                      //           }).toList(),
                      //         ),
                      //       ],
                      //     ),
                      // )
            