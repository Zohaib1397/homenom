import 'package:geocode/geocode.dart';

class UserAddress{
  late Address userAddress;
  late double latitude;
  late double longitude;

  UserAddress({
    required this.userAddress,
    required this.latitude,
    required this.longitude,
 });
}