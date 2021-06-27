import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watchout/Screens/ChatUser.dart';

class DoctorAsk extends StatefulWidget {
  @override
  _DoctorAskState createState() => _DoctorAskState();
}

// FFD5D5
//076482

class _DoctorAskState extends State<DoctorAsk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Doctors')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              // reverse: true,
              children: snapshot.data.docs.map<Widget>((document) {
                // return Text(document['UserName']);
                return Tile(
                  document['name'],
                  document['problem'],
                  document['photo'],
                  document['email'],
                  document['phone'],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  Tile(name, problem, photo, useremail, phone) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => MapPage()));
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Divider(
                height: 2,
                thickness: 2,
                // FFD5D5
                //076482
                color: Color(0xff076482),
              ),
            ),
            Container(
              width: 300,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                problem,
                maxLines: 20,
                overflow: TextOverflow.ellipsis,
                style: styl,
              ),
            ),
            photo == null || photo == ''
                ? Container()
                : Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width - 10,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: NetworkImage(photo), fit: BoxFit.cover))),
            Container(
              height: 60,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var email = prefs.getString('email');
                      FirebaseFirestore.instance
                          .collection('PreviousAnswer')
                          .doc(email)
                          .collection('prev')
                          .doc(email + problem)
                          .set({
                        'name': name,
                        'email': useremail,
                        'post': useremail + problem,
                        'phone': phone
                      }).then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CommentSec(post: useremail + problem)));
                      }).catchError((e) {
                        print('Error');
                      });
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
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Color(0xff076482), shape: BoxShape.circle),
                    child: IconButton(
                      color: Color(0xff076482),
                      onPressed: () {
                        print('Call User');
                        launch("tel://" + phone);
                      },
                      icon: Icon(
                        Icons.call,
                        color: Colors.white,
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
