// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types, file_names

import "package:flutter/material.dart";
import 'package:firebase_database/firebase_database.dart';

class AddRoom extends StatefulWidget {
  const AddRoom({super.key});

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final roomName = TextEditingController();
  final roomLocation = TextEditingController();

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Rooms');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add room'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Create a new room',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: roomName,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Room name',
                  hintText: 'Enter Room name',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: roomLocation,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Room location',
                  hintText: 'Enter Room location',
                ),
              ),

              SizedBox(
                height: 40,
              ),

              MaterialButton(
                onPressed: () {
                
                Map<String, String> roomsMap = {
                  'roomName': roomName.text,
                  'roomLocation' : roomLocation.text
                };

                dbRef.push().set(roomsMap);
                
              },
              color: Colors.blueAccent,
              textColor: Colors.white,
              height: 35,

              child: const Text('Create room'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
