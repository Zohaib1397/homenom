import 'package:flutter/material.dart';
import 'package:homenom/screens/seller_screen.dart';

import '../../constants/constants.dart';
import '../../structure/Role.dart';
import 'drawer_items.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onSignOut;
  final void Function()? onProfileOption;

  const MyDrawer({super.key, required this.onSignOut, this.onProfileOption});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  size: 64,
                ),
              ),
              DrawerItem(
                icon: Icons.home,
                text: "H O M E",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              DrawerItem(
                icon: Icons.person,
                text: "P R O F I L E",
                onTap: onProfileOption,
              ),
              DrawerItem(
                icon: Icons.history,
                text: "H I S T O R Y",
                onTap: (){},
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Column(
              children: [
                currentRole == ROLE.CUSTOMER ? DrawerItem(
                  icon: Icons.business,
                  text: "S E L L E R  A C C O U N T",
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SellerScreen())
                    );
                  },
                ) : DrawerItem(
                  icon: Icons.camera_front_outlined,
                  text: "C U S T O M E R  A C C O U N T",
                  onTap: (){},
                ),
                DrawerItem(
                  icon: Icons.logout,
                  text: "L O G O U T",
                  onTap: onSignOut,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
