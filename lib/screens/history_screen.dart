import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../handlers/MenuHandler.dart';
import '../services/order_controller.dart';
import '../services/user_controller.dart';
import '../structure/Menu.dart';
import '../structure/Order.dart';
import '../structure/Role.dart';
import '../structure/User.dart' as user;

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: currentRole == ROLE.CUSTOMER? CustomerHistory(): SellerHistory(),
      // body: const Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Padding(
      //         padding: EdgeInsets.all(30.0),
      //         child: Image(image: AssetImage("assets/empty_data_icon.png"),),
      //       ),
      //       Text("No History found"),
      //     ],
      //   ),
      // ),
    );
  }
}

class CustomerHistory extends StatefulWidget {
  const CustomerHistory({super.key});

  @override
  State<CustomerHistory> createState() => _CustomerHistoryState();
}

class _CustomerHistoryState extends State<CustomerHistory> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderControllerProvider>(builder: (context, orderControllerProvider, _){
      List<Order> ordersList = orderControllerProvider.respectiveOrders;
      return ordersList.isNotEmpty
          ? ListView.builder(
        itemCount: ordersList.length,
        itemBuilder: (context, index) {
          Order order = ordersList[index];
          return FutureBuilder(
            future: MenuHandler().getMenu(order.recipes.first.menuID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Error loading menu picture');
              } else if (!snapshot.hasData) {
                return const Text('No menu picture found');
              } else {
                var menu = snapshot.data as Menu;
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: menu.menuUrl != null
                        ? CircleAvatar(
                      backgroundImage: NetworkImage(menu.menuUrl),
                    )
                        : const Icon(Icons.image),
                    title: Text('Order ID: ${order.orderId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Status:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${order.status}'),
                        const Text(
                          'Total Amount:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('\$${order.totalAmount}'),
                        const Text(
                          'Order Date:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${order.orderDate}'),
                      ],
                    ),
                    onTap: () {
                      // Navigate to the detailed order screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(order),
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
          : const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Image(image: AssetImage("assets/empty_data_icon.png"),),
            ),
            Text("No History found"),
          ],
        ),
      );
    });
  }
}

class SellerHistory extends StatefulWidget {
  const SellerHistory({super.key});

  @override
  State<SellerHistory> createState() => _SellerHistoryState();
}

class _SellerHistoryState extends State<SellerHistory> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  OrderDetailsScreen(this.order, {super.key});

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
            Text('Order ID: ${order.orderId}', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Status: ${order.status}', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Total Amount: \$${order.totalAmount}', style: TextStyle(fontWeight: FontWeight.bold)),
            FutureBuilder(
              future: MenuHandler().getMenu(order.recipes.first.menuID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading menu details');
                } else if (!snapshot.hasData) {
                  return Text('No menu details found');
                } else {
                  var menu = snapshot.data as Menu;

                  return FutureBuilder(
                    future: UserControllerProvider().getUser(menu.email),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (userSnapshot.hasError) {
                        return Text('Error loading user details');
                      } else if (!userSnapshot.hasData) {
                        return Text('No user details found');
                      } else {
                        var seller = userSnapshot.data as user.User; // Replace with your User class

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Seller Email: ${seller.email}', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        );
                      }
                    },
                  );
                }
              },
            ),
            // Display all recipes with pictures
            const Text('Recipes:', style: TextStyle(fontWeight: FontWeight.bold)),
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
          ],
        ),
      ),
    );
  }
}

