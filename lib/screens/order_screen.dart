import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/cart_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  static const String id = "Order_Screen";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int numberOfItems = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        title: Text("Shop Name here"),
        actions: [
          IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              color: Colors.white,
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartScreen())))
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Hero(
                tag: "RecipePic",
                child: Image(
                  image: AssetImage("assets/temporary/food_background.jpg"),
                  fit: BoxFit.contain,
                )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Recipe Name here",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(loremText),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customOrderCounter(
                          onDecrement: () {
                            setState(() {
                              if (numberOfItems != 1) {
                                numberOfItems -= 1;
                              }
                            });
                          },
                          onIncrement: () {
                            setState(() {
                              numberOfItems += 1;
                            });
                          },
                          orderCount: numberOfItems),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Price: 350 Rs"),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(kDefaultBorderRadius)),
                  color: kAppBackgroundColor,
                  onPressed: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget customOrderCounter({
  required int orderCount,
  required Function() onDecrement,
  required Function() onIncrement,
}) {
  return SizedBox(
    child: Row(
      children: [
        MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius)),
          onPressed: onDecrement,
          minWidth: 10,
          color: kAppBackgroundColor,
          child: const Text(
            "-",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Text("$orderCount"),
        const SizedBox(
          width: 20,
        ),
        MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius)),
          onPressed: onIncrement,
          minWidth: 10,
          color: kAppBackgroundColor,
          child: const Text(
            "+",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ),
  );
}
