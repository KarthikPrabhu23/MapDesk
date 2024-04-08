// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map1/Map/classes.dart';
import 'package:map1/Map/methods/map_screen_functions.dart';
import 'package:map1/Record/components/record_class.dart';
import 'package:map1/my_colors.dart';
import 'package:map1/TargetSelectPage/add_room.dart';

class EmployeeCard extends StatefulWidget {
  final User UserEmployee;
  final Location EmployeeLocation;

  const EmployeeCard(
      {required this.UserEmployee, required this.EmployeeLocation, super.key});

  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  late LatLng currentLocation = const LatLng(0.0, 0.0);
  late LatLng UserEmployeeLoc;

  LatLng? TapPointMap = TapPoint;

  @override
  void initState() {
    super.initState();
    UserEmployeeLoc = LatLng(
      widget.EmployeeLocation.lat,
      widget.EmployeeLocation.lng,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
      child: Card(
        shadowColor: Colors.black87,
        color: MyColors.ButtonBlue,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Colors.white, 
            width: 2, 
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'lib/images/user.png',
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                  Container(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(height: 5),
                        Text(
                          widget.UserEmployee.username,
                          style: MyTextSample.title(context)!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Distance from Target location : ',
                          style: MyTextSample.body1(context)!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          calculateDistance(TapPoint, UserEmployeeLoc),
                          style: MyTextSample.body1(context)!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
