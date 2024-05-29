import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/globle_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
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
  setState(() {
      _page = page;
    });
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
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 30,
        ),
        actions: [
          IconButton(
            onPressed: () => taptochange(0),
            icon: Icon(Icons.home,color: _page==0?primaryColor:secondaryColor,),
          ),
          IconButton(
            onPressed: () => taptochange(1),
            icon:  Icon(Icons.search,color: _page==1?primaryColor:secondaryColor,),
          ),
          IconButton(
            onPressed: () => taptochange(2),
            icon:  Icon(Icons.add_a_photo,color: _page==2?primaryColor:secondaryColor,),
          ),
          IconButton(
            onPressed:() => taptochange(3),
            icon: Icon(Icons.favorite,color: _page==3?primaryColor:secondaryColor,),
          ),
          IconButton(
            onPressed:() => taptochange(4),
            icon: Icon(Icons.person,color: _page==4?primaryColor:secondaryColor,),
          ),
        ],
      ),
      body: PageView(controller: pagecontroller,onPageChanged: taptochange,physics:const NeverScrollableScrollPhysics(),children: homeitems,),
    );
  }
}
