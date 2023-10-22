import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/widgets/recipe_card.dart';

class RecipeScreen extends StatelessWidget {
  //TODO add title here
  //final AssetImage menuImage;
  //final String sellerShopName;
  //final int deliveryCharges;
  const RecipeScreen({super.key});

  static const String id = "Recipe_Screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        title: Text("Temporary Foods"),
      ),
      body: Column(
        children: [
          Hero(
            tag: "FoodMenu",
            child: Image(
              image: AssetImage("assets/temporary/food_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            title: Row(
              children: [
                const Text(
                  "Name: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("widget.menuName"),
              ],
            ),
            subtitle: Row(
              children: [
                const Text(
                  "Delivery: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${"widget.deliveryPrice"} Rs'),
              ],
            ),
            trailing: SizedBox(
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [Icon(Icons.star)],
                  ),
                  Text(
                    // "${"widget.numberOfItemsSold"} Sold",
                    "125 Sold",
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          RecipeCard(onPressed: (){}),
        ],
      ),
    );
  }
}
