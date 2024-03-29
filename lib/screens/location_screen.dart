import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:homenom/structure/Location.dart' as geolocation;
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homenom/constants/constants.dart';


class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  static const String id = "Location_Screen";

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController _mapController;
  LatLng currentPosition = initialLocation;
  CameraPosition initialCameraPosition =
      const CameraPosition(target: initialLocation, zoom: 14.0);
  bool isLoading = false;
  GeoCode geoCode = GeoCode(apiKey: geocoder_api_key);
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void loadDefaults() async{
    currentUserAddress.userAddress = await geoCode.reverseGeocoding(latitude: 0.0, longitude: 0.0);
  }

  Future<void> getCurrentLocation() async {
    try {
      setState(() {
        isLoading = true;
      });

      geolocation.Location location = geolocation.Location();
      await location.checkIfAccessGranted();

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Prompt the user to enable location services
        bool enableLocationServices = await Geolocator.openLocationSettings();
        if (!enableLocationServices) {
          // Handle the case where the user decides not to enable location services
          throw Exception('Location services are disabled.');
        }
      }

      await location.getCurrentLocation();

      print("Current location is retrieved");
      currentPosition = LatLng(location.latitude, location.longitude);
      initialCameraPosition = CameraPosition(target: currentPosition, zoom: 14.0);
    } catch (e) {
      print(e);
      // Handle any errors that occur during the location retrieval process
      // For example, you might want to display an error message to the user
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Address> getAddressFromMarker(double latitude, double longitude) async{

    final address =  await geoCode.reverseGeocoding(latitude: latitude, longitude: longitude);
    return address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Please select your location"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
            child: GoogleMap(
                myLocationEnabled: true,
                onMapCreated: (controller) {
                  setState(() {
                    _mapController = controller;
                  });
                },
                initialCameraPosition: initialCameraPosition,
                markers: {
                  Marker(
                    markerId: const MarkerId("center_marker"),
                    position: currentPosition ?? initialCameraPosition.target,
                  ),
                },
                onCameraMove: (CameraPosition position) {
                  setState(() {
                    currentPosition = position.target;
                  });
                },
              ),
          ),
      floatingActionButton: FloatingActionButton(

        onPressed: () async {
          // Handle the "OK" button click to get the latitude and longitude
          // and getAddress function finds the exact address
          final double latitude = currentPosition.latitude;
          final double longitude = currentPosition.longitude;
          final address = await getAddressFromMarker(latitude, longitude);
          print("Current Address: $address");
          print("Latitude: $latitude, Longitude: $longitude");
          String newAddress = "${address.streetAddress}, ${address.city}";
          setState(() {
            currentUserAddress.userAddress = address;
            currentUserAddress.latitude = latitude;
            currentUserAddress.longitude = longitude;
          });
          Navigator.pop(context, newAddress);
        },
        child: const Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
