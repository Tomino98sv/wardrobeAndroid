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
  var unseenCount=0;
  List<DocumentSnapshot> listOfUnreadMess = new List<DocumentSnapshot>();
  Map<String, String> urlProfiles=Map();

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
    }).then((value){
      stream = Firestore.instance
          .collection('chat')
          .snapshots();
    });

    getInitialData();

  }

  @override
  Widget build(BuildContext context) {
    return urlProfiles.length==0?getLoader("Loading"):Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                            return document.data['participantOne'] != emailUser ?
                            getUnseen(document.data['participantOne'], document) :
                            getUnseen(document.data['participantTwo'], document);
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

    return Center(
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

  Widget getUnseen(String targetEmail, DocumentSnapshot document) {

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore
          .instance
          .collection("chat")
          .document("${document.documentID}")
          .collection(document.data['room'])
          .where("user_email",isEqualTo: targetEmail)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.none: return Text("Not streaming");
          case ConnectionState.waiting: return getLoader("Loading conversation");
          case ConnectionState.active:
            if (!snapshot.hasData) {return Container(child: Text("No data"),);}
            if(snapshot.data.documents.length!=0){
              unseenCount=0;
              listOfUnreadMess=new List<DocumentSnapshot>();
              for(int a=0;a<snapshot.data.documents.length;a++){
                DateTime time1 =snapshot.data.documents[a]["created_at"];
                DateTime time2 = document.data['lastVisitOf${currentUser.uid}'];
                if(time1.difference(time2).isNegative){
                }else{
                  listOfUnreadMess.add(snapshot.data.documents[a]);
                  unseenCount++;
                }
              }
              if(unseenCount!=0){
                return getUnseenContainer(targetEmail,listOfUnreadMess,snapshot.data.documents[0]['user_name']);
              }else{
                return Container(
                  child: Text("All message readed with ${targetEmail}"),
                );
              }
            }else{
              return Container();
            }
              break;
          case ConnectionState.done: return Text("Done");
        }
      },
    );
  }

  Widget getUnseenContainer(String targetEmail,List<DocumentSnapshot>snapList,user_name){
    return Container(
        margin:const EdgeInsets.symmetric(horizontal: 9.0),
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Container(
              width: 40.0,
              height: 40.0,
              margin: const EdgeInsets.only(left: 5.0),
              decoration:
              BoxDecoration(
                color: Theme.of(context).buttonColor,
                image: DecorationImage(
                    image:NetworkImage(urlProfiles[targetEmail]),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(75.0)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text("${user_name}"),
                ),
                Container(
                  child: Text("${unseenCount}"),
                )
              ],
            ),
            getUnseenMessages(snapList),
          ],
        )
    );
  }
  
  Widget getUnseenMessages(List<DocumentSnapshot>snapList){
    return
      ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: new EdgeInsets.all(8.0),
        itemBuilder: (_, int index) {
          DocumentSnapshot document = snapList[index];
          return Text("${document.data['message']}");
        },
        itemCount: snapList.length,
      );
  }


  getInitialData(){
    Firestore.instance
        .collection("users")
        .getDocuments().then((value){
      List<DocumentSnapshot> documents = value.documents;
      for(var a=0;a<documents.length;a++){
        Firestore
            .instance
            .collection("users")
            .where("email",isEqualTo: documents[a].data['email'])
            .snapshots().listen((data) {
          urlProfiles[documents[a].data['email']]= data.documents[0]['photoUrl'];
          setState(() {
            urlProfiles.length;
          });
        });
      }
    });

  }

}