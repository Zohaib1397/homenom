import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../services/menu_controller.dart';
import '../../structure/Menu.dart';
import '../../structure/Recipe.dart';
import '../../structure/Role.dart';
import '../order_screen.dart';

class RecipeCard extends StatelessWidget {
  final Menu menu;
  const RecipeCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(menu.recipeList.length, (index){
        return Dismissible(
          key: Key(menu.recipeList.toString()),
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
            child: ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderScreen(
                  menu: menu,
                  recipe: menu.recipeList[index]
                )));
              },
              title: Text(menu.recipeList[index]['name'], style: const TextStyle(fontWeight: FontWeight.bold),),
              isThreeLine: true,
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description: ${menu.recipeList[index]['description']}"),
                  Text("Price: ${menu.recipeList[index]['price']}"),
                  Text("Sold: ${menu.recipeList[index]['numberSold']}"),
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
