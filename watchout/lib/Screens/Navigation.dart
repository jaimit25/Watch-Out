import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watchout/Tabs/Doctor.dart';
import 'package:watchout/Tabs/Police.dart';

var color = Colors.white;

class Navigation extends StatefulWidget {
  var urole;
  Navigation({@required this.urole});
  @override
  NavigationState createState() => NavigationState(
        urole: urole,
      );
}

class NavigationState extends State<Navigation> {
  int bottomSelectedIndex = 0;
  var role = '';
  var urole;
  NavigationState({@required this.urole});

  @override
  void initState() {
    getRole();
    print('yyyyyy callled init state');
    super.initState();
  }

  PageController pageController = PageController(
    initialPage: 0,
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
      // children: <Widget>[
      //   home(), Track(),
      //   ],
    );
  }

  getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var userrole = prefs.getString('role');
    print(email);
    print('xxxxx ${userrole}');
    var qsnap = await FirebaseFirestore.instance
        .collection('authorityusers')
        .doc(email)
        .get();
    var dc = qsnap.data();

    print('xxxxxxxxxxxxxxxxxxxxx');
    setState(() {
      role = dc['Police/Government Official'];
      print(role);
    });
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
    // 'Doctor',
    // 'Police/Government Official',
    onWillPop() {}

    if (urole == 'Police/Government Official') {
      return WillPopScope(child: Police(), onWillPop: onWillPop);
    } else if (urole == 'Doctor') {
      return WillPopScope(child: Doctor(), onWillPop: onWillPop);
    } else {
      return Scaffold(
        backgroundColor: Color(0xff076482),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text('👤'),
              Text(
                'Problem Getting Your Data',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      );
    }
    // return Scaffold(
    // appBar: AppBar(
    //   backgroundColor: Colors.indigo[900],
    // ),
    // body: buildPageView(),
    // bottomNavigationBar: CurvedNavigationBar(
    //   color: Color(0xFF19196f),
    //   backgroundColor: Colors.grey[50],
    //   buttonBackgroundColor: Color(0xFF19196f),
    //   index: bottomSelectedIndex,
    //   items: [
    //     Icon(
    //       Icons.home,
    //       color: color,
    //     ),
    //     Icon(
    //       Icons.bus_alert,
    //       color: color,
    //     ),
    //   ],
    //   onTap: (index) {
    //     bottomTapped(index);
    //   },
    // ),
    // );
  }
}
