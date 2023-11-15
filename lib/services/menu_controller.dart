import 'package:flutter/material.dart';

import '../handlers/MenuHandler.dart';
import '../structure/Menu.dart';

class MenuControllerProvider extends ChangeNotifier{
  final menuHandler = MenuHandler();

  List<Menu> menuList = [];

  MenuControllerProvider(){
    menusFromHandler();
  }

  Future<void> menusFromHandler()async{
    menuList = await menuHandler.getAll();
    notifyListeners();
  }

  void clearForDispose(){
    menuList.clear();
    notifyListeners();
  }
  bool removeTaskFromList(Menu menu){
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
}