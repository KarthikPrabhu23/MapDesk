// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final Function() onYesPressed;
  final String title;
  final String message;

  const ConfirmationDialog({super.key, 
    required this.onYesPressed,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            onYesPressed();
          },
          child: const Text("Yes"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text("No"),
        ),
      ],
    );
  }
}
