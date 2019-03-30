import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';

class ShowDetails extends StatefulWidget {
  DocumentSnapshot item;
  FirebaseUser user;

  ShowDetails({@required this.item, @required this.user});

  _ShowDetails createState() => new _ShowDetails(item: item, user: user);
}

//show details about item with option to edit
class _ShowDetails extends State<ShowDetails> {
  DocumentSnapshot item;
  double _imageHeight = 248.0;
  FirebaseUser user;
  int requestButton;

  _ShowDetails({@required this.item, @required this.user});

  @override
  void initState() {
    super.initState();
    debugPrint("XXX ini starte");
    Firestore.instance
        .collection('items')
        .document(item.documentID)
        .get()
        .then((onValue) {
      setState(() {
        debugPrint("XXX firestore");
        item = onValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("XXX build");
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('items')
            .document(item.documentID)
            .get()
            .asStream(),
        //shows items from Firebase
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Scaffold(body: new Text('Loading...'));
            default:
              return new Scaffold(
                appBar: new AppBar(
                  title: new Text(snapshot.data['name']),
                ),
                body: SingleChildScrollView(
                  child: new Container(
//                    padding: new EdgeInsets.all(20.0),
                    child: new Center(
                      child: new Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              _buildIamge(),
                              Padding(
                                padding: new EdgeInsets.only(
                                    left: 16.0, top: _imageHeight / 7.5),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
//                                        Icon(Icons.account_circle),
//                                        Padding(padding: EdgeInsets.only(right: 10.0),),
//                                        Text('Name: ',
//                                          style: new TextStyle(
//                                            color: Colors.black,
//                                            fontFamily: 'DancingScript-Bold', //neberie
//                                            fontWeight: FontWeight.w400
//                                        ),),
//                                        Padding(padding: EdgeInsets.only(right: 10.0),),
//                                        Text(snapshot.data['name'],
//                                          style: new TextStyle(
//                                            fontSize: 20.0,
//                                            color: Colors.black,
//                                            fontFamily: 'DancingScript-Bold', //neberie
//                                            fontWeight: FontWeight.w400
//                                        ),),
//                                        Padding(padding: EdgeInsets.only(right: 10.0),),
                                        Container(
                                          width: 200.0,
                                          height: 200.0,
                                          child: TransitionToImage(
                                            image: AdvancedNetworkImage(
                                                snapshot.data['photo_url'],
                                                useDiskCache: true,
                                                timeoutDuration: Duration(seconds: 7),
                                                cacheRule: CacheRule(
                                                    maxAge: const Duration(days: 7)),
//                                              fallbackAssetImage: 'assets/images/error_image.png',
                                                fallbackAssetImage: 'assets/images/image_error.png',
                                                retryLimit: 0
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
//                          Row(
//                            children: <Widget>[
//                              Padding(padding: EdgeInsets.only(top: 20.0),),
//                            Expanded(child: Icon(Icons.account_circle)),
//                            Expanded(
//                              child: Text('Name: ',
//                                style: new TextStyle(
//                                    color: Colors.black,
//                                    fontFamily: 'DancingScript-Bold', //neberie
//                                    fontWeight: FontWeight.w400
//                                ),),
//                            ),
//                            Expanded(
//                                child: Text(snapshot.data['name'],
//                              style: new TextStyle(
//                                  fontSize: 20.0,
//                                  color: Colors.black,
//                                  fontFamily: 'DancingScript-Bold', //neberie
//                                  fontWeight: FontWeight.w400
//                              ),),)
//                            ]
//                          ),
                          Padding(padding: EdgeInsets.only(top: 50.0),),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Icon(Icons.color_lens),
                              ),
                              Expanded(
                                child: Text('Color: ',
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                      fontFamily: 'DancingScript-Bold', //neberie
                                      fontWeight: FontWeight.w400
                                  ),),),
                              Expanded(
                                child: Text(snapshot.data['color'],
                                    style: new TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                        fontFamily: 'DancingScript-Bold', //neberie
                                        fontWeight: FontWeight.w400
                                    )),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 10.0),),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Icon(Icons.aspect_ratio),
                              ),
                              Expanded(
                                child: Text('Size:',
                                    style: new TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                        fontFamily: 'DancingScript-Bold', //neberie
                                        fontWeight: FontWeight.w400
                                    )),),
                              Expanded(
                                child: Text(snapshot.data['size'],
                                    style: new TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                        fontFamily: 'DancingScript-Bold', //neberie
                                        fontWeight: FontWeight.w400
                                    )),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 10.0),),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Icon(Icons.content_cut),
                              ),
                              Expanded(
                                child: Text('Length:',
                                    style: new TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                        fontFamily: 'DancingScript-Bold', //neberie
                                        fontWeight: FontWeight.w400
                                    )),),
                              Expanded(
                                child: Text(
                                    snapshot.data['length'],
                                    style: new TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                        fontFamily: 'DancingScript-Bold', //neberie
                                        fontWeight: FontWeight.w400
                                    )),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 10.0),),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Icon(Icons.card_giftcard),
                              ),
                              Expanded(
                                child: Text('Borrowed To?',
                                    style: new TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                        fontFamily: 'DancingScript-Bold', //neberie
                                        fontWeight: FontWeight.w400
                                    )),),
                              Expanded(
                                child: Text(snapshot.data['borrowName'] != "" ?
                                snapshot.data['borrowName'] :
                                '-',
                                    style: new TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                        fontFamily: 'DancingScript-Bold', //neberie
                                        fontWeight: FontWeight.w400
                                    )
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.get_app),
                              Container(
                                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                              ),
                              Expanded(
                                child: RaisedButton(
                                    child: Text(
                                        seeButtonText(snapshot.data)
//                                    requestButton == 1 ?
//                                    "Ask to Borrow" : requestButton == 2 ?
//                                    "Buy" : requestButton == 3 ?
//                                    "Get for free" : (requestButton == 4 ||requestButton == 5)?
//                                    "This item is currently taken" : "any"
                                    ),
                                    onPressed: (){
                                      seeButtonText(snapshot.data);
                                      giveBuySellBorrow(context, snapshot.data, user);
                                    }),
                              )
                            ],
                          ),

//                          Row(
//                            children: <Widget>[
//                              Expanded(
//                                child: Icon(Icons.person_pin_circle),
//                              ),
//                              Expanded(
//                                child: Text(snapshot.data['']), //ak sa zisti userove meno
//                              )
//                            ],
//                          )





//kod na upravopovanie itemu, ktory asi netreba
//                          Container(
//                            child: InkWell(
//                              onTap: (){ Navigator.push(context,
//                                  MaterialPageRoute(builder: (context) {
//                                    return EditItem(
//                                      item: snapshot.data,
//                                    );
//                                  }));},
//                              child: Container(
//                                decoration: new BoxDecoration(
//                                  color: Colors.pink,
//                                  borderRadius: new BorderRadius.circular(30.0),
//                                ),
//                                alignment: Alignment.center,
//                                padding: EdgeInsets.symmetric(vertical: 8.0),
//                                child: Text('Edit',style: TextStyle(color: Colors.white),),
//                              ),
//                            ),
//                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
//        height: _imageHeight,
      ),
    );
  }

  String seeButtonText(DocumentSnapshot snapshot) {

    debugPrint(snapshot.data['request']);
    if(snapshot.data['borrowName'] == "" || snapshot.data['borrowName'] == null) {
      switch (snapshot.data['request']) {
        case (""):
          return "Ask to Borrow";break;
        case ("borrow"):
          return "Ask to Borrow"; break;
        case ("sell"):
          return "Buy dress"; break;
        case ("giveaway"):
          return "Get for free"; break;
      }
    }
    else
      return "This item is currently taken";
//    if((snapshot.data['request'] == "" || snapshot.data['request'] == null) && snapshot.data['borrowName'] == ""){
//      setState(() {
//        requestButton = 1;
//      });
//    }
//    if (snapshot.data['request'] == "sell"){
//      setState(() {
//        requestButton = 2;
//      });
//    }
//    if (snapshot.data['request'] == "giveaway"){
//      setState(() {
//        requestButton = 3;
//      });
//    }
//    if (snapshot.data['request'] == "borrow"){
//      setState(() {
//        requestButton = 4;
//      });
//    }
//
//    if (snapshot.data['borrowName'] != "" ){
//      setState(() {
//        requestButton = 5;
//      });
//    }
  }
}

Future<Widget> giveBuySellBorrow(BuildContext context, DocumentSnapshot item, FirebaseUser user) {


  if (item.data['borrowName']=="" && item.data['request'] != "borrow"){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Borrow Request"),
          content: Text("I would like to borrow this dress"),
          actions: <Widget>[
            FlatButton(
              child: Text("Send"),
              onPressed: (){
                Firestore.instance.runTransaction((transaction) async {
                  await transaction.set(Firestore.instance.collection("requestBorrow").document(), {
                    'applicant': user.uid,
                    'respondent': item.data['userId'],
                    'itemID': item.documentID
                  });
                });
                debugPrint(user.uid);
                Firestore.instance.collection('items').document(item.documentID)
                    .updateData({"request": "borrow"});
                debugPrint("updatol som items request");
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
  else if (item.data['request'] == "borrow"){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Borrow Request"),
          content: Text("There is at least 1 other user who requested to borrow this dress. Would you like to send your request anyway?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Send"),
              onPressed: (){
                Firestore.instance.runTransaction((transaction) async {
                  await transaction.set(Firestore.instance.collection("requestBorrow").document(), {
                    'applicant': user.uid,
                    'respondent': item.data['userId'],
                    'itemID': item.documentID
                  });
                });
                debugPrint(user.uid);
                Firestore.instance.collection('items').document(item.documentID)
                    .updateData({"request": "borrow"});
                debugPrint("updatol som items request");
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  return null;

}