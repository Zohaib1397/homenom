import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homenom/constants/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  static const String id = "Location_Screen";

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final Completer<GoogleMapController> _completer = Completer();
  late Position position;
  LatLng currentPosition = LatLng(37.3333, -127.0000);
  @override
  void initState() {
    super.initState();
    requestLocationPermission(context);
  }

  Future<void> requestLocationPermission(BuildContext context) async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      // Permission is granted, you can now access the user's location.
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentPosition = LatLng(position.latitude, position.longitude);
      // Do something with the location data.
    } else if (status.isDenied) {
      // Permission is denied, show a dialogue to explain why you need it.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Permission Required'),
            content: Text('This app requires location access to function properly.'),
            actions: <Widget>[
              MaterialButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        title: const Text("Please select your location"),
      ),
      body: GoogleMap(initialCameraPosition: CameraPosition(target: currentPosition, zoom: 14.5)),
      // body: Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 20),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       const Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Text("Your Location"),
      //           SizedBox(width: 10,),
      //           Icon(Icons.my_location),
      //         ],
      //       ),
      //
      //     ],
      //   ),
      // ),
    );
  }
}
