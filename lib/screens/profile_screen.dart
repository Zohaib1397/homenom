import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/widgets/profile_card.dart';
import 'package:homenom/services/Utlis.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});


  final currentUser = FirebaseAuth.instance.currentUser!;
  static const String id = "Profile_Screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        title: Text("Profile Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUser.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data!.data() as Map<String, dynamic>;
                return ListView(
                  children: [
                    // Profile Picture
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person,
                            size: 90,
                          ),
                          Text(user['email']),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("My Details"),
                    ProfileCard(
                      field: "Username",
                      content: user['username'],
                      onEdit: () {},
                    ),
                    ProfileCard(
                      field: "Phone Number",
                      content: "0${user['phoneNum']}",
                      onEdit: () {},
                    ),
                    ProfileCard(
                      field: "Address",
                      content: user['address'],
                      onEdit: () {},
                    ),
                    ProfileCard(
                      field: "National Identity Number",
                      content: "Temporarily unavailable",
                      onEdit: () {},
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Utils.showPopup(context, "Database Error",
                    "Error accessing data. Contact developer");
              } else {
                return Center(
                    child: Container(
                  padding: const EdgeInsets.all(40),
                  child: const CircularProgressIndicator(),
                ));
              }
            }),
      ),
    );
  }
}
