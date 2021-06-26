import 'package:flutter/material.dart';

class ChatNearBy extends StatefulWidget {
  @override
  _ChatNearByState createState() => _ChatNearByState();
}

// FFD5D5
//076482

class _ChatNearByState extends State<ChatNearBy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          FriendList(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1H81w4SmKH5DZmIbxU7EB0aMSkNQDoPQA1mRQxf2Y0wMF1NSa7vghbwwKASi1q4NPmNw&usqp=CAU',
              '9019213139',
              'Name'),
          FriendList(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1H81w4SmKH5DZmIbxU7EB0aMSkNQDoPQA1mRQxf2Y0wMF1NSa7vghbwwKASi1q4NPmNw&usqp=CAU',
              '9019213139',
              'Name'),
          FriendList(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1H81w4SmKH5DZmIbxU7EB0aMSkNQDoPQA1mRQxf2Y0wMF1NSa7vghbwwKASi1q4NPmNw&usqp=CAU',
              '9019213139',
              'Name'),
          FriendList(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1H81w4SmKH5DZmIbxU7EB0aMSkNQDoPQA1mRQxf2Y0wMF1NSa7vghbwwKASi1q4NPmNw&usqp=CAU',
              '9019213139',
              'Name'),
        ],
      ),
    );
  }

  Widget FriendList(String userimg, String phone, String name) {
    return MaterialButton(
      onPressed: () {},
      hoverColor: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          margin: EdgeInsets.only(top: 10, left: 10),
          height: 70,
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
                      phone,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    width: 150,
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
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
}
// FFD5D5
//076482

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
  fontSize: 16,
);
