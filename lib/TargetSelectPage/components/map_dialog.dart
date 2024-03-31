// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:map1/TargetSelectPage/add_room.dart';

// class MapDialog extends StatelessWidget {
//   CameraPosition initialCameraPosition;
//   GoogleMapController mapController;
//   List<Marker> myMarker;


//   MapDialog({
//     super.key,
//     required  this.initialCameraPosition,
//     required  this.mapController,
//     required this.myMarker,
    
//   });

//    handleTap(LatLng tappedPoint) {
//     (tappedPoint);

//     lat = tappedPoint.latitude;
//     long = tappedPoint.longitude;

//     setState(
//       () {
//         myMarker = [];
//         myMarker.add(
//           Marker(
//             markerId: MarkerId(tappedPoint.toString()),
//             position: tappedPoint,
//             infoWindow:
//                 const InfoWindow(title: 'Target', snippet: 'Choose a target'),
//             draggable: true,
//             icon: BitmapDescriptor.defaultMarkerWithHue(
//                 BitmapDescriptor.hueAzure),
//           ),
//         );
//       },
//     );
//   }

  

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Map'),
//       content: SizedBox(
//         height: 400,
//         child: GoogleMap(
//                     initialCameraPosition: initialCameraPosition,
//                     myLocationButtonEnabled: true,
//                     myLocationEnabled: true,
//                     markers: Set.from(myMarker),
//                     onTap: handleTap,
//                     mapType: MapType.normal,
//                     onMapCreated: (GoogleMapController Addcontroller) {
//                       mapController = Addcontroller;
//                     },
//                   ),
//       ),
//       actions: [
//         ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).pop(); // Close the dialog box
//           },
//           child: Text('Close'),
//         ),
//       ],
//     );
//   }
// }
