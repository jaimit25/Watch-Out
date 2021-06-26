import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double CAMERA_ZOOM = 18;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(19.2798547, 72.8740709);
String iconb = 'assets/images/checkpt.png';
String icona = 'assets/images/bus.png';
String iconc = 'assets/images/destination_map_marker.png';

class MapPageTrack extends StatefulWidget {
  // String email;
  // MapPage({@required this.email});
  @override
  // State<StatefulWidget> createState() =>
  //     MapPageState(email: this.email);
  State<StatefulWidget> createState() => MapPageTrackState();
}

class MapPageTrackState extends State<MapPageTrack> {
  // String useremail;
  // MapPageState({@required this.email});

  PolylinePoints polylinePoints;
// List of coordinates to join
  List<LatLng> polylineCoordinates = [];

// Map storing polylines created by connecting
// two points
  Map<PolylineId, Polyline> polylines = {};
  LatLng DRIVER_LOCATION = LatLng(20.5937, 78.9629);
  double lat = 20.5937, lng = 78.9629;
  Completer<GoogleMapController> _controller = Completer();
  // this set will hold my markers
  Set<Marker> _markers = {};
  // this will hold the generated polylines
  Set<Polyline> _polylines = {};

  String googleAPIKey = "AIzaSyDfgqTqhA1NkD8KzwgIS6Z0nNwL2JV-cuQ";
  // for my custom icons
  BitmapDescriptor sourceIcon;
  BitmapDescriptor driverIcon;
  var Data;
  var _mapController;
  BitmapDescriptor destinationIcon;
  BitmapDescriptor checkicon;
  var typ = 1;
  bool follow = false;
  bool traffic = false;
  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
    // setPolylines();
    const fiveSeconds = const Duration(seconds: 2);
    // _fetchData() is your function to fetch data

    Timer.periodic(fiveSeconds, (timer) {
      setMapPins();
    });

    // Timer.periodic(fiveSeconds, (Timer t) async {
    //   setMapPins();
    //   print('called');
    //   _mapController.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
    //   PointLatLng a = PointLatLng(lat, lng);
    //   PointLatLng b = PointLatLng(19.3505548, 72.9166332);
    //   // _createPolylines(a, b);
    // });
    // Data = FirebaseFirestore.instance.collection(location + busval).snapshots();

    // Data = FirebaseFirestore.instance
    //     .collection(location)
    //     // .doc(busval)
    //     // .collection(location)
    //     // .doc(busval)
    //     .snapshots();
  }

  void setSourceAndDestinationIcons() async {
    driverIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), icona);
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), iconb);
    checkicon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), iconb);

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), iconc);
  }

  followcamera() {
    const fiveSeconds = const Duration(seconds: 2);
    Timer.periodic(fiveSeconds, (Timer t) async {
      setMapPins();
      print('called');
      if (follow) {
        _mapController.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
        PointLatLng a = PointLatLng(lat, lng);
        PointLatLng b = PointLatLng(19.3505548, 72.9166332);
      } else {
        t.cancel();
      }
      // _createPolylines(a, b);
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: SOURCE_LOCATION);
    return GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        tiltGesturesEnabled: false,
        markers: _markers,
        polylines: _polylines,
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        onMapCreated: onMapCreated);
  }

  // @override
  // Widget build(BuildContext context) {
  //   CameraPosition initialLocation = CameraPosition(
  //       zoom: CAMERA_ZOOM,
  //       bearing: CAMERA_BEARING,
  //       tilt: CAMERA_TILT,
  //       target: SOURCE_LOCATION);
  //   return SafeArea(
  //     child: Stack(
  //       children: [
  //         Container(
  //           child: StreamBuilder(
  //             stream: FirebaseFirestore.instance
  //                 .collection('')
  //                 .doc('location')
  //                 .snapshots(),
  //             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //               if (!snapshot.hasData) {
  //                 return Center(
  //                   child: CircularProgressIndicator(),
  //                 );
  //               } else {
  //                 var doc = snapshot.data;
  //                 DRIVER_LOCATION = LatLng(doc['latitude'], doc['longitude']);
  //                 lat = doc['latitude'];
  //                 lng = doc['longitude'];
  //                 CameraPosition initialLocation = CameraPosition(
  //                   zoom: CAMERA_ZOOM,
  //                   bearing: CAMERA_BEARING,
  //                   tilt: CAMERA_TILT,
  //                   target: LatLng(doc['latitude'], doc['longitude']),
  //                 );
  //                 return Container(
  //                   height: MediaQuery.of(context).size.height,
  //                   width: MediaQuery.of(context).size.width,
  //                   child: GoogleMap(
  //                       myLocationEnabled: true,
  //                       rotateGesturesEnabled: true,
  //                       trafficEnabled: traffic,
  //                       buildingsEnabled: true,
  //                       compassEnabled: true,
  //                       tiltGesturesEnabled: true,
  //                       markers: _markers,
  //                       // polylines: _polylines,
  //                       polylines: Set<Polyline>.of(polylines.values),
  //                       // mapType: MapType.normal,
  //                       mapType: maptyp(typ),

  //                       // onCameraMove: (),
  //                       initialCameraPosition: initialLocation,
  //                       onMapCreated: onMapCreated),
  //                 );
  //               }
  //             },
  //           ),
  //         ),
  //         Container(
  //           padding: EdgeInsets.all(20),
  //           child: Align(
  //             alignment: Alignment.topRight,
  //             // right: 10,
  //             child: Column(
  //               children: [
  //                 FloatingActionButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       if (typ == 3) {
  //                         typ = 1;
  //                       } else {
  //                         typ++;
  //                       }
  //                     });
  //                   },
  //                   backgroundColor: Color(0xff19196f),
  //                   child: Icon(
  //                     Icons.map_outlined,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 FloatingActionButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       follow = !follow;
  //                     });
  //                     followcamera();
  //                   },
  //                   backgroundColor: Color(0xff19196f),
  //                   child: Icon(
  //                     follow ? Icons.no_transfer : Icons.directions_bus,
  //                     color: follow ? Colors.white : Colors.white,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 FloatingActionButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       traffic = !traffic;
  //                     });
  //                   },
  //                   backgroundColor: Color(0xff19196f),
  //                   child: Icon(
  //                     traffic ? Icons.edit_road : Icons.traffic,
  //                     color: traffic ? Colors.white : Colors.white,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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

  Widget GooglePage(var latp, var lonp) {
    DRIVER_LOCATION = LatLng(latp, lonp);
    lat = latp;
    lng = lonp;

    CameraPosition initialLocation = CameraPosition(
      zoom: CAMERA_ZOOM,
      bearing: CAMERA_BEARING,
      tilt: CAMERA_TILT,
      target: LatLng(latp, lonp),
    );

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
          myLocationEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: false,
          markers: _markers,
          // polylines: _polylines,
          polylines: Set<Polyline>.of(polylines.values),
          mapType: MapType.normal,
          // onCameraMove: (),
          initialCameraPosition: initialLocation,
          onMapCreated: onMapCreated),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    // controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);
    setMapPins();

    setState(() {
      _mapController = controller;
      _mapController.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
    });
  }

  void setMapPins() {
    setState(() {
      // _mapController.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));

      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: SOURCE_LOCATION,
          icon: sourceIcon));
      _markers.add(Marker(
          markerId: MarkerId('driverPin'),
          position: DRIVER_LOCATION,
          icon: driverIcon));
      // destination pin
      //   _markers.add(Marker(
      //       markerId: MarkerId('destPin'),
      //       position: DEST_LOCATION,
      //       icon: destinationIcon));

      //   _markers.add(Marker(
      //       markerId: MarkerId('Bus Top'),
      //       position: CHECK_POINT1,
      //       icon: checkicon));
    });
  }
}
