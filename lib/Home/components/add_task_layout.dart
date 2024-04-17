import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map1/Home/components/big_button.dart';
import 'package:map1/TargetSelectPage/add_room.dart';
import 'package:map1/my_colors.dart';

class AddTaskLayout extends StatelessWidget {
  const AddTaskLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schedule a Task',
            style: GoogleFonts.robotoSlab(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: BigButton(
              color: MyColors.ButtonBlue2,
              icon: Icons.add,
              text: 'Add Task',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddRoom()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

