import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/chatPage/chat.dart';

class SellApplicants extends StatefulWidget {
  DocumentSnapshot requestedItem;
  FirebaseUser currentUser;
  BuildContext context;

  SellApplicants(
      {@required this.requestedItem,
        @required this.context,
        @required this.currentUser});

  @override
  _SellApplicants createState() => _SellApplicants(
      context: context, currentUser: currentUser, requestedItem: requestedItem);
}

class _SellApplicants extends State<SellApplicants> {
  DocumentSnapshot requestedItem;
  FirebaseUser currentUser;
  BuildContext context;
  int counter=0;

  _SellApplicants(
      {@required this.requestedItem, @required context, @required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
//      stream: Firestore.instance.collection('users').snapshots(),
        stream: Firestore.instance.collection('requestBuy').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}',style:Theme.of(context).textTheme.subhead);
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...',style:Theme.of(context).textTheme.subhead);
            default:
              return Scaffold(
                appBar: AppBar(
                  title: Text('Applicants'),
                ),
                body: ListView(
                    children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                      if(document['itemID'] == requestedItem.documentID){
                        counter++;
                        return Container(
                          height: 75.0,
                          padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                          child: Material(
                            color: Colors.white,
                            elevation: 14.0,
                            borderRadius: BorderRadius.circular(14.0),
                            child: ListTile(
                              leading: Text("$counter.",style:TextStyle(color: Colors.black)),
                              title: Text(document['applicantName'],style:TextStyle(color: Colors.black)),
                              trailing: SizedBox(
                                width: 96.0,
                                child: Row(
                                  children: <Widget>[
                                    IconButton(
                                        onPressed: (){
                                          return showDialog(
                                              context: context,
                                              builder: (BuildContext context){
                                                return CupertinoAlertDialog(
                                                  title: Text('Sell dress',style:Theme.of(context).textTheme.subhead),
                                                  content: Text('Are you sure you wish to sell ${requestedItem.data['name']} to ${document['applicantName']} for ${requestedItem.data['price']} eur?',
                                                      style:Theme.of(context).textTheme.subhead),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('Yes',style:Theme.of(context).textTheme.subhead),
                                                      onPressed: (){
                                                        if(requestedItem.data['borrowName']==null || requestedItem.data['borrowName']==""){
                                                        showDialog(context: context,
                                                            builder: (BuildContext context){
                                                              return CupertinoAlertDialog(
                                                                title: Text("Request sent",style:Theme.of(context).textTheme.subhead),
                                                                content: Text("Item was sold to user ${document['applicantName']}",style:Theme.of(context).textTheme.subhead),
                                                                actions: <Widget>[
                                                                  FlatButton(
                                                                    child: Text("OK",style:Theme.of(context).textTheme.subhead),
                                                                    onPressed: (){
                                                                      Firestore.instance
                                                                          .collection('items')
                                                                          .document(requestedItem
                                                                          .documentID)
                                                                          .updateData({
                                                                        "request": "",
                                                                        "userId": document['applicant'] //id of applicant
                                                                      });

                                                                      Firestore.instance
                                                                          .collection('items')
                                                                          .document(requestedItem.documentID)
                                                                          .updateData({'price' : FieldValue.delete()});

                                                                      Firestore.instance.collection('requestBuy').where('itemID', isEqualTo: requestedItem.documentID).getDocuments().then((som){
                                                                        for (DocumentSnapshot ds in som.documents){
                                                                          ds.reference.delete();
                                                                        }
                                                                      });
                                                                      Navigator.pop(context);
                                                                      Navigator.pop(context);
                                                                      Navigator.pop(context);
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                          }
                                                        else{
                                                          showDialog(context: context,
                                                              builder: (BuildContext context){
                                                                return CupertinoAlertDialog(
                                                                  title: Text("Request canceled",style:Theme.of(context).textTheme.subhead),
                                                                  content: Text("Item cannot be sold to user ${document['applicantName']} as the item is currently lent to ${requestedItem.data['borrowName']}",style:Theme.of(context).textTheme.subhead),
                                                                  actions: <Widget>[
                                                                    FlatButton(
                                                                      child: Text("OK",style:Theme.of(context).textTheme.subhead),
                                                                      onPressed: (){
                                                                        Navigator.pop(context);
                                                                        Navigator.pop(context);
                                                                      },
                                                                    )
                                                                  ],
                                                                );
                                                              });
                                                        }


                                                        //kod do firebase

                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text('Cancel',style:Theme.of(context).textTheme.subhead),
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],

                                                );
                                              }
                                          );
                                        },
                                        icon: Icon(Icons.check, color: Theme.of(context).accentColor),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.message,),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ChatPage(document['applicant_email'])
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                              ),

                            ),
                          ),
                        );
                      }
                      else
                        return Container();
                    }).toList()
                ),
              );
          }
        },
      ),
    );
  }

}
