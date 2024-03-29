
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/add_recipe_screen.dart';
import 'package:homenom/screens/cart_screen.dart';
import 'package:homenom/screens/login_screen.dart';
import 'package:homenom/screens/profile_screen.dart';
import 'package:homenom/screens/seller_screen.dart';
import 'package:homenom/screens/transit_screen.dart';
import 'package:homenom/screens/widgets/drawer.dart';
import 'package:provider/provider.dart';

import '../services/menu_controller.dart';
import '../structure/Role.dart';
import 'customer_screen.dart';
import 'driver_screen.dart';
import 'history_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String id = "Home_Screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final currentUser = FirebaseAuth.instance.currentUser!;
  int currentMenuIndex = 0;

  List sellerView = [
    SellerView(),
    ProfileScreen(),
    HistoryScreen(),
  ];
  List driverView = [
    DriverView(),
    ProfileScreen(),
    HistoryScreen(),
    TransitScreen(),
  ];
  List customerView = [
    CustomerView(),
    ProfileScreen(),
    HistoryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    print(currentRole);
  }

  void signOut() {
    final auth = FirebaseAuth.instance;
    Provider.of<MenuControllerProvider>(context, listen: false)
        .clearForDispose();
    auth.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void showProfileScreen() {
    // First pop out drawer
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.background,
      key: _scaffoldKey,
      appBar: buildAppBar(context),
      body: currentRole == ROLE.SELLER ? sellerView[currentMenuIndex] : currentRole == ROLE.DRIVER? driverView[currentMenuIndex]: customerView[currentMenuIndex],
      drawer: MyDrawer(
        onSignOut: signOut,
        onProfileOption: showProfileScreen,
      ),
      floatingActionButton: currentRole == ROLE.SELLER
          ? FloatingActionButton.extended(
              label: const Text("Add Recipe"),
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddRecipeScreen()));
              },
            )
          : currentRole == ROLE.DRIVER?  FloatingActionButton(
        child: const Icon(Icons.location_on_outlined),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddRecipeScreen()));
        },
      ): null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentMenuIndex,
        onTap: (index){
          setState(() {
            currentMenuIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home", activeIcon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile", activeIcon: Icon(Icons.person)),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History", activeIcon: Icon(Icons.history_outlined)),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 10,
      // backgroundColor: Theme.of(context).colorScheme.primary,
      title: currentRole == ROLE.CUSTOMER
          ? const Text(
              "Customer View",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          : currentRole == ROLE.SELLER ? const Text(
              "Seller View",
              style: TextStyle(fontWeight: FontWeight.bold),
            ) : const Text("Driver View", style: TextStyle(fontWeight: FontWeight.bold),),
      // StreamBuilder(
      //   stream: FirebaseFirestore.instance
      //       .collection('Users')
      //       .doc(currentUser.email)
      //       .snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       final user = snapshot.data!.data() as Map<String, dynamic>;
      //       return MaterialButton(
      //         onPressed: () async {
      //           await Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) => const LocationScreen()));
      //           await FirebaseFirestore.instance
      //               .collection("Users")
      //               .doc(currentUser.email)
      //               .update({
      //             "address":
      //             "${currentUserAddress.userAddress.streetAddress}, ${currentUserAddress.userAddress.city}",
      //             "latitude": currentUserAddress.latitude,
      //             "longitude": currentUserAddress.longitude,
      //           });
      //         },
      //         child:Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Icon(
      //               Icons.location_on,
      //               color: Colors.green,
      //             ),
      //             SizedBox(
      //               width: 10,
      //               child: const Text(
      //                 "|",
      //                 style: TextStyle(fontSize: 20, color: Colors.green),
      //               ),
      //             ),
      //             Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   "Location",
      //                   style: TextStyle(fontWeight: FontWeight.bold),
      //                 ),
      //                 Text(
      //                   "${user['address'] == "Null" ? "Deliver To Location" : "${user['address']}"} ",
      //                   style: TextStyle(
      //                     fontSize: 10,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             Icon(
      //               Icons.arrow_drop_down,
      //             ),
      //           ],
      //         ),
      //       );
      //     } else if (snapshot.hasError) {
      //       return Utils.showPopup(context, "Database Error",
      //           "Error accessing data. Contact developer");
      //     } else {
      //       return Center(
      //         child: Container(
      //           padding: const EdgeInsets.all(40),
      //           child: const CircularProgressIndicator(),
      //         ),
      //       );
      //     }
      //   },
      // )
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
            : currentRole == ROLE.SELLER? IconButton.filledTonal(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen())),
                icon: const Icon(Icons.notifications_outlined),
              ) : Container(),
      ],
    );
  }
}
