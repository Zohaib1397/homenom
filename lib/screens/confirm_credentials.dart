import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/otp_screen.dart';
import 'package:homenom/screens/payment_screen.dart';
import 'package:homenom/screens/profile_screen.dart';
import 'package:homenom/services/Utils.dart';
import 'package:homenom/services/user_controller.dart';
import 'package:provider/provider.dart';

import '../structure/TextFieldHandler.dart';
import 'location_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _address = TextFieldHandler();
  final _phoneField = TextFieldHandler();
  bool isLoading = false;

  Future<bool> verifyPhoneNumber() async {
    Completer<bool> verificationCompleter = Completer<bool>();
    bool verified = false;
    print("Verifying phone number: $verified");
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+92${_phoneField.controller.text.toString()}",
        verificationCompleted: (PhoneAuthCredential credentials) async {
          verified = true;
          verificationCompleter.complete(verified);
        },
        verificationFailed: (FirebaseAuthException ex) {
          setState(() {
            isLoading = false;
          });
          verificationCompleter.completeError(ex);
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to OTP screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(verificationId: verificationId),
            ),
          ).then((otpVerified) {
            verified = otpVerified ?? false;
            verificationCompleter.complete(verified);
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      verificationCompleter.completeError(e);
    }
    print("Status verified of phone number: $verified");
    return verificationCompleter.future;
  }

  Future<void> handlePhoneNumberVerification(String phoneNumber) async {
    try {
      setState(() => isLoading = true);
      bool verified = await verifyPhoneNumber();
      if (verified) {
        print("Congratulation Phone is verified");
        // Update phone number status in Firebase
        Provider.of<UserControllerProvider>(context, listen: false)
            .updatePhone(_phoneField.controller.text);
        setState(() => isLoading = false);
      } else {
        setState(() => isLoading = false);
        throw Exception("Invalid code entered");
      }
    } catch (e) {
      Utils.showPopup(context, "Something went wrong", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Credentials"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(currentUser.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final user =
                          snapshot.data!.data() as Map<String, dynamic>;
                      if (user['address'] != "Null") {
                        _address.controller.text = user['address'];
                      }
                      if (user['phoneNum'] != "Null") {
                        _phoneField.controller.text = user['phoneNum'];
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_city_outlined, size: 150),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                              "Verify your delivery address & phone number."),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            // readOnly: true,
                            controller: _address.controller,
                            decoration: kInputFieldDecoration.copyWith(
                              hintText: user['address'] != "Null"
                                  ? user['address']
                                  : "Select from map",
                              errorText: _address.errorText,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.location_on),
                                onPressed: () async {
                                  final address = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const LocationScreen()));
                                  setState(() async {
                                    _address.controller.text = address;
                                  });
                                  Provider.of<UserControllerProvider>(context,listen: false).updateLocation(currentUserAddress.latitude, currentUserAddress.longitude);
                                },
                              ),
                            ),
                          ),
                          TextField(
                            controller: _phoneField.controller,
                            keyboardType: TextInputType.phone,
                            decoration: kInputFieldDecoration.copyWith(
                              hintText: user['phoneNum'] != "Null"
                                  ? user['phoneNum']
                                  : "Enter phone number",
                              prefixIcon: const Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text('+92 ')),
                              suffixIcon: IconButton(
                                icon: user['isPhoneVerified']
                                    ? const Icon(
                                        Icons.verified,
                                        color: Colors.green,
                                      )
                                    : const Icon(
                                        Icons.do_not_disturb_alt_outlined,
                                        color: Colors.red,
                                      ),
                                onPressed: () async {
                                  await handlePhoneNumberVerification(
                                      _phoneField.controller.text);
                                },
                              ),
                              errorText: _phoneField.errorText,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FloatingActionButton.extended(
                            heroTag: "Main Button",
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 0,
                            onPressed: () {
                              if (_address.controller.text != "" && user['isPhoneVerified']) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PaymentScreen()));
                              }
                              else{
                                if(_phoneField.controller.text ==""){
                                  _phoneField.errorText = "Phone number is required";
                                }
                                else{
                                  _phoneField.errorText = "Please verify phone number";
                                }
                                if(_address.controller.text == ""){
                                  _address.errorText = "Address is required";
                                }

                              }
                            },
                            icon: const Icon(
                              Icons.payments_outlined,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Proceed to payment",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
          ),
          isLoading
              ? Scaffold(
                  backgroundColor: Colors.black.withAlpha(200),
                )
              : Container(),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ],
      ),
    );
  }
}
