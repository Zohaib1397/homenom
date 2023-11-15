import 'DAO.dart';

abstract class ItemDAO<T> extends DAO<T>{
  bool deleteItemAtIndex(int index);
  bool searchItemAtIndex(int index);
}