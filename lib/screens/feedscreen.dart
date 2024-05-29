import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/globle_variables.dart';
import 'package:instaclone/widgets/postcard.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: width > weblayoutsize
          ? null
          : AppBar(
              centerTitle: false,
              backgroundColor: width > weblayoutsize
                  ? webBackgroundColor
                  : mobileBackgroundColor,
              title: SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 30,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.messenger_outline_outlined),
                ),
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
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
              itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: width > weblayoutsize ? width * 0.32 : 0,
                        vertical: width > weblayoutsize ? 15 : 0),
                    height: width>weblayoutsize?480:528,
                    width: double.infinity,
                    child: PostCard(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  ));
        },
      ),
    );
  }
}
