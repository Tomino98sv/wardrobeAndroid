import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_app/bl/Pages/chatPage/chat.dart';
import 'package:flutter_app/db/FirestoreManager.dart';
import 'package:flutter_app/db/getItem.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserInfoList extends StatelessWidget{
  DocumentSnapshot userInfo;
  DocumentSnapshot itemInfo;
  FirebaseUser currentUser;
  double _imageHeight = 500.0;

  UserInfoList({@required this.userInfo, this.itemInfo, this.currentUser});

// ten list, ktory sa zobrazi ked si vyberiem borrow item
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('items').where("userId", isEqualTo: userInfo.data['uid']).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}', style:Theme.of(context).textTheme.subhead);
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(body: new Text('Loading...', style:Theme.of(context).textTheme.subhead));
          default:
            return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                title: Text(userInfo['name'], style: TextStyle(color: Colors.white)),
              ),
                 body: new Center(
                   child: Column(
                      children: <Widget>[
                        new Stack(
                          children: <Widget>[
                            _buildIamge(),
                            new Padding(
                              padding: new EdgeInsets.only(left: 16.0, top: _imageHeight / 20),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        image: DecorationImage(
                                            image: NetworkImage(userInfo.data['photoUrl']),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                        boxShadow: [
                                          BoxShadow(blurRadius: 7.0, color: Theme.of(context).buttonColor)
                                        ]
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "User name: ",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only(right: 10.0),),
                                      Text(
                                        userInfo.data['name'],
                                        style: TextStyle(
                                          fontSize:17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "User email: ",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only(right: 10.0),),
                                      Text(
                                        userInfo.data['email'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),]
                                  ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "Item: ",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.only(right: 10.0),),
                                          Text(
                                            itemInfo.data['name'],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                  Container(
                                    margin: EdgeInsets.only(left: 270.0,right: 20.0),
                                      child: FloatingActionButton(
                                        child: Icon(Icons.check),
                                          shape: _DiamondBorder(),
                                          onPressed: (){
                                          if (itemInfo.data['borrowedTo'] == ""  || itemInfo.data['borrowedTo'] == null) {
                                          itemInfo.data['borrowedTo'] = userInfo.data['uid'];
                                          itemInfo.data['borrowName'] = userInfo.data['name'];
                                          Firestore.instance.collection('items')
                                              .document(itemInfo.documentID)
                                              .updateData({
                                            "borrowedTo": itemInfo.data['borrowedTo'],
                                            "borrowName": itemInfo.data['borrowName']
                                          });
                                          debugPrint(itemInfo.data['borrowedTo']);
                                          debugPrint(itemInfo.data['borrowName']);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                        else {
                                          Firestore.instance.collection('items')
                                              .document(itemInfo.documentID)
                                              .updateData({
                                            "borrowedTo": "",
                                            "borrowName": ""
                                          });
                                          Navigator.pop(context);
                                        }}) ,
                                  )
                                    ],
                                  ),),
                                ],
                              ),
                        Text('User\'s items: '),
                        Expanded(
                          child: Container(
                            height: 200.0,
                              child: GridView.count(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 8.0),
                                crossAxisCount: 3,
                                crossAxisSpacing: 12.0,
                                mainAxisSpacing: 12.0,
                                shrinkWrap: true,
                                children: snapshot.data.documents.map((DocumentSnapshot document) {
                                  Item item = Item(
                                    name: document['name'],
                                    color: document['color'],
                                    size: document['size'],
                                    length: document['length'],
                                    photoUrl: document['photo_url'],
                                    id: document.documentID,
                                    borrowName: document['borrowName'],
                                    description: document['description'],
                                  );
                                  return GestureDetector(
                                    child: Material(
                                      color: Colors.white,
                                      shadowColor: Colors.grey,
                                      elevation: 14.0,
                                      borderRadius: BorderRadius.circular(24.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: <Widget>[
                                            item.photoUrl == null ||
                                                item.photoUrl == ""
                                                ? Icon(Icons.broken_image)
                                                : CachedNetworkImage(
                                              imageUrl: item.photoUrl,
                                              fit: BoxFit.cover,
                                              alignment: Alignment.topLeft,
                                              placeholder: (context,
                                                  imageUrl) =>
                                                  CircularProgressIndicator(),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                width: double.maxFinite,
                                                height: 26.0,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.0, horizontal: 16.0),
                                                color: Color(0x66000000),
                                                alignment: Alignment.bottomCenter,
                                                child: Text(
                                                  document['name'],
                                                  style:
                                                  TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
//                        }
//                      else
//                        return Container();
                                }).toList(),
                              )
//                            child: ListView(
//                                children:
//                                snapshot.data.documents.map((DocumentSnapshot document){
//                                  return Slidable(
//                                    delegate: SlidableDrawerDelegate(),
//                                    actionExtentRatio: 0.25,
//                                    child: ExpansionTile(
//                                      leading: Container(
//                                          width: 46.0,
//                                          height: 46.0,
//                                          child: document['photo_url'] == null || document['photo_url'] == ""
//                                              ? Icon(Icons.broken_image)
//                                              : TransitionToImage(
//                                            image: AdvancedNetworkImage(
//                                              document['photo_url'],
//                                              useDiskCache: true,
//                                              cacheRule:
//                                              CacheRule(maxAge: const Duration(days: 7)),
//                                            ),
//                                          )
//                                      ),
//                                      title: Text(document['name'], style:Theme.of(context).textTheme.subhead),
//                                      children: <Widget>[
//                                        Text('Name: ${document['name']}',style:Theme.of(context).textTheme.subhead),
//                                        Text('Color: ${document['color']}',style:Theme.of(context).textTheme.subhead),
//                                        Text('Size: ${document['size']}', style:Theme.of(context).textTheme.subhead),
//                                        Text('Length: ${document['length']}', style:Theme.of(context).textTheme.subhead),
//                                      ],
//                                    ),
//                                  );
//                                }).toList()
//                            ),
                          ),
                        ),
                          ],
                        ),
                 ),
            );
      }});
  }
  Widget _buildIamge() {
    return new ClipPath(
      clipper: new DialogonalClipper(),
      child: new Image.asset(
        'assets/images/biela.jpg',
        fit: BoxFit.fitWidth,
//        height: _imageHeight,
      ),
    );
  }


}
class _DiamondBorder extends ShapeBorder {
  const _DiamondBorder();

  @override
  EdgeInsetsGeometry get dimensions {
    return const EdgeInsets.only();
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection textDirection }) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection textDirection }) {
    return Path()
      ..moveTo(rect.left + rect.width / 2.0, rect.top)
      ..lineTo(rect.right, rect.top + rect.height / 2.0)
      ..lineTo(rect.left + rect.width  / 2.0, rect.bottom)
      ..lineTo(rect.left, rect.top + rect.height / 2.0)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection textDirection }) {}

  // This border doesn't support scaling.
  @override
  ShapeBorder scale(double t) {
    return null;
  }
}

class UserInfoList2 extends StatefulWidget{

  DocumentSnapshot userInfo;
  UserInfoList2({@required this.userInfo});
  _UserInfoList2 createState() {
    return _UserInfoList2(userInfo: userInfo);
  }

}

// list userov (5.screen) a owner details
class _UserInfoList2 extends State<UserInfoList2>{
  DocumentSnapshot userInfo;
  double _imageHeight = 500.0;

  _UserInfoList2({@required this.userInfo});
  FirebaseUser curUser;
  var userName;

@override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((value){

      setState(() {
        curUser=value;
        Stream<QuerySnapshot> snapshot = Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: curUser.uid)
            .snapshots();
        snapshot.listen((QuerySnapshot data) {
          userName = data.documents[0]['name'];
          debugPrint("${userName}");
        });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('items').where("userId", isEqualTo: userInfo.data['uid']).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}', style:Theme.of(context).textTheme.subhead);
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Scaffold(body: new Text('Loading...', style:Theme.of(context).textTheme.subhead));
            default:
              return Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Colors.white),
                  title: Text(userInfo['name'], style:TextStyle(color: Colors.white)),
                ),
                body:
               new Center(
                 child: new Column(
                   children: <Widget>[
                   new Stack(
                       children: <Widget>[
                         _buildIamge(),
                         new Padding(
                           padding: new EdgeInsets.only(left: 16.0, top: _imageHeight / 10),
                           child: Column(
                                 children: <Widget>[
                                   Container(
                                     width: 100.0,
                                     height: 100.0,
                                     decoration: BoxDecoration(
                                         color: Theme.of(context).accentColor,
                                         image: DecorationImage(
                                             image: NetworkImage(userInfo.data['photoUrl']),
                                             fit: BoxFit.cover),
                                         borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                         boxShadow: [
                                           BoxShadow(blurRadius: 7.0, color:Theme.of(context).buttonColor)
                                         ]
                                     ),
                                   ),
                                   Padding(padding: EdgeInsets.only(bottom: 5.0),),
                                   Row(
                                     children: <Widget>[
                                       Text(
                                           "User name: ",
                                         style: TextStyle(
                                           fontSize: 15.0,
                                           color: Colors.black,
                                           fontWeight: FontWeight.w400,
                                         ),
                                         ),
                                       Padding(padding: EdgeInsets.only(right: 10.0,bottom: 5.0),),
                                       Text(
                                           userInfo.data['name'],
                                         style: TextStyle(
                                           fontSize: 17.0,
                                           color: Colors.black,
                                           fontWeight: FontWeight.w400,
                                         ),
                                         ),
                                     ],
                                   ),
                                   Row(
                                     children: <Widget>[
                                        Text(
                                           "User email: ",
                                       textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                         ),
                                        Padding(padding: EdgeInsets.only(right: 10.0,bottom: 5.0),),
                                        Text(
                                           userInfo.data['email'],
                                           textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                         ),
                                     ],
                                   ),
                                   Padding(padding: EdgeInsets.only(top: 10.0),),
                                   Container(
                                     margin: EdgeInsets.only(left: 290.0, right: 5.0,bottom: 15.0),
                                     child: FloatingActionButton(
                                         child: Icon(Icons.message),
                                         shape: _DiamondBorder(),
                                         onPressed: () {
                                           Navigator.push(
                                               context,
                                               MaterialPageRoute(builder: (context) => ChatPage(userInfo.data["email"])
                                               ));
                                         }),
                                   ),
                                 ],
                               ),
                           ),
                       ],
                     ),
//                   Container(
//                     margin: EdgeInsets.only(left: 290.0, right: 5.0,bottom: 15.0),
//                     child: FloatingActionButton(
//                         child: Icon(Icons.message),
//                         shape: _DiamondBorder(),
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => ChatPage(userInfo.data["email"])
//                               ));
//                         }),
//                   ),
                     Text('User\'s items: ',),
                     Container(
                       child: Expanded(
                           child: GridView.count(
                               crossAxisCount: 3,
                               crossAxisSpacing: 12.0,
                               mainAxisSpacing: 12.0,
                               padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 8.0),
                               shrinkWrap: true,
                               children: snapshot.data.documents.map((DocumentSnapshot document)  {
                                 return GestureDetector(
                                   child: Material(
                                       color: Colors.white,
                                       shadowColor: Colors.grey,
                                       elevation:14.0,
                                       borderRadius: BorderRadius.circular(24.0),
                                       child: Container(
                                           child: ClipRRect(
                                               borderRadius: BorderRadius.circular(10.0),
                                             child: Stack(
                                               fit: StackFit.expand,
                                               children: <Widget>[
                                                 document["photo_url"] == null || document["photo_url"] == ""
                                                     ? Icon(Icons.broken_image)
                                                     : CachedNetworkImage(
                                                   imageUrl: document["photo_url"],
                                                   fit: BoxFit.cover,
                                                   alignment: Alignment.topLeft,
                                                   placeholder: (context, imageUrl) =>
                                                       CircularProgressIndicator(),
                                                 ),
                                                 Align(
                                                   alignment: Alignment.bottomCenter,
                                                   child: Container(
                                                     width: double.maxFinite,
                                                     height: 26.0,
                                                     padding: EdgeInsets.symmetric(
                                                         vertical: 4.0, horizontal: 16.0),
                                                     color: Color(0x66000000),
                                                     alignment: Alignment.bottomCenter,
                                                     child: Text(
                                                       document['name'],
                                                       style: TextStyle(color: Colors.white),
                                                     ),
                                                   ),
                                                 )

                                               ],
                                             ),



                                           )
                                       )
                                   ),
                                   onTap: (){
                                     showDialog(
                                         context: context,
                                         barrierDismissible: false,
                                         child: CupertinoAlertDialog(
                                           title: Text(document['name']),
                                           content: Column(
                                             mainAxisAlignment: MainAxisAlignment.center,
                                             children: <Widget>[
                                               CachedNetworkImage(
                                                 imageUrl: document['photo_url'],
                                                 placeholder: (context, imageUrl) =>
                                                     CircularProgressIndicator(),
                                               ),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                 children: <Widget>[
                                                   Text("About:  "),
                                                   Text(document['description']),
                                                 ],
                                               ),
                                             ],
                                           ),
                                           actions: <Widget>[
                                             Row(
                                               children: <Widget>[
                                                 FlatButton(
                                                   onPressed: (){
                                                     Navigator.push(context,
                                                         MaterialPageRoute(builder: (context) {
                                                           return ShowDetails(item: document, user: curUser, userName: userName);
                                                         }));
                                                   },
                                                   child: Text("Get"),
                                                 ),
                                                 FlatButton(
                                                   onPressed: () {
                                                     Navigator.pop(context);
                                                   },
                                                   child: Text("Cancel"),
                                                 )
                                               ],
                                             )
                                           ],
                                         )
                                     );
                                   },
                                 );
                               }).toList()),

                       ),
                       ),









//                       height: 250,
//                         child: ListView(
//                             children:
//                             snapshot.data.documents.map((DocumentSnapshot document){
//                               return Slidable(
//                                 delegate: SlidableDrawerDelegate(),
//                                 actionExtentRatio: 0.25,
//                                 child: ExpansionTile(
//                                   leading: Container(
//                                       width: 46.0,
//                                       height: 46.0,
//                                       child: document['photo_url'] == null || document['photo_url'] == ""
//                                           ? Icon(Icons.broken_image)
//                                           : TransitionToImage(
//                                         image: AdvancedNetworkImage(
//                                           document['photo_url'],
//                                           useDiskCache: true,
//                                           cacheRule:
//                                           CacheRule(maxAge: const Duration(days: 7)),
//                                         ),
//                                       )
//                                   ),
//                                   title: Text(document['name'], style:Theme.of(context).textTheme.subhead),
//                                   children: <Widget>[
//                                     Text('Name: ${document['name']}', style:Theme.of(context).textTheme.subhead),
//                                     Text('Color: ${document['color']}', style:Theme.of(context).textTheme.subhead),
//                                     Text('Size: ${document['size']}',style:Theme.of(context).textTheme.subhead),
//                                     Text('Length: ${document['length']}',style:Theme.of(context).textTheme.subhead),
//                                   ],
//                                 ),
//                               );
//                             }).toList()
//                         ),

                   ],
                 ),
               ),);
          }});
  }
  Widget _buildIamge() {
    return new ClipPath(
      clipper: new DialogonalClipper(),
      child: new Image.asset(
        'assets/images/biela.jpg',
        fit: BoxFit.fitWidth,
//        height: _imageHeight,
      ),
    );
  }
}



class DialogonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height - 60.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}



