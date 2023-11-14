import 'package:flutter/material.dart';
import 'package:homenom/screens/recipe_screen.dart';

import '../../constants/constants.dart';

class MenuCard extends StatefulWidget {
  final AssetImage menuImage;
  final String menuName;
  final double sellerRating;
  final int numberOfItemsSold;
  final String deliveryPrice;

  const MenuCard(
      {super.key,
      required this.menuImage,
      required this.menuName,
      required this.deliveryPrice,
      required this.sellerRating,
      required this.numberOfItemsSold});

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  List<Icon> ratingStars = [];

  @override
  void initState() {
    super.initState();
    // The following loop checks for the rating of the seller in double
    // and fills the icon or half fill or add outlined icon accordingly
    for (int i = 0; i < 5; i++) {
      if (i + 1 <= widget.sellerRating) {
        ratingStars.add(
          const Icon(
            Icons.star,
            size: kRatingStarIconSize,
          ),
        );
      }
      else if(i+1 > widget.sellerRating && i < widget.sellerRating){
        ratingStars.add(
          const Icon(
            Icons.star_half_outlined,
            size: kRatingStarIconSize,
          )
        );
      }
      else {
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RecipeScreen()));
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
                  image: widget.menuImage,
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
                          Text(widget.menuName),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          const Text(
                            "Delivery: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${widget.deliveryPrice} Rs'),
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
                              "${widget.numberOfItemsSold} Sold",
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
