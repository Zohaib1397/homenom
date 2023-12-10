import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homenom/structure/Database/ItemDAO.dart';
import 'package:homenom/structure/User.dart' as user;
import '../structure/Role.dart';

class UserHandler implements ItemDAO {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  late dynamic collection;

  UserHandler() {
    collection = _fireStore.collection("Users");
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

  Future<bool> updateLocation(double latitude, double longitude) async {
    try {
      await collection
          .doc(_auth.currentUser!.email)
          .update({'latitude': latitude, 'longitude': longitude});
      return true;
    } catch (e) {
      print("Error in database while updating location: ${e.toString()}");
      return false;
    }
  }

  Future<user.User?> getUser(String? email) async {
    try {
      late DocumentSnapshot userSnapshot;
      if (email != null) {
        userSnapshot = await collection.doc(email).get();
      } else {
        userSnapshot = await collection.get();
      }
      if (userSnapshot.exists) {
        user.User currentUser =
            user.User.fromJson(userSnapshot.data() as Map<String, dynamic>);
        return currentUser;
      } else {
        print("User document does not exist");
        return null;
      }
    } catch (e) {
      print("Error getting user: $e");
      return null;
    }
  }
  Future<bool> updateUserRating(String email, double newRating) async {
    try {
      DocumentSnapshot userSnapshot = await collection.doc(email).get();

      if (userSnapshot.exists) {
        double currentRating = (userSnapshot['rating'] ?? 0).toDouble();
        double updatedRating = ((currentRating + newRating)/ 2).toDouble();
        await collection.doc(email).update({'rating': updatedRating});
        return true;
      } else {
        print("User document does not exist");
        return false;
      }
    } catch (e) {
      print("Error in database while updating user's rating: ${e.toString()}");
      return false;
    }
  }
  Future<bool> updateRole(ROLE role) async {
    try {
      await collection
          .doc(_auth.currentUser!.email)
          .update({'role': role.toString()});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updatePhoneNumber(String number) async {
    try {
      await collection
          .doc(_auth.currentUser!.email)
          .update({'phoneNum': number, 'isPhoneVerified': true});

      return true;
    } catch (e) {
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
