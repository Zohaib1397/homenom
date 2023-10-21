import 'package:flutter/material.dart';

import '../../constants/constants.dart';



class MenuCard extends StatelessWidget {
  final AssetImage menuImage;
  final String menuName;
  final double deliveryPrice;
  const MenuCard({super.key, required this.menuImage, required this.menuName, required this.deliveryPrice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Menu Opened")));
        },
        child: Material(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          elevation: 10,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                child: Image(
                  image: menuImage,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text("Name: ", style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(menuName),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Delivery: ", style: TextStyle(fontWeight: FontWeight.bold),),
                              Text('$deliveryPrice Rs'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
