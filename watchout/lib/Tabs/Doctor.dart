import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watchout/Authentication/splash.dart';
import 'package:watchout/Screens/DoctoAsk.dart';
import 'package:watchout/Screens/PreviousAnswer.dart';

class Doctor extends StatefulWidget {
  @override
  _DoctorState createState() => _DoctorState();
}

Color colr = Color(0xff076482);
Color colra = Color(0xff076482);

class _DoctorState extends State<Doctor> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Color(0xff076482),
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
                // onSelected: (route) {
                //   print(route);
                //   // Note You must create respective pages for navigation
                //   Navigator.push(context,
                //       MaterialPageRoute(builder: (context) => SplashScreen()));
                // },
              ),
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 4.0,
              physics: BouncingScrollPhysics(),
              tabs: [
                Tab(
                    child: Text(
                  'Ask',
                  style: txts,
                )),
                Tab(
                    child: Text(
                  'Previous Answer',
                  style: txts,
                )),
              ],
            ),
            title: Text(
              'Watch Out',
              style: txts,
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: DoctorAsk(),
              ),
              Center(
                child: PreviousAnswer(),
              )
            ],
          ),
        ),
      ),
    );
  }
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SplashScreen()));
          // FlutterRestart.restartApp();
          // SystemNavigator.pop();
        },
      ),
    ],
  );

  showDialog(context: context, builder: (BuildContext context) => baseDialog);
}

TextStyle txts = TextStyle(
  color: Colors.white,
  fontSize: 17,
);

// Fluttertoast.showToast(
//                           msg: "Message Sent",
//                           toastLength: Toast.LENGTH_SHORT,
//                           gravity: ToastGravity.SNACKBAR,
//                           timeInSecForIosWeb: 2,
//                           backgroundColor: Colors.black,
//                           textColor: Colors.white,
//                           fontSize: 16.0);

TextStyle txtsblack = TextStyle(
  color: Colors.black,
  fontSize: 15,
);
