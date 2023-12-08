import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacePicker extends StatefulWidget {
  const PlacePicker({super.key});

  @override
  State<PlacePicker> createState() => PlacePickerState();
}

class PlacePickerState extends State<PlacePicker> {
  // Completer<GoogleMapController> _controller = Completer();

  List<Marker> myMarker = [];

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
        // onMapCreated: (GoogleMapController controller) {
        //   _controller.complete(controller);
        // },
      ),
    );
  }

  _handleTap(LatLng tappedPoint) {
    print(tappedPoint);

    setState(
      () {
        myMarker = [];
        myMarker.add(
          Marker(
            markerId: MarkerId(tappedPoint.toString()),
            position: tappedPoint,
            draggable: true,
            
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            onDragEnd: (dragEndPosition) {
              print(dragEndPosition);
            },
          ),
        );
      },
    );
  }
}
