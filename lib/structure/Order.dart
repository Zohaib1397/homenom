import 'Recipe.dart';
// import 'Menu.dart';
import 'User.dart';

class Order {
  late String orderId;
  late User? customer;
  // late Menu menu;
  late List<Recipe> recipes;
  late DateTime orderDate;
  late double totalAmount;
  late String status;
  late String sellerEmail;

  Order({
    required this.orderId,
    required this.customer,
    // required this.menu,
    required this.recipes,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.sellerEmail,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      customer: User.fromJson(json['customer']),
      // menu: Menu.fromJson(json['menu']),
      recipes: (json['recipes'] as List<dynamic>)
          .map((recipeJson) => Recipe.fromJson(recipeJson))
          .toList(),
      orderDate: DateTime.parse(json['orderDate']),
      totalAmount: json['totalAmount'],
      status: json['status'],
      sellerEmail: json['sellerEmail'],
    );

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> order = {
      'orderId': orderId,
      'customer': customer?.toJson(),
      // 'menu': menu.toJson(),
      'recipes': recipes.map((recipe) => recipe.toJson()).toList(),
      'orderDate': orderDate.toIso8601String(),
      'totalAmount': totalAmount,
      'status': status,
      'sellerEmail': sellerEmail,
    };
    return order;
  }
}
