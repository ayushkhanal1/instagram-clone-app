import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaclone/models/user.dart' as model;
import 'package:instaclone/resources/storage_methods.dart';
class Authmethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<model.User> getuserdetails() async{
    User currentuser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentuser.uid).get();
    return model.User.fromsnapshot(snap);
  }
  Future<String> signupUser({
    required String email,
    required String Password,
    required String bio,
    required String username,
    required Uint8List file,
  }) async {
    String res = "some error occured!";
    try {
      if (email.isNotEmpty ||
          Password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: Password);
        print(cred.user!.uid);
        String photourl =
            await StorageMethods().uploadimage('ProfilePics', file, false);
        model.User uuser = model.User(
            email: email,
            photourl: photourl,
            bio: bio,
            username: username,
            uid: cred.user!.uid,
            followers: [],
            following: []);
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(uuser.toJson());
        res = 'success';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> loginuser(
      {required String email, required String password}) async {
    String res = 'some error occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'please enter all the fields ';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<void> signout() async
  {
   await _auth.signOut();
  }
}
