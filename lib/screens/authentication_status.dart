import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homenom/screens/VerificationScreen.dart';
import 'login_screen.dart';

class AuthenticationStatus extends StatelessWidget {
  const AuthenticationStatus({super.key});

  static const String id = "Authentication_Status";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          //OTP screen checks if the phone number is verified or not
          return const EmailVerificationScreen();
        }
        else{
          return const LoginScreen();
        }
      },
    );
  }
}
