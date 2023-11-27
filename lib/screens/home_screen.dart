import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/add_recipe_screen.dart';
import 'package:homenom/screens/cart_screen.dart';
import 'package:homenom/screens/location_screen.dart';
import 'package:homenom/screens/login_screen.dart';
import 'package:homenom/screens/profile_screen.dart';
import 'package:homenom/screens/seller_screen.dart';
import 'package:homenom/screens/widgets/drawer.dart';
import 'package:homenom/screens/widgets/menu_card.dart';
import 'package:provider/provider.dart';

import '../services/Utils.dart';
import '../services/menu_controller.dart';
import '../services/recipe_card_brain.dart';
import '../structure/Menu.dart';
import '../structure/Role.dart';
import 'customer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String id = "Home_Screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    print(currentRole);
  }

  void signOut() {
    final _auth = FirebaseAuth.instance;
    _auth.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void showProfileScreen() {
    // First pop out drawer
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.background,
      key: _scaffoldKey,
      appBar: buildAppBar(context),
      body: currentRole == ROLE.SELLER ? SellerView() : CustomerView(),
      drawer: MyDrawer(
        onSignOut: signOut,
        onProfileOption: showProfileScreen,
      ),
      floatingActionButton: currentRole == ROLE.SELLER
          ? FloatingActionButton.extended(
        label: const Text("Add Recipe"),
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddRecipeScreen()));
              },
            )
          : null,
      // bottomNavigationBar: NavigationBar(
      //   onDestinationSelected: (int index) {
      //     print('Selected $index');
      //   },
      //   selectedIndex: 0,
      //   destinations: const <NavigationDestination>[
      //     NavigationDestination(
      //       selectedIcon: Icon(Icons.person),
      //       icon: Icon(Icons.person_outline),
      //       label: 'Learn',
      //     ),
      //     NavigationDestination(
      //       selectedIcon: Icon(Icons.engineering),
      //       icon: Icon(Icons.engineering_outlined),
      //       label: 'Relearn',
      //     ),
      //     NavigationDestination(
      //       selectedIcon: Icon(Icons.bookmark),
      //       icon: Icon(Icons.bookmark_border),
      //       label: 'Unlearn',
      //     ),
      //   ],
      // ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 10,
      // backgroundColor: Theme.of(context).colorScheme.primary,
      title: currentRole == ROLE.CUSTOMER? StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!.data() as Map<String, dynamic>;
            return MaterialButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LocationScreen()));
                await FirebaseFirestore.instance
                    .collection("Users")
                    .doc(currentUser.email)
                    .update({
                  "address":
                      "${currentUserAddress.userAddress.streetAddress}, ${currentUserAddress.userAddress.city}",
                  "latitude": currentUserAddress.latitude,
                  "longitude": currentUserAddress.longitude,
                });
              },
              child:Row(
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${user['address'] == "Null" ? "Deliver To Location" : "${user['address']}"} ",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Utils.showPopup(context, "Database Error",
                "Error accessing data. Contact developer");
          } else {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(40),
                child: const CircularProgressIndicator(),
              ),
            );
          }
        },
      ) : const Text("Seller View", style: TextStyle(fontWeight: FontWeight.bold),),
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
        currentRole == ROLE.CUSTOMER
            ? IconButton(

                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()));
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                ))
            : IconButton.filledTonal(

                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
              ),
      ],
    );
  }
}
