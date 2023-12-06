import 'package:flutter/cupertino.dart';

import '../handlers/OrderHandler.dart';
import '../structure/Order.dart';

class OrderControllerProvider extends ChangeNotifier {
  final orderHandler = OrderHandler();
  List<Order> orderList = [];
  List<Order> respectiveOrders = []; //Also the order history
  List<Order> sellerOrderHistory = []; //Order history for seller
  List<Order> pendingOrders = []; //pendingOrders

  OrderControllerProvider() {
    loadRespectiveOrders();
  }

  Future<void> loadRespectiveOrders() async {
    respectiveOrders = await orderHandler.getHistory();
    notifyListeners();
    // sellerOrderHistory = await orderHandler.getSellerHistory();
    // notifyListeners();
  }

  Future<bool> createOrder(Order order) async {
    //create order by customer
    try {
      print("Creating Order");
      await orderHandler.create(order.toJson());
      print("Order saved");
      respectiveOrders.add(order);
      notifyListeners();
      return true;
    } catch (e) {
      print("Error creating order: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateOrderStatus(Order order, String status) async {
    try{
      await orderHandler.updateOrderStatus(order.toJson(),status);
      loadRespectiveOrders();
      notifyListeners();
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }

  Future<void> getSellerPendingOrders() async {
    pendingOrders = await orderHandler.search("Pending");
  }

}
