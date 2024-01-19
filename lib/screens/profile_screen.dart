import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homenom/screens/location_screen.dart';
import 'package:homenom/screens/widgets/profile_card.dart';
import 'package:homenom/structure/TextFieldHandler.dart';
import 'package:homenom/services/Utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String id = "Profile_Screen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final currentUser = FirebaseAuth.instance.currentUser!;

class _ProfileScreenState extends State<ProfileScreen> {
  TextFieldHandler editingText = TextFieldHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        title: const Text("Profile Page"),
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
                  ),
                  ProfileCard(
                    field: "Phone Number",
                    content: "0${user['phoneNum']}",
                  ),
                  ProfileCard(
                    field: "Address",
                    content: user['address'],
                  ),
                  user['role'] == "ROLE.SELLER"
                      ? ProfileCard(
                          field: "National Identity Number",
                          content: user['CNIC'],
                        )
                      : Container(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      showEditDialog(context, user);
                    },
                    child: Text("Edit My Details"),
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
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void showEditDialog(BuildContext context, Map<String, dynamic> user) {
    setState(() {
      editingText.controller.text = user['username'];
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit My Details"),
          content: Column(
            children: [
              TextField(
                controller: editingText.controller,
                decoration: InputDecoration(
                  labelText: "Username",
                  errorText: editingText.errorText,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("Users")
                    .doc(currentUser.email)
                    .update({
                  "username": editingText.controller.text,
                  // Update other fields here
                });
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                child: const Text("Save"),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                child: const Text("Cancel"),
              ),
            )
          ],
        );
      },
    );
  }
}
