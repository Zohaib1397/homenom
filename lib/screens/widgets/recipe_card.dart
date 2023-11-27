import 'package:flutter/material.dart';
import 'package:homenom/screens/add_recipe_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../services/menu_controller.dart';
import '../../structure/Menu.dart';
import '../../structure/Recipe.dart';
import '../../structure/Role.dart';
import '../order_screen.dart';

class RecipeCard extends StatefulWidget {
  final Menu menu;
  const RecipeCard({super.key, required this.menu});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(widget.menu.recipeList.length, (index){
        return Dismissible(
          key: Key(widget.menu.recipeList.toString()),
          direction: currentRole == ROLE.SELLER? DismissDirection.endToStart : DismissDirection.none,
          confirmDismiss: (DismissDirection direction) async {
            final confirmDismiss =  await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirm"),
                  content: const Text("Are you sure you want to dismiss this Recipe?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Dismiss"),
                    ),
                  ],
                );
              },
            );
            if(confirmDismiss){
              // Provider.of<MenuControllerProvider>(context, listen: false).removeMenuFromList(menuList[index]);
            }
          },
          background: buildSwipingContainer(
              currentRole == ROLE.SELLER? Colors.red: Colors.transparent, "Delete", Icons.delete, Alignment.centerRight),
          child: Card(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              child: ListTile(
                onTap: (){
                  setState(() {
                    currentRole != ROLE.SELLER? Navigator.push(context, MaterialPageRoute(builder: (context) => OrderScreen(
                        menu: widget.menu,
                        recipe: widget.menu.recipeList[index]
                    ))): isExpanded = !isExpanded;
                  });
                },
                title: Text(widget.menu.recipeList[index]['name'], style: const TextStyle(fontWeight: FontWeight.bold),),
                isThreeLine: true,
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description: ${widget.menu.recipeList[index]['description']}"),
                    Text("Price: ${widget.menu.recipeList[index]['price']}"),
                    Text("Sold: ${widget.menu.recipeList[index]['numberSold']}"),
                    isExpanded? Row(children: [
                      IconButton.filled(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddRecipeScreen(index: index, recipe: widget.menu.recipeList[index])));
                      }, icon: Icon(Icons.edit_outlined, color: Theme.of(context).colorScheme.onPrimary,)),
                    ],): Container(),
                  ],
                ),
                trailing: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image(image: AssetImage("assets/temporary/food_background.jpg"), fit: BoxFit.contain,)),

              ),
            ),
          ),
        );
      }),
    );
  }
}
