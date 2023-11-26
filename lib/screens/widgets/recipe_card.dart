import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../services/menu_controller.dart';
import '../../structure/Recipe.dart';

class RecipeCard extends StatelessWidget {
  final List<dynamic> recipeList;
  final void Function() onPressed;
  const RecipeCard({super.key,required this.recipeList, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(recipeList.length, (index){
        return Dismissible(
          key: Key(recipeList.toString()),
          direction: DismissDirection.endToStart,
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
              Colors.red, "Delete", Icons.delete, Alignment.centerRight),
          child: Card(
            child: ListTile(
              onTap: onPressed,
              title: Text(recipeList[index]['name'], style: const TextStyle(fontWeight: FontWeight.bold),),
              isThreeLine: true,
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description: ${recipeList[index]['description']}"),
                  Text("Price: ${recipeList[index]['price']}"),
                  Text("Sold: ${recipeList[index]['numberSold']}"),
                ],
              ),
              trailing: Image(image: AssetImage("assets/temporary/food_background.jpg"), fit: BoxFit.contain,),

            ),
          ),
        );
      }),
    );
  }
}
