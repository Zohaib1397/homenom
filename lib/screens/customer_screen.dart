import 'package:flutter/material.dart';
import 'package:homenom/screens/widgets/menu_card.dart';
import 'package:provider/provider.dart';

import '../services/menu_controller.dart';
import '../structure/Menu.dart';


class CustomerView extends StatelessWidget {
  const CustomerView({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Consumer<MenuControllerProvider>(builder: (context, menuControllerProvider, _){
            List<Menu> menuList = menuControllerProvider.customerMenus;
            return Column(
              children: List.generate(menuList.length, (index){
                menuList[index].computeRequiredCalculation();
                return MenuCard(
                  menu: menuList[index],
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}
