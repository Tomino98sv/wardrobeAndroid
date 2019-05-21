import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPage createState() => _NotificationsPage();

}

class _NotificationsPage extends State<NotificationsPage>{

  FirebaseUser currentUser;
  String nameUser;
  String emailUser;
  String uid;
  Stream<QuerySnapshot> stream;
  DocumentSnapshot _documentSnapshot;

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
          debugPrint("My email is ${emailUser}");
        });
      });
    }).then((value){
      stream = Firestore.instance
          .collection('chat')
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: stream,
                builder: (BuildContext context, snapshot) {
                  switch(snapshot.connectionState){
                    case ConnectionState.none: return Text("Not streaming");
                    case ConnectionState.waiting: return getLoader("Starting chatroom");
                    case ConnectionState.active:
                      if (!snapshot.hasData) {return Container(child: Text("No data"),);}
                      return new ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: new EdgeInsets.all(8.0),
                        itemBuilder: (_, int index) {
                          DocumentSnapshot document = snapshot.data.documents[index];
                          if(document.data['participantOne']==emailUser || document.data['participantTwo']==emailUser){
                            debugPrint("   ${document.data['participantOne']}   TRUE    ${document.data['participantTwo']}   AND  ${emailUser}");
                            return Container(
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text("${document.data['participantOne']}"),
                                        Text("${document.data['participantTwo']}"),
                                        SizedBox(height: 30.0),
                                      ],
                                    ),
                                    Container(
                                      child: getUnseen(),
                                    )
                                  ],
                                )
                            );
                          }else{
                            return Container();
                          }

                        },
                        itemCount: snapshot.data.documents.length,
                      );
                    case ConnectionState.done: return Text("Done");
                  }
                },
              )
          ),
        ],
      ),
    );
  }

  Widget getLoader(String content){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Text(
            content,
            style: TextStyle(fontSize: 20.0),
          )
        ],
      ),
    );
  }

  Widget getUnseen(){
    return Text("0");
  }

}