import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_out/Authentication/login.dart';
import 'package:watch_out/Navigation/navigation.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var colr;
  bool usercheck = false;
  @override
  void initState() {
    // usercheck = getData();
    Timer(Duration(seconds: 2), () {
      // usercheck = getData();
      directLogin();
    });
  }

  directLogin() async {
    print("Xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    // getData();
    var collectionRef = FirebaseFirestore.instance.collection('users');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('email');
    prefs.getString('pass');
    var doc = await collectionRef.doc(id).get();
    setState(() {
      usercheck = doc.exists;
    });

    if (usercheck) {
      if (usercheck) {
        print('fuid');
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Navigation()));
      } else {
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => login()));
      }
    } else {
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFD5D5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/watchout.gif'),
                  ),
                ), // child: Text(provider.uid),
              ),
            ],
          ),
          // Container(
          //   margin: EdgeInsets.only(top: 30),
          //   child: AnimatedTextKit(
          //     animatedTexts: [
          //       TypewriterAnimatedText('Social Media App',
          //           textStyle: TextStyle(
          //               color: Colors.pink[600],
          //               fontSize: 20,
          //               fontWeight: FontWeight.bold)),
          //       // ScaleAnimatedText(
          //       //   'Then Scale',
          //       //   textStyle:
          //       //       TextStyle(fontSize: 70.0, fontFamily: 'Canterbury'),
          //       // ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  // getData() async {
  //   var collectionRef = FirebaseFirestore.instance.collection('users');
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.getString('email');
  //   prefs.getString('pass');
  //   var doc = await collectionRef.doc().get();
  //   setState(() {
  //     usercheck = doc.exists;
  //   });
  // }
}
