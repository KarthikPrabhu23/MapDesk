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
      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
      child: Container(
        width: double.infinity,
        height: 360,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 215, 206, 180),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 5),
          child: ListView(
            padding: EdgeInsets.zero,
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              // CONTENT STARTS
    
              SizedBox(
                // width: double.infinity,
                width: 500,
                height: 300,
                child: FirebaseAnimatedList(
                  scrollDirection: Axis.horizontal,
                  query: dbRef.orderByChild("roomName"),
                  itemBuilder: (BuildContext context,
                      DataSnapshot snapshot,
                      Animation<double> animation,
                      int index) {
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

