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
      await collection.doc().set(order.toJson());
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> delete(order) async {
    try {
      await collection.doc(order.id).delete();
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

  Future<List<order.Order>> getHistory() async{
    List<order.Order> orderList = [];
    await collection.get().then((value) {
      value.docs.forEach((element) {
        order.Order currentOrder = order.Order.fromJson(element.data());
        currentOrder.orderId = element.id;
        if (auth.currentUser!.email == currentOrder.customer.email) {
          orderList.add(currentOrder);
        }
      });
    });
    return orderList;
  }

  @override
  Future<List> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future search(String orderId) {
    // TODO: implement search
    throw UnimplementedError();
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