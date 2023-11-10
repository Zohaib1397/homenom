import 'Recipe.dart';

class Menu{
  late String title;
  late int menuRating;
  late String menuUrl;
  late List<Recipe> recipeList;
  
  Menu({
    required this.menuUrl,
    required this.title,
    required this.menuRating,
    required this.recipeList,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
      menuUrl: json['menuUrl'],
      title: json['title'],
      menuRating: json['menuRating'],
      recipeList: json['recipeList']
  );

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = {
      'menuUrl': menuUrl,
      'title' : title,
      'menuRating' : menuRating,
      'recipeList' : recipeList,
    };

    return data;
  }
}