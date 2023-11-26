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
    collection = _firestore.collection("Data").doc(_auth.currentUser!.email);
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

  Future<bool> deleteRecipe(recipe) async{
    try{
      String menuID = recipe.menuID;
      DocumentReference menuRef = collection.collection("Menu").doc(menuID);
      var data = (await menuRef.get()).data() as Map<String, dynamic>?;

      List<dynamic> currentRecipeList = data?['recipeList'] as List<dynamic>;

      // Add the new recipe to the list
      currentRecipeList.remove(recipe.toJson());
      await menuRef.update({'recipeList': currentRecipeList});
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }

  Future<bool> createRecipe(recipe) async {
    try{
      String menuID = recipe.menuID;
      DocumentReference menuRef = collection.collection("Menu").doc(menuID);
      var data = (await menuRef.get()).data() as Map<String, dynamic>?;

      List<dynamic> currentRecipeList = data?['recipeList'] as List<dynamic>;

      // Add the new recipe to the list
      currentRecipeList.add(recipe.toJson());
      await menuRef.update({'recipeList': currentRecipeList});
      return true;
    }catch(e){
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
    print("Getting Data");
    Completer<List<Menu>> completer = Completer();
    bool completerCompleted = false;
    collection.collection('Menu').snapshots().listen((snapshot) {
      print("Hearing snapshots");
      List<Menu> menuList = [];
      final list = snapshot.docs;
      for (final menu in list) {
        final title = menu.data()['title'];
        final id = menu.id;
        final url = menu.data()['menuUrl'];
        print(title);
        final recipeList = menu.data()['recipeList'];

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
