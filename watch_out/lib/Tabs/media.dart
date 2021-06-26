import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watch_out/Screens/addFeed.dart';

class media extends StatefulWidget {
  const media({Key key}) : super(key: key);

  @override
  _mediaState createState() => _mediaState();
}

class _mediaState extends State<media> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF076482),

        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //         bottomLeft: Radius.circular(20),
        //         bottomRight: Radius.circular(20))),
        elevation: 0,

        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (Context) => Addfeed()));
          },
          child: Icon(
            Icons.add_circle_outline,
            size: 30,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Everyone Is Media',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        // actions: [
        //   GestureDetector(
        //     onTap: () {
        //       // Navigator.push(context,
        //       //     MaterialPageRoute(builder: (context) => chatpages()));
        //     },
        //     child: Container(
        //       margin: EdgeInsets.only(right: 20),
        //       child: Icon(
        //         Icons.chat_bubble,
        //         size: 25,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ],
        centerTitle: true,
        leadingWidth: 70,
      ),
      body: ListView(shrinkWrap: true, children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.83,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('News')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                  children: snapshot.data.docs.map<Widget>((documnet) {
                    return FeeD(documnet['location'], documnet['text'],
                        documnet['newsphoto']);
                  }).toList(),
                );
              }
            },
          ),
        ),
      ]),
    );
  }

  Widget FeeD(location, heading, photo) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 500,
          decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(photo))),
        ),
        Container(
          color: Colors.black54,
          width: MediaQuery.of(context).size.width,
          height: 500,
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10),
            height: 470,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.location_pin,
                              color: Colors.white, size: 20),
                        ),
                        TextSpan(
                          text: location,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    heading,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(2),
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: Colors.white70, shape: BoxShape.circle),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 40,
                    color: Colors.black,
                  ),
                )
              ],
            ))
      ],
    );
  }
}
