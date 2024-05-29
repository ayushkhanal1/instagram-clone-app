import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String bio;
  final String username;
  final String photourl;
  final List followers;
  final List following;
  const User({
    required this.email,
    required this.photourl,
    required this.bio,
    required this.username,
    required this.uid,
    required this.followers,
    required this.following,
  });
  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'bio': bio,
        'followers': [],
        'following': [],
        'photourl': photourl,
      };
  static User fromsnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
        email: snapshot['email'],
        photourl: snapshot['photourl'],
        bio: snapshot['bio'],
        username: snapshot['username'],
        uid: snapshot['uid'] ,
        followers: snapshot['followers'],
        following: snapshot['following']);
  }
}
