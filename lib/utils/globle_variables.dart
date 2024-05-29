import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/screens/addpost_screen.dart';
import 'package:instaclone/screens/feedscreen.dart';
import 'package:instaclone/screens/profile_screens.dart';
import 'package:instaclone/screens/search_screen.dart';
const weblayoutsize = 600;
List<Widget> homeitems= [
          const FeedScreen(),
          const SearchScreen(),
          const AddPost(),
          const Center(
            child: Text('notifications'),
          ),
         ProfileScreen(uuid: FirebaseAuth.instance.currentUser!.uid),
        ];
