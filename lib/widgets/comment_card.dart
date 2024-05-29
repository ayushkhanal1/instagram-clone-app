// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key,required this.snap});
final snap;
  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
                widget.snap['photourl']),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                            text:widget.snap['username'] ,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' ${widget.snap['comment']}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                  DateFormat.yMMMd().format(
                    widget.snap['publisheddate'].toDate(),
                  ),
                  style: const TextStyle(color: secondaryColor, fontSize: 14),
                ),
                  ),
                ],
              ),
            ),
          ),
          Container(
           padding: EdgeInsets.only(bottom: 10),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite_outline,size: 16,),
              
            ),
          )
        ],
      ),
    );
  }
}
