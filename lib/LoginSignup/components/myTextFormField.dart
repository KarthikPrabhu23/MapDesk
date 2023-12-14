// ignore_for_file: file_names
import "package:flutter/material.dart";

class myTextFormField extends StatelessWidget {
  final MyController;
  final String hintText;
  final labelText;

  const myTextFormField(
      {super.key,
      required this.MyController,
      required this.hintText,
      this.labelText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: TextFormField(
        controller: MyController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.grey[600],
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500)),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
          ),
        ),
      ),
    );
  }
}
