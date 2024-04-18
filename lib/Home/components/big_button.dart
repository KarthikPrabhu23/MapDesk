import 'package:flutter/material.dart';
import 'package:map1/my_colors.dart';

class BigButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const BigButton({
    Key? key,
    required this.color,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width * 0.7,
      height: screenSize.height * 0.15,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.ButtonBlue2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 43,
              color: Colors.white,
            ),
            const SizedBox(height: 8.0),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
