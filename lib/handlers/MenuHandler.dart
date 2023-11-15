import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homenom/structure/Database/ItemDAO.dart';

import '../structure/Menu.dart';
import '../structure/Recipe.dart';

class MenuHandler implements ItemDAO {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late dynamic collection;

  MenuHandler() {
    collection = _firestore.collection("data").doc(_auth.currentUser!.email);
  }

  @override
  Future<bool> create(item) async {
    try {
      await collection.collection("Menu").add(item.toJson());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> delete(item) async {
    try {
      await collection.collection("Menu").doc(item.id).delete();
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

  @override
  Future<List<Menu>> getAll() {
    Completer<List<Menu>> completer = Completer();
    bool completerCompleted = false;
    collection.collection('Menu').snapshots().listen((snapshot) {
      List<Menu> menuList = [];
      final list = snapshot.docs;
      for (final menu in list) {
        final title = menu.data()['title'];
        final id = menu.id;
        final url = menu.data()['url'];
        print(title);
        final recipeList = menu.data()['recipeList'] as List<Recipe>;

        Menu temporaryMenu = Menu(
          menuUrl: url,
          title: title,
          recipeList: recipeList,
        );
        temporaryMenu.id = id;
        menuList.add(temporaryMenu);
      }
      if (!completerCompleted) {
        completer.complete(menuList);
        completerCompleted = true; // Mark the completer as completed
      }
    });
    return completer.future;
  }

  @override
  Future<Menu> search(String title) {
    // TODO: implement search
    throw UnimplementedError();
  }

  @override
  bool searchItemAtIndex(int index) {
    // TODO: implement searchItemAtIndex
    throw UnimplementedError();
  }

  @override
  Future<bool> update(item) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
