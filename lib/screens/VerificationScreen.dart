import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homenom/constants/constants.dart';
import 'home_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  final _auth = FirebaseAuth.instance;
  Timer? timer;
  bool isResendButtonActive = false;
  double defaultBodyFontSize = 16.0;
  Timer? countDownTimer;
  int countDownDuration = 60;
  int _currentTickerValue = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      isEmailVerified = _auth.currentUser!.emailVerified;
    });

    toggleCountDownTimer();
    if (!isEmailVerified) {
      sendVerificationEmail();
      countDownRefresher();
    }
  }

  void toggleCountDownTimer() {
    _currentTickerValue = countDownDuration;
    countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTickerValue > 0) {
        setState(() {
          _currentTickerValue--;
        });
      } else {
        setState(() {
          countDownTimer!.cancel();
          isResendButtonActive = true;
        });
      }
    });
  }

  @override
  void dispose() {
    if (countDownTimer != null) {
      countDownTimer!.cancel();
    }
    if(timer!=null){
      timer!.cancel();
    }
    super.dispose();
  }

  void checkEmailVerification() async {
    try {
      await _auth.currentUser!.reload();
      setState(() {
        isEmailVerified = _auth.currentUser!.emailVerified;
      });
      print("Email verification state: $isEmailVerified");
      if(!isEmailVerified){
        countDownRefresher();
      }else{
        countDownTimer!.cancel();
        timer!.cancel();
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something wrong in verification checking")));
    }
  }
  void countDownRefresher() {
    if (timer == null || !timer!.isActive) {
      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        checkEmailVerification();
      });
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const HomeScreen()
        : Scaffold(
            backgroundColor: kAppBackgroundColor,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
              title: const Center(
                child: Text(
                  "Email Verification",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email_outlined, size: 150,),
                  const SizedBox(
                    height: 20,
                  ),
                  Text.rich(
                    TextSpan(
                      text: "An email has been sent to ",
                      style: TextStyle(
                        fontSize: defaultBodyFontSize,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '${_auth.currentUser!.email}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, // Add bold style
                          ),
                        ),
                        const TextSpan(
                            text:
                                ".\n To be able to login, you need to verify\n your email first."),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    textWidthBasis: TextWidthBasis.longestLine,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    disabledColor: Colors.black26,
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: isResendButtonActive
                        ? () {
                            setState(() {
                              isResendButtonActive = false;
                              toggleCountDownTimer();
                            });
                          }
                        : null,
                    child: const Text(
                      "Resend Verification Link",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Text(isResendButtonActive
                      ? ""
                      : "Resend in: ${_currentTickerValue.toString().padLeft(2, '0')}s"),
                ],
              ),
            ),
          );
  }

}
