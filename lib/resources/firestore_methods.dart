import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/models/post.dart';
import 'package:instaclone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadpost(String description, Uint8List file, String uid,
      String username, String profileimage) async {
    String res = 'some error occured';
    try {
      String photourl = await StorageMethods().uploadimage('posts', file, true);
      String postid = const Uuid().v1();
      Post post = Post(
          datepublished: DateTime.now(),
          likes: [],
          description: description,
          postid: postid,
          posturl: photourl,
          profileimage: profileimage,
          uid: uid,
          username: username);
      _firestore.collection('posts').doc(postid).set(
            post.toJson(),
          );
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likepost(String postid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postid).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postid).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> oncomment(String username, String text, String uid,
      String photourl, String postid) async {
    try {
      if (text.isNotEmpty) {
        String commentid = Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postid)
            .collection('comments')
            .doc(commentid)
            .set({
          'username': username,
          'comment': text,
          'photourl': photourl,
          'postid': postid,
          'uid': uid,
          'publisheddate': DateTime.now(),
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> deletepost(String postid) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postid).delete();
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> followuser(String uid, String followid) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followid)) {
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followid])
        });
        await _firestore.collection('users').doc(followid).update({
        'followers':FieldValue.arrayRemove([uid])
      });
      }
      else
      {
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followid])
        });
        await _firestore.collection('users').doc(followid).update({
        'followers':FieldValue.arrayUnion([uid])
      });
      }
    }
     catch (e) {
      print(
        e.toString(),
      );
    }
  }
}
