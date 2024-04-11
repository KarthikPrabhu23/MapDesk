import 'package:flutter/material.dart';
import 'package:map1/Map/map_screen.dart';

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
            padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
              },
              child: Container(
                width: 170,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(222, 21, 30, 132),
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
                            cacheHeight: 175,
                            cacheWidth: 175,
                            width: double.infinity,
                            height: 150,
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
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
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
                            Text(
                              room['roomLocation'],
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                                fontSize: 13,
                              ),
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
                               style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.white,
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
