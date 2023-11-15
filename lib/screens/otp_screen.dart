import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:pinput/pinput.dart';

import '../structure/TextFieldHandler.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  const OTPScreen({super.key, required this.phoneNumber});

  static const String id = "OTP_Screen";

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _auth = FirebaseAuth.instance;
  final _pinField = TextFieldHandler();
  bool isSendButtonActive = true;
  int timerDuration = 60;
  int _currentTickerValue = 0;
  Timer? sendEmailTimer;

  @override
  void dispose() {
    sendEmailTimer!.cancel();
    super.dispose();
  }

  void startTimer() {
    _currentTickerValue = timerDuration;
    sendEmailTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTickerValue > 0) {
        setState(() {
          _currentTickerValue--;
        });
      } else {
        setState(() {
          sendEmailTimer!.cancel();
          isSendButtonActive = true;
        });
      }
    });
  }

  Future<void> sendPasswordReset() async {
    try {
      showDialog(
        context: context,
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.all(40),
            child: const CircularProgressIndicator(),
          ),
        ),
      );
      await _auth.verifyPhoneNumber(
        phoneNumber: "+92${_auth.currentUser!.phoneNumber}",
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? token) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      // await _auth.sendPasswordResetEmail(email: _emailField.controller.text);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("OTP has been sent")));
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _currentTickerValue = 0;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(
      backgroundColor: kAppBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "One Time Passcode",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                "Please enter OTP sent on ${widget.phoneNumber}",
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                controller: _pinField.controller,
                length: 6,
                showCursor: true,
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                disabledColor: Colors.black26,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: isSendButtonActive
                    ? () async {
                        setState(() {
                          startTimer();
                          isSendButtonActive = false;
                        });
                        await sendPasswordReset();
                      }
                    : null,
                child: const Text(
                  "Send Request Again",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text(isSendButtonActive
                  ? ""
                  : "Resend in: ${_currentTickerValue.toString().padLeft(2, '0')}s"),
            ],
          ),
        ),
      ),
    );
  }
}
