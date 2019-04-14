import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';

class ShowDetails extends StatefulWidget {
  DocumentSnapshot item;
  FirebaseUser user;
  var userName;

  ShowDetails({@required this.item, @required this.user, @required this.userName});

  _ShowDetails createState() => new _ShowDetails(item: item, user: user, userName: userName);
}

//show details about item with option to edit
class _ShowDetails extends State<ShowDetails> {
  DocumentSnapshot item;
  double _imageHeight = 248.0;
  FirebaseUser user;
  int requestButton;
  var userName;

  _ShowDetails({@required this.item, @required this.user, @required this.userName});

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
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}',style:Theme.of(context).textTheme.subhead);
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Scaffold(body: new Text('Loading...',style:Theme.of(context).textTheme.subhead));
            default:
              return new Scaffold(
                appBar: new AppBar(
                  title: new Text(snapshot.data['name'],style:Theme.of(context).textTheme.subhead),
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
                                          child: ZoomableWidget(
                                            minScale: 1.0,
                                            maxScale: 2.0,
                                            // default factor is 1.0, use 0.0 to disable boundary
                                            panLimit: 0.0,
                                            bounceBackBoundary: true,
                                            child:  CachedNetworkImage(
                                              imageUrl: snapshot.data['photo_url'],
                                              placeholder: (context, imageUrl) => CircularProgressIndicator(),
                                            ),
//                                            child: TransitionToImage(
//                                              image: AdvancedNetworkImage(
//                                                  snapshot.data['photo_url'],
//                                                  useDiskCache: true,
//                                                  timeoutDuration: Duration(seconds: 7),
//                                                  cacheRule: CacheRule(
//                                                      maxAge: const Duration(days: 7)),
////                                              fallbackAssetImage: 'assets/images/error_image.png',
//                                                  fallbackAssetImage: 'assets/images/image_error.png',
//                                                  retryLimit: 0
//                                              ),
//                                              placeholder: CircularProgressIndicator(),
//                                              duration: Duration(milliseconds: 300),
//                                            ),
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
                                  style:Theme.of(context).textTheme.subhead),),
                              Expanded(
                                child: Text(snapshot.data['color'],
                                    style:Theme.of(context).textTheme.subhead),
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
                                    style:Theme.of(context).textTheme.subhead),),
                              Expanded(
                                child: Text(snapshot.data['size'],
                                    style:Theme.of(context).textTheme.subhead),
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
                                    style:Theme.of(context).textTheme.subhead),),
                              Expanded(
                                child: Text(
                                    snapshot.data['length'],
                                    style:Theme.of(context).textTheme.subhead),
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
                                child: Text(snapshot.data['borrowName'] != ""?
                                    'Lent To' :
                                    'Can I get it?',
                                    style:Theme.of(context).textTheme.subhead),),
                              Expanded(
                                child: Text(snapshot.data['borrowName'] != "" ?
                                snapshot.data['borrowName'] :
                                'Yes',
                                    style:Theme.of(context).textTheme.subhead
                                ),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 10.0),),
                          Container(
                            child: (snapshot.data['request']=="sell" ||snapshot.data['request']=="buy")
                            ? Row(
                              children: <Widget>[
                                Expanded(
                                  child: Icon(Icons.monetization_on),
                                ),
                                Expanded(
                                  child: Text("Price:", style:Theme.of(context).textTheme.subhead),
                                ),
                                Expanded(
                                  child: Text(
                                      snapshot.data['price'],
                                      style:Theme.of(context).textTheme.subhead),
                                )
                              ],
                            )
                            : Container(),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Icon(Icons.get_app),
                              ),
                              Expanded(
                                child: RaisedButton(
                                    child: Text(
                                        seeButtonText(snapshot.data),
                                        style:Theme.of(context).textTheme.subhead
//                                    requestButton == 1 ?
//                                    "Ask to Borrow" : requestButton == 2 ?
//                                    "Buy" : requestButton == 3 ?
//                                    "Get for free" : (requestButton == 4 ||requestButton == 5)?
//                                    "This item is currently taken" : "any"
                                    ),
                                    onPressed: (){
                                      seeButtonText(snapshot.data);
                                      if (seeButtonText(snapshot.data)!= "This item is currently taken""This item is currently taken")
                                        giveBuySellBorrow(context, snapshot.data, user, userName);
                                    }),
                              ),
                              Expanded(
                                child: Text(""),
                              )
                            ],
                          ),
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
        'assets/images/biela.jpg',
        fit: BoxFit.fitWidth,
//        height: _imageHeight,
      ),
    );
  }

  //nebude vidno
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
        case ("buy"):
          return "Buy dress"; break;
        case ("giveaway"):
          return "Get for free"; break;
      }
    }
    else
      return "This item is currently taken";
  }
}

Future<Widget> giveBuySellBorrow(BuildContext context, DocumentSnapshot item, FirebaseUser user, String userName) {


  if (item.data['borrowName']=="" && item.data['request'] == ""){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Borrow Request",style:Theme.of(context).textTheme.subhead),
          content: Text("I would like to borrow this dress",style:Theme.of(context).textTheme.subhead),
          actions: <Widget>[
            FlatButton(
              child: Text("Confirm"),
              onPressed: (){
                showDialog(context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text("Request sent",style:Theme.of(context).textTheme.subhead),
                    content: Text("The request has been sent!",style:Theme.of(context).textTheme.subhead),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("OK",style:Theme.of(context).textTheme.subhead),
                        onPressed: (){
                          Firestore.instance.runTransaction((transaction) async {
                            await transaction.set(Firestore.instance.collection("requestBorrow").document(), {
                              'applicant': user.uid,
                              'respondent': item.data['userId'],
                              'itemID': item.documentID,
                              'itemName': item.data['name'],
                              'applicantName': userName
                            });
                          });
                          debugPrint(user.uid);
                          Firestore.instance.collection('items').document(item.documentID)
                              .updateData({"request": "borrow"});
                          debugPrint("updatol som items request");
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });

              },
            ),
            FlatButton(
              child: Text("Cancel",style:Theme.of(context).textTheme.subhead),
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
          title: Text("Borrow Request",style:Theme.of(context).textTheme.subhead),
          content: Text("There is at least 1 other user who requested to borrow this dress. Would you like to send your request anyway?",
              style:Theme.of(context).textTheme.subhead),
          actions: <Widget>[
            FlatButton(
              child: Text("Send", style:Theme.of(context).textTheme.subhead),
              onPressed: (){
                var count = 0;
                Firestore.instance.collection('requestBorrow').where('itemID', isEqualTo: item.documentID).getDocuments().then((foundDoc){
                  for (DocumentSnapshot ds in foundDoc.documents){
                    if (ds['applicant'] == user.uid){
                      count++;
                    }
                  }
                  if (count ==0){
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("Request sent", style:Theme.of(context).textTheme.subhead),
                            content: Text("The request has been sent!", style:Theme.of(context).textTheme.subhead),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("OK",style:Theme.of(context).textTheme.subhead),
                                onPressed: (){
                                  Firestore.instance.runTransaction((transaction) async {
                                    await transaction.set(Firestore.instance.collection("requestBorrow").document(), {
                                      'applicant': user.uid,
                                      'respondent': item.data['userId'],
                                      'itemID': item.documentID,
                                      'itemName': item.data['name'],
                                      'applicantName': userName
                                    });
                                  });
                                  debugPrint(user.uid);
                                  Firestore.instance.collection('items').document(item.documentID)
                                      .updateData({"request": "borrow"});
                                  debugPrint("updatol som items request");
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
//                    Navigator.pop(context);
                  }
                  else
                    requestAlreadySent(context);
                });

              },
            ),
            FlatButton(
              child: Text("Cancel", style:Theme.of(context).textTheme.subhead),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
  else if (item.data['request'] == "giveaway"){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Get for free",style:Theme.of(context).textTheme.subhead),
          content: Text("I would like to get this dress for free",style:Theme.of(context).textTheme.subhead),
          actions: <Widget>[
            FlatButton(
              child: Text("Confirm"),
              onPressed: (){
                var count2 = 0;
                Firestore.instance.collection('requestGiveaway').where('itemID', isEqualTo: item.documentID).getDocuments().then((foundDoc) {
                  for (DocumentSnapshot ds in foundDoc.documents) {
                    if (ds['applicant'] == user.uid) {
                      count2++;
                    }
                  }

                  if (count2 ==0){
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("Request sent",style:Theme.of(context).textTheme.subhead),
                            content: Text("The request has been sent!",style:Theme.of(context).textTheme.subhead),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("OK",style:Theme.of(context).textTheme.subhead),
                                onPressed: (){
                                  Firestore.instance.runTransaction((transaction) async {
                                    await transaction.set(Firestore.instance.collection("requestGiveaway").document(), {
                                      'applicant': user.uid,
                                      'respondent': item.data['userId'],
                                      'itemID': item.documentID,
                                      'itemName': item.data['name'],
                                      'applicantName': userName
                                    });
                                  });
                                  debugPrint(user.uid);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  }
                  else
                    requestAlreadySent(context);
                });


              },
            ),
            FlatButton(
              child: Text("Cancel",style:Theme.of(context).textTheme.subhead),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
  else if (item.data['request'] == "sell" || item.data['request'] == "buy"){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Buy item",style:Theme.of(context).textTheme.subhead),
          content: Text("I would like to buy this dress \nfor ${item.data['price']} eur",style:Theme.of(context).textTheme.subhead),
          actions: <Widget>[
            FlatButton(
              child: Text("Confirm", style:Theme.of(context).textTheme.subhead),
              onPressed: (){
                var count1 = 0;
                Firestore.instance.collection('requestBuy').where('itemID', isEqualTo: item.documentID).getDocuments().then((foundDoc){
                  for (DocumentSnapshot ds in foundDoc.documents){
                    if (ds['applicant'] == user.uid){
                      count1++;
                    }
                  }

                  if(count1 ==0){
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("Request sent",style:Theme.of(context).textTheme.subhead),
                            content: Text("The request has been sent!",style:Theme.of(context).textTheme.subhead),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("OK",style:Theme.of(context).textTheme.subhead),
                                onPressed: (){
                                  Firestore.instance.runTransaction((transaction) async {
                                    await transaction.set(Firestore.instance.collection("requestBuy").document(), {
                                      'applicant': user.uid,
                                      'respondent': item.data['userId'],
                                      'itemID': item.documentID,
                                      'itemName': item.data['name'],
                                      'applicantName': userName,
                                      'price': item.data['price']
                                    });
                                  });

                                  Firestore.instance.collection('items').document(item.documentID)
                                      .updateData({"request": "buy"});
                                  debugPrint(user.uid);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  }
                  else
                    requestAlreadySent(context);
                });
              },
            ),
            FlatButton(
              child: Text("Cancel",style:Theme.of(context).textTheme.subhead),
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
Widget requestAlreadySent(BuildContext context){
  showDialog(context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Request not sent",style:Theme.of(context).textTheme.subhead),
          content: Text("You have already asked for this item", style:Theme.of(context).textTheme.subhead),
          actions: <Widget>[
            FlatButton(
              child: Text("OK",style:Theme.of(context).textTheme.subhead),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        );
      });
}

