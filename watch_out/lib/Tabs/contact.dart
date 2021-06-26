import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:watch_out/Contact/add_contact.dart';

class contact extends StatefulWidget {
  // const contact({ Key? key }) : super(key: key);

  @override
  _contactState createState() => _contactState();
}

class _contactState extends State<contact> {
  var myemail;

  // void setState(fn) {
  //   if (mounted) {
  //     super.setState(fn);
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    // launch("tel://" + '7045228801');
    super.initState();
    getemail();
  }

  getemail() async {
    print('Calledddddddddddddddddddddddddddddddddddddd');
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      myemail = pref.getString('email');
      print(myemail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff076482),
        title: Text('Emergency Contact'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Search()));
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.add_call,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('emergency')
            .doc(myemail)
            .collection('contacts')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              shrinkWrap: true,
              children: snapshot.data.docs.map<Widget>((document) {
                return GestureDetector(
                    onTap: () {
                      print(
                          'xxxxxxxxxxxxxxxxxxxxxiiiiiiiiiiiyyyyyyyyyyyyyyyyyy');
                      launch("tel://" + document['phone']);
                    },
                    child:
                        // Text(
                        //   document['phone'],
                        // ),
                        Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  // border: Border.all(width: 3, color: Colors.pink),
                                  image: DecorationImage(
                                      image: NetworkImage(document['photo']),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 160,
                                    child: Text(
                                      document['name'] == null
                                          ? ""
                                          : document['name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xff076482),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    width: 120,
                                    child: Text(
                                      document['phone'] == null
                                          ? ""
                                          : document['phone'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Color(0xff076482),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon:
                                  Icon(Icons.delete, color: Color(0xff076482)),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('emergency')
                                    .doc(myemail)
                                    .collection('contacts')
                                    .doc(document.id)
                                    .delete();
                              },
                            )
                          ]),
                    ));
              }).toList(),
            );
          }
        },
      ),
    );
  }

  void CallDialog(context, phone) {
    var baseDialog = AlertDialog(
      title: new Text(" Call"),
      content: Container(
        child: Text('Call User'),
      ),
      actions: <Widget>[
        FlatButton(
          color: Color(0xff076482),
          child: new Text("Confirm",
              style: TextStyle(
                color: Colors.white,
              )),
          onPressed: () async {
            launch("tel://" + phone);
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  Emergencylist(name, useremail, photo, phone, id) {
    return MaterialButton(
      onPressed: () {
        launch("tel://" + phone);
      },
      child: GestureDetector(
        onTap: () => launch("tel://" + '7045228801'),
        // hoverColor: theme_navigation,
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  // color: Colors.pink,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    // color: Colors.pink
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(photo), fit: BoxFit.cover)),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 160,
                              child: Text(
                                name == null ? "" : name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xff076482),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              width: 120,
                              child: Text(
                                phone == null ? "" : phone,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  color: Color(0xff076482),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
