import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../handlers/MenuHandler.dart';
import '../structure/Menu.dart';
import '../structure/Recipe.dart';

class MenuControllerProvider extends ChangeNotifier{
  final menuHandler = MenuHandler();
  List<Menu> menuList = [];
  List<Menu> customerMenus = [];
  List<dynamic> cartList = [];

  MenuControllerProvider(){
    menusFromHandler();
  }

  void addItemToCart(dynamic item){
     cartList.add(item);
     notifyListeners();
     print(cartList);
  }
  void clearCart(){
    cartList.clear();
    notifyListeners();
  }


  Future<String> getMenuId(int index) async {
    print(menuList);
    menuList = [];
    await menusFromHandler();
    print(menuList);
    return menuList[index].id;
  }

  Future<void> menusFromHandler()async{
    //TODO This handler is needed to be adjusted
    menuList = await menuHandler.getAll();
    notifyListeners();
    customerMenus =await menuHandler.getAll();
    // await menuHandler.getEveryMenu();
    notifyListeners();
  }

  void clearForDispose(){
    menuList.clear();
    notifyListeners();
  }
  bool removeMenuFromList(Menu menu){
    try{
      menuHandler.delete(menu);
      menuList.remove(menu);
      notifyListeners();
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }
  bool addMenuToList(Menu menu){
    try{
      menuHandler.create(menu);
      menuList.add(menu);
      notifyListeners();
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }
  // Future<bool> removeRecipeFromList(Recipe recipe, int index) async{
  //   try{
  //     String recipeID = await get
  //     menuHandler.deleteRecipe(recipe);
  //     menuList.remove(menu);
  //     notifyListeners();
  //     return true;
  //   }catch(e){
  //     print(e.toString());
  //     return false;
  //   }
  // }
  Future<bool> addRecipeToMenu(Recipe recipe, int index) async {
    try{
      String menuID = await getMenuId(index);
      recipe.menuID = menuID;
      menuHandler.createRecipe(recipe);
      menuList[index].recipeList.add(recipe);
      notifyListeners();
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }

}