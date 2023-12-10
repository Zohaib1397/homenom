import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:homenom/screens/transit_screen.dart';
import 'package:homenom/services/menu_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
        title: currentRole == ROLE.SELLER? const Text("Orders"): const Text("History"),
      ),
      body: currentRole == ROLE.CUSTOMER? CustomerHistory(): currentRole == ROLE.SELLER? SellerHistory() : Container(),
    );
  }
}


class CustomerHistory extends StatefulWidget {
  const CustomerHistory({super.key});

  @override
  State<CustomerHistory> createState() => _CustomerHistoryState();
}


class _CustomerHistoryState extends State<CustomerHistory> {
  double? sellerRating;
  double? menuRating;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderControllerProvider>(builder: (context, orderControllerProvider, _) {
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
                return const CardLoading(
                  height: 100,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  margin: EdgeInsets.only(bottom: 10),
                );
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
                        if (order.status == 'Delivered') ...[
                          const Text(
                            'Rate Seller:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          RatingBar.builder(
                            initialRating: sellerRating ?? 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: kAppBackgroundColor,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                sellerRating = rating;
                              });
                            },
                          ),
                          const Text(
                            'Rate Delivery:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          RatingBar.builder(
                            initialRating: menuRating ?? 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: kAppBackgroundColor,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                menuRating = rating;
                              });
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Perform the logic to submit ratings and update the order status
                              _submitRatingsAndCompleteOrder(
                                order,
                                sellerRating ?? 0,
                                menuRating ?? 0,
                              );
                            },
                            child: const Text('Rate & Complete Order'),
                          ),
                        ],
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
              child: Image(image: AssetImage("assets/empty_data_icon.png")),
            ),
            Text("No History found"),
          ],
        ),
      );
    });
  }

  void _submitRatingsAndCompleteOrder(Order order, double sellerRating, double menuRating) {
    for(final recipe in order.recipes){
      Provider.of<MenuControllerProvider>(context, listen: false).updateMenuRating(recipe, menuRating);
      // Provider.of<MenuControllerProvider>(context, listen: false).updateSold(recipe, 1);
    }
    Provider.of<UserControllerProvider>(context, listen: false).updateRating(order.sellerEmail, sellerRating);
    Provider.of<OrderControllerProvider>(context, listen: false).updateOrderStatus(order, 'Rated');
    Provider.of<MenuControllerProvider>(context, listen: false).menusFromHandler();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Ratings submitted. Order is complete."),
    ));
  }
}

class SellerHistory extends StatefulWidget {
  const SellerHistory({Key? key}) : super(key: key);

  @override
  State<SellerHistory> createState() => _SellerHistoryState();
}
class _SellerHistoryState extends State<SellerHistory> {
  String selectedStatus = 'Accepted'; // Default status

  @override
  void initState() {
    super.initState();

    _fetchSellerOrders();
  }

  void _fetchSellerOrders() {
    Provider.of<OrderControllerProvider>(context, listen: false).getSellerOrdersByStatus(selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderControllerProvider>(
      builder: (context, orderControllerProvider, _) {
        return Column(
          children: [
            DropdownButton<String>(
              value: selectedStatus,
              items: ['Accepted', 'Rejected', 'Ready-To-Deliver', 'In-Transit', 'Delivered']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    selectedStatus = value;
                  });
                  orderControllerProvider.getSellerOrdersByStatus(selectedStatus);
                }
              },
            ),
            Expanded(
              child: orderControllerProvider.sellerOrdersByStatus.isNotEmpty
                  ? ListView.builder(
                itemCount: orderControllerProvider.sellerOrdersByStatus.length,
                itemBuilder: (context, index) {
                  Order order = orderControllerProvider.sellerOrdersByStatus[index];
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
                                selectedStatus == "Accepted"? ElevatedButton(
                                  onPressed: (){
                                   orderControllerProvider.updateOrderStatus(order, "Ready-To-Deliver");
                                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select driver."),));
                                   orderControllerProvider.getSellerOrdersByStatus(selectedStatus);
                                  },
                                  child: const Text("Complete Order"),
                                ): Container(),
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
                      child: Image(image: AssetImage("assets/empty_data_icon.png")),
                    ),
                    Text("No Product found"),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
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
                  return const CardLoading(
                    height: 100,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    margin: EdgeInsets.only(bottom: 10),
                  );
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

