import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homenom/constants/constants.dart';
import '../services/TextFieldHandler.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  static const id = "Forget_Password_Screen";

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _auth = FirebaseAuth.instance;
  final _phoneField = TextFieldHandler();
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

  Future<void> sendPasswordResetEmail() async {
    try {
      showDialog(context: context, builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: const CircularProgressIndicator(),
        ),
      ),);
      await _auth.sendPasswordResetEmail(email: _phoneField.controller.text);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Email has been sent")));
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
    return Scaffold(
      backgroundColor: kAppBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Forget Password",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text("Please enter your email address to reset password"),
              const SizedBox(
                height: 30,
              ),
              TextField(
                keyboardType: TextInputType.phone,
                controller: _phoneField.controller,
                decoration: kInputFieldDecoration.copyWith(
                    hintText: "Enter email address here"),
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
                        await sendPasswordResetEmail();
                      }
                    : null,
                child: const Text(
                  "Send Request",
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
