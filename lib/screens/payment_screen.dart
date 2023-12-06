import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:homenom/screens/home_screen.dart';
import 'package:homenom/screens/widgets/build_cache_image.dart';
import 'package:homenom/services/order_controller.dart';
import 'package:homenom/services/user_controller.dart';
import 'package:provider/provider.dart';
import '../services/menu_controller.dart';
import '../structure/Order.dart';
import '../structure/Recipe.dart';
import '../structure/User.dart' as user;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, List<dynamic>> totalOrders = {};
  late List<dynamic> recipeList;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    recipeList = Provider.of<MenuControllerProvider>(context, listen: false).cartList;
    separateMenus();
    print("Total Orders: ${totalOrders}");
  }

  void separateMenus(){
    //identify each menu id in the recipe list
    // and separate into multiple lists so that we consider it for multiple orders
    for(final recipe in recipeList){
      if(!totalOrders.containsKey(recipe['menuID'])){
        totalOrders[recipe['menuID']] = [];
      }
        totalOrders[recipe['menuID']]!.add(recipe);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Order"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(),
            const Icon(Icons.payments_outlined, size: 150),
            const SizedBox(
              height: 10,
            ),
            const Text.rich(
              TextSpan(
                text: "Please confirm your order through",
                style: TextStyle(
                  fontSize: 16,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '\nCash-On-Delivery',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Add bold style
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              textWidthBasis: TextWidthBasis.longestLine,
            ),
            const SizedBox(
              height: 20,
            ),
            ...List.generate(Provider.of<MenuControllerProvider>(context, listen: false).cartList.length, (index) {
              totalPrice += recipeList[index]['price']*recipeList[index]['currentOrder'];
              totalPrice += recipeList[index]['deliveryPrice'];
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
                    trailing: generateCachedImage(url: recipeList[index]['url'], clip: 12),
                    // trailing: Image(image: NetworkImage(recipeList[index]['url']), fit: BoxFit.contain,),
                  ),
                ),
              );
            }),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Total Price: ",
                style: TextStyle(fontSize: 20)),
                Text("$totalPrice",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                // Text("Delivery Price: ")
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.red,
              elevation: 0,
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
              },
              label: const Text("Cancel Order", style: TextStyle(color: Colors.white),),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              heroTag: "Main Button",
              elevation: 0,
              onPressed: () async {
                //TODO add logic here to separate orders
                for(var menuID in totalOrders.keys){
                  user.User? customer = await Provider.of<UserControllerProvider>(context, listen: false).getUser(FirebaseAuth.instance.currentUser!.email);
                  Order order = Order(
                      orderId: UniqueKey().toString(),
                      customer: customer,
                      recipes: totalOrders[menuID]!.map((element) => Recipe.fromJson(element)).toList(),
                      orderDate: DateTime.now(),
                      totalAmount: totalPrice,
                      status: "Pending"
                  );
                  //Todo add logic for multiple ids
                  Provider.of<OrderControllerProvider>(context, listen: false).createOrder(order);
                }
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const _OrderConfirmed()));
                Provider.of<MenuControllerProvider>(context, listen: false).cartList.clear();
                recipeList.clear();
              },
              label: const Text("Place Order"),
            ),
          ),
        ],
      ),
    );
  }
}


class _OrderConfirmed extends StatelessWidget {
  const _OrderConfirmed();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Confirmed"),
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen())),
          icon: Icon(Icons.close),
        ),
      ),
      body: const Center(
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.verified_user_rounded, size: 200, color: Colors.green,),
              SizedBox(height: 20),
              Text("Congratulation your order has been placed."),
            ],
          ),
        ),
      ),
    );
  }
}
