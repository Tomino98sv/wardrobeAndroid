import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_app/bl/Pages/menu.dart';
import 'package:flutter_app/bl/Pages/profilePics.dart';
import 'package:flutter_app/bl/Pages/wardrobeTabbar.dart';
import 'package:flutter_app/bl/mainLoginPage.dart';
import 'package:flutter_app/bl/videjko/services/usermanagment.dart';
import 'package:flutter_app/db/FirestoreManager.dart';
import 'package:flutter_app/db/editItem.dart';
import 'package:flutter_app/db/model/Item.dart';
import 'package:flutter_app/db/userInfo.dart';
import 'package:flutter_app/ui/homePage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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
                                left: 16.0, top: _imageHeight / 5.0),
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
                                    AnimatedFab()
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
                          child: TabBarView(controller: _tabController, children: <Widget>[
                            GridView.count(
                              crossAxisCount: 3,
                                crossAxisSpacing: 12.0,
                                mainAxisSpacing: 12.0,

                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  if (document["userId"] == user2.uid &&
                                      document['borrowedTo'] == "") {
                                    return GestureDetector(
                                      child: Material(
                                        color: Colors.white,
                                        shadowColor: Colors.grey,
                                        elevation:14.0,
                                        borderRadius: BorderRadius.circular(24.0),

                                        child: Container(

                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10.0),
                                            child: document["photo_url"] == null || document["photo_url"] == ""
                                                ? Icon(Icons.broken_image)
                                                : CachedNetworkImage(
                                              imageUrl: document["photo_url"],
                                              fit: BoxFit.cover,
                                              alignment: Alignment.topLeft,
                                              placeholder: (context, imageUrl) =>
                                                  CircularProgressIndicator(),
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
                                                      Text(document["description"]),
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
                                                      child: Text("Edit"),
                                                    ),
                                                    FlatButton(
                                                      onPressed: (){
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder: (context) {
                                                                  return UserList(item: document);
                                                                }));
                                                      },
                                                      child: Text("Borrow"),
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
                                      onLongPress: (){
                                        return showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Delete Item',style:Theme.of(context).textTheme.subhead),
                                              content: Text(
                                                  'Are you sure you want to delete this item?',style:Theme.of(context).textTheme.subhead),
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
                                                  child: Text('Cancel',style:Theme.of(context).textTheme.subhead),
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
                                  } else {
                                    return Container();
                                  }
                                }).toList()),
                            GridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12.0,
                                mainAxisSpacing: 12.0,
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document)  {
                                  if (document["userId"] == user2.uid &&
                                      document['borrowedTo'] != "") {
                                    return GestureDetector(
                                      child: Material(
                                          color: Colors.white,
                                          shadowColor: Colors.grey,
                                          elevation:14.0,
                                          borderRadius: BorderRadius.circular(24.0),

                                          child: Container(

                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10.0),
                                                child: document["photo_url"] == null || document["photo_url"] == ""
                                                    ? Icon(Icons.broken_image)
                                                    : CachedNetworkImage(
                                                  imageUrl: document["photo_url"],
                                                  fit: BoxFit.cover,
                                                  alignment: Alignment.topLeft,
                                                  placeholder: (context, imageUrl) =>
                                                      CircularProgressIndicator(),
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
                                                      Text("Lent to:  "),
                                                      Text('${document['borrowName']}',style:Theme.of(context).textTheme.subhead),
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
                                                                title: Text('Get item',style:Theme.of(context).textTheme.subhead),
                                                                content: Text(
                                                                    'Are you sure that user returned your item back to you?',
                                                                    style:Theme.of(context).textTheme.subhead),
                                                                actions: <Widget>[
                                                                  FlatButton(
                                                                    child: Text('Yes',style:Theme.of(context).textTheme.subhead),
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
                                                                    child: Text('Cancel',style:Theme.of(context).textTheme.subhead),
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            });

                                                      },
                                                      child: Text('Recieve',style:Theme.of(context).textTheme.subhead),
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
                                  } else {
                                    return Container();
                                  }
                                }).toList()),





                            GridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12.0,
                                mainAxisSpacing: 12.0,
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  if (document['borrowedTo'] == user2.uid) {
                                    return GestureDetector(
                                      child: Material(
                                          color: Colors.white,
                                          shadowColor: Colors.grey,
                                          elevation:14.0,
                                          borderRadius: BorderRadius.circular(24.0),
                                          child: Container(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10.0),
                                                child: document["photo_url"] == null || document["photo_url"] == ""
                                                    ? Icon(Icons.broken_image)
                                                    : CachedNetworkImage(
                                                  imageUrl: document["photo_url"],
                                                  fit: BoxFit.cover,
                                                  alignment: Alignment.topLeft,
                                                  placeholder: (context, imageUrl) =>
                                                      CircularProgressIndicator(),
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
                                                              style:Theme.of(context).textTheme.subhead);
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
                                                                title: Text('Return item',style:Theme.of(context).textTheme.subhead),
                                                                content: Text(
                                                                    'Are you sure that you returned your item back to the owner?',
                                                                    style:Theme.of(context).textTheme.subhead),
                                                                actions: <Widget>[
                                                                  FlatButton(
                                                                    child: Text('Yes',style:Theme.of(context).textTheme.subhead),
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
                                                                    child: Text('Cancel',style:Theme.of(context).textTheme.subhead),
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            });

                                                      },
                                                      child: Text('Return',style:Theme.of(context).textTheme.subhead),
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
                                  } else {
                                    return Container();
                                  }
                                }).toList()),
                          ])),
                          Container(
                            margin: EdgeInsets.only(left: 290.0, right: 5.0,bottom: 15.0),
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
                          )
                      ,
                    ],
                  );
              }
            })
    );
  }

  Widget _buildIamge() {
    return Container(
      width: double.maxFinite,
      height: 200.0,
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





