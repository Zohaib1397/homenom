import 'package:flutter/material.dart';
import 'package:homenom/screens/widgets/recipe_card.dart';

import '../structure/Menu.dart';

class RecipeScreen extends StatefulWidget {
  final Menu menu;
  final int menuIndex;
  final String priceRange;
  final List<Icon> ratingStars;

  const RecipeScreen(
      {super.key,
      required this.menu,
        required this.menuIndex,
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
        elevation: 10,
        // backgroundColor: kAppBackgroundColor,
        title: const Text("Menu Recipes"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Image(
                image: NetworkImage(widget.menu.menuUrl),
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
              const Text("Recipes under this menu are", style: TextStyle(fontWeight: FontWeight.bold),),
              widget.menu.recipeList.isEmpty? const Padding(
                padding: EdgeInsets.all(20.0),
                child: Image(image: AssetImage("assets/empty_data_icon.png"), fit: BoxFit.cover,),
              ) :
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RecipeCard(menuIndex: widget.menuIndex, menu: widget.menu),
              ),
              const SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}
