
class Menu{
  late String id;
  late String title;
  // late String email;
  late int menuRating;
  late String menuUrl;
  late List<dynamic> recipeList;

  //Calculation of Menu prices based on data
  int rating = 0;
  double averageRating = 0;
  double minimum = 0;
  double maximum = 0;
  int numberSold = 0;

  void clear() {
    rating = 0;
    averageRating = 0;
    minimum = 0;
    maximum = 0;
    numberSold = 0;
  }
  
  Menu({
    required this.menuUrl,
    required this.title,
    // required this.email,
    required this.recipeList,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
      menuUrl: json['menuUrl'],
      title: json['title'],
      // email: json['email'],
      recipeList: json['recipeList']
  );

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = {
      'menuUrl': menuUrl,
      'title' : title,
      // 'email' : email,
      'recipeList' : recipeList,
    };

    return data;
  }
  void computeRequiredCalculation(){
    // clear();
    if(recipeList.isNotEmpty){
      //Display the minimum and maximum delivery price of recipe
      minimum = recipeList[0]['deliveryPrice'] as double;
      maximum = minimum;
      //Calculate average rating on the recipes of menu
      for(int i =0; i < recipeList.length;i++){
        //for rating
        rating += recipeList[i]['rating'] as int;
        //for delivery price
        final deliveryPrice = recipeList[i]['deliveryPrice'] as double;
        if(minimum > deliveryPrice){
          minimum = deliveryPrice;
        }
        if(maximum < deliveryPrice){
          maximum = deliveryPrice;
        }
        //for sold items
        numberSold += recipeList[i]['numberSold'] as int;
      }
      averageRating = rating/recipeList.length;

    }
  }
}