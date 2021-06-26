import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_out/chat/add_chat.dart';
import 'package:watch_out/chat/chatscreen.dart';

class chatlist extends StatefulWidget {
  // const chatlist({ Key? key }) : super(key: key);

  @override
  _chatlistState createState() => _chatlistState();
}

class _chatlistState extends State<chatlist> {
  var myemail;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getemail();
  }

  getemail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      myemail = pref.getString("email");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff076482),
        title: Text('Chat'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => add_chat()));
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance
      //       .collection('emergency')
      //       .doc(myemail)
      //       .collection('contacts')
      //       .orderBy('time', descending: true)
      //       .snapshots(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (!snapshot.hasData) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else {
      //       return ListView(
      //         shrinkWrap: true,
      //         children: snapshot.data.docs.map<Widget>((document) {
      //           return GestureDetector(
      //               onTap: () {
      //                 print(
      //                     'xxxxxxxxxxxxxxxxxxxxxiiiiiiiiiiiyyyyyyyyyyyyyyyyyy');
      //                 // launch("tel://" + document['phone']);
      //                 Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) => ChatScreen(
      //                               useremail: document['mail'],
      //                               roomId:
      //                                   getRoomId(myemail, document['mail']),
      //                               Name: document['name'],
      //                               Photo: document['photo'],
      //                               Email: myemail,
      //                             )));
      //               },
      //               child:
      //                   // Text(
      //                   //   document['phone'],
      //                   // ),
      //                   Container(
      //                 margin: EdgeInsets.only(left: 20, top: 10),
      //                 child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     children: [
      //                       Container(
      //                         height: 60,
      //                         width: 60,
      //                         decoration: BoxDecoration(
      //                             shape: BoxShape.circle,
      //                             // border: Border.all(width: 3, color: Colors.pink),
      //                             image: DecorationImage(
      //                                 image: NetworkImage(document['photo']),
      //                                 fit: BoxFit.cover)),
      //                       ),
      //                       Container(
      //                         margin: EdgeInsets.only(left: 10),
      //                         child: Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           mainAxisAlignment: MainAxisAlignment.start,
      //                           children: [
      //                             Container(
      //                               width: 160,
      //                               child: Text(
      //                                 document['name'] == null
      //                                     ? ""
      //                                     : document['name'],
      //                                 maxLines: 1,
      //                                 overflow: TextOverflow.ellipsis,
      //                                 style: TextStyle(
      //                                   color: Color(0xff076482),
      //                                   fontSize: 16,
      //                                   fontWeight: FontWeight.bold,
      //                                 ),
      //                               ),
      //                             ),
      //                             Container(
      //                               margin: EdgeInsets.only(top: 5),
      //                               width: 120,
      //                               child: Text(
      //                                 document['phone'] == null
      //                                     ? ""
      //                                     : document['phone'],
      //                                 overflow: TextOverflow.ellipsis,
      //                                 maxLines: 2,
      //                                 style: TextStyle(
      //                                   color: Color(0xff076482),
      //                                   fontSize: 14,
      //                                   fontWeight: FontWeight.w400,
      //                                 ),
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     ]),
      //               ));
      //         }).toList(),
      //       );
      //     }
      //   },
      // ),
      body: StreamBuilder(
        // FirebaseFirestore.instance
        //             .collection('Chats')
        //             .doc(roomId)
        //             .collection('chat')
        //             .orderBy('time', descending: true)
        //             .snapshots()
        stream: FirebaseFirestore.instance
            // .collection('Chats')
            // .doc(createRoom)
            .collection('ChatRoom')
            .doc(myemail)
            .collection('ChatList')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data.docs.map<Widget>((document) {
              // return Text(document['UserName']);
              return userTile(
                  document['Name'],
                  document['Email'],
                  document['Photo'],
                  document['Email'],
                  document['useremail'],
                  document['lastMessage'],
                  document['check'],
                  document['roomId'],
                  document.id);
            }).toList(),
          );
        },
      ),
    );
  }

// (String Name, String Email, String Photo, String useremail,
  // String lastmessage, var check, String roomId, String id)
  String getRoomId(String email, String useremail) {
    String a = email;
    String b = useremail;
    if (a.codeUnitAt(0) == b.codeUnitAt(0)) {
      for (int i = 0; i <= 8; i++) {
        if (a.codeUnitAt(i) != b.codeUnitAt(i)) {
          if (a.codeUnitAt(i) > b.codeUnitAt(i)) {
            return a + b;
          } else {
            return b + a;
          }
        }
      }
    }
//   else {
    if (a.codeUnitAt(0) > b.codeUnitAt(0)) {
      return a + b;
    } else {
      return b + a;
    }
//   }
  }

  void DialogBoxForeverDelete(roomId, uid, uuid, id) {
    var baseDialog = AlertDialog(
      title: new Text(
        "Delete",
        style: styl,
      ),
      content: Container(
        child: Text(
          'Your Chat Room is Deleted Successfully',
          style: styl,
        ),
      ),
      // actions: <Widget>[
      // FlatButton(
      //   color: color.theme1,
      //   child: new Text("Yes", style: txt.lailaverysmall),
      //   onPressed: () {
      //     // print(roomId);
      //     // String createRoom = getRoomId(uid, uuid);
      //     // FirebaseFirestore.instance
      //     //     .collection('ChatRoom')
      //     //     .doc(uid)
      //     //     .collection('ChatList')
      //     //     .doc(roomId)
      //     //     .delete();
      //     // Navigator.pop(context);
      //   },
      // ),
      // ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  Widget userTile(
      String Name,
      String Email,
      String Photo,
      String mymail,
      String useremail,
      String lastmessage,
      var check,
      String roomId,
      String id) {
    return MaterialButton(
      onLongPress: () {
        FirebaseFirestore.instance
            .collection('ChatRoom')
            .doc(myemail)
            .collection('ChatList')
            .doc(roomId)
            .delete();
        DialogBoxForeverDelete(roomId, myemail, useremail, id);
      },
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String mail = prefs.getString('email');
        FirebaseFirestore.instance
            .collection('ChatRoom')
            .doc(useremail)
            .collection('ChatList')
            .doc(roomId)
            .update({
          'check': true,
        });
        FirebaseFirestore.instance
            .collection('ChatRoom')
            .doc(myemail)
            .collection('ChatList')
            .doc(roomId)
            .update({
          'check': true,
        }).then((value) async {
          String createRoom = getRoomId(mail, useremail);
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                roomId: createRoom,
                useremail: useremail,
                Name: Name,
                Photo: Photo,
                Email: Email,
              ),
            ),
          );
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  child: Stack(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            // border: Border.all(color: color.theme1, width: 2),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(Photo),
                            )),
                      ),
                      check
                          ? Container()
                          : Container(
                              height: 14,
                              width: 14,
                              margin: EdgeInsets.only(top: 45, left: 45),
                              // decoration: BoxDecoration(
                              //     shape: BoxShape.circle, color: Colors.red),
                            ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Name == null || Name == "" ? 'Name' : Name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        lastmessage == null || lastmessage == ""
                            ? 'Photo'
                            : lastmessage,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12.5,
                            // color: Colors.grey[700],
                            color: check ? Colors.grey[600] : Colors.grey[900],
                            fontWeight:
                                check ? FontWeight.w600 : FontWeight.w800),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              child: Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
