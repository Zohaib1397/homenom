class User {
  late String name;
  late String username;
  late String address;
  late String email;
  late String id;
  late String phoneNum;
  late bool isPhoneVerified;
  late double rating;
  late String role;
  late double latitude;
  late double longitude;

  User({
    required this.name,
    required this.username,
    required this.address,
    required this.email,
    required this.id,
    required this.phoneNum,
    required this.isPhoneVerified,
    required this.rating,
    required this.role,
    required this.latitude,
    required this.longitude,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      id: json['id'] ?? '',
      phoneNum: json['phoneNum'] ?? '',
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
      role: json['role'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'username': username,
      'address': address,
      'email': email,
      'id': id,
      'phoneNum': phoneNum,
      'isPhoneVerified': isPhoneVerified,
      'rating': rating,
      'role': role,
      'latitude': latitude,
      'longitude': longitude,
    };

    return data;
  }
}
