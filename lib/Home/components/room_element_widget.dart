
import 'package:flutter/material.dart';
import 'package:map1/Map/map_loc.dart';

class RoomElementWidget extends StatelessWidget {
  const RoomElementWidget({
    super.key,
    required this.context,
    required this.room,
  });

  final BuildContext context;
  final Map room;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 0, 8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapLoc()),
                );
              },
              child: Container(
                width: 180,
                height: 334,
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x430F1113),
                      offset: Offset(0, 1),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: room['roomName'],
                        transitionOnUserGestures: true,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://www.google.com/maps/d/u/0/thumbnail?mid=1A4gtHz4iHLjSs1S_fI_f__3baxs&hl=en_US',
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                        child: Text(
                          // 'Room Name',
                          room['roomName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // ignore: prefer_const_constructors
                            Text(
                              '1.',
                            ),
                            Text(
                              // 'roomLocation',
                              room['roomLocation'],
                            ),
                          ],
                        ),
                      ),
                      const Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(4, 4, 0, 0),
                            child: Text(
                              'More info',
                            ),
                          ),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                            size: 24,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

