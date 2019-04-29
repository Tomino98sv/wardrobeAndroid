import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
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
  String profileUrlImg="";


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

        snapshot.listen((QuerySnapshot data){
          profileUrlImg = data.documents[0]['photoUrl'];
        });
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
                                    InkWell(
                                      child: Container(
                                        width: 65.0,
                                        height: 65.0,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).accentColor,
                                            image: DecorationImage(
                                                image: NetworkImage(profileUrlImg),
                                                fit: BoxFit.cover),
                                            borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                            boxShadow: [
                                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                                            ]
                                        ),
                                      ),
                                      onTap: (){
                                        add();
                                        debugPrint("funguje klikanie na fotku");
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                    ),
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
                            ListView(
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  if (document["userId"] == user2.uid &&
                                      document['borrowedTo'] == "") {
                                    return Slidable(
                                      delegate: SlidableDrawerDelegate(),
                                      actionExtentRatio: 0.25,
                                      child: ExpansionTile(
                                        leading: Container(
                                            width: 46.0,
                                            height: 46.0,
                                            child: document['photo_url'] == null ||
                                                document['photo_url'] == ""
                                                ? Icon(Icons.broken_image)
                                                : ZoomableWidget(
                                                minScale: 1.0,
                                                maxScale: 2.0,
                                                // default factor is 1.0, use 0.0 to disable boundary
                                                panLimit: 0.0,
                                                bounceBackBoundary: true,
                                                child: TransitionToImage(
                                                  image: AdvancedNetworkImage(
                                                      document['photo_url'],
                                                      useDiskCache: true,
                                                      timeoutDuration: Duration(seconds: 7),
                                                      cacheRule: CacheRule(
                                                          maxAge: const Duration(days: 7)),
                                                      fallbackAssetImage: 'assets/images/image_error.png',
                                                      retryLimit: 0
                                                  ),
                                                )
                                            )
                                        ),
                                        title: Text(document['name'],style:Theme.of(context).textTheme.subhead),
                                        children: <Widget>[
                                          Text('Name: ${document['name']}',style:Theme.of(context).textTheme.subhead),
                                          Text('Color: ${document['color']}',style:Theme.of(context).textTheme.subhead),
                                          Text('Size: ${document['size']}',style:Theme.of(context).textTheme.subhead),
                                          Text('Length: ${document['length']}',style:Theme.of(context).textTheme.subhead),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Container(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder: (context) {
                                                                return EditItem(item: document);
//                            return SecondRoute(item: document); //tu je predchadzajuci kod
                                                              }));
                                                      debugPrint("idem dalej");
                                                    },
                                                    child: Container(
                                                      decoration: new BoxDecoration(
                                                        color: Theme.of(context).buttonColor,
                                                        borderRadius:
                                                        new BorderRadius.circular(30.0),
                                                      ),
                                                      margin: EdgeInsets.all(10.0),
                                                      height: 40.0,
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        'Edit',
                                                        style:
                                                        Theme.of(context).textTheme.subhead,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Container(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder: (context) {
                                                                return UserList(item: document);
                                                              }));
                                                    },
                                                    child: Container(
                                                      decoration: new BoxDecoration(
                                                        color: Theme.of(context).buttonColor,
                                                        borderRadius:
                                                        new BorderRadius.circular(30.0),
                                                      ),
                                                      margin: EdgeInsets.all(10.0),
                                                      height: 40.0,
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        'Borrow to...',
                                                        style:Theme.of(context).textTheme.subhead,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      secondaryActions: <Widget>[
                                        new IconSlideAction(
                                          icon: Icons.transfer_within_a_station,
                                          caption: 'Delete',
                                          color: Colors.red,
                                          onTap: () {
                                            debugPrint('klikol som');
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
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }).toList()),
                            ListView(
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document)  {
                                  if (document["userId"] == user2.uid &&
                                      document['borrowedTo'] != "") {
                                    return Slidable(
                                      delegate: SlidableDrawerDelegate(),
                                      actionExtentRatio: 0.25,
                                      child: ExpansionTile(
                                        leading: Container(
                                            width: 46.0,
                                            height: 46.0,
                                            child: document['photo_url'] == null ||
                                                document['photo_url'] == ""
                                                ? Icon(Icons.broken_image)
                                                : ZoomableWidget(
                                                minScale: 1.0,
                                                maxScale: 2.0,
                                                // default factor is 1.0, use 0.0 to disable boundary
                                                panLimit: 0.0,
                                                bounceBackBoundary: true,
                                                child: TransitionToImage(
                                                  image: AdvancedNetworkImage(
                                                      document['photo_url'],
                                                      useDiskCache: true,
                                                      timeoutDuration: Duration(seconds: 7),
                                                      cacheRule: CacheRule(
                                                          maxAge: const Duration(days: 7)),
                                                      fallbackAssetImage: 'assets/images/image_error.png',
                                                      retryLimit: 0
                                                  ),
                                                )
                                            )
                                        ),
                                        title: Text(document['name'],style:Theme.of(context).textTheme.subhead),
                                        children: <Widget>[
                                          Text('Name: ${document['name']}',style:Theme.of(context).textTheme.subhead),
                                          Text('Color: ${document['color']}',style:Theme.of(context).textTheme.subhead),
                                          Text('Size: ${document['size']}',style:Theme.of(context).textTheme.subhead),
                                          Text('Length: ${document['length']}',style:Theme.of(context).textTheme.subhead),
                                          new Text(
                                              'Borrowed to : ${document['borrowName']}',style:Theme.of(context).textTheme.subhead),
                                          new Container(
                                            margin:
                                            EdgeInsets.only(top: 10.0, bottom: 10.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(30.0),
                                              child: Material(
                                                color: Theme.of(context).buttonColor,
                                                borderRadius: BorderRadius.circular(30.0),
                                                child: InkWell(
                                                  splashColor: Theme.of(context).accentColor,
                                                  onTap: () {
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
                                                        }); // kod s vyberom userov Navigator.push
                                                  },
                                                  child: Container(
                                                    width: 200.0,
                                                    height: 40.0,
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                    child: Text(
                                                      'I got my dress back',
                                                      style:Theme.of(context).textTheme.subhead,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }).toList()),
                            ListView(
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  if (document['borrowedTo'] == user2.uid) {
                                    return Slidable(
                                      delegate: SlidableDrawerDelegate(),
                                      actionExtentRatio: 0.25,
                                      child: ExpansionTile(
                                        leading: Container(
                                            width: 46.0,
                                            height: 46.0,
                                            child: document['photo_url'] == null ||
                                                document['photo_url'] == ""
                                                ? Icon(Icons.broken_image)
                                                : ZoomableWidget(
                                                minScale: 1.0,
                                                maxScale: 2.0,
                                                // default factor is 1.0, use 0.0 to disable boundary
                                                panLimit: 0.0,
                                                bounceBackBoundary: true,
                                                child: TransitionToImage(
                                                  image: AdvancedNetworkImage(
                                                      document['photo_url'],
                                                      useDiskCache: true,
                                                      timeoutDuration: Duration(seconds: 7),
                                                      cacheRule: CacheRule(
                                                          maxAge: const Duration(days: 7)),
                                                      fallbackAssetImage: 'assets/images/image_error.png',
                                                      retryLimit: 0
                                                  ),
                                                )
                                            )),
                                        title: Text(document['name'],style:Theme.of(context).textTheme.subhead),
                                        children: <Widget>[
                                          Text('Name: ${document['name']}',style:Theme.of(context).textTheme.subhead),
                                          Text('Color: ${document['color']}',style:Theme.of(context).textTheme.subhead),
                                          Text('Size: ${document['size']}',style:Theme.of(context).textTheme.subhead),
                                          Text('Length: ${document['length']}',style:Theme.of(context).textTheme.subhead),

                                          StreamBuilder<QuerySnapshot>(
                                            stream:  Firestore.instance
                                                .collection('users')
                                                .where('uid', isEqualTo: document['userId'])
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              return Text('Borrowed from: ${snapshot.data.documents[0]['name']}',
                                                  style:Theme.of(context).textTheme.subhead);
                                            },
                                          ),
                                          new Container(
                                            margin:
                                            EdgeInsets.only(top: 10.0, bottom: 10.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(30.0),
                                              child: Material(
                                                color: Theme.of(context).buttonColor,
                                                borderRadius: BorderRadius.circular(30.0),
                                                child: InkWell(
                                                  splashColor: Theme.of(context).accentColor,
                                                  onTap: () {
                                                    return showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Return back',style:Theme.of(context).textTheme.subhead),
                                                            content: Text(
                                                                'Are you sure that you returned your item back to the owner?',
                                                                style:Theme.of(context).textTheme.subhead),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                child: Text('Yes'),
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
                                                    // kod s vyberom userov Navigator.push
                                                  },
                                                  child: Container(
                                                    width: 170.0,
                                                    height: 40.0,
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                    child: Text(
                                                      'Return to user',
                                                      style:Theme.of(context).textTheme.subhead,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                      ),
                    ],
                  );
              }
            })
    );
  }

  Widget _buildIamge() {
    return new ClipPath(
      clipper: new DialogonalClipper(),
      child: new Image.asset(
        'assets/images/biela.jpg',
        fit: BoxFit.fitWidth,
        //     height: _imageHeight,

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

Widget add() {
  return new Container(
    child: FloatingActionButton(
      onPressed: null,
      tooltip: 'Add',
      child: Icon(Icons.add),
    ),
  );
}


