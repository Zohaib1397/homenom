
import 'User.dart';


class Seller extends User{
  late String CNIC;
  late int rating;

  Seller({
    required String name,
    required String username,
    required String address,
    required String email,
    required String id,
    required String phoneNum,
    required bool isPhoneVerified,
    required this.CNIC,
    required this.rating,
  }) : super(
    name: name,
    username: username,
    address: address,
    email: email,
    id: id,
    phoneNum: phoneNum,
    isPhoneVerified: isPhoneVerified,
  );

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    name: json['User']['name'],
    username: json['User']['username'],
    address: json['User']['address'],
    email: json['User']['email'],
    id: json['User']['id'],
    phoneNum: json['User']['phoneNum'],
    isPhoneVerified: json['User']['isPhoneVerified'],
    CNIC : json['CNIC'],
    rating : json['rating'],
  );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'User' : super.toJson(),
      'CNIC' : CNIC,
      'rating' : rating
    };

    return data;
  }
}