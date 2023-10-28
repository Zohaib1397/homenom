import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/location_screen.dart';
import 'package:homenom/screens/widgets/profile_card.dart';
import 'package:homenom/services/TextFieldHandler.dart';
import 'package:homenom/services/Utlis.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});


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
        backgroundColor: kAppBackgroundColor,
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
                      onEdit: () {
                        setState(() {
                          editingText.controller.text = user['username'];
                        });
                        FieldEditingPopUp(context, user['isPhoneVerified'], fieldName: 'username', title: "Username", handler: editingText);
                      },
                    ),
                    ProfileCard(
                      field: "Phone Number",
                      content: "0${user['phoneNum']}",
                      onEdit: () {
                        setState(() {
                          editingText.controller.text = "${user['phoneNum']}";
                        });
                        FieldEditingPopUp(context, user['isPhoneVerified'], fieldName: 'phoneNum', title: "Phone Number", handler: editingText);
                        Utils.showPopup(context, "Notice", "Editing phone number will clear phone verifications");
                      },
                    ),
                    ProfileCard(
                      field: "Address",
                      content: user['address'],
                      onEdit: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LocationScreen()),
                        );
                        await FirebaseFirestore.instance.collection("Users").doc(currentUser.email).update({"address": "${userAddress.streetAddress}, ${userAddress.city}"});
                      },
                    ),
                    user['role'] == "ROLE.SELLER"? ProfileCard(
                      field: "National Identity Number",
                      content: user['CNIC'],
                      onEdit: () {
                        setState(() {
                          editingText.controller.text = user['CNIC'];
                        });
                        FieldEditingPopUp(context, user['isPhoneVerified'], fieldName: 'CNIC', title: "National Identity Number", handler: editingText);
                      },
                    ): Container(),
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

Future FieldEditingPopUp(BuildContext context, bool phoneVerification, {required fieldName, required String title, required TextFieldHandler handler}){
  return showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      title: Text("Edit $title"),
      content: TextField(
        controller: handler.controller,
        decoration: InputDecoration(
          errorText: handler.errorText,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await FirebaseFirestore.instance.collection("Users").doc(currentUser.email).update({fieldName: handler.controller.text, "isPhoneVerified": fieldName == 'phoneNum'? !phoneVerification : phoneVerification});
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
  });
}
