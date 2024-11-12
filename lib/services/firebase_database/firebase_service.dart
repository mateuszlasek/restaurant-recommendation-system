import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:proj_inz/firebase_options.dart';

import '../../models/user_form_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database;

  FirebaseService() : _database = FirebaseDatabase.instance;

  Future<void> submitUserForm(UserFormModel userForm) async {
    try {
      String? uid = await getUserUID();
      if (uid != null) {
        DatabaseReference ref = _database.ref('user_forms/$uid');
        await ref.set(userForm.toMap());
        print('Data submitted successfully for user UID: $uid');
      } else {
        print('Error: No user UID available');
      }
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  Future<String?> getUserUID() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      print("No user is logged in");
      return null;
    }
  }

  Future<UserFormModel?> getUserFormByUID(String uid) async {
    try {
      DatabaseReference ref = _database.ref('user_forms/$uid');
      DatabaseEvent event = await ref.once();
      if (event.snapshot.exists) {
        Map<String, dynamic> data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return UserFormModel.fromMap(data);
      } else {
        print('No data found for UID: $uid');
        return null;
      }
    } catch (e) {
      print('Error fetching data for UID $uid: $e');
      return null;
    }
  }

  Future<void> deleteUserFormByUID(String uid) async {
    try {
      DatabaseReference ref = _database.ref('user_forms/$uid');
      await ref.remove();
      print('Data deleted successfully for UID: $uid');
    } catch (e) {
      print('Error deleting data for UID $uid: $e');
    }
  }
}