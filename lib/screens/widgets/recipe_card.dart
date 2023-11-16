import 'package:flutter/material.dart';

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
