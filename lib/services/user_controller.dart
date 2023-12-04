import 'package:flutter/cupertino.dart';

import '../handlers/UserHandler.dart';
import '../structure/Role.dart';

class UserControllerProvider extends ChangeNotifier{
  final userHandler = UserHandler();

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