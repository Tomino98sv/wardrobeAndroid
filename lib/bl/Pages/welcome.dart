import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_app/bl/mainLoginPage.dart';
import 'package:flutter_app/db/FirestoreManager.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';


class WelcomePage extends StatefulWidget {

  @override
  _WelcomePageState createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> {

  FirebaseUser user2;
  GoogleSignInAccount googleUser;

//  Firestore.instance.collection("items")

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        user2 = fUser;
      });
    });
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
           return new Text ('Loading...');
         default:
       return SingleChildScrollView(
         child: new Container(
           padding: new EdgeInsets.all(32.0),
         child: new Center(
           child: new Column(
               children: <Widget>[
                 Container(
                   alignment: Alignment.topRight,
                   child: new OutlineButton(
                         borderSide: BorderSide(
                             color: Colors.red,style: BorderStyle.solid,width: 3.0),
                         child: Text('Logout'),
                         onPressed: () {
                           FirebaseAuth
                               .instance.signOut().then((value){
                             Navigator.push(context, new MaterialPageRoute(
                                 builder: (context) =>
                                 new QuickBee())
                             );
                           }).catchError((e){
                             print(e);
                           });
                         },
                       ),
                 ),
                 StreamBuilder<QuerySnapshot>(
                   stream: Firestore.instance.collection('users').where('uid',isEqualTo: user2.uid).snapshots(),
                   builder: (context,snapshot){
                     if(!snapshot.hasData) return Text("Loading data ... wait please");
                     return Column(
                       children: <Widget>[
                         Text(
                           snapshot.data.documents[0]['name'],
                           style: new TextStyle(fontSize: 20.0,color: Colors.orange),
                         ),
                         Text(
                           snapshot.data.documents[0]['email'],
                           style: new TextStyle(fontSize: 15.0,color: Colors.orange),
                         ),
                       ],
                     );
                   },
                 ),
                 Center(
                   child: Text('My Items:'),
                 ),
                 Container(
                   height: 200.0,
                   child: ListView(
                       children: snapshot.data.documents.map((DocumentSnapshot document) {
                         if (document["userId"] == user2.uid && document['borrowedTo'] == "") {
                           return Slidable(
                             delegate: SlidableDrawerDelegate(),
                             actionExtentRatio: 0.25,
                             child: ExpansionTile(
                               leading: Container(
                                   width: 46.0,
                                   height: 46.0,
                                   child: document['photo_url'] == null ||
                                       document['photo_url'] == ""
                                       ? Icon(Icons.filter_vintage)
                                       : TransitionToImage(
                                     image: AdvancedNetworkImage(
                                       document['photo_url'],
                                       useDiskCache: true,
                                       cacheRule:
                                       CacheRule(maxAge: const Duration(days: 7)),
                                     ),
                                   )
                               ),
                               title: Text(document['name']),
                               children: <Widget>[
                                 Text('Name: ${document['name']}'),
                                 Text('Color: ${document['color']}'),
                                 Text('Size: ${document['size']}'),
                                 Text('Length: ${document['length']}'),
                                 RaisedButton(
                                   child: Text(
                                       'Borrow to...',
                                       style: TextStyle(color: Colors.white)),
                                   color: Colors.pinkAccent,
                                   elevation: 4.0,
                                   onPressed: () {
                                     Navigator.push(context,
                                         MaterialPageRoute(builder: (context) {
                                           return UserList(item: document);
                                         }));
                                     // kod s vyberom userov Navigator.push
                                   },
                                 ),
                               ],
                             ),
                           );
                         }
                         else {
                           return Container();
                         }
                       }).toList()
                   ),
                 ),
                 Center(
                   child: Text('Borrowed Items:'),
                 ),
                 Container(
                   height: 200.0,
                   child: ListView(
                     children: snapshot.data.documents.map((DocumentSnapshot document) {
                       if (document["userId"] == user2.uid && document['borrowedTo'] != ""){
                       return Slidable(
                         delegate: SlidableDrawerDelegate(),
                         actionExtentRatio: 0.25,
                         child: ExpansionTile(
                           leading: Container(
                               width: 46.0,
                               height: 46.0,
                               child: document['photo_url'] == null || document['photo_url'] == ""
                                   ? Icon(Icons.filter_vintage)
                                   : TransitionToImage(
                                 image: AdvancedNetworkImage(
                                   document['photo_url'],
                                   useDiskCache: true,
                                   cacheRule:
                                   CacheRule(maxAge: const Duration(days: 7)),
                                 ),
                               )
                           ),
                           title: Text(document['name']),
                           children: <Widget>[
                             Text('Name: ${document['name']}'),
                             Text('Color: ${document['color']}'),
                             Text('Size: ${document['size']}'),
                             Text('Length: ${document['length']}'),
                             RaisedButton(
                               child: Text(
                                   'I got my dress back', style: TextStyle(color: Colors.white)),
                               color: Colors.pinkAccent,
                               elevation: 4.0,
                               onPressed: () {
                                   return showDialog(
                                     context: context,
                                     builder: (BuildContext context){
                                       return AlertDialog(
                                         title: Text('Get item'),
                                         content: Text('Are you sure that user returned your item back to you?'),
                                         actions: <Widget>[
                                           FlatButton(
                                             child: Text('Yes'),
                                             onPressed: (){
                                               Firestore.instance
                                                   .collection('items')
                                                   .document(document.documentID)
                                                   .updateData({"borrowedTo": "", "borrowName": ""});
                                               debugPrint("vratil sa mi item");
                                               Navigator.pop(context);
                                             },
                                           ),
                                           FlatButton(
                                             child: Text('Cancel'),
                                             onPressed: (){
                                               Navigator.pop(context);
                                             },
                                           )
                                         ],
                                       );
                                     }
                                   );
                                 // kod s vyberom userov Navigator.push
                               },
                             ),
                           ],
                         ),
                       );
                       }
                       else {
                         return Container();
                       }
                     }).toList()
                   ),
                 ),
                 Center(
                   child: Text('Items I borrowed:'),
                 ),
                 Container(
                   height: 200.0,
                   child: ListView(
                       children: snapshot.data.documents.map((DocumentSnapshot document) {
                         if (document["userId"] == user2.uid && document['borrowedTo'] == user2.uid){
                           return Slidable(
                             delegate: SlidableDrawerDelegate(),
                             actionExtentRatio: 0.25,
                             child: ExpansionTile(
                               leading: Container(
                                   width: 46.0,
                                   height: 46.0,
                                   child: document['photo_url'] == null || document['photo_url'] == ""
                                       ? Icon(Icons.filter_vintage)
                                       : TransitionToImage(
                                     image: AdvancedNetworkImage(
                                       document['photo_url'],
                                       useDiskCache: true,
                                       cacheRule:
                                       CacheRule(maxAge: const Duration(days: 7)),
                                     ),
                                   )
                               ),
                               title: Text(document['name']),
                               children: <Widget>[
                                 Text('Name: ${document['name']}'),
                                 Text('Color: ${document['color']}'),
                                 Text('Size: ${document['size']}'),
                                 Text('Length: ${document['length']}'),
                                 RaisedButton(
                                   child: Text(
                                       'Get back', style: TextStyle(color: Colors.white)),
                                   color: Colors.pinkAccent,
                                   elevation: 4.0,
                                   onPressed: () {
                                     return showDialog(
                                         context: context,
                                         builder: (BuildContext context){
                                           return AlertDialog(
                                             title: Text('Get item'),
                                             content: Text('Are you sure that user returned your item back to you?'),
                                             actions: <Widget>[
                                               FlatButton(
                                                 child: Text('Yes'),
                                                 onPressed: (){
                                                   Firestore.instance
                                                       .collection('items')
                                                       .document(document.documentID)
                                                       .updateData({"borrowedTo": "", "borrowName": ""});
                                                   debugPrint("vratil sa mi item");
                                                   Navigator.pop(context);
                                                 },
                                               ),
                                               FlatButton(
                                                 child: Text('Cancel'),
                                                 onPressed: (){
                                                   Navigator.pop(context);
                                                 },
                                               )
                                             ],
                                           );
                                         }
                                     );
                                     // kod s vyberom userov Navigator.push
                                   },
                                 ),
                               ],
                             ),
                           );
                         }
                         else {
                           return Container();
                         }
                       }).toList()
                   ),
                 )
               ],
             ),
         ),
       ),
       );
     }
     }
   );
  }


}

//      child: new Center(
//       child: Container(
//         padding: EdgeInsets.all(32.0),
//         child: Column(
//           children: <Widget>[
//             Center(
//               child: Container(
//                 child: new Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     new Text('You are now logged in'),
//                     SizedBox(
//                       height: 15.0,
//                     ),
//                     new OutlineButton(
//                       borderSide: BorderSide(
//                           color: Colors.red,style: BorderStyle.solid,width: 3.0),
//                       child: Text('Logout'),
//                       onPressed: () {
//                         FirebaseAuth
//                             .instance.signOut().then((value){
//                           Navigator.of(context).pushReplacementNamed('/MainBee');
//                         }).catchError((e){
//                           print(e);
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
