import 'package:flutter/cupertino.dart';

import '../handlers/UserHandler.dart';
import '../structure/Role.dart';
import '../structure/User.dart';

class UserControllerProvider extends ChangeNotifier{
  final userHandler = UserHandler();

  Future<User?> getUser(String? email) async{
    return await userHandler.getUser(email);
  }
  Future<bool> updateLocation(double latitude, double longitude) async{
    try{
      await userHandler.updateLocation(latitude, longitude);
      return true;
    }catch(e){
      print("Error saving location: ${e.toString()}");
      return false;
    }
  }
  Future<bool> updateRole(ROLE role) async{
    var status = await userHandler.updateRole(role);
    notifyListeners();
    return status;
  }

  Future<bool> updatePhone(String phoneNum) async{
    var status = await userHandler.updatePhoneNumber(phoneNum);
    notifyListeners();
    return status;
  }
}