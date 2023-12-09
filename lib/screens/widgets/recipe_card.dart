import 'package:flutter/material.dart';
import 'package:homenom/screens/add_recipe_screen.dart';
import 'package:homenom/screens/widgets/build_cache_image.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../services/menu_controller.dart';
import '../../structure/Menu.dart';
import '../../structure/Recipe.dart';
import '../../structure/Role.dart';
import '../order_screen.dart';
class RecipeCard extends StatefulWidget {
  final Menu menu;
  final int menuIndex;
  const RecipeCard({super.key, required this.menu, required this.menuIndex});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  List<bool> isRecipeExpanded = [];

  @override
  void initState() {
    super.initState();
    isRecipeExpanded = List.generate(widget.menu.recipeList.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuControllerProvider>(
      builder: (context, menuProvider, _) {
        List<Menu> menuList = currentRole == ROLE.SELLER? menuProvider.menuList : menuProvider.customerMenus;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(menuList[widget.menuIndex].recipeList.length, (index) {
            return Dismissible(
              key: UniqueKey(),
              direction: currentRole == ROLE.SELLER
                  ? DismissDirection.endToStart
                  : DismissDirection.none,
              confirmDismiss: (DismissDirection direction) async {
                final confirmDismiss = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm"),
                      content: const Text("Are you sure you want to delete this Recipe?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  },
                );
                if (confirmDismiss) {
                  await menuProvider.removeRecipeFromList(
                    Recipe.fromJson(menuList[widget.menuIndex].recipeList[index]),
                    widget.menuIndex,
                    index,
                  );
                  setState((){});
                }
                return;
              },
              background: buildSwipingContainer(
                currentRole == ROLE.SELLER ? Colors.red : Colors.transparent,
                "Delete",
                Icons.delete,
                Alignment.centerRight,
              ),
              child: Card(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  child: ListTile(
                    onTap: () {
                      print("Recipe Index chosen: $index");
                      setState(() {
                        currentRole != ROLE.SELLER
                            ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderScreen(
                              menu: widget.menu,
                              recipe: menuList[widget.menuIndex].recipeList[index],
                            ),
                          ),
                        )
                            : isRecipeExpanded[index] = !isRecipeExpanded[index];
                      });
                    },
                    title: Text(
                      menuList[widget.menuIndex].recipeList[index]['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    isThreeLine: true,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Description: ${menuList[widget.menuIndex].recipeList[index]['description']}"),
                        Text("Price: ${menuList[widget.menuIndex].recipeList[index]['price']}"),
                        Text("Sold: ${menuList[widget.menuIndex].recipeList[index]['numberSold']}"),
                        isRecipeExpanded[index]
                            ? Row(
                          children: [
                            IconButton.filled(
                              onPressed: () {
                                print("Edit Recipe at: $index");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddRecipeScreen(
                                      index: index,
                                      recipe: menuList[widget.menuIndex].recipeList[index],
                                      menuIndex: widget.menuIndex,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.edit_outlined,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        )
                            : Container(),
                      ],
                    ),
                    trailing: generateCachedImage(url: menuList[widget.menuIndex].recipeList[index]['url'], clip: 12),
                    // trailing: ClipRRect(
                    //   borderRadius: BorderRadius.circular(12),
                    //   child: Image(
                    //     image: NetworkImage(menuList[widget.menuIndex].recipeList[index]['url']),
                    //     fit: BoxFit.contain,
                    //   ),
                    // ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
