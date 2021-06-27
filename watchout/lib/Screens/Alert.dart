import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watchout/Authentication/splash.dart';
import 'package:watchout/Map/MapPageTrack.dart';

class Alert extends StatefulWidget {
  @override
  _AlertState createState() => _AlertState();
}

// FFD5D5
//076482
class _AlertState extends State<Alert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff076482),
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Alert').snapshots(),
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
                  document['address'],
                  document['email'],
                  document['lat'],
                  document['lng'],
                  document['phone'],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  Tile(name, address, email, double lat, double lng, phone) {
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
                address,
                maxLines: 20,
                overflow: TextOverflow.ellipsis,
                style: styl,
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
              height: 60,
              child: Row(
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     print('Send message');
                  //     Fluttertoast.showToast(
                  //         msg: "Message Sent",
                  //         toastLength: Toast.LENGTH_SHORT,
                  //         gravity: ToastGravity.SNACKBAR,
                  //         timeInSecForIosWeb: 2,
                  //         backgroundColor: Colors.black,
                  //         textColor: Colors.white,
                  //         fontSize: 16.0);
                  //   },
                  //   child: Container(
                  //     margin:
                  //         EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  //     height: 40,
                  //     width: 150,
                  //     decoration: BoxDecoration(
                  //         color: Color(0xff076482),
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: Center(
                  //       child: Text(
                  //         'Notify When Safe',
                  //         style: stylwhite,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {
                      print('Track User');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapPage(
                                    useremail: email,
                                  )));
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Color(0xff076482),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'Track User',
                          style: stylwhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SingleTile('Latitude  : ', '${lat}'),
                SingleTile('Longitude : ', '${lng}')
              ],
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

  void DialogBoxLogOut(context) {
    var baseDialog = AlertDialog(
      title: new Text(
        "Logout",
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Container(
        child: Text('Are you sure you want to logout?'),
      ),
      actions: <Widget>[
        FlatButton(
          color: Color(0xff076482),
          child: new Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            await pref.clear();
            // FirebaseAuth.instance.signOut();
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SplashScreen()));
            // FlutterRestart.restartApp();
            // SystemNavigator.pop();
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }
}

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
