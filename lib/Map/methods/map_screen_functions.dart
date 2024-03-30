// ignore_for_file: avoid_print, library_prefixes

import 'dart:math' as Math;
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
