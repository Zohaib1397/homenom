import 'package:card_loading/card_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homenom/screens/transit_screen.dart';
import 'package:homenom/services/user_controller.dart';
import 'package:homenom/structure/IntentUtils.dart';
import 'package:provider/provider.dart';

import '../handlers/MenuHandler.dart';
import '../services/order_controller.dart';
import '../structure/Menu.dart';
import '../structure/Order.dart' as order_class;
import '../structure/User.dart' as user;
class DriverView extends StatefulWidget {
  const DriverView({Key? key}) : super(key: key);

  static const String id = "Driver_Screen";

  @override
  State<DriverView> createState() => _DriverViewState();
}

class _DriverViewState extends State<DriverView> {
  @override
  void initState() {
    super.initState();
    _loadTransitOrders();
  }

  void _loadTransitOrders() {
    Provider.of<OrderControllerProvider>(context, listen: false)
        .getReadyToDeliverOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderControllerProvider>(
      builder: (context, orderControllerProvider, _) {
        return orderControllerProvider.readyToDeliverOrders.isNotEmpty
            ? ListView.builder(
          itemCount:
          orderControllerProvider.readyToDeliverOrders.length,
          itemBuilder: (context, index) {
            order_class.Order order =
            orderControllerProvider.readyToDeliverOrders[index];
            return FutureBuilder(
              future: MenuHandler().getMenu(order.recipes.first.menuID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CardLoading(
                    height: 100,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    margin: EdgeInsets.only(bottom: 10),
                  );
                } else if (snapshot.hasError) {
                  return const Icon(Icons.image);
                } else if (!snapshot.hasData) {
                  return const Icon(Icons.image);
                } else {
                  var menu = snapshot.data as Menu;
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(menu.menuUrl ?? ''),
                      ),
                      title: Text('Order ID: ${order.orderId}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Status:',
                              style:
                              TextStyle(fontWeight: FontWeight.bold)),
                          Text('${order.status}'),
                          const Text('Total Amount:',
                              style:
                              TextStyle(fontWeight: FontWeight.bold)),
                          Text('\$${order.totalAmount}'),
                          const Text('Order Date:',
                              style:
                              TextStyle(fontWeight: FontWeight.bold)),
                          Text('${order.orderDate}'),
                          const Text('From:',
                              style:
                              TextStyle(fontWeight: FontWeight.bold)),
                          FutureBuilder(
                            future: getAddress(order.sellerEmail),
                            builder: (context, sellerSnapshot) {
                              if (sellerSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text('Loading...');
                              } else if (sellerSnapshot.hasError) {
                                return const Text(
                                    'Error loading seller address');
                              } else if (!sellerSnapshot.hasData) {
                                return const Text(
                                    'No seller address found');
                              } else {
                                var sellerAddress =
                                sellerSnapshot.data as String;
                                return Text(sellerAddress);
                              }
                            },
                          ),
                          const Text('To:',
                              style:
                              TextStyle(fontWeight: FontWeight.bold)),
                          Text(order.customer?.address ??
                              'No customer address found'),
                          ElevatedButton(
                            onPressed: () async {
                              // Change the order status to In-Transit
                              Provider.of<OrderControllerProvider>(
                                  context,
                                  listen: false)
                                  .updateOrderStatus(order, "In-Transit");

                              // Update the new collection in Firebase with driver details and order details
                              await updateDriverCollection(order);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => TransitScreen()));
                            },
                            child: Text('Get This Order'),
                          ),
                        ],
                      ),
                      onTap: () async {
                        final source = await getAddress(order.sellerEmail);
                        // Navigate to the detailed order screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoreOrderDetailsScreen(
                              order,
                              source: source,
                              destination: order.customer?.address ??
                                  "Islamabad",
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            );
          },
        )
            : const Center(child: Text('No Available Orders'));
      },
    );
  }

  Future<String> getAddress(String email) async {
    final user =
    await Provider.of<UserControllerProvider>(context, listen: false)
        .getUser(email);
    if (user != null) {
      return user.address;
    } else {
      return "No address found";
    }
  }

  Future<void> updateDriverCollection(order_class.Order order) async {
    final driverCollection = FirebaseFirestore.instance.collection('Delivery');
    final driver = await Provider.of<UserControllerProvider>(context, listen: false).getUser(FirebaseAuth.instance.currentUser!.email);
    await driverCollection.add({
      'driver': driver?.toJson(),
      'orderId': order.orderId,
      'orderDetails': order.toJson(),
    });
  }
}


class MoreOrderDetailsScreen extends StatelessWidget {
  final order_class.Order order;
  final String source;
  final String destination;

  MoreOrderDetailsScreen(this.order,
      {Key? key, required this.source, required this.destination})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.orderId}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Status: ${order.status}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Total Amount: \$${order.totalAmount}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            FutureBuilder(
              future: MenuHandler().getMenu(order.recipes.first.menuID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading menu details');
                } else if (!snapshot.hasData) {
                  return Text('No menu details found');
                } else {
                  var menu = snapshot.data as Menu;

                  return FutureBuilder(
                    future: UserControllerProvider().getUser(order.sellerEmail),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (userSnapshot.hasError) {
                        return Text('Error loading user details');
                      } else if (!userSnapshot.hasData) {
                        return Text('No user details found');
                      } else {
                        var seller = userSnapshot.data
                            as user.User;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Seller Email: ${seller.email}',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('From: ${seller.address}',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('To: ${order.customer?.address}',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        );
                      }
                    },
                  );
                }
              },
            ),
            // Display all recipes with pictures
            const Text('Recipes:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Column(
              children: order.recipes.map((recipe) {
                return ListTile(
                  leading: recipe.url != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(recipe.url),
                        )
                      : const Icon(Icons.image),
                  title: Text('Recipe Name: ${recipe.name}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: \$${recipe.price}'),
                      Text('Quantity: ${recipe.quantity}'),
                      // Add more details as needed
                    ],
                  ),
                );
              }).toList(),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     openGoogleMaps(source, destination);
            //   },
            //   child: Text('Show Directions'),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> openGoogleMaps(String source, String destination) async {
    await IntentUtils.launchGoogleMaps(sourceAddress: source, destinationAddress: destination);
  }
}
