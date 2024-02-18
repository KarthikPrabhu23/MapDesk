import 'package:flutter/material.dart';

class ProfileController with ChangeNotifier {
  void pickImage(context) {
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          content: Container(
            height: 120,
            child: Column(
              children: [
                ListTile(
                  onTap: () {},
                  leading: const Icon(
                    Icons.camera,
                    color: Colors.black,
                  ),
                  title: const Text('Camera'),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(
                    Icons.photo,
                    color: Colors.black,
                  ),
                  title: const Text('Camera'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
