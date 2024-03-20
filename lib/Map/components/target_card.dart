// ignore_for_file: avoid_print

// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

Widget targetCard(element, GoogleMapController controller) {
  return Padding(
    padding: const EdgeInsets.only(left: 12, top: 10),
    child: InkWell(
      onTap: () {
        print("targetCard clicked");
        // zoomInMarker(element, controllerCompleter);
        zoomInMarker(element, controller);
      },
      child: Container(
        height: 100,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: const Color.fromARGB(197, 57, 151, 227),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              element.infoWindow.title.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
