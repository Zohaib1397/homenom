

import 'Role.dart';

class User {
  late String name;
  late String username;
  late String address;
  late String email;
  late String id;
  late String phoneNum;
  late bool isPhoneVerified;
  late String CNIC;
  late int rating;
  late String role;
  late double latitude;
  late double longitude;
  late String restaurantName;

  User({
    required this.name,
    required this.username,
    required this.address,
    required this.email,
    required this.id,
    required this.phoneNum,
    required this.isPhoneVerified,
    required this.CNIC,
    required this.rating,
    required this.role,
    required this.latitude,
    required this.longitude,
    required this.restaurantName
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    username: json['username'],
    address: json['address'],
    email: json['email'],
    id: json['id'],
    phoneNum: json['phoneNum'],
    isPhoneVerified: json['isPhoneVerified'],
    CNIC : json['CNIC'],
    rating : json['rating'],
    role: json['role'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    restaurantName: json['restaurantName']
  );

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = {
      'name' : name,
      'username' : username,
      'address' : address,
      'email' : email,
      'id' : id,
      'phoneNum' : phoneNum,
      'isPhoneVerified' :isPhoneVerified,
      'CNIC': CNIC,
      'rating': rating,
      'role' : role,
      'latitude': latitude,
      'longitude' : longitude,
      'restaurantName' :restaurantName
    };

    return data;
  }

}
