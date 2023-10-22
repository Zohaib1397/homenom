import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/cart_screen.dart';
import 'package:homenom/screens/location_screen.dart';
import 'package:homenom/screens/login_screen.dart';
import 'package:homenom/screens/profile_screen.dart';
import 'package:homenom/screens/widgets/drawer.dart';
import 'package:homenom/screens/widgets/menu_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String id = "Home_Screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void signOut() {
    final _auth = FirebaseAuth.instance;
    _auth.signOut();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void showProfileScreen(){
    // First pop out drawer
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        title: MaterialButton(
          onPressed: () {
            Navigator.of(context).pushNamed(LocationScreen.id);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.green,
              ),
              SizedBox(
                width: 10,
                child: const Text(
                  "|",
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    "Deliver To Location",
                    style: TextStyle(color: Colors.white.withAlpha(100)),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ],
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: const Image(
                image: AssetImage("assets/homenom.png"),
              )),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MenuCard(
              menuImage: AssetImage("assets/temporary/food_background.jpg"),
              menuName: "BackCAPS Food",
              deliveryPrice: 150,
              sellerRating: 2.1,
              numberOfItemsSold: 125,
            ),
          ],
        ),
      ),
      drawer: MyDrawer(
        onSignOut: signOut,
        onProfileOption: showProfileScreen,
      ),
    );
  }
}
