
import 'User.dart';

class Seller extends User {
  late String CNIC;
  late String restaurantName;

  Seller({
    required String name,
    required String username,
    required String address,
    required String email,
    required String id,
    required String phoneNum,
    required bool isPhoneVerified,
    required this.CNIC,
    required double rating,
    required String role,
    required double latitude,
    required double longitude,
    required this.restaurantName,
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

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    name: json['User']['name'],
    username: json['User']['username'],
    address: json['User']['address'],
    email: json['User']['email'],
    id: json['User']['id'],
    phoneNum: json['User']['phoneNum'],
    isPhoneVerified: json['User']['isPhoneVerified'],
    CNIC: json['CNIC'],
    rating: json['rating'],
    role: json['role'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    restaurantName: json['restaurantName'],
  );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'User': super.toJson(),
      'CNIC': CNIC,
      'restaurantName': restaurantName,
    };

    return data;
  }
}