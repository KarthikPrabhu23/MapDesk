import 'package:flutter/material.dart';

class CustomInfoWindow extends StatelessWidget {
  final String title;
  final String username;
  final List<String> infoLines;
  final VoidCallback onTap;

  const CustomInfoWindow({
    required this.title,
    required this.username,
    required this.infoLines,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        height: 150,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Username: $username',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: infoLines.map((line) => Text(line)).toList(),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: onTap,
              child: Text('Tap me!'),
            ),
          ],
        ),
    );
  }
}