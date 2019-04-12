import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/deals/applicantListB.dart';
import 'package:flutter_app/deals/applicantListGA.dart';
import 'package:flutter_app/deals/dealsTabbar.dart';

class DealsPage extends StatefulWidget {
  @override
  _DealsPage createState() => _DealsPage();

}


class _DealsPage extends State<DealsPage> with TickerProviderStateMixin{
  FirebaseUser userCurrent;
  TabController _tabController;

//  Future<QuerySnapshot> requests = Firestore.instance.collection('requestBorrow').where('applicant', isEqualTo: userCurrent.uid).getDocuments();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        userCurrent = fUser;
      });
    });
    _tabController = new TabController(length: 3, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
//      stream: Firestore.instance.collection('requestBorrow').snapshots(),
        stream: Firestore.instance.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError) return new Text('Error ${snapshot.error}');
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
              return new Text('Loading',style:Theme.of(context).textTheme.subhead);
            default:
              return Scaffold(
                body: Column(
                  children: <Widget>[
                        Container(
//                      width: double.maxFinite,
                          child: DealsTabbar(
                            tabController: _tabController,
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                              controller: _tabController,
                              children: <Widget>[
                                ListView(
                                  children:
                                  snapshot.data.documents.map((DocumentSnapshot document) {
                                    if(document['request'] == "borrow" && userCurrent.uid == document['userId']) {
                                      return ListTile(
                                        title: Text(document['name'],style:Theme.of(context).textTheme.subhead),
                                        trailing: Icon(Icons.navigate_next),
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context){
                                            return BorrowApplicants(requestedItem: document, context: context, currentUser: userCurrent,);
                                          }));
                                        }

                                      );
                                    }
                                    else
                                      return Container();
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
                                ),
                                Text("Requests from users who want to buy items",style:Theme.of(context).textTheme.subhead),
                                ListView(
                                  children:
                                  snapshot.data.documents.map((DocumentSnapshot document) {
                                    if(document['request'] == "giveaway" && userCurrent.uid == document['userId']) {
                                      return ListTile(
                                          title: Text(document['name'],style:Theme.of(context).textTheme.subhead),
                                          trailing: Icon(Icons.navigate_next),
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context){
                                              return GiveawayApplicants(requestedItem: document, context: context, currentUser: userCurrent,);
                                            }));
                                          }

                                      );
                                    }
                                    else
                                      return Container();
                                  }).toList(),
                                ),

                              ]),
                        )



                      ],
                ),
              );
          }
        },
      ),
    );

  }

}