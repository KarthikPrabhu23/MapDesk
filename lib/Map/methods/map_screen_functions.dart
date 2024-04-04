// ignore_for_file: avoid_print, library_prefixes

import 'dart:math' as Math;
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

bool areCoordinatesClose(LatLng coord1, LatLng coord2) {
  // Earth radius in meters
  const double earthRadius = 6371000; // meters

  // Convert latitudes and longitudes from degrees to radians
  double lat1 = Math.pi * coord1.latitude / 180;
  double lon1 = Math.pi * coord1.longitude / 180;
  double lat2 = Math.pi * coord2.latitude / 180;
  double lon2 = Math.pi * coord2.longitude / 180;

  // Calculate the differences
  double dLat = lat2 - lat1;
  double dLon = lon2 - lon1;

  // Haversine formula
  double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(lat1) * Math.cos(lat2) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
  double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  double distance = earthRadius * c;

  print(distance <= 10 ? 'Distance within 10' : 'Distance is far');

  // Check if the distance is less than or equal to 5 meters
  return distance <= 10;
}

double calculateDistance(LatLng coord1, LatLng coord2) {
  const double pi = 3.1415926535897932;
  const double earthRadius = 6371000; // Radius of the earth in meters

  // Convert latitude and longitude from degrees to radians
  double lat1 = coord1.latitude * pi / 180.0;
  double lon1 = coord1.longitude * pi / 180.0;
  double lat2 = coord2.latitude * pi / 180.0;
  double lon2 = coord2.longitude * pi / 180.0;

  // Calculate the differences between latitudes and longitudes
  double dLat = lat2 - lat1;
  double dLon = lon2 - lon1;

  // Calculate the distance using the Haversine formula
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadius * c;

  return distance; 
}