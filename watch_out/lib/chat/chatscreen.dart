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
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_out/Screens/MapPage.dart';
import 'package:watch_out/chat/ViewImage.dart';

var imageurl;

TextStyle styl = TextStyle(fontSize: 15, color: Colors.black);
TextStyle stylwhite = TextStyle(fontSize: 15, color: Colors.white);

class ChatScreen extends StatefulWidget {
  String useremail;
  String roomId;
  String Name, Photo, Email;
  String imageurl;
  ChatScreen(
      {@required this.useremail,
      @required this.roomId,
      this.Name,
      this.Photo,
      this.Email});

  @override
  _ChatScreenState createState() => _ChatScreenState(
      useremail: useremail,
      roomId: roomId,
      Name: this.Name,
      Photo: this.Photo,
      Email: this.Email);
}

class _ChatScreenState extends State<ChatScreen> {
  String useremail;
  String roomId;
  String Name, Photo, Email;
  _ChatScreenState(
      {this.useremail, this.roomId, this.Name, this.Photo, this.Email});
  Color a, b, c;
  var Data;

  var Chats;
  BuildContext contxt;
  String message;

  TextEditingController chatController = TextEditingController();
  // var QuerySnapshot;
  var chatsdata;
  var myemail;
  @override
  void initState() {
    super.initState();
    getemail();

    chatsdata = FirebaseFirestore.instance
        .collection('Chats')
        .doc(roomId)
        .collection('chat')
        .snapshots();

    // Data = FirebaseFirestore.instance.collection('Users').snapshots();
    // Chats=FirebaseFirestore.instance.collection('').snapshots();
  }

  getemail() async {
    print('Calledddddddddddddddddddddddddddddddddddddd');
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      myemail = pref.getString('email');
      print(myemail);
    });
  }

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

  @override
  Widget build(BuildContext context) {
    onWillPop() {
      Navigator.of(context).pop();
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Navigation()));
    }

    contxt = context;

    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xff076482),
            title: Text('Message'),
            actions: [
              IconButton(
                icon: Icon(Icons.location_pin, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapPage(useremail: useremail)));
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_forever, color: Colors.white),
                onPressed: () {
                  DialogBoxForeverDelete(context, roomId);
                },
              ),
              IconButton(
                icon: Icon(Icons.call, color: Colors.white),
                onPressed: () async {
                  var collectionRef =
                      FirebaseFirestore.instance.collection('users');
                  var docu = await collectionRef.doc(useremail).get();
                  // var users = await collectionRef.doc(emailCont.text).snapshots();
                  bool check = docu.exists;
                  var dc = docu.data();
                  launch("tel://" + dc['phone']);
                },
              )
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Flexible(
                child: Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Chats')
                        .doc(roomId)
                        .collection('chat')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: Icon(
                                Icons.sentiment_very_dissatisfied_outlined,
                                size: 40,
                                color: Colors.black));
                      }
                      return ListView(
                        reverse: true,
                        children: snapshot.data.docs.map<Widget>((document) {
                          // return Text(document['UserName']);
                          return MessageTile(
                              document['Photo'],
                              document['message'],
                              document['Sender'],
                              document['Reciever'],
                              document['time'],
                              document['File'],
                              document['StringExtra'],
                              document.id,
                              contxt);
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
              chatControls(),
            ],
          ),
        ),
        onWillPop: onWillPop);
  }

  void DialogBoxImage(context) {
    var baseDialog = AlertDialog(
      title: new Text(
        "Upload Image",
        style: TextStyle(fontSize: 15, color: Colors.black),
      ),
      content: Container(
        child: Text(
          'Enter Text and then Press Image Add Button to Enter Text. ',
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          color: Color(0xff076482),
          child: new Text(
            "Yes",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String myemail = prefs.getString('email');
            String createRoom = getRoomId(myemail, useremail);
            FirebaseFirestore.instance
                .collection('ChatRoom')
                .doc(useremail)
                .collection('ChatList')
                .doc(createRoom)
                .update({
              'lastMessage': message == null || message == "" ? '...' : message,
              'check': false,
              'time': Timestamp.now().toString(),
            });
            await FirebaseFirestore.instance
                .collection('Chats')
                .doc(roomId)
                .collection('chat')
                .doc(Timestamp.now().toString())
                .set({
              'Sender': myemail,
              'Reciever': useremail,
              'time': Timestamp.now().toString(),
              'message': message == null || message == "" ? '...' : message,
              'Photo': imageurl,
              'File': '',
              'StringExtra': '',
            }).then((value) {
              print('Photo Uploaded');
              FirebaseFirestore.instance
                  .collection('ChatRoom')
                  .doc(myemail)
                  .collection('ChatList')
                  .doc(createRoom)
                  .update({
                'lastMessage':
                    message == null || message == "" ? '...' : message,
                'check': false,
                'time': Timestamp.now().toString(),
              });
              chatController.clear();
              setState(() {
                imageurl = "";
              });
            }).catchError((e) {});
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  uploadImage() async {
    // imageurl = "";
    print('This Code Will Run');
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        //Upload to Firebase
        var snapshot = await _storage
            .ref()
            .child('ChatsImage')
            .child(roomId)
            .child(generateRandomString(200))
            .putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageurl = downloadUrl;
        });
        DialogBoxImage(context);

        // // FirebaseFirestore.instance.collection('Feed').add({
        // //   'Photo': imageurl,
        // //   'Head': heading.text,
        // //   'body': bodymaterial.text,
        // // });

        // print(imageurl);
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
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
      String Photo,
      String Message,
      String Sender,
      String Reciever,
      var time,
      String File,
      String StringExtra,
      String id,
      BuildContext context) {
    return Container(
      alignment:
          myemail == Sender ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          DialogBoxDelete(context, id, roomId);
        },
        child: Container(
          decoration: BoxDecoration(
              color: myemail == Sender ? Color(0xff076482) : Colors.red[300],
              borderRadius: BorderRadius.all(Radius.circular(14))),
          padding: EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
          margin: EdgeInsets.only(
              left: myemail == Sender ? 60 : 4,
              right: myemail == Sender ? 4 : 60,
              top: 4,
              bottom: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Photo == ""
                  ? Container(width: 0, height: 0)
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewImage(Photo)));
                      },
                      child: Container(
                        height: 300,
                        // width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(Photo),
                          ),
                        ),
                      ),
                    ),
              Container(
                padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                child: Text(Message,
                    maxLines: 100,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

// alignment: Sender == uid
//                     ? Alignment.centerRight
//                     : Alignment.centerLeft,
  chatControls() {
    return Container(
      color: Color(0xff076482),
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              uploadImage();
            },
            child: Opacity(
              opacity: 1,
              child: Container(
                margin: EdgeInsets.only(left: 5, right: 10),
                padding: EdgeInsets.all(10),
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(
                  Icons.add_a_photo,
                  size: 22,
                  color: Color(0xff076482),
                ),
              ),
            ),
          ),
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
                setState(() {
                  message = value;
                });
                if (value == "" && chatController.text == "") {
                  Fluttertoast.showToast(
                      msg: "Message Cannot be Empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.purple,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  await FirebaseFirestore.instance
                      .collection('Chats')
                      .doc(roomId)
                      .collection('chat')
                      .doc(Timestamp.now().toString())
                      .set({
                    'Sender': myemail,
                    'Reciever': useremail,
                    'time': Timestamp.now().toString(),
                    'message': chatController.text,
                    'Photo': '',
                    'File': '',
                    'StringExtra': '',
                  }).then((type) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String mail = prefs.getString('email');
                    String createRoom = getRoomId(mail, useremail);
                    var collectionRef =
                        FirebaseFirestore.instance.collection('users');
                    var docu = await collectionRef.doc(useremail).get();
                    var mydocu = await collectionRef.doc(myemail).get();
                    // var users = await collectionRef.doc(emailCont.text).snapshots();
                    bool check = docu.exists;
                    var dc = docu.data();
                    var mydc = mydocu.data();
                    print(dc['name']);
                    print(mydc['name']);
                    await FirebaseFirestore.instance
                        .collection('ChatRoom')
                        .doc(useremail)
                        .collection('ChatList')
                        .doc(createRoom)
                        .set({
                      // 'Name': mydc['name'],
                      'Name': mydc['name'],
                      'Photo': mydc['photo'],
                      'Email': useremail,
                      'useremail': myemail,
                      'roomId': createRoom,
                      'lastMessage': chatController.text,
                      'check': false,
                      'time': Timestamp.now().toString(),
                    });
                    // FirebaseFirestore.instance
                    //     .collection('ChatRoom')
                    //     .doc(useremail)
                    //     .collection('ChatList')
                    //     .doc(roomId)
                    //     .set({
                    //   'lastMessage': value,
                    //   'check': false,
                    //   'time': Timestamp.now().toString(),
                    // });
                    // FirebaseFirestore.instance
                    //     .collection('ChatRoom')
                    //     .doc(useremail)
                    //     .collection('ChatList')
                    //     .doc(roomId)
                    //     .update({
                    //   'lastMessage': value,
                    //   'check': false,
                    //   'time': Timestamp.now().toString(),
                    // });
                    FirebaseFirestore.instance
                        .collection('ChatRoom')
                        .doc(myemail)
                        .collection('ChatList')
                        .doc(createRoom)
                        .set({
                      'Name': Name,
                      'Photo': Photo,
                      'Email': Email,
                      'useremail': useremail,
                      'roomId': createRoom,
                      'lastMessage': chatController.text,
                      'check': false,
                      'time': Timestamp.now().toString(),
                    }).then((value) async {
                      print('hi there');
                    });
                  }).then((value) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String mail = prefs.getString('email');
                    String createRoom = getRoomId(mail, useremail);
                    FirebaseFirestore.instance
                        .collection('ChatRoom')
                        .doc(useremail)
                        .collection('ChatList')
                        .doc(createRoom)
                        .update({
                      'lastMessage': message,
                      'check': false,
                      'time': Timestamp.now().toString(),
                    });
                  });

                  chatController.clear();
                }
              },
              style: styl,
              decoration: InputDecoration(
                hintText: 'Say Hi ...',
                hintStyle: styl,
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
                Fluttertoast.showToast(
                    msg: "Message Cannot be Empty",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                await FirebaseFirestore.instance
                    .collection('Chats')
                    .doc(roomId)
                    .collection('chat')
                    .doc(Timestamp.now().toString())
                    .set({
                  'Sender': myemail,
                  'Reciever': useremail,
                  'time': Timestamp.now().toString(),
                  'message': chatController.text,
                  'Photo': '',
                  'File': '',
                  'StringExtra': '',
                }).then((type) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String mail = prefs.getString('email');
                  String createRoom = getRoomId(mail, useremail);
                  var collectionRef =
                      FirebaseFirestore.instance.collection('users');
                  var docu = await collectionRef.doc(useremail).get();
                  var mydocu = await collectionRef.doc(myemail).get();
                  // var users = await collectionRef.doc(emailCont.text).snapshots();
                  bool check = docu.exists;
                  var dc = docu.data();
                  var mydc = mydocu.data();
                  print(dc['name']);
                  print(mydc['name']);
                  await FirebaseFirestore.instance
                      .collection('ChatRoom')
                      .doc(useremail)
                      .collection('ChatList')
                      .doc(createRoom)
                      .set({
                    // 'Name': mydc['name'],
                    'Name': mydc['name'],
                    'Photo': Photo,
                    'Email': useremail,
                    'useremail': myemail,
                    'roomId': createRoom,
                    'lastMessage': chatController.text,
                    'check': false,
                    'time': Timestamp.now().toString(),
                  });
                  // FirebaseFirestore.instance
                  //     .collection('ChatRoom')
                  //     .doc(useremail)
                  //     .collection('ChatList')
                  //     .doc(roomId)
                  //     .set({
                  //   'lastMessage': value,
                  //   'check': false,
                  //   'time': Timestamp.now().toString(),
                  // });
                  // FirebaseFirestore.instance
                  //     .collection('ChatRoom')
                  //     .doc(useremail)
                  //     .collection('ChatList')
                  //     .doc(roomId)
                  //     .update({
                  //   'lastMessage': value,
                  //   'check': false,
                  //   'time': Timestamp.now().toString(),
                  // });
                  FirebaseFirestore.instance
                      .collection('ChatRoom')
                      .doc(myemail)
                      .collection('ChatList')
                      .doc(createRoom)
                      .set({
                    'Name': Name,
                    'Photo': Photo,
                    'Email': Email,
                    'useremail': useremail,
                    'roomId': createRoom,
                    'lastMessage': chatController.text,
                    'check': false,
                    'time': Timestamp.now().toString(),
                  }).then((value) async {
                    print('hi there');
                  });
                }).then((value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String mail = prefs.getString('email');
                  String createRoom = getRoomId(mail, useremail);
                  FirebaseFirestore.instance
                      .collection('ChatRoom')
                      .doc(useremail)
                      .collection('ChatList')
                      .doc(createRoom)
                      .update({
                    'lastMessage': message,
                    'check': false,
                    'time': Timestamp.now().toString(),
                  });
                });

                chatController.clear();
              }
            },
            child: Opacity(
              opacity: 1,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.all(10),
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(
                  Icons.send,
                  size: 22,
                  color: Color(0xff076482),
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

void DialogBoxDelete(context, id, roomId) {
  var baseDialog = AlertDialog(
    title: new Text(
      "Delete Confirmation",
      style: styl,
    ),
    content: Container(
      child: Text(
        'You Really Want to Delete Message?',
        style: styl,
      ),
    ),
    actions: <Widget>[
      FlatButton(
        color: Colors.amber,
        child: new Text("Yes", style: styl),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('Chats')
              .doc(roomId)
              .collection('chat')
              .doc(id)
              .delete();
          Navigator.pop(context);
        },
      ),
    ],
  );

  showDialog(context: context, builder: (BuildContext context) => baseDialog);
}

void DialogBoxForeverDelete(context, roomId) {
  var baseDialog = AlertDialog(
    title: new Text(
      "Delete Confirmation",
      style: styl,
    ),
    content: Container(
      child: Text(
        'Delete All The Messages Permanently',
        style: styl,
      ),
    ),
    actions: <Widget>[
      FlatButton(
        color: Color(0xff076482),
        child: new Text("Yes", style: stylwhite),
        onPressed: () {
          print(roomId);
          FirebaseFirestore.instance
              .collection('Chats')
              .doc(roomId)
              .collection('chat')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });

          Navigator.pop(context);
        },
      ),
    ],
  );

  showDialog(context: context, builder: (BuildContext context) => baseDialog);
}
