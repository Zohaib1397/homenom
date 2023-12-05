import 'package:flutter/material.dart';

import '../constants/constants.dart';
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
    return const Placeholder();
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
