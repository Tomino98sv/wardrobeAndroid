import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/chatPage/chat.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPage createState() => _NotificationsPage();
}

class _NotificationsPage extends State<NotificationsPage> {
  FirebaseUser currentUser;
  String nameUser;
  String emailUser;
  String uid;
  Stream<QuerySnapshot> stream;
  var unseenCount = 0;
  var allUnseenCount=0;
  List<DocumentSnapshot> listOfUnreadMess = new List<DocumentSnapshot>();
  Map<String, String> urlProfiles = Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        currentUser = fUser;
        Stream<QuerySnapshot> snapshot = Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: currentUser.uid)
            .snapshots();

        snapshot.listen((QuerySnapshot data) {
          emailUser = data.documents[0]['email'];
          nameUser = data.documents[0]['name'];
          uid = data.documents[0]['uid'];
        });
      });
    }).then((value) {
      stream = Firestore.instance.collection('chat').snapshots();
    });

    getInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return urlProfiles.length == 0
        ? getLoader("Loading")
        : Scaffold(
            body: Column(
              children: <Widget>[
                Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("Not streaming");
                      case ConnectionState.waiting:
                        return getLoader("Starting chatroom");
                      case ConnectionState.active:
                        if (!snapshot.hasData) {
                          return Container(
                            child: Text("No data"),
                          );
                        }
                        return new ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (_, int index) {
                            DocumentSnapshot document =
                                snapshot.data.documents[index];
                            if (document.data['participantOne'] == emailUser ||
                                document.data['participantTwo'] == emailUser) {
                              return document.data['participantOne'] !=
                                      emailUser
                                  ? getUnseen(
                                      document.data['participantOne'], document)
                                  : getUnseen(document.data['participantTwo'],
                                      document);
                            } else {
                              return Container();
                            }
                          },
                          itemCount: snapshot.data.documents.length,
                        );
                      case ConnectionState.done:
                        return Text("Done");
                    }
                  },
                )),
              ],
            ),
          );
  }

  Widget getLoader(String content) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Text(
            content,
            style: TextStyle(fontSize: 20.0,
                fontFamily: 'Pacifico'),
          )
        ],
      ),
    );
  }

  Widget getUnseen(String targetEmail, DocumentSnapshot document) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("chat")
          .document("${document.documentID}")
          .collection(document.data['room'])
          .where("user_email", isEqualTo: targetEmail)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text("Not streaming");
          case ConnectionState.waiting:
            return Container();
          case ConnectionState.active:
            if (!snapshot.hasData) {
              return Container(
                child: Text("No data"),
              );
            }
            if (snapshot.data.documents.length != 0) {
              unseenCount = 0;
              listOfUnreadMess = new List<DocumentSnapshot>();
              for (int a = 0; a < snapshot.data.documents.length; a++) {
//                DateTime time1 = snapshot.data.documents[a]["created_at"];
                DateTime time1;
                DateTime time2;
              if(Platform.isAndroid) {
                time1 = snapshot.data.documents[a]["created_at"];
                debugPrint("$time1");
                time2 = document.data['lastVisitOf${currentUser.uid}'];
              }
              else {
                time1 = (snapshot.data.documents[a]["created_at"]).toDate();
                debugPrint("$time1");
                time2 = (document.data['lastVisitOf${currentUser.uid}']).toDate();
              }

//                DateTime time2 = document.data['lastVisitOf${currentUser.uid}'];
                if (time1.difference(time2).isNegative) {
                } else {
                  listOfUnreadMess.add(snapshot.data.documents[a]);
                  unseenCount++;
                  allUnseenCount++;
                }
              }
              if (unseenCount != 0) {
                return getUnseenContainer(targetEmail, listOfUnreadMess,
                    snapshot.data.documents[0]['user_name']);
              } else {
                return Container();
              }
            } else {
              return Container();
            }
            break;
          case ConnectionState.done:
            return Text("Done");
        }
      },
    );
  }

  Widget getUnseenContainer(String targetEmail, List<DocumentSnapshot> snapList, user_name) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 6.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 60.0,
            child: Material(
              color: Colors.white,
              shadowColor: Colors.grey,
              elevation: 14.0,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.0),
                topRight: Radius.circular(14.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 1.0),
                      child: RawMaterialButton(
                        onPressed: () {
                          debugPrint("Pressed ${targetEmail}");
                          confirm(context, "See all messages",
                              "", targetEmail);
                        },
                        child: Container(
                          width: 45.0,
                          height: 45.0,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                              imageUrl: urlProfiles[targetEmail],
                              placeholder: (context, imageUrl) =>
                                  CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 0.0),
                      child: Text(
                        "${user_name}",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ]),
                  Stack(
                    children:<Widget>[
                      new RawMaterialButton(
                        onPressed: () {
                          debugPrint("Pressed ${targetEmail}");
                          confirm(context, "See all messages",
                              "", targetEmail);
                        },
                        child: Icon(
                            Icons.message,
                            size: 36.0,
                            color: Colors.black
                        ),
                      ),
                      Positioned(
                        left: 45,
                        height: 30.0,
                        width: 30.0,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle
                          ),
                          child: Text(
                            "${unseenCount}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Material(
              color: Colors.white,
              shadowColor: Colors.grey,
              elevation: 14.0,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(14.0),
                bottomRight: Radius.circular(14.0),
              ),
              child: getLastUnseenMessages(snapList)
          ),
        ],
      ),
    );
  }

  Widget getLastUnseenMessages(List<DocumentSnapshot> snapList) {
    DocumentSnapshot document = snapList[snapList.length - 1];
    DateTime date;
    if(Platform.isAndroid){
      date = document.data["created_at"];
    }
    else{
      date = (document.data["created_at"]).toDate();
    }
    var dateformat = "${date.hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')}:"
        "${date.second.toString().padLeft(2, '0')} ";
    return Container(
      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
      padding: EdgeInsets.only(left: 6.0, right: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          new Expanded(
              child: Text(
                "${document.data['message']}",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              )
          ),
          Text(
            "${dateformat}",
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.blueGrey,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  getInitialData() {
    Firestore.instance.collection("users").getDocuments().then((value) {
      List<DocumentSnapshot> documents = value.documents;
      for (var a = 0; a < documents.length; a++) {
        Firestore.instance
            .collection("users")
            .where("email", isEqualTo: documents[a].data['email'])
            .snapshots()
            .listen((data) {
          urlProfiles[documents[a].data['email']] =
              data.documents[0]['photoUrl'];
          setState(() {
            urlProfiles.length;
          });
        });
      }
    });
  }

  confirm(BuildContext context, String title, String description,
      String targetEmail) {
    debugPrint("TUUUUUUUUUUUUUUU ALERTDIALOG");

    return showDialog(
        context: context,
        barrierDismissible: false,
        child: CupertinoAlertDialog(
          title: Text(title,style: TextStyle(fontFamily: 'Pacifico')),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigations(targetEmail),
              child: Text("Continue"),
            ),
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            )
          ],
        ),
        );
  }

  Navigations(String targetEmail) {
    Navigator.pop(context);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ChatPage(targetEmail)));
  }
}

//confirm(context,"Continue to ChatPage","want chatting with that person?")
