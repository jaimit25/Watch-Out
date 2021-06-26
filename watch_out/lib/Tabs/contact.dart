import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:watch_out/Tabs/home.dart';

class contact extends StatefulWidget {
  // const contact({ Key? key }) : super(key: key);

  @override
  _contactState createState() => _contactState();
}

class _contactState extends State<contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.view_list,
        backgroundColor: Color(0xff076482),
        children: [
          SpeedDialChild(
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            label: "Add product",
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => home()));
            },
          ),
          SpeedDialChild(
            child: Icon(
              Icons.turned_in_rounded,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            label: "My Products",
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => home()));
            },
          ),
          SpeedDialChild(
            child: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            backgroundColor: Colors.white,
            label: "Show Favourites",
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => home()));
            },
          ),
        ],
      ),
    );
  }
}
