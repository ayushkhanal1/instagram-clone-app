import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/globle_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  late PageController pagecontroller;
  var _page = 0;
  @override
  void initState() {
    super.initState();
    pagecontroller = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pagecontroller.dispose();
  }

  void taptochange(int page) {
    pagecontroller.jumpToPage(page);
  }

  void onchange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pagecontroller,
        onPageChanged: onchange,
        children:homeitems,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,
                color: _page == 1 ? primaryColor : secondaryColor),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle,
                color: _page == 2 ? primaryColor : secondaryColor),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite,
                color: _page == 3 ? primaryColor : secondaryColor),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _page == 4 ? primaryColor : secondaryColor),
          ),
        ],
        onTap: taptochange,
      ),
    );
  }
}
