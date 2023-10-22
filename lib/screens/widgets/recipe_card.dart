import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final void Function() onPressed;
  const RecipeCard({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ListTile(
            onTap: onPressed,
            title: Text("Chicken Cheese Burger"),
            isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("This is the description of the specific recipe"),
                Text("Price: 200"),
              ],
            ),
            trailing: Hero(
              tag: "RecipePic",
                child: Image(image: AssetImage("assets/temporary/food_background.jpg"), fit: BoxFit.contain,)),

          ),
        ],
      ),

    );
  }
}
