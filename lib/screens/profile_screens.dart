// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/resources/auth_methods.dart';
import 'package:instaclone/resources/firestore_methods.dart';
import 'package:instaclone/screens/login_screens.dart';
import 'package:instaclone/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.uuid});
  final uuid;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userprofiledata = {};
  int postlen = 0;
  int Followers = 0;
  int following = 0;
  bool isfollowing = false;
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    userdata();
  }

  Future<void> userdata() async {
    setState(() {
      isloading = true;
    });
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uuid)
          .get();
      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      userprofiledata = usersnap.data()!;
      postlen = postsnap.docs.length;
      following = usersnap.data()!['followers'].length;
      Followers = usersnap.data()!['followers'].length;
      isfollowing = usersnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userprofiledata['username'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            backgroundColor: mobileBackgroundColor,
            body: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userprofiledata['photourl'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    staticcolumn(postlen, 'Posts'),
                                    staticcolumn(following, 'Following'),
                                    staticcolumn(Followers, 'Followers'),
                                  ],
                                ),
                                FirebaseAuth.instance.currentUser!.uid ==
                                        widget.uuid
                                    ? Container(
                                        margin: EdgeInsets.only(top: 15),
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 71, 68, 68),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: TextButton(
                                          onPressed: () async {
                                            await Authmethods().signout();
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Sign Out',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : isfollowing
                                        ? Container(
                                            margin: EdgeInsets.only(top: 15),
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 71, 68, 68),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: TextButton(
                                              onPressed: () async {
                                                await FirestoreMethods()
                                                    .followuser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userprofiledata['uid']);
                                                setState(() {
                                                  isfollowing = false;
                                                  Followers--;
                                                });
                                              },
                                              child: Text(
                                                'Unfollow',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(top: 15),
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: TextButton(
                                              onPressed: () async {
                                                await FirestoreMethods()
                                                    .followuser(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  userprofiledata['uid'],
                                                );
                                                setState(() {
                                                  isfollowing = true;
                                                  Followers++;
                                                });
                                              },
                                              child: Text(
                                                'Follow',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          userprofiledata['username'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 1),
                        child: Text(
                          userprofiledata['bio'],
                        ),
                      ),
                      Divider(),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uuid)
                            .get(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 1.5,
                                    childAspectRatio: 1),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  snapshot.data!.docs[index];
                              return Container(
                                child: Image(
                                  image: NetworkImage(
                                    snap['posturl'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Container staticcolumn(int num, String teext) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            num.toString(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            teext,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
