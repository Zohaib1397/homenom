import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/firebase_options.dart';
import 'package:homenom/screens/ForgetPasswordScreen.dart';
import 'package:homenom/screens/Signup%20Screens/driver_signup_screen.dart';
import 'package:homenom/screens/add_menu_screen.dart';
import 'package:homenom/screens/add_recipe_screen.dart';
import 'package:homenom/screens/askRoleScreen.dart';
import 'package:homenom/screens/authentication_status.dart';
import 'package:homenom/screens/cart_screen.dart';
import 'package:homenom/screens/home_screen.dart';
import 'package:homenom/screens/login_screen.dart';
import 'package:homenom/screens/profile_screen.dart';
import 'package:homenom/screens/Signup%20Screens/customer_signup_screen.dart';
import 'package:homenom/services/menu_controller.dart';
import 'package:homenom/services/order_controller.dart';
import 'package:homenom/services/user_controller.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MenuControllerProvider()),
          ChangeNotifierProvider(create: (context) => UserControllerProvider()),
          ChangeNotifierProvider(create: (context) => OrderControllerProvider())
        ],
        child: const MyApp(),
      ),

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true, colorSchemeSeed: kAppBackgroundColor,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AuthenticationStatus.id,
      routes: {
        DriverSignUpScreen.id : (context) => const DriverSignUpScreen(),
        AskRoleScreen.id: (context) => const AskRoleScreen(),
        AddMenuScreen.id: (context) => const AddMenuScreen(),
        AddRecipeScreen.id: (context) => AddRecipeScreen(),
        CartScreen.id: (context) => const CartScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        ProfileScreen.id: (context) => const ProfileScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        AuthenticationStatus.id: (context) => const AuthenticationStatus(),
        ForgetPasswordScreen.id: (context) => const ForgetPasswordScreen(),
      },
    );
  }
}
