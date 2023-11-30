import 'package:flutter/material.dart';
import 'package:homenom/screens/Signup%20Screens/driver_signup_screen.dart';
import 'package:homenom/screens/Signup%20Screens/seller_signup_screen.dart';
import 'package:homenom/screens/Signup%20Screens/customer_signup_screen.dart';
import 'package:homenom/screens/widgets/drawer_items.dart';

import '../structure/Role.dart';

class AskRoleScreen extends StatelessWidget {
  const AskRoleScreen({super.key});

  static const String id = "Ask_Role_Screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Role Selection"),
      ),
      body: Column(
        children: [
          const Hero(
            tag: "homenom",
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: Image(
                image: AssetImage("assets/homenom.png"),
                height: 200,
              ),
            ),
          ),
          const Text(
            'Choose your role',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),
          const Text("I am a.."),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                buildExpandedCard(
                    AssetImage("assets/Seller.png"),
                    "Seller",
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SellerSignUpScreen()))),
                buildExpandedCard(
                    AssetImage("assets/Driver.png"), "Driver", () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DriverSignUpScreen()))),
                buildExpandedCard(
                  AssetImage("assets/Customer.png"),
                  "Customer",
                  () => Navigator.pushNamed(context, SignUpScreen.id),
                ),
              ],
            ),
          ),
        ],
        // SimpleDialogOption(
        //   onPressed: () {
        //     setState(() {
        //       currentRole = ROLE.CUSTOMER;
        //     });
        //     Provider.of<UserControllerProvider>(context, listen: false).updateRole(currentRole!);
        //   },
        //   child:const DrawerItem(
        //     icon: Icons.camera_front_outlined,
        //     text: "Customer Account",
        //     onTap: null,
        //   ),
        // ),
        // SimpleDialogOption(
        //   onPressed: () {
        //     setState(() {
        //       currentRole = ROLE.DRIVER;
        //     });
        //     Provider.of<UserControllerProvider>(context, listen: false).updateRole(currentRole!);
        //   },
        //   child: const DrawerItem(
        //     icon: Icons.pedal_bike,
        //     text: "Driver Account",
        //     onTap: null,
        //   ),
        // ),
      ),
    );
  }

  Expanded buildExpandedCard(
    AssetImage image,
    String text,
    Function() onPressed,
  ) {
    return Expanded(
      child: Card(
        child: MaterialButton(
          onPressed: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: image,
                height: 100,
              ),
              Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
