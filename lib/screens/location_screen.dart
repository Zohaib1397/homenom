import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/services/Location.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  static const String id = "Location_Screen";

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final Completer<GoogleMapController> _completer = Completer();
  LatLng currentPosition = LatLng(32.9427, 73.7257);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print("Call of init state");
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });
    Location location = Location();
    location.checkIfAccessGranted();
    await location.getCurrentLocation();
    print("Current location is retrieved");
    currentPosition = LatLng(location.latitude, location.longitude);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        title: const Text("Please select your location"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentPosition,
                zoom: 14.5,
              ),
              markers: {
                Marker(
                  markerId: MarkerId("source"),
                  position: currentPosition,
                ),
              },
            ),
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
