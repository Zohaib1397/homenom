class Recipe {
  late String id;
  late String url;
  late String name;
  late String description;
  late double price;
  late double deliveryPrice;
  late int rating;
  late int quantity;
  late int numberSold;
  late String menuID;
  late int currentOrder;

  Recipe({
    required this.id,
    required this.url,
    required this.name,
    required this.description,
    required this.price,
    required this.deliveryPrice,
    required this.rating,
    required this.quantity,
    required this.menuID,
    required this.numberSold,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'],
    url: json['url'],
    name: json['name'],
    description: json['description'],
    price: json['price'],
    deliveryPrice: json['deliveryPrice'],
    rating: json['rating'],
    quantity: json['quantity'],
    menuID: json['menuID'],
    numberSold: json['numberSold'],
  );

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = {
      'id' : id,
      'url': url,
      'name' : name,
      'description' : description,
      'price' : price,
      'deliveryPrice' : deliveryPrice,
      'rating' : rating,
      'quantity' : quantity,
      'menuID' : menuID,
      'numberSold' : numberSold,
    };

    return data;
  }
}
