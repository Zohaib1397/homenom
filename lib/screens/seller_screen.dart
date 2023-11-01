import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  static const String id = "Seller_Screen";

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {

  final _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAppBackgroundColor,
        child: Icon(Icons.add),
        onPressed: (){},
      ),
    );
  }

}
