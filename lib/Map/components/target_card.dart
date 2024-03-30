// ignore_for_file: avoid_print

// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map1/Map/methods/map_screen_functions.dart';

class TargetCard extends StatefulWidget {
  final Marker markerElement;
  final GoogleMapController controller;

  const TargetCard(
      {required this.markerElement, required this.controller, super.key});

  @override
  State<TargetCard> createState() => _TargetCardState();
}

class _TargetCardState extends State<TargetCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 10),
      child: InkWell(
        onTap: () {
          zoomInMarker(widget.markerElement, widget.controller);
        },
        child: Container(
          height: 160,
          width: 325,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            // color: const Color.fromARGB(197, 57, 151, 227),
            color: const Color.fromARGB(255, 142, 134, 227),
          ),
          child: Card(
            color: const Color(0xff4338CA),
            elevation: 5.0, // Add some shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Set rounded corners
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Space elements evenly
              children: [
                // Image container
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: 100, // Set image container width
                    height:
                        100, // Set image container height (same as card height)
                    child: ClipRRect(
                      // Clip rounded corners for image
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YmVhY2hlc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                        cacheWidth: 175,
                        cacheHeight: 175,
                        fit: BoxFit.cover, // Adjust fit if needed
                      ),
                    ),
                  ),
                ),
                // Content container
                Expanded(
                  // Expand to fill remaining space
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Add some padding
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Align content vertically
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to left
                      children: [
                        Text(
                          widget.markerElement.infoWindow.title.toString(),
                          style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          widget.markerElement.infoWindow.snippet.toString(),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white70,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              onPressed: () async {
                                zoomInMarker(widget.markerElement, widget.controller);

                                Position currPosition =
                                    await Geolocator.getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.high);

                                areCoordinatesClose(
                                    widget.markerElement.position,
                                    LatLng(currPosition.latitude,
                                        currPosition.longitude));
                              },
                              icon: const Row(
                                children: [
                                  Icon(
                                    Icons.verified_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 2),
                                  // Text(
                                  //   'Reached',
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //     fontSize:
                                  //         12, // Adjust the font size as needed
                                  //   ),
                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Button container
                IconButton(
                  icon: const Icon(
                    Icons.car_crash_rounded,
                    color: Colors.white,
                  ), // Replace with your desired icon
                  onPressed: () {
                    // Handle button press event
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void zoomOutMarker(GoogleMapController gMapController) {
  gMapController.animateCamera(
    CameraUpdate.newCameraPosition(
      const CameraPosition(
        target: LatLng(12.898799, 74.984734),
        zoom: 16,
      ),
    ),
  );
}

zoomInMarker(element, mapController) {
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

// Widget targetCard(element, GoogleMapController controller) {
//   return Padding(
//     padding: const EdgeInsets.only(left: 12, top: 10),
//     child: InkWell(
//       onTap: () {
//         print("TargetCard clicked");
//         // zoomInMarker(element, controllerCompleter);
//         zoomInMarker(element, controller);
//       },
//       child: Container(
//         height: 100,
//         width: 120,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8.0),
//           color: const Color.fromARGB(197, 57, 151, 227),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(2.0),
//             child: Text(
//               element.infoWindow.title.toString(),
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }
