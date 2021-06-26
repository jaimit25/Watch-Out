import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:location/location.dart';
import 'package:watch_out/Navigation/navigation.dart';

class home extends StatefulWidget {
  // const home({ Key? key }) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  bool isObsecure = true;
  // File _image;
  bool isloading = false;
  bool userValid = false;
  var myLocation;
  double lat = 0, lng = 0;
  var Add = 'Address';
  var locality = "India";

  getUserLocation() async {
    //call this async method from whereever you need

    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    // currentLocation = myLocation;
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    print(myLocation.latitude);
    print(myLocation.longitude);
    setState(() {
      lat = myLocation.latitude;
      lng = myLocation.longitude;
    });
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    setState(() {
      locality = first.locality;
      print(locality);
      Add =
          ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}';
    });
    return first;
  }

  @override
  void initState() {
    super.initState();

    getUserLocation();
    // initializeFCM();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Text(
                          'Hi, ' + 'Jenna',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 5,
                          left: 20,
                        ),
                        // padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'Welcome Back',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 10,
                        right: 15,
                      ),
                      decoration: BoxDecoration(
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.grey[400],
                            blurRadius: 5.0,
                          ),
                        ],
                        color: Color(0xff076482),
                        shape: BoxShape.circle,
                      ),
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red[200],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      new BoxShadow(
                        offset: Offset.zero,
                        color: Colors.grey[400],
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        margin: EdgeInsets.only(top: 15),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/alarm.png'))),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          'Active Emergency',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white30),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        margin: EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              child: Icon(
                                Icons.location_pin,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(right: 5),
                              child: Text(
                                locality,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          'Your Location will be shared with security personnel and your Emergency Contacts!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 5, top: 10),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(color: Colors.green),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Text(
                            'Activate',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 205,
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 0),
                  decoration: BoxDecoration(
                    color: Color(0xff076482),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      new BoxShadow(
                        offset: Offset.zero,
                        color: Colors.grey[400],
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 20),
                        child: Text(
                          'Report Something Suspicious?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        // alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 15),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'See something out of place? Being Suspicious ? Feeling Unsafe? ...Share your Location With Your Emergency Contacts and have them watch over you.',
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 200,
                          height: 50,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 5, top: 10, left: 15),
                          decoration: BoxDecoration(
                              color: Color(0xffFFD5D5),
                              border: Border.all(color: Color(0xffFFD5D5)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            'Share Your Location',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xff076482),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 15, left: 20),
                  child: Text(
                    'Safety Tips',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Color(0xff076482),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  margin: EdgeInsets.only(top: 10, bottom: 5, left: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 90,
                            height: 90,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              // color: Color(0xff076482),
                              color: Colors.green[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),

                              boxShadow: [
                                new BoxShadow(
                                  offset: Offset.zero,
                                  color: Colors.grey[400],
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image:
                                        AssetImage('assets/images/house.png')),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 90,
                            height: 90,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              // color: Color(0xff076482),
                              color: Colors.red[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),

                              boxShadow: [
                                new BoxShadow(
                                  offset: Offset.zero,
                                  color: Colors.grey[400],
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image:
                                        AssetImage('assets/images/online.png')),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 90,
                            height: 90,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              // color: Color(0xff076482),
                              color: Colors.yellow[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),

                              boxShadow: [
                                new BoxShadow(
                                  offset: Offset.zero,
                                  color: Colors.grey[400],
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image:
                                        AssetImage('assets/images/party.png')),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 90,
                            height: 90,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              // color: Color(0xff076482),
                              color: Colors.blue[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),

                              boxShadow: [
                                new BoxShadow(
                                  offset: Offset.zero,
                                  color: Colors.grey[400],
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image:
                                        AssetImage('assets/images/shop.png')),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 90,
                            height: 90,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              // color: Color(0xff076482),
                              color: Colors.purple[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),

                              boxShadow: [
                                new BoxShadow(
                                  offset: Offset.zero,
                                  color: Colors.grey[400],
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image:
                                        AssetImage('assets/images/travel.png')),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 90,
                            height: 90,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              // color: Color(0xff076482),
                              color: Colors.teal[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),

                              boxShadow: [
                                new BoxShadow(
                                  offset: Offset.zero,
                                  color: Colors.grey[400],
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: AssetImage('assets/images/car.png')),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    width: double.infinity,
                    height: 250,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      // color: Color(0xff076482),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        new BoxShadow(
                          offset: Offset.zero,
                          color: Colors.grey[400],
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                            // color: Colors.grey[50],
                            // color: Color(0xffFFD5D5),
                            color: Color(0xff076482),
                          ),
                          width: 190,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                margin: EdgeInsets.only(left: 10, top: 10),
                                decoration: BoxDecoration(
                                    // shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/emergency.png'))),
                              ),
                              Container(
                                // width: 190,
                                // alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 15),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  'Emergency Contact',
                                  // textAlign: TextAlign.center,
                                  style: TextStyle(
                                    // color: Color(0xff076482),
                                    // color: Color(0xffFFD5D5),
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Container(
                                // width: 200,
                                // alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 15),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  'Add your Trusted Persons in Emergency contact. So, they can Help you in case of Emergency',
                                  // textAlign: TextAlign.center,
                                  style: TextStyle(
                                    // color: Color(0xff076482),
                                    // color: Color(0xffFFD5D5),
                                    color: Colors.white70,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage('assets/images/bg.png')),
                            color: Colors.white,
                          ),
                          width: 150,
                        )
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
