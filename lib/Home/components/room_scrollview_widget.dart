import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:map1/Home/components/room_element_widget.dart';

class RoomScrollView extends StatelessWidget {
  const RoomScrollView({
    super.key,
    required this.dbRef,
  });

  final Query dbRef;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.41,
        decoration: const BoxDecoration(
          // color: Color.fromARGB(211, 242, 247, 255),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
          child: ListView(
            padding: EdgeInsets.zero,
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              // CONTENT STARTS

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                child: FirebaseAnimatedList(
                  scrollDirection: Axis.horizontal,
                  query: dbRef.orderByChild("roomName"),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map room = snapshot.value as Map;

                    room['key'] = snapshot.key;

                    return RoomElementWidget(context: context, room: room);
                  },
                ),
              ),
              // CONTENT ENDS
            ],
          ),
        ),
      ),
    );
  }
}
