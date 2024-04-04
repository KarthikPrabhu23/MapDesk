// ignore_for_file: non_constant_identifier_names

import "package:flutter/material.dart";
import "package:map1/Map/classes.dart";


class DisplayEmployeeAssigned extends StatelessWidget {
  const DisplayEmployeeAssigned({
    super.key,
    required this.IsEmployeeAssigned,
    required this.selectedAssign,
  });

  final bool IsEmployeeAssigned;
  final User selectedAssign;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IsEmployeeAssigned
          ? Text(
              'Task Assigned to ${selectedAssign.username}',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            )
          : const SizedBox(),
    );
  }
}