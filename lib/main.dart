import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homenom/firebase_options.dart';
import 'package:homenom/screens/ForgetPasswordScreen.dart';
import 'package:homenom/screens/authentication_status.dart';
import 'package:homenom/screens/home_screen.dart';
import 'package:homenom/screens/location_screen.dart';
import 'package:homenom/screens/login_screen.dart';
import 'package:homenom/screens/otp_screen.dart';
import 'package:homenom/screens/profile_screen.dart';
import 'package:homenom/screens/signup_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    MyApp()
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AuthenticationStatus.id,
      routes: {
        HomeScreen.id : (context) => const HomeScreen(),
        ProfileScreen.id : (context) => ProfileScreen(),
        LocationScreen.id : (context) => const LocationScreen(),
        LoginScreen.id : (context) => const LoginScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        AuthenticationStatus.id: (context) => const AuthenticationStatus(),
        ForgetPasswordScreen.id: (context) => const ForgetPasswordScreen(),
      },
    );
  }
}
