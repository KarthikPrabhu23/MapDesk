import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacePicker extends StatefulWidget {
  PlacePicker({super.key});

  String lat = PlacePickerState().lat;
  String long = PlacePickerState().long;

  @override
  State<PlacePicker> createState() => PlacePickerState();
}

class PlacePickerState extends State<PlacePicker> {
  // Completer<GoogleMapController> _controller = Completer();

  late GoogleMapController _googleMapController;

  String lat = "";
  String long = "";

  List<Marker> myMarker = [];

  List<Marker> allMarkers = [];

  static const CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(12.898799, 74.984734), zoom: 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        myLocationButtonEnabled: true,
        markers: Set.from(myMarker),
        onTap: _handleTap,
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
        },
      ),
    );
  }

  _handleTap(LatLng tappedPoint) {
    print(tappedPoint);
    print(tappedPoint.latitude);
    print(tappedPoint.longitude);

    lat = tappedPoint.latitude.toString();
    long = tappedPoint.longitude.toString();

    print("latitude is " + lat);
    print("longitude is " + long);

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
            onDragEnd: (dragEndPosition) {
              print(dragEndPosition);
            },
          ),
        );
      },
    );

    return tappedPoint;
  }

  setmarkers() {
    allMarkers.add(
      Marker(
        markerId: MarkerId(3.toString()),
        position: const LatLng(12.1799, 74.1984734),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    );
    allMarkers.add(
      Marker(
        markerId: MarkerId(5.toString()),
        position: const LatLng(12.3799, 74.084734),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    );

    return allMarkers;
  }
}
