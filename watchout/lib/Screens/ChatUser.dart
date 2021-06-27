import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watchout/Authentication/splash.dart';
import 'package:watchout/Screens/Navigation.dart';
import 'package:watchout/Tabs/Doctor.dart';

// var imageurl;
// var color = Color(0xFF19196f);
// String uid;

class CommentSec extends StatefulWidget {
  String post;
  CommentSec({@required this.post});

  @override
  _CommentSecState createState() => _CommentSecState(post: post);
}

class _CommentSecState extends State<CommentSec> {
  var post;
  _CommentSecState({@required this.post});
  var Data;
  var email;
  var Chats;
  // BuildContext contxt;
  String message;

  TextEditingController chatController = TextEditingController();
  // var QuerySnapshot;
  var chatsdata;
  var mymail;
  @override
  void initState() {
    super.initState();

    getDataShared();
    chatsdata = FirebaseFirestore.instance
        .collection('Doctors')
        .doc(post)
        .collection('Comments')
        .snapshots();
    // print(uid);
    print('yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy');
    // Data = FirebaseFirestore.instance.collection('Users').snapshots();
    // Chats=FirebaseFirestore.instance.collection('').snapshots();
  }

  getDataShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mymail = prefs.getString('email');
      print(mymail);
      print("getttttt emaiiiil");
    });
  }

  @override
  Widget build(BuildContext context) {
    onWillPop() {
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Doctor()));
    }

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff076482),
            title: Text('Watch Out'),
            actions: [
              PopupMenuButton(
                itemBuilder: (BuildContext bc) => [
                  PopupMenuItem(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SplashScreen()));
                          },
                          child: Text("Refresh")),
                      value: "Refresh"),
                  PopupMenuItem(
                      child: GestureDetector(
                          onTap: () {
                            //
                            DialogBoxLogOut(context);
                          },
                          child: Text("Log Out")),
                      value: "Log out"),
                ],
                onSelected: (route) {
                  print(route);
                  // Note You must create respective pages for navigation
                  Navigator.pushNamed(context, route);
                },
              ),
            ],
          ),
          backgroundColor: Colors.white,
          // appBar: AppBar(
          //   backgroundColor: color,
          //   title: Text('Message'),
          // ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('authorityusers')
                .doc(mymail)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var doc = snapshot.data;
                print(doc['photo']);
                print(doc['name']);
                print(doc['email']);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Flexible(
                      child: Container(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Doctors')
                              .doc(post)
                              .collection('Comments')
                              .orderBy('time', descending: true)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return ListView(
                                reverse: true,
                                children:
                                    snapshot.data.docs.map<Widget>((document) {
                                  // return Text(document['UserName']);
                                  return MessageTile(
                                      document['Photo'],
                                      document['Message'],
                                      document['send'],
                                      document.id,
                                      document['name']);
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    chatControls(doc['photo'], doc['name'], doc['email']),
                  ],
                );
              }
            },
          ),
        ),
        onWillPop: onWillPop);
  }

  void displayBottomSheet(BuildContext cont) {
    showModalBottomSheet(
        // backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        context: cont,
        builder: (ctx) {
          return Container(
            height: 200,
          );
        });
  }

  Widget MessageTile(
      String Photo, String Message, String send, String id, String name) {
    return GestureDetector(
      onLongPress: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var email = prefs.getString('email');
        if (email == send) {
          DialogBoxDelete(context, id);
        } else {
          print(email);
          print(send);
          print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
        }
      },
      child: Container(
        child: Row(
          children: [
            Container(
                height: 60,
                width: 60,
                margin: EdgeInsets.all(5),
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(140)),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    Photo,
                  ),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  send == mymail ? 'you' : name,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  Message,
                  maxLines: 100,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void DialogBoxDelete(context, id) {
    var baseDialog = AlertDialog(
      title: new Text(
        "Delete",
        // style: txt.andika,
      ),
      content: Container(
        child: Text(
          'You Want to Delete Message?',
          // style: txt.andikasmall,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          color: Color(0xff076482),
          child: new Text(
            "Yes",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('Doctors')
                .doc(post)
                .collection('Comments')
                .doc(id)
                .delete()
                .then((value) {
              Navigator.pop(context);
            });
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  chatControls(PhotoUser, name, email) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: chatController,
              textInputAction: TextInputAction.send,
              onChanged: (input) {
                setState(() {
                  message = input;
                });
              },
              onFieldSubmitted: (value) async {
                if (chatController.text == "") {
                } else {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var myemail = prefs.getString('email');
                  var collectionRef =
                      FirebaseFirestore.instance.collection('users');
                  var docu = await collectionRef.doc(myemail).get();
                  bool check = docu.exists;
                  var dc = docu.data();
                  FirebaseFirestore.instance
                      .collection('Doctors')
                      .doc(post)
                      .collection('Comments')
                      .add({
                    'Message': chatController.text,
                    'send': myemail,
                    'time': Timestamp.now().toString(),
                    'Photo': PhotoUser,
                    'name': name
                  }).then((value) {
                    print('message sent');
                    chatController.text = '';
                  }).catchError((e) {
                    print('message not sent');
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'Say Hi ...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (chatController.text == "") {
              } else {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var myemail = prefs.getString('email');
                var collectionRef =
                    FirebaseFirestore.instance.collection('users');
                var docu = await collectionRef.doc(myemail).get();
                bool check = docu.exists;
                var dc = docu.data();
                FirebaseFirestore.instance
                    .collection('Doctors')
                    .doc(post)
                    .collection('Comments')
                    .add({
                  'Message': chatController.text,
                  'send': myemail,
                  'time': Timestamp.now().toString(),
                  'Photo': PhotoUser,
                  'name': name
                }).then((value) {
                  print('message sent');
                  chatController.text = '';
                }).catchError((e) {
                  print('message not sent');
                });
              }
            },
            child: Opacity(
              opacity: 1,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.indigo[400], shape: BoxShape.circle),
                child: Icon(
                  Icons.send,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void displayBottomSheet(BuildContext cont, String id) {
  showModalBottomSheet(
      // backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      context: cont,
      builder: (ctx) {
        return Container(
          height: 200,
          child: Column(
            children: [
              MaterialButton(
                onPressed: () {},
              )
            ],
          ),
        );
      });
}
