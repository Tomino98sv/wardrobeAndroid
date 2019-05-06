import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {

  final String emailTarget;

  ChatPage(this.emailTarget);

  @override
  _ChatPageState createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

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

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        user = fUser;
        Stream<QuerySnapshot> snapshot = Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .snapshots();

        snapshot.listen((QuerySnapshot data){
//          profileUrlImg = data.documents[0]['photoUrl'];
          emailUser = data.documents[0]['email'];
          nameUser = data.documents[0]['name'];
        });

        Stream<QuerySnapshot> snapshotOfTarget = Firestore.instance
            .collection('users')
            .where('email', isEqualTo:  widget.emailTarget)
            .snapshots();

        snapshotOfTarget.listen((QuerySnapshot dataTarget){
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('chat')
                      .document("${documentIDcurrent}")
                      .collection(collname)
                      .orderBy("created_at", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return new ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) {
                        DocumentSnapshot document =
                        snapshot.data.documents[index];

                        bool isOwnMessage = false;
                        if (document['user_email'] == emailUser) {
                          isOwnMessage = true;
                        }
                        return isOwnMessage
                            ? _ownMessage(
                            document['message'], document['user_name'])
                            : _message(
                            document['message'], document['user_name']);
                      },
                      itemCount: snapshot.data.documents.length,
                    );
                  },
                ),
              ),
              new Divider(height: 1.0),
              Container(
                margin: EdgeInsets.only(bottom: 20.0, right: 10.0, left: 10.0),
                child: Row(
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                        controller: _controller,
                        onSubmitted: _handleSubmit,
                        decoration:
                        new InputDecoration.collapsed(hintText: "send message"),
                      ),
                    ),
                    new Container(
                      child: new IconButton(
                          icon: new Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            _handleSubmit(_controller.text);
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _ownMessage(String message, String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10.0,),
            Text(userName),
            Text(message),
          ],
        ),
        Icon(Icons.person),
      ],
    );
  }

  Widget _message(String message, String userName) {
    return Row(
      children: <Widget>[
        Icon(Icons.person),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10.0,),
            Text(userName),
            Text(message),
          ],
        )
      ],
    );
  }

  _handleSubmit(String message) async {
    _controller.text = "";

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
        });
      }).catchError((err) {
        print(err);
      });
      refToSub=Firestore.instance.collection("chat").document("${documentIDcurrent}").collection(collname);
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

//    final QuerySnapshot result = await Firestore.instance
//        .collection(name)
//        .getDocuments();
//    final List<DocumentSnapshot> documents = result.documents;
//    return documents.length != 0;
  }

}
