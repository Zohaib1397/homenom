class Recipe {
  late String id;
  late String url;
  late String name;
  late String description;
  late double price;
  late double deliveryPrice;
  late double rating;
  late int quantity;
  late int numberSold;
  late String menuID;
  late int currentOrder;
  late String sellerEmail;

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
    required this.sellerEmail,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'],
    url: json['url'],
    name: json['name'],
    description: json['description'],
    price: (json['price'] as num).toDouble(),
    deliveryPrice: (json['deliveryPrice'] as num).toDouble(),
    rating: (json['rating'] as num).toDouble(),
    quantity: json['quantity'],
    menuID: json['menuID'],
    numberSold: json['numberSold'],
    sellerEmail: json['sellerEmail'],
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
      'sellerEmail' : sellerEmail
    };

    return data;
  }
}
