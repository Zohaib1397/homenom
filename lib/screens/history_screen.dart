import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../structure/Role.dart';

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
    return const Placeholder();
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


