import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final Function() onYesPressed;
  final String title;
  final String message;
  final String gifPath;

  const ConfirmationDialog({
    super.key,
    required this.onYesPressed,
    required this.title,
    required this.message,
    
    required this.gifPath,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          children: <Widget>[
            Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
               gifPath,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); 
            onYesPressed();
          },
          child: const Text("Yes"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); 
          },
          child: const Text("No"),
        ),
      ],
    );
  }
}
