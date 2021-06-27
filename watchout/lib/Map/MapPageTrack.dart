import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchout/Tabs/Doctor.dart';

const double CAMERA_ZOOM = 18;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
String iconb = 'assets/images/checkpt.png';

class MapPage extends StatefulWidget {
  var useremail;
  MapPage({@required this.useremail});

  @override
  State<StatefulWidget> createState() => MapPageState(useremail: useremail);
}

class MapPageState extends State<MapPage> {
  var useremail;
  MapPageState({@required this.useremail});

  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  // LatLng USERLOCATION = LatLng(20.5937, 78.9629);
  LatLng USERLOCATION;
  //  = LatLng(19.2856, 72.8691);
  // LatLng SOURCE_LOCATION = LatLng(20.5937, 78.9629);
  LatLng SOURCE_LOCATION = LatLng(19.2856, 72.8691);
  double lat = 0, lng = 0;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  String googleAPIKey = "AIzaSyAt07QXD3BGWgWZCh15Rm122EvnH_aUg9I";

  // BitmapDescriptor sourceIcon;
  // BitmapDescriptor driverIcon;
  var _mapController;
  BitmapDescriptor destinationIcon;
  BitmapDescriptor usericon;
  var typ = 1;
  bool follow = false;
  bool traffic = false;
  var colr = Color(0xff076482);
  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();

    const fiveSeconds = const Duration(seconds: 2);
    Timer.periodic(fiveSeconds, (timer) {
      setMapPins();
    });
  }

  void setSourceAndDestinationIcons() async {
    usericon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), iconb);
  }

  followcamera() {
    const fiveSeconds = const Duration(seconds: 2);
    Timer.periodic(fiveSeconds, (Timer t) async {
      setMapPins();
      print('called');
      if (follow) {
        _mapController.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
        setMapPins();
      } else {
        t.cancel();
      }
      // _createPolylines(a, b);
    });
  }

  @override
  Widget build(BuildContext context) {
    onWillPop() {
      Navigator.pop(context);
    }

    CameraPosition initialLocation = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: SOURCE_LOCATION);

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Color(0xff076482), title: Text('Watch Out')),
          body: Stack(
            children: [
              Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(useremail)
                      .snapshots(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      var doc = snapshot.data;

                      // setState(() {
                      doc = snapshot.data;
                      USERLOCATION = LatLng(doc['lat'], doc['lng']);
                      lat = doc['lat'];
                      lng = doc['lng'];
                      // });
                      // setMapPins();
                      CameraPosition initialLocation = CameraPosition(
                        zoom: CAMERA_ZOOM,
                        bearing: CAMERA_BEARING,
                        tilt: CAMERA_TILT,
                        target: LatLng(doc['lat'], doc['lng']),
                      );
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: GoogleMap(
                            myLocationEnabled: true,
                            rotateGesturesEnabled: true,
                            trafficEnabled: traffic,
                            buildingsEnabled: true,
                            compassEnabled: true,
                            tiltGesturesEnabled: true,
                            markers: _markers,
                            // polylines: _polylines,
                            polylines: Set<Polyline>.of(polylines.values),
                            // mapType: MapType.normal,
                            mapType: maptyp(typ),

                            // onCameraMove: (),
                            initialCameraPosition: initialLocation,
                            onMapCreated: onMapCreated),
                      );
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.topRight,
                  // right: 10,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            if (typ == 3) {
                              typ = 1;
                            } else {
                              typ++;
                            }
                          });
                        },
                        backgroundColor: colr,
                        child: Icon(
                          Icons.map_outlined,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            follow = !follow;
                          });
                          followcamera();
                        },
                        backgroundColor: colr,
                        child: Icon(
                          follow ? Icons.no_transfer : Icons.directions_bus,
                          color: follow ? Colors.white : Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            traffic = !traffic;
                          });
                        },
                        backgroundColor: colr,
                        child: Icon(
                          traffic ? Icons.edit_road : Icons.traffic,
                          color: traffic ? Colors.white : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onWillPop: onWillPop);
  }

  MapType maptyp(int a) {
    switch (a) {
      case 1:
        return MapType.normal;
        break;
      case 2:
        return MapType.hybrid;
        break;
      case 3:
        return MapType.terrain;
        break;
      default:
        return MapType.normal;
        break;
    }
  }

  void onMapCreated(GoogleMapController controller) {
    // controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);
    setMapPins();
    // setPolylines();
    setState(() {
      _mapController = controller;
      _mapController.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
    });
  }

  void setMapPins() {
    setState(() {
      // _mapController.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
      _markers.add(Marker(
          markerId: MarkerId('driverPin'),
          position: USERLOCATION,
          icon: usericon));
      // destination pin
    });
  }
}
