import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {

  final String emailTarget;

  ChatPage(this.emailTarget);

  @override
  _ChatPageState createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{

   Widget _screen;
   Widget animationControl;
   final _controller = TextEditingController();
  String documentIDcurrent;
  CollectionReference refToSub;
  String nameUser;
  String emailUser;
  FirebaseUser user;
  String nameUserTarget;
  String emailUserTarget;
  FirebaseUser targetUser;
  String collname;
  QuerySnapshot initialDataSnapshot;
  Stream<QuerySnapshot> stream;
   bool _isWritting = false;

   String myProfUrlImg = "";
   String hisProfUrlImg = "";

  @override
  void initState() {
    super.initState();
    _screen= CircularProgressIndicator();
    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        user = fUser;
        Stream<QuerySnapshot> snapshot = Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .snapshots();

        snapshot.listen((QuerySnapshot data){
          myProfUrlImg = data.documents[0]['photoUrl'];
          emailUser = data.documents[0]['email'];
          nameUser = data.documents[0]['name'];
        });

        Stream<QuerySnapshot> snapshotOfTarget = Firestore.instance
            .collection('users')
            .where('email', isEqualTo:  widget.emailTarget)
            .snapshots();

        snapshotOfTarget.listen((QuerySnapshot dataTarget){
          hisProfUrlImg = dataTarget.documents[0]["photoUrl"];
          emailUserTarget = dataTarget.documents[0]['email'];
          nameUserTarget = dataTarget.documents[0]['name'];

          bool prva;
          bool druha;
          doesCollectionAlreadyExist("${emailUser}_${emailUserTarget}")
              .then((value){prva=value;})
              .then((value){
            doesCollectionAlreadyExist("${emailUserTarget}_${emailUser}").then((value){druha=value;})
                .then((value){

              if(prva==true){
                collname="${emailUser}_${emailUserTarget}";
              }else if(druha==true){
                collname="${emailUserTarget}_${emailUser}";
              }else{
                collname="${emailUserTarget}_${emailUser}";
              }

              stream = Firestore.instance
                  .collection('chat')
                  .document("${documentIDcurrent}")
                  .collection(collname)
                  .orderBy("created_at", descending: true)
                  .snapshots();

              if(refToSub != null){
                debugPrint("refTosub have data ${refToSub}");
                getInitialData(collname);
              }else {
                debugPrint("refTosub is empty ${refToSub}");
                setState(() {
                  _screen = getStreamBuilder();
                });
              }
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("chat page"),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: _screen
              ),
              new Divider(height: 1.0),
              Container(
                child: _getInputAndSend(),
                decoration: BoxDecoration(color: Theme.of(context).cardColor), //accent color
              ),
            ],
          ),
        ));
  }

  Widget _ownMessage(String message) {
    return  new Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Container(
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10.0),
                      color: Colors.pink,
                    ),
                    margin: const EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(10.0),
                    child: new Text("${message}",style:TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            new Container(
              width: 40.0,
              height: 40.0,
              margin: const EdgeInsets.only(right: 5.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).buttonColor,
                  image: DecorationImage(
                      image:NetworkImage(myProfUrlImg),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(75.0)),
              ),
            ),
          ],
        ),
      );
  }

  Widget _message(String message) {
    return  new Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            width: 40.0,
            height: 40.0,
            margin: const EdgeInsets.only(left: 5.0),
            decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                image: DecorationImage(
                    image:NetworkImage(hisProfUrlImg),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(75.0)),
            ),
          ),
          new Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(10.0),
                  child: new Text("${message}",style:TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _handleSubmit(String message) async {
    _controller.text = "";
    setState(() {
      _isWritting = false;
    });

    if(refToSub==null){
      var db = Firestore.instance;
      db.collection("chat").add({
        "room":collname,
      }).then((val) {
        print("sucess coll doc  ${val.documentID}");
        documentIDcurrent=val.documentID;
        Firestore.instance.collection("chat").document("${val.documentID}").collection("${collname}").add({
          "user_email": emailUser,
          "user_name": nameUser,
          "message": message,
          "created_at": DateTime.now()
        }).then((value){
          print("sucess subcoll doc ${value.documentID}");
          refToSub=Firestore.instance.collection("chat").document("${documentIDcurrent}").collection(collname);
          getInitialData(collname);
        });
      }).catchError((err) {
        print(err);
      });
    }else{
      refToSub.add({
        "user_email": emailUser,
        "user_name": nameUser,
        "message": message,
        "created_at": DateTime.now()
      }).then((value){
        print("ELSE sucess subcoll doc ${value.documentID}");
      }).catchError((err){
        print(err);
      });
    }
  }

  Future<bool> doesCollectionAlreadyExist(String name) async {

     final QuerySnapshot docId = await Firestore.instance
        .collection("chat")
        .where('room', isEqualTo: name)
        .getDocuments();
     final List<DocumentSnapshot> documents = docId.documents;

     if(documents.length != 0){
       refToSub = Firestore.instance.collection("chat").document("${documents[0].documentID}").collection(name);
       documentIDcurrent="${documents[0].documentID}";
     }
     return documents.length != 0;

  }

  void getInitialData(String nameCollection){
    refToSub.getDocuments().then((value){
      initialDataSnapshot=value;

      debugPrint(" DATA on initialData ");
      debugPrint("");

      for(int a=0;a<initialDataSnapshot.documents.length;a++){
        debugPrint(" user_email: "+initialDataSnapshot.documents[a].data["user_email"]);
        debugPrint(" user_name: "+initialDataSnapshot.documents[a].data["user_name"]);
        debugPrint(" message: "+initialDataSnapshot.documents[a].data["message"]);
        debugPrint("");
      }
    }).then((val){
      setState(() {
          _screen = getStreamBuilder();
      });
    });
  }

  Widget getStreamBuilder(){
    return StreamBuilder<QuerySnapshot>(
      initialData: initialDataSnapshot,
      stream: stream,
      builder: (BuildContext context, snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.none: return Text("Not streaming");
          case ConnectionState.waiting: return CircularProgressIndicator();
          case ConnectionState.active:
            if (!snapshot.hasData) {return Container();}
            return new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) {
                DocumentSnapshot document = snapshot.data.documents[index];
                bool isOwnMessage = false;
                if (document['user_email'] == emailUser) {
                  isOwnMessage = true;
                }
                debugPrint("itemBuilder called");
                return isOwnMessage
                    ? _ownMessage(
                    document['message'])
                    : _message(
                    document['message']);
              },
              itemCount: snapshot.data.documents.length,
            );
          case ConnectionState.done: return Text("Done");
        }
      },
    );
  }

  Widget _getInputAndSend(){
    return IconTheme(
      data: new IconThemeData(
          color:Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 9.0),
        child: Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _controller,
                onChanged: (String txt){
                  setState(() {
                    _isWritting = txt.length>0;
                  });
                },
                onSubmitted: _handleSubmit,
                decoration:
                new InputDecoration.collapsed(hintText: "Enter some text to send a message"),
              ),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 3.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? new CupertinoButton(
                  child: Text("Submit"),
                  onPressed: _isWritting ? () => _handleSubmit(_controller.text)
                      : null
              )
                  : new IconButton(
                icon: new Icon(Icons.message),
                onPressed: _isWritting
                    ?() => _handleSubmit(_controller.text)
                    : null,
              ),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
            border:
            new Border(top: new BorderSide(color: Colors.brown)))
            :null,
      ),
    );
  }
}
