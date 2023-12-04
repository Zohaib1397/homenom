import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homenom/structure/Database/ItemDAO.dart';

import '../structure/Role.dart';

class UserHandler implements ItemDAO{
  
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  late dynamic collection;
  
  UserHandler(){
    collection = _fireStore.collection("Users").doc(_auth.currentUser!.email);
  }
  
  @override
  Future<bool> create(user) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(user) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  bool deleteItemAtIndex(int index) {
    // TODO: implement deleteItemAtIndex
    throw UnimplementedError();
  }

  @override
  Future<List> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future search(String name) {
    // TODO: implement search
    throw UnimplementedError();
  }

  @override
  bool searchItemAtIndex(int index) {
    // TODO: implement searchItemAtIndex
    throw UnimplementedError();
  }

  Future<bool> updateRole(ROLE role) async{
    try{
      await collection.update({'role': role.toString()});
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }

  Future<bool> updatePhoneNumber(String number) async{
    try{
      await collection.update({
        'phoneNum': number,
        'isPhoneVerified' : true
      });

      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }


  @override
  Future<bool> update(user) {
    // TODO: implement update
    throw UnimplementedError();
  }

}