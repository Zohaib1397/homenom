
import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';
import 'package:homenom/screens/cart_screen.dart';
import 'package:homenom/services/menu_controller.dart';
import 'package:provider/provider.dart';

import '../services/Utils.dart';
import '../structure/Menu.dart';

class OrderScreen extends StatefulWidget {
  final Menu menu;
  final dynamic recipe;
  const OrderScreen({super.key, required this.recipe, required this.menu});

  static const String id = "Order_Screen";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int numberOfItems = 1;
  List<Icon> ratingStars = [];

  @override
  void initState() {
    super.initState();
    int rating = widget.recipe['rating'];
    for (int i = 0; i < 5; i++) {
      if (i + 1 <= rating) {
        ratingStars.add(
          const Icon(
            Icons.star,
            size: kRatingStarIconSize,
          ),
        );
      } else if (i + 1 > rating && i < rating) {
        ratingStars.add(const Icon(
          Icons.star_half_outlined,
          size: kRatingStarIconSize,
        ));
      } else {
        ratingStars.add(
          const Icon(
            Icons.star_border_outlined,
            size: kRatingStarIconSize,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text(widget.menu.title),
        actions: [
          IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartScreen())))
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Image(
              image: AssetImage("assets/temporary/food_background.jpg"),
              fit: BoxFit.contain,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.recipe['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: ratingStars
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Description",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(widget.recipe['description'],
                          textAlign: TextAlign.justify,),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customOrderCounter(
                          onDecrement: () {
                            setState(() {
                              if (numberOfItems != 1) {
                                numberOfItems -= 1;
                              }
                            });
                          },
                          onIncrement: () {
                            setState(() {
                              if (numberOfItems != widget.recipe['quantity']) {
                                numberOfItems += 1;
                              }
                            });
                          },
                          orderCount: numberOfItems),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Price: ${widget.recipe['price']} Rs"),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(kDefaultBorderRadius)),
                  color: kAppBackgroundColor,
                  onPressed: () async {
                    widget.recipe['currentOrder'] = numberOfItems;
                      Provider.of<MenuControllerProvider>(context, listen: false).addItemToCart(widget.recipe);
                      Utils.showPopup(context, "Success", "Item added to cart successfully");
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget customOrderCounter({
  required int orderCount,
  required Function() onDecrement,
  required Function() onIncrement,
}) {
  return SizedBox(
    child: Row(
      children: [
        MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius)),
          onPressed: onDecrement,
          minWidth: 10,
          color: kAppBackgroundColor,
          child: const Text(
            "-",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Text("$orderCount"),
        const SizedBox(
          width: 20,
        ),
        MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius)),
          onPressed: onIncrement,
          minWidth: 10,
          color: kAppBackgroundColor,
          child: const Text(
            "+",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ),
  );
}
