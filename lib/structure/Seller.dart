import 'User.dart';


class Seller extends User{
  late String CNIC;

  Seller(this.CNIC) : super.name('', '', '', '', '');
}