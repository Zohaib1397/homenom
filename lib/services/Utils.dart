import 'package:flutter/material.dart';

class Utils {
  static showPopup(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                child: const Text("Okay"),
              ),
            )
          ],
        );
      },
    );
  }
}
