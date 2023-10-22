import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  static const String id = "Order_Screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        title: Text("Shop Name here"),
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
                  Text(
                    "This is the textual description of the recipe",
                  ),
                  MaterialButton(
                    onPressed: (){},
                    child: Text("Add"),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Price: 350 Rs"),
                MaterialButton(onPressed: (){}, child: Text("Add to Cart"),)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
