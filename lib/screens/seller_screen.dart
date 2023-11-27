import 'package:flutter/material.dart';
import 'package:homenom/screens/widgets/menu_card.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../services/menu_controller.dart';
import '../services/recipe_card_brain.dart';
import '../structure/Menu.dart';

class SellerView extends StatelessWidget {
  SellerView({
    super.key,
  });

  final menuController = MenuControllerProvider();
  final calculate = Calculations();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Consumer<MenuControllerProvider>(
            builder: (context, menuControllerProvider, _) {
              List<Menu> menuList = menuControllerProvider.menuList;
              return Column(
                children: List.generate(menuList.length, (index){
                  menuList[index].computeRequiredCalculation();
                  return Dismissible(
                    key: UniqueKey(), //Getting a unique key
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (DismissDirection direction) async {
                      final confirmDismiss =  await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text("Are you sure you want to dismiss this Menu?. All recipes will be removed."),
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
                        Provider.of<MenuControllerProvider>(context, listen: false).removeMenuFromList(menuList[index]);
                      }
                    },
                    background: buildSwipingContainer(
                        Colors.red, "Delete", Icons.delete, Alignment.centerRight),
                    child: MenuCard(
                      menu: menuList[index],
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

}
