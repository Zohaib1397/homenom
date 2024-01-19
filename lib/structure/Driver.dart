import 'User.dart';

class Driver extends User {
  late String bikeNumber;
  late String bikeType;
  late String license;
  late String bikeRegNo;

  Driver({
    required String name,
    required String username,
    required String address,
    required String email,
    required String id,
    required String phoneNum,
    required bool isPhoneVerified,
    required double rating,
    required String role,
    required double latitude,
    required double longitude,
    required this.bikeNumber,
    required this.bikeType,
    required this.license,
    required this.bikeRegNo,
  }) : super(
    name: name,
    username: username,
    address: address,
    email: email,
    id: id,
    phoneNum: phoneNum,
    isPhoneVerified: isPhoneVerified,
    rating: rating,
    role: role,
    latitude: latitude,
    longitude: longitude,
  );

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    name: json['User']['name'],
    username: json['User']['username'],
    address: json['User']['address'],
    email: json['User']['email'],
    id: json['User']['id'],
    phoneNum: json['User']['phoneNum'],
    isPhoneVerified: json['User']['isPhoneVerified'],
    rating: json['rating'],
    role: json['role'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    bikeNumber: json['bikeNumber'],
    bikeType: json['bikeType'],
    license: json['license'],
    bikeRegNo: json['bikeRegNo'],
  );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'User': super.toJson(),
      'bikeNumber': bikeNumber,
      'bikeType': bikeType,
      'license': license,
      'bikeRegNo': bikeRegNo,
    };

    return data;
  }
}
