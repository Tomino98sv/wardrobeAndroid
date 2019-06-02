import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/menu.dart';
import 'package:flutter_app/bl/Pages/wardrobeTabbar.dart';
import 'package:flutter_app/db/FirestoreManager.dart';
import 'package:flutter_app/db/editItem.dart';
import 'package:flutter_app/db/model/Item.dart';
import 'package:firebase_storage/firebase_storage.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {

  FirebaseUser user2;
  double _imageHeight = 248.0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        user2 = fUser;
        Stream<QuerySnapshot> snapshot = Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: user2.uid)
            .snapshots();
      });
    });
    _tabController = new TabController(length: 3, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
//     stream: Firestore.instance.collection('items').where("userId", isEqualTo: user2.uid).snapshots(),
            stream: Firestore.instance.collection('items').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...',style:Theme.of(context).textTheme.subhead);
                default:
                  return new Column(
                    children: <Widget>[
                      new Stack(
                        children: <Widget>[
                          _buildIamge(),
                          new Padding(
                            padding: new EdgeInsets.only(
                                left: 30.0,top: 2.0),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection('users')
                                  .where('uid', isEqualTo: user2.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return Text("Loading data ... wait please",style:Theme.of(context).textTheme.subhead);
                                return Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          snapshot.data.documents[0]['name'],
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 5.0),
                                        ),
                                        Text(
                                          snapshot.data.documents[0]['email'],
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 55.0),
                                    ),
                                    AnimatedFab(),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.maxFinite,
                        child: WardrobeTabBar(
                          tabController: _tabController,
                        ),
                      ),
                      Expanded(
                          child: Stack(
                            children: <Widget> [

                              TabBarView(
                                controller: _tabController, children: <Widget>[
                              GridView.count(
                                crossAxisCount: 3,
                                  crossAxisSpacing: 12.0,
                                  mainAxisSpacing: 12.0,
                                  padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 8.0),
                                  shrinkWrap: true,
                                  children: snapshot.data.documents
                                      .where((doc) => doc['borrowedTo'] == "")
                                      .where((doc) => doc['userId'] == user2.uid)
                                      .map((DocumentSnapshot document) {
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
                                                        Text("About:  ",style: TextStyle(color: Colors.black)),
                                                        Text(document["description"], style: TextStyle(color: Colors.black),),
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
                                                            MaterialPageRoute(
                                                                builder: (context) {
                                                                  return EditItem(item: document);
                                                                }));
                                                        debugPrint("idem dalej");
                                                        },
                                                        child: Text("Edit",style: TextStyle(color: Colors.black)),
                                                      ),
                                                      FlatButton(
                                                        onPressed: (){
                                                          Navigator.push(context,
                                                              MaterialPageRoute(
                                                                  builder: (context) {
                                                                    return UserList(item: document, user: user2);
                                                                  }));
                                                        },
                                                        child: Text("Borrow",style: TextStyle(color: Colors.black)),
                                                      ),
                                                      FlatButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text("Cancel",style: TextStyle(color: Colors.black)),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )
                                          );
                                        },
                                        onLongPress: (){
                                          return showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Delete Item',style: TextStyle(color: Colors.black)),
                                                content: Text(
                                                    'Are you sure you want to delete this item?',style: TextStyle(color: Colors.black)),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('Yes'),
                                                    onPressed: () {
                                                      Firestore.instance
                                                          .collection('items')
                                                          .document(document.documentID)
                                                          .delete();
                                                      Navigator.pop(context);
                                                      deleteFireBaseStorageItem(
                                                          document['photoUrl']);
                                                      debugPrint("vymazanee");
                                                    },
                                                  ),
                                                  FlatButton(
                                                    child: Text('Cancel',style: TextStyle(color: Colors.black)),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );

                                  }).toList()),
                              //second tab
                              GridView.count(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12.0,
                                  mainAxisSpacing: 12.0,
                                  padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 8.0),
                                  shrinkWrap: true,
                                  children: snapshot.data.documents
                                    .where((doc) => doc["userId"] == user2.uid)
                                    .where((doc) => doc["borrowedTo"] != "")
                                      .map((DocumentSnapshot document)  {
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

//
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
                                                        Text("Lent to:  "),
                                                        Text('${document['borrowName']}',style: TextStyle(color: Colors.black)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      FlatButton(
                                                        onPressed: (){
                                                          return showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text('Get item',style: TextStyle(color: Colors.black)),
                                                                  content: Text(
                                                                      'Are you sure that user returned your item back to you?',
                                                                      style: TextStyle(color: Colors.black)),
                                                                  actions: <Widget>[
                                                                    FlatButton(
                                                                      child: Text('Yes',style: TextStyle(color: Colors.black)),
                                                                      onPressed: () {
                                                                        Firestore.instance
                                                                            .collection('items')
                                                                            .document(document
                                                                            .documentID)
                                                                            .updateData({
                                                                          "borrowedTo": "",
                                                                          "borrowName": ""
                                                                        });
                                                                        debugPrint(
                                                                            "vratil sa mi item");
                                                                        Navigator.pop(context);
                                                                        Navigator.pop(context);
                                                                      },
                                                                    ),
                                                                    FlatButton(
                                                                      child: Text('Cancel',style: TextStyle(color: Colors.black)),
                                                                      onPressed: () {
                                                                        Navigator.pop(context);
                                                                      },
                                                                    )
                                                                  ],
                                                                );
                                                              });

                                                        },
                                                        child: Text('Recieve',style: TextStyle(color: Colors.black)),
                                                      ),
                                                      FlatButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text("Cancel", style: TextStyle(color: Colors.black)),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )
                                          );
                                        },
                                      );
                                  }).toList()),
                              //third tab
                              GridView.count(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12.0,
                                  mainAxisSpacing: 12.0,
                                  padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 8.0),
                                  shrinkWrap: true,
                                  children: snapshot.data.documents
                                    .where((doc) => doc["borrowedTo"] == user2.uid)
                                      .map((DocumentSnapshot document) {
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
                                                        Text("Borrowed from:  "),
                                                        StreamBuilder<QuerySnapshot>(
                                                          stream:  Firestore.instance
                                                              .collection('users')
                                                              .where('uid', isEqualTo: document['userId'])
                                                              .snapshots(),
                                                          builder: (context, snapshot) {
                                                            return Text('${snapshot.data.documents[0]['name']}',
                                                                style: TextStyle(color: Colors.black));
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      FlatButton(
                                                        onPressed: (){
                                                          return showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text('Return item', style: TextStyle(color: Colors.black),),
                                                                  content: Text(
                                                                      'Are you sure that you returned your item back to the owner?',
                                                                      style:TextStyle(color: Colors.black)),
                                                                  actions: <Widget>[
                                                                    FlatButton(
                                                                      child: Text('Yes',style:TextStyle(color: Colors.black)),
                                                                      onPressed: () {
                                                                        Firestore.instance
                                                                        .collection('items')
                                                                        .document(document
                                                                        .documentID)
                                                                        .updateData({
                                                                      "borrowedTo": "",
                                                                      "borrowName": ""
                                                                    });
                                                                    debugPrint(
                                                                        "vratil sa mi item");
                                                                    Navigator.pop(context);
                                                                    Navigator.pop(context);
                                                                      },
                                                                    ),
                                                                    FlatButton(
                                                                      child: Text('Cancel',style: TextStyle(color: Colors.black)),
                                                                      onPressed: () {
                                                                        Navigator.pop(context);
                                                                      },
                                                                    )
                                                                  ],
                                                                );
                                                              });

                                                        },
                                                        child: Text('Return',style: TextStyle(color: Colors.black)),
                                                      ),
                                                      FlatButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text("Cancel", style: TextStyle(color: Colors.black)),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )
                                          );
                                        },
                                      );
                                  }).toList()),

                            ]),
                              Container(
                                margin: EdgeInsets.only(left: 320.0, right: 5.0,top: 250.0,),
                                child: FloatingActionButton(
                                    heroTag: "btnWelcome",
                                    child: Icon(Icons.add),
                                    shape: _DiamondBorder(),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                            return MyNewItem();
                                          }));
                                    }),
                              ),
                          ])),

                    ],
                  );
              }

            })
    );
  }

  Widget _buildIamge() {
    return Container(
      width: double.maxFinite,
      height: 180.0,
      child: new ClipPath(
        clipper: new DialogonalClipper(),
        child: new Image.asset(
          'assets/images/biela.jpg',
          fit: BoxFit.fitWidth,
          //     height: _imageHeight,

        ),
      ),
    );
  }

  void deleteFireBaseStorageItem(String fileUrl) {
    String filePath = fileUrl.replaceAll(
        new RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/wardrobe-26e92.appspot.com/o/'),
        '');
    filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
    StorageReference storageReferance = FirebaseStorage.instance.ref();
    storageReferance
        .child(filePath)
        .delete()
        .then((_) => print('Successfully deleted $filePath storage item'));
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

class _DiamondBorder extends ShapeBorder {
  const _DiamondBorder();

  @override
  EdgeInsetsGeometry get dimensions {
    return const EdgeInsets.only();
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..moveTo(rect.left + rect.width / 2.0, rect.top)
      ..lineTo(rect.right, rect.top + rect.height / 2.0)
      ..lineTo(rect.left + rect.width / 2.0, rect.bottom)
      ..lineTo(rect.left, rect.top + rect.height / 2.0)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  // This border doesn't support scaling.
  @override
  ShapeBorder scale(double t) {
    return null;
  }

}

class Constants {
  static const String Settings = "Settings";
  static const String LogOut = "Logout";

  static const List<String> choices = <String>[
    Settings,
    LogOut
  ];
}





