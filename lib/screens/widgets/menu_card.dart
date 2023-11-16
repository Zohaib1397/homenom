import 'package:flutter/material.dart';
import 'package:homenom/screens/recipe_screen.dart';

import '../../constants/constants.dart';
import '../../structure/Menu.dart';

class MenuCard extends StatefulWidget {
  final Menu menu;

  const MenuCard(
      {super.key,
      required this.menu});

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  List<Icon> ratingStars = [];
  String deliveryPriceRange = "";

  @override
  void initState() {
    super.initState();
    // The following loop checks for the rating of the seller in double
    // and fills the icon or half fill or add outlined icon accordingly
    deliveryPriceRange = "${widget.menu.minimum} - ${widget.menu.maximum}";
    for (int i = 0; i < 5; i++) {
      if (i + 1 <= widget.menu.averageRating) {
        ratingStars.add(
          const Icon(
            Icons.star,
            size: kRatingStarIconSize,
          ),
        );
      } else if (i + 1 > widget.menu.averageRating && i < widget.menu.averageRating) {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipeScreen(
                        menu: widget.menu,
                        priceRange: deliveryPriceRange,
                        ratingStars: ratingStars,
                      )));
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
                  // image: widget.menuImage,
                  image: AssetImage("assets/temporary/food_background.jpg"),
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
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      title: Row(
                        children: [
                          const Text(
                            "Name: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.menu.title),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          const Text(
                            "Delivery: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('$deliveryPriceRange Rs'),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: ratingStars,
                            ),
                            Text(
                              "${widget.menu.numberSold} Sold",
                              style: const TextStyle(fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
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
