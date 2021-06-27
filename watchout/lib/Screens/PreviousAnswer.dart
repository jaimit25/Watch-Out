import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watchout/Screens/ChatUser.dart';

class PreviousAnswer extends StatefulWidget {
  @override
  _PreviousAnswerState createState() => _PreviousAnswerState();
}

// FFD5D5
//076482
class _PreviousAnswerState extends State<PreviousAnswer> {
  var mymail;

  getDataShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mymail = prefs.getString('email');
      print(mymail);
      print("getttttt emaiiiil");
    });
  }

  @override
  void initState() {
    super.initState();

    getDataShared();
    // print(uid);
    print('yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy');
    // Data = FirebaseFirestore.instance.collection('Users').snapshots();
    // Chats=FirebaseFirestore.instance.collection('').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('PreviousAnswer')
            .doc(mymail)
            .collection('prev')
            // .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              shrinkWrap: true,
              // reverse: true,
              children: snapshot.data.docs.map<Widget>((document) {
                // return Text(document['email']);
                return Tile(
                  document['name'],
                  document['email'],
                  document['post'],
                  document['phone'],
                  document.id,
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  Tile(name, useremail, post, phone, id) {
    return GestureDetector(
      onLongPress: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => MapPage()));
        FirebaseFirestore.instance
            .collection('PreviousAnswer')
            .doc(useremail)
            .collection('prev')
            .doc(id)
            .delete();
        // .orderBy('time', descending: true)
      },
      child: Container(
        // height: 300,
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.grey),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(2, 7),
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            //   child: Divider(
            //     height: 2,
            //     thickness: 2,
            //     // FFD5D5
            //     //076482
            //     color: Color(0xff076482),
            //   ),
            // ),
            Container(
              height: 60,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var email = prefs.getString('email');

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentSec(post: post)));
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Color(0xff076482),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'Chat With User',
                          style: stylwhite,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      launch("tel://" + phone);
                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // var email = prefs.getString('email');

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => CommentSec(post: post)));
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Color(0xff076482),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'Call',
                          style: stylwhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SingleTile(title, val) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          Text(
            title,
            style: styl,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            val,
            style: styl,
          ),
        ],
      ),
    );
  }
}

BoxDecoration box = BoxDecoration(
  // border: Border.all(color: Colors.grey),
  boxShadow: [
    BoxShadow(
      color: Colors.grey,
      offset: Offset(2, 7),
    )
  ],
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
);

TextStyle styl = TextStyle(
  color: Colors.black,
  fontSize: 12,
);
TextStyle stylwhite = TextStyle(
  color: Colors.white,
  fontSize: 14,
);
TextStyle styltheme = TextStyle(
  color: Color(0xff076482),
  fontSize: 12,
);
