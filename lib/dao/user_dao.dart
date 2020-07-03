import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDAO {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  FirebaseUser user;

  // create user collection
  Future<bool> createUserCollection(String username, String email) async {
    if (_auth.currentUser() != null) {
      user = await _auth.currentUser();

      try {
        await _firestore.collection('users').document(user.uid).setData({
          'uid': user.uid,
          'username': username,
          'email': email,
        });

        return true;
      } catch (e) {
        print(e);

        return false;
      }
    } else {
      return false;
    }
  }

  Future<String> getUsername() async {
    if (_auth.currentUser() != null) {
      user = await _auth.currentUser();

      String username;

      await _firestore
          .collection('users')
          .document(user.uid)
          .get()
          .then((DocumentSnapshot ds) {
        if (ds.exists) {
          username = ds.data['username'];
        } else {
          username = null;
        }
      });

      return username;
    } else {
      return null;
    }
  }
}
