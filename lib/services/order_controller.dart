import 'package:flutter/cupertino.dart';

import '../handlers/OrderHandler.dart';
import '../structure/Order.dart';

class OrderControllerProvider extends ChangeNotifier {
  final orderHandler = OrderHandler();
  List<Order> orderList = [];
  List<Order> respectiveOrders = []; //Also the order history
  List<Order> sellerOrderHistory = []; //Order history for seller
  List<Order> pendingOrders = []; //pendingOrders
  List<Order> approvedOrders = []; //Approved order list
  List<Order> sellerOrdersByStatus = [];
  List<Order> readyToDeliverOrders = [];

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
      await orderHandler.create(order.toJson());
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

  Future<void> getSellerOrdersByStatus(String status) async {
    sellerOrdersByStatus = await orderHandler.search(status);
    notifyListeners();
  }

  Future<void> getSellerPendingOrders() async {
    pendingOrders = await orderHandler.search("Pending");
    notifyListeners();
  }
  Future<void> getSellerApprovedOrders() async {
    approvedOrders = await orderHandler.search("Approved");
    notifyListeners();
  }
  Future<void> getReadyToDeliverOrders() async {
    readyToDeliverOrders = await orderHandler.searchForDriver("Ready-To-Deliver");
    notifyListeners();
  }

}
