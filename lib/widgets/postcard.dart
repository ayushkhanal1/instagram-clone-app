import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/resources/firestore_methods.dart';
import 'package:instaclone/screens/comment_screen.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.snap});
  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isliked = false;
  var commentnumber = 0;
  @override
  void initState() {
    super.initState();
    commentcount();
  }

  void commentcount() async {
    try {
      QuerySnapshot commentsnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postid'])
          .collection('comments')
          .get();
      commentnumber = commentsnap.docs.length;
    } catch (e) {
      print(
        e.toString(),
      );
    }
    setState(() {});
  }

  void liketap() async {
    setState(() {
      isliked = !isliked;
    });
    await FirestoreMethods().likepost(
        widget.snap['postid'], widget.snap['uid'], widget.snap['likes']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: mobileBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                  .copyWith(right: 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(widget.snap['profileimage']),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        widget.snap['username'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            children: [
                              SimpleDialogOption(
                                padding: const EdgeInsets.all(20),
                                child: const Text('Delete post'),
                                onPressed: () async {
                                  await FirestoreMethods().deletepost(
                                    widget.snap['postid'],
                                  );
                                  Navigator.of(context).pop();
                                },
                              ),
                              SimpleDialogOption(
                                  padding: const EdgeInsets.all(20),
                                  child: const Text('Report'),
                                  onPressed: () {}),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.more_vert),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.35,
              width: double.infinity,
              child: Image.network(
                widget.snap['posturl'],
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: liketap,
                  icon: isliked
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_outline,
                        ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(snap: widget.snap),
                    ),
                  ),
                  icon: const Icon(
                    Icons.comment_outlined,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.bookmark,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 2),
              child: Row(
                children: [
                  Text('${widget.snap['likes'].length} likes'),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 5, left: 3),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: primaryColor),
                  children: [
                    TextSpan(
                      text: widget.snap['username'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '  ${widget.snap['description']}'),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.only(
                  left: 3,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'View all $commentnumber comments',
                    style: const TextStyle(color: secondaryColor, fontSize: 16),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 3,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  DateFormat.yMMMd().format(
                    widget.snap['datepublished'].toDate(),
                  ),
                  style: const TextStyle(color: secondaryColor, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
