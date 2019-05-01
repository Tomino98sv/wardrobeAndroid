import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_app/db/FirestoreManager.dart';
import 'package:flutter_app/db/getItem.dart';
import 'package:flutter_app/db/userInfo.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AllDressesList extends StatefulWidget {
  @override
  _DressesListState createState() {
    return _DressesListState();
  }
}

class _DressesListState extends State<AllDressesList> {
  FirebaseUser userCurrent;
  var userName;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        userCurrent = fUser;
        Stream<QuerySnapshot> snapshot = Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: userCurrent.uid)
            .snapshots();
        snapshot.listen((QuerySnapshot data) {
          userName = data.documents[0]['name'];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('items').snapshots(),
      //shows items from Firebase
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}',
              style: Theme.of(context).textTheme.subhead);
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...',
                style: Theme.of(context).textTheme.subhead);
          default:
            return Scaffold(
              body: new GridView.count(
                padding: EdgeInsets.only(top: 16.0),
                crossAxisCount: 3,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 12.0,
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
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
                  if (document['userId'] != userCurrent.uid) {
                    return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: new Radius.elliptical(40.0, 10.0),
                            bottomLeft: new Radius.circular(20.0),
                          ),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black12,
                              offset: new Offset(20.0, 10.0),
                              blurRadius: 20.0,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.elliptical(32.0, 20.0)),
                          child: item.photoUrl == null || item.photoUrl == ""
                              ? Icon(Icons.broken_image)
                              : CachedNetworkImage(
                                  imageUrl: item.photoUrl,
                                  placeholder: (context, imageUrl) =>
                                      CircularProgressIndicator(),
                                ),
                        ),
                      ),
                      onTap: (){
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          child: CupertinoAlertDialog(
                            title: Text(item.name),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: item.photoUrl,
                                  placeholder: (context, imageUrl) =>
                                      CircularProgressIndicator(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("About:  "),
                                    Text(item.description),
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
                                            return ShowDetails(item: document, user: userCurrent, userName: userName);
                                          }));
                                    },
                                    child: Text("Get"),
                                  ),
                                  FlatButton(
                                    onPressed: (){
                                      Firestore.instance.collection('users').where("uid", isEqualTo: document['userId']).snapshots().listen((user){
                                        debugPrint(document['userId']);
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                              return UserInfoList2(userInfo: user.documents?.first);
                                            }));
                                      });
                                    },
                                    child: Text("Seller"),
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
                      }
                      ,
                    );
                  } else {
                    return Container();
                  }
                }).toList(),
              ),
            );
        }
      },
    );
    ;
  }
}
