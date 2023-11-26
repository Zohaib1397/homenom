import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/order_screen.dart';
import 'package:homenom/screens/widgets/recipe_card.dart';
import 'package:homenom/services/menu_controller.dart';
import 'package:provider/provider.dart';

import '../structure/Menu.dart';

class RecipeScreen extends StatefulWidget {
  final Menu menu;
  final String priceRange;
  final List<Icon> ratingStars;

  const RecipeScreen(
      {super.key,
      required this.menu,
      required this.priceRange,
      required this.ratingStars});

  static const String id = "Recipe_Screen";

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        title: const Text("Menu Recipes"),
      ),
      body: Column(
        children: [
          Image(
            image: AssetImage("assets/temporary/food_background.jpg"),
            fit: BoxFit.cover,
          ),
          ListTile(
            title: Row(
              children: [
                const Text(
                  "Name: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.menu.title),
              ],
            ),
            subtitle: Row(
              children: [
                const Text(
                  "Delivery: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${widget.priceRange} Rs'),
              ],
            ),
            trailing: SizedBox(
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: widget.ratingStars,
                  ),
                  Text(
                    "${widget.menu.numberSold} Sold",
                    // "125 Sold",
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          RecipeCard(menu: widget.menu),
        ],
      ),
    );
  }
}
