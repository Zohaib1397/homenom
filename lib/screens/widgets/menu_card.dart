import 'package:flutter/material.dart';
import 'package:homenom/screens/recipe_screen.dart';
import 'package:homenom/screens/widgets/build_cache_image.dart';

import '../../constants/constants.dart';
import '../../structure/Menu.dart';
import '../../structure/Role.dart';

class MenuCard extends StatefulWidget {
  final Menu menu;
  final int menuIndex;

  const MenuCard({super.key, required this.menu, required this.menuIndex});

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
      } else if (i + 1 > widget.menu.averageRating &&
          i < widget.menu.averageRating) {
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
                        menuIndex: widget.menuIndex,
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
              generateCachedImage(url: widget.menu.menuUrl, clip: kDefaultBorderRadius, height: 250),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(kDefaultBorderRadius),
              //   child: Image(
              //     // image: widget.menuImage,
              //     image: NetworkImage(widget.menu.menuUrl),
              //     // image: AssetImage("assets/temporary/food_background.jpg"),
              //     fit: BoxFit.cover,
              //   ),
              // ),
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
                      subtitle: currentRole == ROLE.CUSTOMER
                          ? buildRelevantRow(
                              "Delivery: ",
                              '$deliveryPriceRange Rs',
                            )
                          : buildRelevantRow(
                        "Total Recipes: ",
                        '${widget.menu.recipeList.length}'
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

  Row buildRelevantRow(
    String title,
    String content,
  ) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(content),
      ],
    );
  }
}
