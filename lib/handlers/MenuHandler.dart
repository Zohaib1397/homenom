import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homenom/structure/Database/ItemDAO.dart';

import '../structure/Menu.dart';
import 'package:collection/collection.dart';

class MenuHandler implements ItemDAO {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late dynamic collection;

  MenuHandler() {
    collection = _firestore.collection('Menus');
  }

  @override
  Future<bool> create(item) async {
    try {
      await collection.doc().set(item.toJson());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> delete(item) async {
    try {
      await collection.doc(item.id).delete();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deleteRecipe(recipe) async {
    try {
      String menuID = recipe.menuID;
      print(menuID);
      DocumentReference menuRef = collection.doc(menuID);
      var data = (await menuRef.get()).data() as Map<String, dynamic>?;

      List<dynamic> currentRecipeList = data?['recipeList'] as List<dynamic>;
      currentRecipeList.removeWhere((item) {
        return const MapEquality().equals(item, recipe.toJson());
      });
      await menuRef.update({'recipeList': currentRecipeList});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }



  Future<bool> updateRecipe(recipe, newRecipe) async {
    try {
      String menuID = newRecipe.menuID;
      DocumentReference menuRef = collection.doc(menuID);
      var data = (await menuRef.get()).data() as Map<String, dynamic>?;

      List<dynamic> currentRecipeList = data?['recipeList'] as List<dynamic>;
      currentRecipeList.removeWhere((item) {
        return const MapEquality().equals(item, recipe.toJson());
      });
      // Add the new recipe to the list
      currentRecipeList.add(newRecipe.toJson());
      await menuRef.update({'recipeList': currentRecipeList});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> createRecipe(recipe) async {
    try {
      String menuID = recipe.menuID;
      DocumentReference menuRef = collection.doc(menuID);
      var data = (await menuRef.get()).data() as Map<String, dynamic>?;

      List<dynamic> currentRecipeList = data?['recipeList'] as List<dynamic>;

      // Add the new recipe to the list
      currentRecipeList.add(recipe.toJson());
      await menuRef.update({'recipeList': currentRecipeList});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<Menu>> getRespectiveMenus() async {
    List<Menu> menuList = [];
    await collection.get().then((value) {
      value.docs.forEach((element) {
        Menu menu = Menu.fromJson(element.data());
        menu.id = element.id;
        if (_auth.currentUser!.email == menu.email) {
          menuList.add(menu);
        }
      });
    });
    return menuList;
  }

  @override
  bool deleteItemAtIndex(int index) {
    // TODO: implement deleteItemAtIndex
    throw UnimplementedError();
  }

  @override
  Future<List<Menu>> getAll() async {
    List<Menu> menuList = [];

    await FirebaseFirestore.instance.collection("Menus").get().then(
      (value) {
        for (var element in value.docs) {
          Menu menu = Menu.fromJson(element.data());
          menu.id = element.id;
          menuList.add(menu);
        }
      },
    );

    return menuList;
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

  Future<bool> updateSold(recipe, sold) async {
    try {
      String menuID = recipe.menuID;
      DocumentReference menuRef = collection.doc(menuID);
      var data = (await menuRef.get()).data() as Map<String, dynamic>?;

      List<dynamic> currentRecipeList = data?['recipeList'] as List<dynamic>;
      var updatedRecipe = recipe.toJson();

      for (int i = 0; i < currentRecipeList.length; i++) {
        if (currentRecipeList[i]['id'] == updatedRecipe['id']) {
          int previousSold = currentRecipeList[i]['numberSold'] ?? 0;

          currentRecipeList[i]['numberSold'] = previousSold + sold;
          break;
        }
      }

      await menuRef.update({'recipeList': currentRecipeList});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateRecipeRating(recipe, newRating) async {
    try {
      String menuID = recipe.menuID;
      DocumentReference menuRef = collection.doc(menuID);
      var data = (await menuRef.get()).data() as Map<String, dynamic>?;

      List<dynamic> currentRecipeList = data?['recipeList'] as List<dynamic>;
      var updatedRecipe = recipe.toJson();

      for (int i = 0; i < currentRecipeList.length; i++) {
        if (currentRecipeList[i]['id'] == updatedRecipe['id']) {
          double rating = (currentRecipeList[i]['rating'] ?? 0).toDouble();
          if(rating != 0.0) {
            currentRecipeList[i]['rating'] = (rating + newRating) / 2;
          }else{
            currentRecipeList[i]['rating'] = newRating;
          }
          int previousSold = currentRecipeList[i]['numberSold'] ?? 0;

          currentRecipeList[i]['numberSold'] = previousSold + 1;
          break;
        }
      }

      await menuRef.update({'recipeList': currentRecipeList});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
  Future<Menu?> getMenu(String menuID) async {
    try {
      DocumentSnapshot menuSnapshot = await collection.doc(menuID).get();
      if (menuSnapshot.exists) {
        Menu menu = Menu.fromJson(menuSnapshot.data() as Map<String, dynamic>);
        menu.id = menuSnapshot.id;
        return menu;
      } else {
        print("Menu with ID $menuID not found");
        return null;
      }
    } catch (e) {
      print("Error getting menu: $e");
      return null;
    }
  }
}
