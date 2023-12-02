import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/services/menu_controller.dart';
import 'package:provider/provider.dart';

import '../services/Utils.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static const String id = "Cart_Screen";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<dynamic> recipeList;

  @override
  void initState() {
    super.initState();
    recipeList = Provider.of<MenuControllerProvider>(context, listen: false).cartList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart List"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 10,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 10,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              label: const Text(
                "Clear Cart",
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: kAppBackgroundColor,
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                setState(() {
                  Provider.of<MenuControllerProvider>(context,listen: false).clearCart();

                });
                Utils.showPopup(context, "Success", "Cart cleared successfully.");
                // clearCartNow(context);
                //
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (c) => const SplashScreen()));
                //
                // Fluttertoast.showToast(msg: "Cart has been cleared.");
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn2",
              label: const Text(
                "Check Out",
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: kAppBackgroundColor,
              icon: const Icon(Icons.navigate_next),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (c) => AddressScreen(
                //       totalAmount: totalAmount.toDouble(),
                //       sellerUID: widget.sellerUID,
                //     ),
                //   ),
                // );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(Provider.of<MenuControllerProvider>(context, listen: false).cartList.length, (index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(recipeList[index]['name'], style: const TextStyle(fontWeight: FontWeight.bold),),
                  isThreeLine: true,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Description: ${recipeList[index]['description']}"),
                      Text("Price: ${recipeList[index]['price']}"),
                      Text("Sold: ${recipeList[index]['numberSold']}"),
                      Text("Total Quantity: ${recipeList[index]['currentOrder']}"),
                    ],
                  ),
                  trailing: const Image(image: AssetImage("assets/temporary/food_background.jpg"), fit: BoxFit.contain,),

                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
