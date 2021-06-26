import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_out/Tabs/contact.dart';
import 'package:watch_out/Tabs/home.dart';

var color = Colors.white;

class Navigation extends StatefulWidget {
  @override
  NavigationState createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  int bottomSelectedIndex = 2;

  PageController pageController = PageController(
    initialPage: 2,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      // physics: new NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (index) {
        setState(() {
          bottomSelectedIndex = index;
        });
        pageChanged(index);
      },
      children: <Widget>[home(), home(), home(), home(), contact()],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.indigo[900],
      // ),
      body: buildPageView(),
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(0xFF076482),
        backgroundColor: Colors.grey[50],
        buttonBackgroundColor: Color(0xFF076482),
        index: bottomSelectedIndex,
        items: [
          Icon(
            Icons.person_search,
            color: color,
          ),
          Icon(
            Icons.help,
            color: color,
          ),
          Icon(
            Icons.health_and_safety_sharp,
            color: color,
          ),
          Icon(
            Icons.chat_bubble,
            color: color,
          ),
          Icon(
            Icons.call,
            color: color,
          )
        ],
        onTap: (index) {
          bottomTapped(index);
        },
      ),
    );
  }
}
