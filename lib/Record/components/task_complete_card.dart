import 'package:flutter/material.dart';
import 'package:map1/Map/classes.dart';
import 'package:map1/Record/components/record_class.dart';
import 'package:map1/my_colors.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final Target targetLoc;

  const TaskCard({required this.targetLoc, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shadowColor: Colors.black87,
        color: MyColors.ButtonBlue,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Colors.white, // Border color
            width: 2, // Border width
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
                    'lib/images/completePin.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  // Add some spacing between the image and the text
                  Container(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Add some spacing between the top of the card and the title
                        Container(height: 5),
                        // Add a title widget
                        Text(
                          targetLoc.roomName,
                          style: MyTextSample.title(context)!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        // Add some spacing between the title and the subtitle
                        Container(height: 5),
                        // Add a subtitle widget
                        Text(
                          targetLoc.roomLocation,
                          style: MyTextSample.body1(context)!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // Add some spacing between the subtitle and the text
                        Container(height: 10),
                        // Add a text widget to display some text
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Task Info:', // Replace 'Heading 1' with your actual heading text
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              targetLoc.targetInfo,
                              maxLines: 2,
                              style: MyTextSample.subhead(context)!.copyWith(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Deadline :', 
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              DateFormat('dd-MM-yyyy hh:mm a')
                                  .format(targetLoc.deadlineTime.toDate()),
                              maxLines: 2,
                              style: MyTextSample.subhead(context)!.copyWith(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Add spacing between sections
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Task achieved at :',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              // DateFormat('dd-MM-yyyy, hh:mm a')
                              //     .format(targetLoc.deadlineCompletedAt.toDate()),
                              targetLoc.deadlineCompletedAt,
                              maxLines: 2,
                              style: MyTextSample.subhead(context)!.copyWith(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
