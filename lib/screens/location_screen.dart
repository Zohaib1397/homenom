import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  static const String id = "Location_Screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        title: const Text("Please select your location"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Your Location"),
                SizedBox(width: 10,),
                Icon(Icons.my_location),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
