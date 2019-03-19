import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_app/bl/Pages/wardrobeTabbar.dart';
import 'package:flutter_app/bl/mainLoginPage.dart';
import 'package:flutter_app/db/FirestoreManager.dart';
import 'package:flutter_app/db/model/Item.dart';
import 'package:flutter_app/db/userInfo.dart';
import 'package:flutter_app/ui/homePage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  GoogleSignInAccount googleUser;
  double _imageHeight = 248.0;
  TabController _tabController;

//  Firestore.instance.collection("items")

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        user2 = fUser;
      });
    });
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
//     stream: Firestore.instance.collection('items').where("userId", isEqualTo: user2.uid).snapshots(),
        stream: Firestore.instance.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new Column(
                children: <Widget>[
                  new Stack(
                    children: <Widget>[
                      _buildIamge(),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.only(top: 24.0, right: 24.0),
                          child: Material(
                            color: Colors.pink,
                            shape: _DiamondBorder(),
                            //    borderRadius: BorderRadius.circular(30.0),
                            child: InkWell(
                              splashColor: Colors.pink[400],
                              customBorder: _DiamondBorder(),
                              onTap: () {
                                FirebaseAuth.instance.signOut().then((value) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => QuickBee()),
                                      (Route<dynamic> route) => false);
                                }).catchError((e) {
                                  print(e);
                                });
                              },
                              child: Container(
                                width: 90.0,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 30.0),
                                child: Icon(Icons.power_settings_new,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      new Padding(
                        padding: new EdgeInsets.only(
                            left: 16.0, top: _imageHeight / 2.5),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('users')
                              .where('uid', isEqualTo: user2.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Text("Loading data ... wait please");
                            return Column(
                              children: <Widget>[
                                Text(
                                  snapshot.data.documents[0]['name'],
                                  style: new TextStyle(
                                      fontSize: 30.0,
                                      color: Colors.black,
                                      fontFamily: 'DancingScript-Bold',
                                      //neberie
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  snapshot.data.documents[0]['email'],
                                  style: new TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 313.0, top: 180.0),
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
                  ),
                  Container(
                    width: double.maxFinite,
                    child: WardrobeTabBar(
                      tabController: _tabController,
                    ),
                  ),
                  Expanded(
                      child: TabBarView(controller: _tabController, children: <
                          Widget>[
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
                                    : TransitionToImage(
                                        image: AdvancedNetworkImage(
                                          document['photo_url'],
                                          useDiskCache: true,
                                          cacheRule: CacheRule(
                                              maxAge: const Duration(days: 7)),
                                        ),
                                      )),
                            title: Text(document['name']),
                            children: <Widget>[
                              Text('Name: ${document['name']}'),
                              Text('Color: ${document['color']}'),
                              Text('Size: ${document['size']}'),
                              Text('Length: ${document['length']}'),
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
                                            color: Colors.pink,
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                          margin: EdgeInsets.all(10.0),
                                          height: 40.0,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Edit',
                                            style:
                                                TextStyle(color: Colors.white),
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
                                            color: Colors.pink,
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                          margin: EdgeInsets.all(10.0),
                                          height: 40.0,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Borrow to...',
                                            style:
                                                TextStyle(color: Colors.white),
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
                                      title: Text('Delete Item'),
                                      content: Text(
                                          'Are you sure you want to delete this item?'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Yes'),
                                          onPressed: () {
                                            Firestore.instance
                                                .collection('items')
                                                .document(document.documentID)
                                                .delete();
//                                    StorageReference obr = FirebaseStorage.instance.getReferenceFromUrl(item.photoUrl);
//                                    obr.delete();
                                            Navigator.pop(context);
                                            deleteFireBaseStorageItem(
                                                document['photoUrl']);

                                            debugPrint("vymazanee");
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('Cancel'),
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
                            .map((DocumentSnapshot document) {
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
                                    : TransitionToImage(
                                        image: AdvancedNetworkImage(
                                          document['photo_url'],
                                          useDiskCache: true,
                                          cacheRule: CacheRule(
                                              maxAge: const Duration(days: 7)),
                                        ),
                                      )),
                            title: Text(document['name']),
                            children: <Widget>[
                              Text('Name: ${document['name']}'),
                              Text('Color: ${document['color']}'),
                              Text('Size: ${document['size']}'),
                              Text('Length: ${document['length']}'),
                              new Text(
                                  'Borrowed to : ${document['borrowName']}'),
                              new Container(
                                margin:
                                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: Material(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: InkWell(
                                      splashColor: Colors.pink[400],
                                      onTap: () {
                                        return showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Get item'),
                                                content: Text(
                                                    'Are you sure that user returned your item back to you?'),
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
                                                    child: Text('Cancel'),
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
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
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
                                    : TransitionToImage(
                                        image: AdvancedNetworkImage(
                                          document['photo_url'],
                                          useDiskCache: true,
                                          cacheRule: CacheRule(
                                              maxAge: const Duration(days: 7)),
                                        ),
                                      )),
                            title: Text(document['name']),
                            children: <Widget>[
                              Text('Name: ${document['name']}'),
                              Text('Color: ${document['color']}'),
                              Text('Size: ${document['size']}'),
                              Text('Length: ${document['length']}'),

                              StreamBuilder<QuerySnapshot>(
                                stream:  Firestore.instance
                                    .collection('users')
                                    .where('uid', isEqualTo: document['userId'])
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  return Text('Borrowed from: ${snapshot.data.documents[0]['name']}',);
                                },
                              ),
                              new Container(
                                margin:
                                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: Material(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: InkWell(
                                      splashColor: Colors.pink[400],
                                      onTap: () {
                                        return showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Return to '),
                                                content: Text(
                                                    'Are you sure that user returned your item back to you?'),
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
                                                    child: Text('Cancel'),
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
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
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
                  ])),
                ],
              );
          }
        });
  }

  Widget _buildIamge() {
    return new ClipPath(
      clipper: new DialogonalClipper(),
      child: new Image.asset(
        'assets/images/pinkB.jpg',
        fit: BoxFit.fitWidth,
   //     height: _imageHeight,

      ),
    );
  }

  void deleteFireBaseStorageItem(String fileUrl) {
    String filePath = fileUrl.replaceAll(
        new RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/wardrobe-2324a.appspot.com/o/'),
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
