import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/models/user.dart';
import 'package:instaclone/provider/user_provider.dart';
import 'package:instaclone/resources/firestore_methods.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.snap});
  final snap;
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _commentcontroller = TextEditingController();
    final User? user = Provider.of<UserProvider>(context).getter;
    void dispose() {
      super.dispose();
      _commentcontroller.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postid'])
            .collection('comments').orderBy('publisheddate',descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => CommentCard( snap: snapshot.data!.docs[index].data()),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user!.photourl,
                ),
                radius: 18,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextField(
                  controller: _commentcontroller,
                  maxLines: 20,
                  decoration: InputDecoration(
                    hintText: 'Comment as ${user.username}',
                    border: InputBorder.none,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await FirestoreMethods().oncomment(
                      user.username,
                      _commentcontroller.text,
                      user.uid,
                      user.photourl,
                      widget.snap['postid']);
                      setState(() {
                        _commentcontroller.text='';
                      });
                },
                child: const Text(
                  'Post',
                  style: TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
