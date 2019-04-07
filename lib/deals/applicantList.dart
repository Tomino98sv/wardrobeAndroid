import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BorrowApplicants extends StatefulWidget {
  DocumentSnapshot requestedItem;
  FirebaseUser currentUser;
  BuildContext context;

  BorrowApplicants(
      {@required this.requestedItem,
      @required this.context,
      @required this.currentUser});

  @override
  _BorrowApplicants createState() => _BorrowApplicants(
      context: context, currentUser: currentUser, requestedItem: requestedItem);
}

class _BorrowApplicants extends State<BorrowApplicants> {
  DocumentSnapshot requestedItem;
  FirebaseUser currentUser;
  BuildContext context;
  int counter=0;

  _BorrowApplicants(
      {@required this.requestedItem, @required context, @required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
//      stream: Firestore.instance.collection('users').snapshots(),
      stream: Firestore.instance.collection('requestBorrow').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return Scaffold(
              body: ListView(
                children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                    if(document['itemID'] == requestedItem.documentID){
                      counter++;
                      return ListTile(
                        leading: Text("$counter."),
                        title: Text(document['applicantName']),
                        trailing: FlatButton(
                            onPressed: (){
                              return showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text('Lend dress'),
                                    content: Text('Are you sure you wish to lend ${requestedItem.data['name']} to ${document['applicantName']}?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Yes'),
                                        onPressed: (){
                                          showDialog(context: context,
                                          builder: (BuildContext context){
                                            return AlertDialog(
                                              title: Text("Request sent"),
                                              content: Text("Item lent to user ${requestedItem.data['name']}"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("OK"),
                                                  onPressed: (){
                                                    Firestore.instance
                                                        .collection('items')
                                                        .document(requestedItem
                                                        .documentID)
                                                        .updateData({
                                                      "borrowedTo": document['applicant'],
                                                      "borrowName": document['applicantName'],
                                                      "request": ""
                                                    });
                                                    
                                                    Firestore.instance.collection('requestBorrow').where('itemID', isEqualTo: requestedItem.documentID).getDocuments().then((som){
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


                                          //kod do firebase

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
                            },
                            child: Text('Choose')),

                      );
                    }
                    else
                      return Container();
                  }).toList()
              ),
            );
        }
      },
    );
  }
}
