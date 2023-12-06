import 'package:homenom/structure/Order.dart' as order;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homenom/structure/Database/ItemDAO.dart';

class OrderHandler implements ItemDAO{

  final auth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance;
  late dynamic collection;

  OrderHandler(){
    collection = store.collection("Orders");
  }

  @override
  Future<bool> create(order) async {
    try{
      await collection.doc(order['orderId']).set(order);
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> delete(order) async {
    try {
      await collection.doc(order['orderId']).delete();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  bool deleteItemAtIndex(int index) {
    // TODO: implement deleteItemAtIndex
    throw UnimplementedError();
  }

  //Order history for customer account
  Future<List<order.Order>> getHistory() async{
    List<order.Order> orderList = [];
    await collection.get().then((value) {
      value.docs.forEach((element) {
        order.Order currentOrder = order.Order.fromJson(element.data());
        currentOrder.orderId = element.id;
        if (auth.currentUser!.email == currentOrder.customer?.email) {
          orderList.add(currentOrder);
        }
      });
    });
    return orderList;
  }

  // //Order history for seller account
  // Future<List<order.Order>> getSellerHistory() async{
  //   List<order.Order> orderList = [];
  //   await collection.get().then((value) {
  //     value.docs.forEach((element) {
  //       order.Order currentOrder = order.Order.fromJson(element.data());
  //       currentOrder.orderId = element.id;
  //       if (auth.currentUser!.email == currentOrder.menu.email) {
  //         orderList.add(currentOrder);
  //       }
  //     });
  //   });
  //   return orderList;
  // }

  Future<bool> updateOrderStatus(order, String status) async{
    try{
      //Update the order status
      await collection.doc(order['orderId']).update({'status': status});
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }

  @override
  Future<List> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  //Search orders based on status
  @override
  Future<List<order.Order>> search(String status) async {
    List<order.Order> orderList = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection.get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> element in querySnapshot.docs) {
      order.Order currentOrder = order.Order.fromJson(element.data());
      currentOrder.orderId = element.id;
      //TODO implement logic to get the email from the menu
      if (status == currentOrder.status) {
        orderList.add(currentOrder);
      }
    }
    return orderList;
  }

  @override
  bool searchItemAtIndex(int index) {
    // TODO: implement searchItemAtIndex
    throw UnimplementedError();
  }

  @override
  Future<bool> update(order) {
    // TODO: implement update
    throw UnimplementedError();
  }

}