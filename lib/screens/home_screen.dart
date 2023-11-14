import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/add_recipe_screen.dart';
import 'package:homenom/screens/cart_screen.dart';
import 'package:homenom/screens/location_screen.dart';
import 'package:homenom/screens/login_screen.dart';
import 'package:homenom/screens/profile_screen.dart';
import 'package:homenom/screens/widgets/drawer.dart';
import 'package:homenom/screens/widgets/menu_card.dart';

import '../services/Utlis.dart';
import '../structure/Role.dart';

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
      key: _scaffoldKey,
      appBar: buildAppBar(context),
      body: currentRole == ROLE.SELLER ? SellerView() : CustomerView(),
      drawer: MyDrawer(
        onSignOut: signOut,
        onProfileOption: showProfileScreen,
      ),
      floatingActionButton: currentRole == ROLE.SELLER
          ? FloatingActionButton(
              backgroundColor: kAppBackgroundColor,
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddRecipeScreen()));
              },
            )
          : null,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kAppBackgroundColor,
      title: StreamBuilder(
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
                        "${user['address'] == "Null" ? "Deliver To Location" : "${user['address']}"} ",
                        style: TextStyle(
                            fontSize: 10, color: Colors.white.withAlpha(100)),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
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
            : Container(),
      ],
    );
  }
}

class SellerView extends StatelessWidget {
  SellerView({
    super.key,
  });

  final auth = FirebaseAuth.instance;
  Future<void> removeMenu(dynamic menuList, int menuIndex, BuildContext context) async {
    try {
      final auth = FirebaseAuth.instance;
      final menuDoc = FirebaseFirestore.instance.collection("Menu").doc(auth.currentUser!.email);

      // Get the document ID from your menuList or use another method to obtain it
      final documentId = 'your_document_id'; // Replace with your actual logic

      // Ensure menuIndex is valid
      if (menuIndex >= 0 && menuIndex < menuList.length) {
        // Remove the item from the local list
        dynamic removedItem = menuList[menuIndex];

        // Update the document in Firebase
        await menuDoc.collection("menus").doc(documentId).update({
          "menus": FieldValue.arrayRemove([removedItem]),
        });
      } else {
        print("Invalid menuIndex");
      }
    } catch (e) {
      Utils.showPopup(context, "Database Error",
          "Something went wrong with Firebase. Error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Menu")
                  .doc(auth.currentUser!.email)
                  .snapshots(),
              builder: (context, snapshots) {
                if(snapshots.hasData){
                  if(snapshots.data!.data()!=null){
                    final data = snapshots.data!.data() as Map<String, dynamic>;
                    final menuList = data['menus'] as List<dynamic>;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.builder(
                            itemCount: menuList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final recipeList = menuList[index]['recipeList'] as List<dynamic>;
                              int rating = 0;
                              double averageRating = 0;
                              double minimum = 0;
                              double maximum = 0;
                              int numberSold = 0;
                              if(recipeList.isNotEmpty){
                                //Display the minimum and maximum delivery price of recipe
                                minimum = recipeList[0]['deliveryPrice'] as double;
                                maximum = minimum;
                                //Calculate average rating on the recipes of menu
                                for(int i =0; i < recipeList.length;i++){
                                  //for rating
                                  rating += recipeList[i]['rating'] as int;
                                  //for delivery price
                                  final deliveryPrice = recipeList[i]['deliveryPrice'] as double;
                                  if(minimum > deliveryPrice){
                                    minimum = deliveryPrice;
                                  }
                                  if(maximum < deliveryPrice){
                                    maximum = deliveryPrice;
                                  }
                                  //for sold items
                                  numberSold += recipeList[i]['numberSold'] as int;
                                }
                                averageRating = rating/recipeList.length;


                              }
                              return Dismissible(
                                key: Key("${menuList[index]['title']}+${menuList[index]['recipeList']}"),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (DismissDirection direction) async {
                                  final confirmDismiss =  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm"),
                                        content: const Text("Are you sure you want to dismiss this Menu?. All recipes will be removed."),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text("Dismiss"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if(confirmDismiss){
                                    await removeMenu(menuList, index, context);
                                  }
                                },
                                child: MenuCard(
                                  menuImage: AssetImage("assets/temporary/food_background.jpg"),
                                  menuName: menuList[index]['title'],
                                  deliveryPrice: "$minimum - $maximum",
                                  sellerRating: averageRating,
                                  numberOfItemsSold: numberSold,

                                ),
                              );
                            }),
                      ),
                    );
                  }
                  return Container();
                }else{
                  return Container();
                }
              }),
        ],
      ),
    );
  }
}

class CustomerView extends StatelessWidget {
  const CustomerView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MenuCard(
            menuImage: AssetImage("assets/temporary/food_background.jpg"),
            menuName: "BackCAPS Food",
            deliveryPrice: "150",
            sellerRating: 2.1,
            numberOfItemsSold: 125,
          ),
        ],
      ),
    );
  }
}
