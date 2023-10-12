import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String id = "Profile_Screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        title: Text("Profile Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 90,
                  ),
                  Text("email@example.com"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("My Details"),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Hello",

              ),
            ),
          ],
        ),
      ),
    );
  }
}
