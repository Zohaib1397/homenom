
class User {
  late String name;
  late String username;
  late String address;
  late String email;
  late String id;
  late String phoneNum;
  late bool isPhoneVerified;

  User({
    required this.name,
    required this.username,
    required this.address,
    required this.email,
    required this.id,
    required this.phoneNum,
    required this.isPhoneVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    username: json['username'],
    address: json['address'],
    email: json['email'],
    id: json['id'],
    phoneNum: json['phoneNum'],
    isPhoneVerified: json['isPhoneVerified'],
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
    };

    return data;
  }

}
