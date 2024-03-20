import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map1/Map/components/target_card.dart';

class TargetSlider extends StatelessWidget {
  const TargetSlider({
    super.key,
    required this.clientsToggle,
    required this.setOfMarkers,
    required Completer<GoogleMapController> controller,
  }) : _controller = controller;

  final bool clientsToggle;
  final Set<Marker> setOfMarkers;
  final Completer<GoogleMapController> _controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height - 240,
      child: SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: clientsToggle
            ? ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(9),
                children: setOfMarkers.map(
                  (element) {
                    if (element.icon ==
                        BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed)) {
                      return targetCard(element, _controller);
                    } else {
                      return targetCard(element, _controller);
                    }
                  },
                ).toList(),
              )
            : const SizedBox(
                height: 1,
                width: 1,
              ),
      ),
    );
  }
}
