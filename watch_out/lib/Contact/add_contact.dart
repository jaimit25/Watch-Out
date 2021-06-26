import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_out/Tabs/contact.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();
  var searchsnapshot;
  QuerySnapshot searchResultSnapshot;
  TextEditingController searchEditingController = new TextEditingController();
  bool isLoading = false;
  bool haveUserSearched = false;
  var Data;
  String uiduser;
  var email;

  @override
  void initState() {
    super.initState();

    // Future.delayed(Duration(milliseconds: 2), () {
    //   setState(() {});
    // });
    // Data = FirebaseFirestore.instance.collection('users').snapshots();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  // bool a = false;
  bool a = true;

  @override
  Widget build(BuildContext context) {
    onWillPop() {
      Navigator.pop(context);
    }

    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.2,
            backgroundColor: Color(0xff076482),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Colors.white)),
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 50,
                margin:
                    EdgeInsets.only(top: 10, bottom: 10, right: 12, left: 12),
                padding: EdgeInsets.only(top: 2, bottom: 2, right: 5, left: 7),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    // border: Border.all(width: 1, color: , s
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: TextFormField(
                  style: TextStyle(color: Color(0xff076482)),

                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (value) {
                    // Fluttertoast.showToast(
                    //     msg: "This is Center Short Toast",
                    //     toastLength: Toast.LENGTH_SHORT,
                    //     gravity: ToastGravity.CENTER,
                    //     timeInSecForIosWeb: 1,
                    //     backgroundColor: Colors.red,
                    //     textColor: Colors.white,
                    //     fontSize: 16.0);

                    setState(() {
                      haveUserSearched = !haveUserSearched;
                    });
                  },
                  // controller: _searchController,
                  controller: _searchController,
                  onChanged: (query) {
                    // searchUser(query);
                    setState(() {
                      haveUserSearched = !haveUserSearched;
                    });
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Color(0xff076482)),
                      hintText: 'Search ...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      border: InputBorder.none),
                ),
              ),
              userList(),
            ],
          ),
        ),
        onWillPop: onWillPop);
  }

  Widget userList() {
    return haveUserSearched
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where('searchname',
                    isGreaterThanOrEqualTo:
                        _searchController.text.toLowerCase())
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                children: snapshot.data.docs.map<Widget>((document) {
                  return FriendList(document['photo'], document['name'],
                      document['email'], document['phone']);
                }).toList(),
              );
            },
          )
        : Center(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('emergency')
                  .doc('janavip81@gmail.com')
                  .collection('contacts')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data.docs.map<Widget>((document) {
                    // return Emergencylist(document['name'], document['mail'],
                    //     document['photo'], document['phone'], document.id);

                    return GestureDetector(
                      onTap: () {
                        print('ooooooooooooooooooooooooooooooooooooooooo');
                        launch("tel://" + document['phone']);
                        // CallDialog(context, document['phone']);
                      },
                      child: MaterialButton(
                        onPressed: () {
                          print('ooooooooooooooooooooooooooooooooooooooooo');
                          // launch("tel://" + document['phone']);
                        },
                        child: Container(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => user_profile(
                                  //               useremail: userEmail,
                                  //             )));
                                },
                                child: Container(
                                  // color: Colors.pink,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    // color: Colors.pink
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            // border: Border.all(width: 3, color: Colors.pink),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    document['photo']),
                                                fit: BoxFit.cover)),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                            )
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Color(0xff076482)),
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();

                                          var myemail =
                                              prefs.getString('email');
                                          FirebaseFirestore.instance
                                              .collection('emergency')
                                              .doc(myemail)
                                              .collection('contacts')
                                              .doc(document.id)
                                              .delete();
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Container(
                            //   margin: EdgeInsets.only(left: 30, right: 30),
                            //   child: Divider(
                            //     height: 5,
                            //     color: Colors.white,
                            //   ),
                            // )
                          ],
                        )),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          );
    // Center(
    //     child: StreamBuilder(
    //       stream: FirebaseFirestore.instance
    //           .collection('UserSearched')
    //           .where('mail', isEqualTo: email)
    //           .snapshots(),
    //       builder: (BuildContext context,
    //           AsyncSnapshot<QuerySnapshot> snapshot) {
    //         if (!snapshot.hasData) {
    //           return Center(
    //             child: CircularProgressIndicator(),
    //           );
    //         }
    //         return ListView(
    //           shrinkWrap: true,
    //           reverse: true,
    //           children: snapshot.data.docs.map<Widget>((document) {
    //             // return Container();
    //             // return Divider(
    //             //   height: 2,
    //             //   color: Colors.black,
    //             // );
    //             return userTileDelete(
    //                 document['Name'],
    //                 document['UserEmail'],
    //                 document['Photo'],
    //                 document['phone'],
    //                 document.id);
    //           }).toList(),
    //         );
    //       },
    //     ),
    //   );
  }

  Widget userTileDelete(
      String Name, String userEmail, String Photo, String phone, String id) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => user_profile(
        //               useremail: userEmail,
        //             )));
        DialogBoxadd(context, userEmail, Name, Photo, phone);
      },
      // hoverColor: theme_navigation,
      child: Container(
          child: Column(
        children: [
          Container(
            child: GestureDetector(
              onTap: () {
                DialogBoxadd(context, userEmail, Name, Photo, phone);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => user_profile(
                //               useremail: userEmail,
                //             )));
              },
              child: Container(
                // color: Colors.pink,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  // color: Colors.pink
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // border: Border.all(width: 3, color: Colors.pink),
                          image: DecorationImage(
                              image: NetworkImage(Photo), fit: BoxFit.cover)),
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
                              Name == null ? "" : Name,
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
                              Name == null ? "" : Name,
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
                    IconButton(
                      icon: Icon(Icons.delete, color: Color(0xff076482)),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('UserSearched')
                            .doc(id)
                            .delete();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(left: 30, right: 30),
          //   child: Divider(
          //     height: 5,
          //     color: Colors.white,
          //   ),
          // )
        ],
      )),
    );
  }

  Widget FriendList(String userimg, String name, String mail, String phone) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var myemail = prefs.getString('email');
        FirebaseFirestore.instance
            .collection('UserSearched')
            .doc(name + mail)
            .set({
          'Name': name,
          'Photo': userimg,
          'UserEmail': mail,
          'mail': myemail,
          'phone': phone,
          'time': Timestamp.now().toString(),
          // 'userName': username
        }).then((value) async {
          DialogBoxadd(context, mail, name, userimg, phone);
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => user_profile(
          //               useremail: mail,
          //             )));
        });
        //
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          margin: EdgeInsets.only(top: 10, left: 10),
          height: 80,
          // color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(5),
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(userimg),
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    child: Text(
                      name == null ? "" : name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(0xff076482),
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    width: 150,
                    child: Text(
                      mail == null ? "" : mail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void DialogBoxadd(context, mail, name, userimg, phone) {
    var baseDialog = AlertDialog(
      title: new Text("Emergency Contact"),
      content: Container(
        child: Text('Add user in your Emergency Contact'),
      ),
      actions: <Widget>[
        FlatButton(
          color: Color(0xff076482),
          child: new Text("Confirm",
              style: TextStyle(
                color: Colors.white,
              )),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var myemail = prefs.getString('email');

            FirebaseFirestore.instance
                .collection('emergency')
                .doc(myemail)
                .collection('contacts')
                .doc(mail)
                .set({
              'name': name,
              'mail': mail,
              'photo': userimg,
              'phone': phone,
              'time': Timestamp.now().toString(),
            }).then((value) {
              Fluttertoast.showToast(
                msg: 'Added to Emergency Contacts',
                timeInSecForIosWeb: 2,
                backgroundColor: Color(0xff076482),
                textColor: Colors.white,
              );
            });
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }
}
