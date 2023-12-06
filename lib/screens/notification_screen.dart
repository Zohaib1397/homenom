import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../handlers/MenuHandler.dart';
import '../services/order_controller.dart';
import '../structure/Menu.dart';
import '../structure/Order.dart';
import '../structure/Role.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: currentRole == ROLE.SELLER
          ? SellerNotification()
          : DriverNotification(),
      // body: const Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Padding(
      //         padding: EdgeInsets.all(30.0),
      //         child: Image(image: AssetImage("assets/empty_data_icon.png"),),
      //       ),
      //       Text("No Notification"),
      //     ],
      //   ),
      // ),
    );
  }
}

//This screen will find the orders whose status is pending and are of respective seller
class SellerNotification extends StatefulWidget {
  const SellerNotification({super.key});

  @override
  State<SellerNotification> createState() => _SellerNotificationState();
}

class _SellerNotificationState extends State<SellerNotification> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderControllerProvider>(
        builder: (context, orderControllerProvider, _) {
          orderControllerProvider.getSellerPendingOrders();
          List<Order> orderList =  orderControllerProvider.pendingOrders;
          return orderList.isNotEmpty
              ? ListView.builder(
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              Order order = orderList[index];
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => OrderDetailsScreen(order),
                          //   ),
                          // );
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

class DriverNotification extends StatefulWidget {
  const DriverNotification({super.key});

  @override
  State<DriverNotification> createState() => _DriverNotificationState();
}

class _DriverNotificationState extends State<DriverNotification> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
