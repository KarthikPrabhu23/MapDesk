// // ignore_for_file: camel_case_types, file_names

// import "package:flutter/material.dart";
// import 'package:firebase_database/firebase_database.dart';

// class roomElement extends StatefulWidget {
//   // final String roomName;
//   // final String roomLocation;

//   final Map room;

//   // const roomElement(this.roomName, this.roomLocation, {super.key});
//   const roomElement(Map room, {super.key});

//   @override
//   State<roomElement> createState() => _roomElementState();
// }

// class _roomElementState extends State<roomElement> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 0, 8),
//               child: Container(
//                 width: 200,
//                 height: 334,
//                 decoration: BoxDecoration(
//                   color: Colors.amberAccent,
//                   boxShadow: const [
//                     BoxShadow(
//                       blurRadius: 4,
//                       color: Color(0x430F1113),
//                       offset: Offset(0, 1),
//                     )
//                   ],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Hero(
//                         tag: 'locationImage',
//                         transitionOnUserGestures: true,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(
//                             'https://images.unsplash.com/photo-1601456713871-996c8765d82c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fGJlYWNoZXN8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
//                             width: double.infinity,
//                             height: 220,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       const Padding(
//                         padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
//                         child: Text(
//                           room['roomName'],
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ),
//                       const Padding(
//                         padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Text(
//                               '1.',
//                             ),
//                             Text(
//                               room['roomLocation'],
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Row(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                             padding: EdgeInsetsDirectional.fromSTEB(4, 4, 0, 0),
//                             child: Text(
//                               'More info',
//                             ),
//                           ),
//                           Icon(
//                             Icons.navigate_next,
//                             color: Colors.black,
//                             size: 24,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
 
 
//   }
// }
