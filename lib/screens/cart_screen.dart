import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/confirm_address.dart';
import 'package:homenom/screens/widgets/build_cache_image.dart';
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
    final cartListLength = Provider.of<MenuControllerProvider>(context, listen: false).cartList.length;
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
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                if(cartListLength>0){
                  setState(() {
                    Provider.of<MenuControllerProvider>(context,listen: false).clearCart();
                  });
                  Utils.showPopup(context, "Success", "Cart cleared successfully.");
                }else{
                  Utils.showPopup(context, "Oops", "List is already empty.");
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "Main Button",
              label: const Text(
                "Check Out",
                style: TextStyle(fontSize: 16),
              ),
              // backgroundColor: kAppBackgroundColor,
              icon: const Icon(Icons.navigate_next),
              onPressed: () {
                if(cartListLength>0){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddressScreen()));
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Oops!! cart is empty.")));
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(Provider.of<MenuControllerProvider>(context, listen: false).cartList.length, (index) {
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
                    trailing: generateCachedImage(url: recipeList[index]['url'], clip: 0),
                    // trailing: Image(image: NetworkImage(recipeList[index]['url']), fit: BoxFit.contain,),

                  ),
                ),
              );
            }),
            Provider.of<MenuControllerProvider>(context, listen: false).cartList.length == 0? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Image(image: AssetImage("assets/empty_data_icon.png"),),
                  ),
                  Text("No item in cart"),
                ],
              ),
            ) : Container(),
          ]
        ),
      ),
    );
  }
}
