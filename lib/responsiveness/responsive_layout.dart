import 'package:flutter/material.dart';
import 'package:instaclone/provider/user_provider.dart';
import 'package:instaclone/utils/globle_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout(
      {super.key,
      required this.mobilescreenlayout,
      required this.webscreenlayout});
  final Widget webscreenlayout;
  final Widget mobilescreenlayout;

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    adddata();
  }

  adddata() async{
    UserProvider _userprovider=Provider.of(context,listen: false);
    await _userprovider.refreshuser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > weblayoutsize) {
          return widget.webscreenlayout;
        } else {
          return widget.mobilescreenlayout;
        }
      },
    );
  }
}
