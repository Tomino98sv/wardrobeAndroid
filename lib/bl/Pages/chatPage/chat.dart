import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {

  final String emailTarget;

  ChatPage(this.emailTarget){
    debugPrint("TERGET EMAIL JE "+emailTarget);
  }

  @override
  _ChatPageState createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final _controller = TextEditingController();

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

    Future<bool> doesCollectionAlreadyExist(String name) async {
      final QuerySnapshot result = await Firestore.instance
          .collection(name)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      debugPrint("POCET DOCUMENTOV V SNAPSHOTE ${documents.length}");
      debugPrint("existuje?  ${documents.length != 0}");
      return documents.length != 0;
    }

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
          debugPrint("PRVY MAIL JE "+emailUser);
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
              .then((value){prva=value;debugPrint("Value v calle prva: ${value}");})
              .then((value){
            doesCollectionAlreadyExist("${emailUserTarget}_${emailUser}").then((value){druha=value;debugPrint("Value v calle druha: ${value}");})
                .then((value){
              debugPrint("prva: po inite: ${prva}");
              debugPrint("prva: po inite: ${druha}");

              if(prva==true){
                debugPrint("${emailUser}_${emailUserTarget}   TATO EXISTUJE");
                collname="${emailUser}_${emailUserTarget}";
              }else if(druha==true){
                debugPrint("${emailUserTarget}_${emailUser}  TATO EXISTUJE");
                collname="${emailUserTarget}_${emailUser}";
              }else{
                debugPrint("${emailUserTarget}_${emailUser}  ziadna neexistuje tuto vytvaram");
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
                      .collection("${collname}")
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

  _handleSubmit(String message) {
    _controller.text = "";
    var db = Firestore.instance;
    db.collection("${collname}").add({
      "user_email": emailUser,
      "user_name": nameUser,
      "message": message,
      "created_at": DateTime.now()
    }).then((val) {
      print("sucess");
    }).catchError((err) {
      print(err);
    });
  }



}
