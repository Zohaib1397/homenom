class Recipe {
  late String id;
  late String url;
  late String name;
  late String description;
  late double price;
  late int rating;
  late int quantity;

  Recipe({
    required this.id,
    required this.url,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.quantity,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
      id: json['id'],
      url: json['url'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      rating: json['rating'],
      quantity: json['quantity']
  );

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = {
      'id' : id,
      'url': url,
      'name' : name,
      'description' : description,
      'price' : price,
      'rating' : rating,
      'quantity' : quantity,
    };

    return data;
  }
}
