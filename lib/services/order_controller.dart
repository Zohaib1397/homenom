import 'package:flutter/cupertino.dart';

import '../handlers/OrderHandler.dart';
import '../structure/Order.dart';

class OrderControllerProvider extends ChangeNotifier{
  final orderHandler = OrderHandler();
  List<Order> orderList = [];
}