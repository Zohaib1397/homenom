import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../structure/Address.dart';
import '../structure/Role.dart';

final kInputFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(40),
    borderSide: BorderSide.none,
  ),
  errorStyle: TextStyle(
    color: Colors.black
  ),
);

ROLE currentRole = ROLE.CUSTOMER;

UserAddress currentUserAddress = UserAddress(userAddress: Address(), latitude: 0.0, longitude: 0.0);
const initialLocation = LatLng(33.6844, 73.0479);
const kAppBackgroundColor = Color(0xFFB55157);
const kDefaultBorderRadius = 16.0;
const kRatingStarIconSize = 10.0;

const loremText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

const google_api_key = "AIzaSyCDBOCu_XE--rB5BamJJm4wFmk4AUa2pRI";
const geocoder_api_key = "348740175803540265921x108595";