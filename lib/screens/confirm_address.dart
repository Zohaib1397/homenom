import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/payment_screen.dart';
import 'package:homenom/screens/profile_screen.dart';

import '../structure/TextFieldHandler.dart';
import 'location_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _address = TextFieldHandler();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Address"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUser.email)
                .snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                final user = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_city_outlined, size: 150),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Verify your delivery address."),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      // readOnly: true,
                      controller: _address.controller,
                      decoration: kInputFieldDecoration.copyWith(
                        hintText: user['address']!="Null"? user['address']:"Select from map",
                        errorText: _address.errorText,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.location_on),
                          onPressed: () {
                            setState(() async {
                              _address.controller.text =
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const LocationScreen()));
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FloatingActionButton.extended(
                      elevation: 0,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const PaymentScreen()));
                      },
                      icon: const Icon(Icons.payments_outlined),
                      label: const Text("Proceed to payment"),
                    ),
                  ],
                );
              }
              else{
                return Container();
              }

          }
        ),
      ),
    );
  }
}
