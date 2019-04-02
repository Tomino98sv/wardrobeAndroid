import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DealsPage extends StatefulWidget {
  @override
  _DealsPage createState() => _DealsPage();

}


class _DealsPage extends State<DealsPage>{
  FirebaseUser userCurrent;

//  Future<QuerySnapshot> requests = Firestore.instance.collection('requestBorrow').where('applicant', isEqualTo: userCurrent.uid).getDocuments();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        userCurrent = fUser;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('requestBorrow').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (snapshot.hasError) return new Text('Error ${snapshot.error}');
        switch (snapshot.connectionState){
          case ConnectionState.waiting:
            return new Text('Loading');
          default:
            return ListView(
              children:
              snapshot.data.documents.map((DocumentSnapshot document) {
                if(document['respondent'] == userCurrent.uid) {
                  return ListTile(
                    title: Text(document['itemName']),

                  );
                }
                else
                  return Container(child: Text("You don't have any borrow requests from other users"),);
//                if(document['userId']==userCurrent.uid){
//                  return ListTile(
//                    title: Text(document['name']),
//
//                  );
//                }
//                else{
//                  return Container();
//                }


              }).toList(),
            );
        }
      },
    );

  }

}