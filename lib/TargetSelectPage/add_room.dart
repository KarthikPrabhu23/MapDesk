// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types, file_names, unused_import, avoid_print, non_constant_identifier_names, library_prefixes, avoid_unnecessary_containers
import 'dart:math';
// import 'package:firebase_core_web/firebase_core_web_interop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/geolocation.dart' as geo;
import 'package:map1/Home/home_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map1/LoginSignup/components/widgets.dart';
import 'package:map1/Map/classes.dart' as MyClass;
import 'package:map1/Map/classes.dart';
import 'package:map1/Record/components/task_complete_card.dart';
import 'package:map1/TargetSelectPage/components/employee_card.dart';
import 'package:map1/TargetSelectPage/components/map_dialog.dart';
import 'package:map1/app_constants.dart';
import 'package:map1/components/my_button.dart';
import 'package:map1/my_colors.dart';

//  File to choose target location on map and add it to the realtime database

late LatLng TapPoint;

class AddRoom extends StatefulWidget {
  const AddRoom({super.key});

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  List<Marker> allMarkers = [];
  late DatabaseReference dbRef;
  late double lat;
  late double long;
  bool completed = false;
  List<Marker> myMarker = [];
  final roomLocation = TextEditingController();
  final roomName = TextEditingController();
  final tInfo = TextEditingController();

  late BitmapDescriptor targetLocationIcon;

  static const CameraPosition _cecLocation =
      CameraPosition(target: LatLng(12.898799, 74.984734), zoom: 15);

  // ignore: unused_field
  late GoogleMapController _mapController;

  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  // Dropdown widget
  late MyClass.User selectedUser;
  late MyClass.User selectedAssign;

  bool IsEmployeeAssigned = false;

  bool MapTapped = false;

  final Mode _mode = Mode.overlay;

  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Rooms');

    selectedTime = TimeOfDay.now();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();

    _loadTargetLocationIcon();
  }

  Future<void> _loadTargetLocationIcon() async {
    Uint8List imageData = (await rootBundle.load('lib/images/targetPin.png'))
        .buffer
        .asUint8List();
    targetLocationIcon = BitmapDescriptor.fromBytes(imageData);
    setState(() {});
  }

  handleTap(LatLng tappedPoint) {
    (tappedPoint);

    lat = tappedPoint.latitude;
    long = tappedPoint.longitude;

    setState(
      () {
        TapPoint = tappedPoint;
        MapTapped = true;
        myMarker = [];
        myMarker.add(
          Marker(
            markerId: MarkerId(tappedPoint.toString()),
            position: tappedPoint,
            infoWindow:
                const InfoWindow(title: 'Target', snippet: 'Choose a target'),
            draggable: true,
            //   icon: BitmapDescriptor.defaultMarkerWithHue(
            // BitmapDescriptor.hueAzure),
            // ),
            icon: targetLocationIcon,
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void setCustomMapPin() async {
    Uint8List imageData = (await rootBundle.load('lib/images/targetPin.png'))
        .buffer
        .asUint8List();
    targetLocationIcon = BitmapDescriptor.fromBytes(imageData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        toolbarHeight: 62,
        title: const Text(
          'Add Task',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  controller: roomName,
                  decoration: textInputDecorationPrimary.copyWith(
                    labelText: 'Task name',
                    hintText: 'Enter Task name',
                    border: OutlineInputBorder(),
                    focusColor: Theme.of(context).primaryColor,
                    fillColor: Theme.of(context).primaryColor,
                    prefixIcon: Icon(
                      Icons.work,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  controller: roomLocation,
                  decoration: textInputDecorationPrimary.copyWith(
                    labelText: "Task Location",
                    hintText: 'Enter Task location',
                    border: OutlineInputBorder(),
                    focusColor: Theme.of(context).primaryColor,
                    fillColor: Theme.of(context).primaryColor,
                    prefixIcon: Icon(
                      Icons.location_city,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  controller: tInfo,
                  decoration: textInputDecorationPrimary.copyWith(
                    labelText: 'Task Information',
                    hintText: 'Enter task information',
                    border: OutlineInputBorder(),
                    focusColor: Theme.of(context).primaryColor,
                    fillColor: Theme.of(context).primaryColor,
                    prefixIcon: Icon(
                      Icons.book,
                      color: Theme.of(context)
                          .primaryColor, // Use primary color here
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: _handlePressButton,
                    ),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onTap: _handlePressButton,
                ),
                const SizedBox(
                  height: 9,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: MyColors.ButtonBlue2,
                    width: 2,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deadline : ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16,
                              color: MyColors.ButtonBlue2,
                              fontWeight: FontWeight.w400),
                        ),
                        Row(
                          children: [
                            Text(
                              'Time : ${selectedTime.format(context)}',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(width: 6),
                            IconButton(
                              onPressed: () => _selectTime(context),
                              icon: Icon(Icons
                                  .access_time), // Use your desired icon here
                              tooltip: 'Select Deadline',
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Date : ${DateFormat.yMMMd().format(selectedDate)}',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(width: 6),
                            IconButton(
                              focusColor: Colors.blue.withOpacity(0.7),
                              onPressed: () => _selectDate(context),
                              icon: Icon(Icons
                                  .calendar_month), // Use your desired icon here
                              tooltip: 'Select Deadline',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Tap on the map below to choose a target location',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                AddRoomMap(context),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  child: MapTapped
                      ? Container(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.34,
                            // height: 600,
                            width: MediaQuery.of(context).size.width * 0.8,

                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 192, 187, 238),
                                  Color.fromARGB(255, 221, 219, 224)
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    'Your Employees :',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  scrollDirection: Axis.vertical,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.283,
                                    // height: 500,
                                    child: StreamBuilder<List<User>>(
                                      stream: FirestoreService
                                          .userCollectionStream(),
                                      builder: (context, userSnapshot) {
                                        if (userSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (userSnapshot.hasError) {
                                          return Text(
                                              'Error: ${userSnapshot.error}');
                                        } else {
                                          return ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            padding: const EdgeInsets.all(9),
                                            itemCount:
                                                userSnapshot.data!.length,
                                            itemBuilder: (context, index) {
                                              final user =
                                                  userSnapshot.data![index];

                                              // if (user.assignedToEmployee) {
                                              return EmployeeCard(
                                                UserEmployee: user,
                                                EmployeeLocation: user.location,
                                              );
                                              // } else {
                                              // return Container();
                                              // }
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }

                      List<DropdownMenuItem<MyClass.User>> items = [];

                      final users = snapshot.data!.docs;

                      for (var user in users) {
                        final userData = user.data() as Map<String, dynamic>;
                        final username = userData['username'] as String;
                        final userObject = MyClass.User(
                          name: userData['name'] as String,
                          username: username,
                          userUid: user.id,
                          location: MyClass.Location(
                            lat: Random().nextDouble() * 180 - 90,
                            lng: Random().nextDouble() * 360 - 180,
                          ),
                        );
                        items.add(
                          DropdownMenuItem<MyClass.User>(
                            value: userObject,
                            child: Text(username),
                          ),
                        );
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Assign task to ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300),
                          ),
                          DropdownButton<MyClass.User>(
                            items: items,
                            onChanged: (selectedItem) {
                              setState(() {
                                selectedUser = selectedItem!;
                                selectedAssign = selectedUser;
                                IsEmployeeAssigned = true;
                              });
                              print('Selected MyClass.User: $selectedUser');
                              print(
                                  'SelectedUser uid is : ${selectedUser.userUid}');
                              print(
                                  'SelectedAssign uid is : ${selectedAssign.userUid}');
                              print(
                                  'SelectedAssign name is : ${selectedAssign.username}');
                              print('selectedAssign: $selectedAssign');
                            },
                            hint: Text(
                              ' employee',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  child: IsEmployeeAssigned
                      ? Text(
                          'Task Assigned to ${selectedAssign.username}',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : SizedBox(),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: MyButton(
                    onPressed: () {
                      Map<dynamic, dynamic> roomsMap = {
                        'roomName': roomName.text,
                        'roomLocation': roomLocation.text,
                        'latitude': lat,
                        'longitude': long,
                        'completed': false,
                        'targetInfo': tInfo.text,
                      };

                      dbRef.push().set(roomsMap);

                      DateTime dateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );

                      print("FIRESTORE to store TARGETLOC");
                      try {
                        FirebaseFirestore.instance
                            .collection('TargetLoc')
                            .doc()
                            .set(
                          {
                            'roomName': roomName.text,
                            'roomLocation': roomLocation.text,
                            'completed': false,
                            'targetInfo': tInfo.text,
                            'location': {
                              'lat': lat,
                              'lng': long,
                            },
                            'deadlineTime': dateTime,
                            'deadlineCompletedAt': dateTime.toString(),
                            'assignedToEmployee': selectedAssign.username,
                            'assignedToEmployeeID': selectedUser.userUid,
                          },
                        );
                        print('Data stored successfully');
                      } catch (e) {
                        print('Error storing data: $e');
                      }

                      try {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(selectedUser.userUid)
                            .update(
                          {
                            'assignedToTask': roomName.text,
                          },
                        );
                        print('Data stored successfully');
                      } catch (e) {
                        print('Error storing data: $e');
                      }

                      Navigator.pop(context);
                    },
                    buttonIcon: Icons.map,
                    buttonText: 'Create Task',
                  ),
                ),
                const SizedBox(
                  height: 55,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// MARK: AddRoomMap
  Container AddRoomMap(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: MyColors.ButtonBlue2,
          width: 2,
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.52,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onVerticalDragStart: (start) {},
        child: GoogleMap(
          initialCameraPosition: _cecLocation,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          markers: Set.from(myMarker),
          onTap: handleTap,
          mapType: MapType.normal,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
          onMapCreated: (GoogleMapController Addcontroller) {
            _mapController = Addcontroller;
          },
        ),
      ),
    );
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: Constants.apiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    myMarker.clear();
    myMarker.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    _mapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Constants.apiKey5,
      // onError: onError,
      mode: _mode,
      language: 'en',
      strictbounds: false,
      types: [""],
      // decoration: InputDecoration(
      //     hintText: 'Search',
      //     focusedBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(20),
      //         borderSide: BorderSide(color: Colors.white))),
      components: [
        Component(Component.country, "in"),
        Component(Component.country, "usa")
      ],
    );

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  // void onError(PlacesAutocompleteResponse response) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     elevation: 0,
  //     behavior: SnackBarBehavior.floating,
  //     backgroundColor: Colors.transparent,
  //     content: AwesomeSnackbarContent(
  //       title: 'Message',
  //       message: response.errorMessage!,
  //       contentType: ContentType.failure,
  //     ),
  //   ));

  //   homeScaffoldKey.currentState!
  //       .showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  // }
}
