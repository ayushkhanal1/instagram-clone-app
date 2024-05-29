import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String postid;
  final String uid;
  final String username;
  final  datepublished;
  final String posturl;
  final String profileimage;
  final likes;
  const Post({
    required this.datepublished,
    required this.description,
    required this.likes,
    required this.postid,
    required this.posturl,
    required this.profileimage,
    required this.uid,
    required this.username,
  });
  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'datepublished': datepublished,
        'posturl': posturl,
        'likes': likes,
        'profileimage': profileimage,
        'postid': postid,
        'description': description,
      };
  static Post fromsnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        datepublished: snapshot['datepublished'],
        posturl: snapshot['posturl'],
        postid: snapshot['postid'],
        username: snapshot['username'],
        uid: snapshot['uid'],
        likes: snapshot['likes'],
        profileimage: snapshot['profileimage'],
        description: snapshot['discreption']);
  }
}
