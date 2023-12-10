
import 'Recipe.dart';

class Menu{
  late String id;
  late String title;
  late String email;
  late int menuRating;
  late String menuUrl;
  late List<dynamic> recipeList;

  //Calculation of Menu prices based on data
  double rating = 0.0;
  double averageRating = 0.0;
  double minimum = 0.0;
  double maximum = 0.0;
  int numberSold = 0;

  void clear() {
    rating = 0.0;
    averageRating = 0.0;
    minimum = 0.0;
    maximum = 0.0;
    numberSold = 0;
  }
  
  Menu({
    required this.menuUrl,
    required this.title,
    required this.email,
    required this.recipeList,
    required this.menuRating,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
      menuUrl: json['menuUrl'],
      title: json['title'],
      email: json['email'],
      recipeList:  json['recipeList'],
      menuRating: json['menuRating'],
  );

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = {
      'menuUrl': menuUrl,
      'title' : title,
      'email' : email,
      'recipeList' : recipeList,
      'menuRating':menuRating
    };

    return data;
  }
  void computeRequiredCalculation() {
    clear();
    if (recipeList.isNotEmpty) {
      final list = recipeList.map((recipeJson) => Recipe.fromJson(recipeJson)).toList();
      // Display the minimum and maximum delivery price of recipe
      minimum = list[0].deliveryPrice;
      maximum = minimum;

      // Calculate average rating on the recipes of menu
      for (int i = 0; i < list.length; i++) {
        // For rating
        rating += list[i].rating;

        // For delivery price
        final deliveryPrice = list[i].deliveryPrice;
        if (minimum > deliveryPrice) {
          minimum = deliveryPrice;
        }
        if (maximum < deliveryPrice) {
          maximum = deliveryPrice;
        }

        // For sold items
        numberSold += list[i].numberSold;
      }

      // Avoid division by zero
      averageRating = list.length > 0 ? rating / list.length : 0.0;
    }
  }
}