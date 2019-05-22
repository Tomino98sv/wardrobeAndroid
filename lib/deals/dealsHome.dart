import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/deals/applicantListB.dart';
import 'package:flutter_app/deals/applicantListGA.dart';
import 'package:flutter_app/deals/applicantListS.dart';
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

  var countBorrow = 0;
  var countSell = 0;
  var countGive = 0;



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
                                //first tab
                                GridView.count(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12.0,
                                    mainAxisSpacing: 12.0,
                                    padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 8.0),
                                    shrinkWrap: true,
                                    children: snapshot.data.documents
                                        .where((doc) => doc["request"] == "borrow" && userCurrent.uid == doc['userId'])
                                        .map((DocumentSnapshot document) {
                                      return GestureDetector(
                                        child: Material(
                                            color: Colors.white,
                                            shadowColor: Colors.grey,
                                            elevation:14.0,
                                            borderRadius: BorderRadius.circular(24.0),
                                            child: Container(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: <Widget>[
                                                      document["photo_url"] == null || document["photo_url"] == ""
                                                          ? Icon(Icons.broken_image)
                                                          : CachedNetworkImage(
                                                        imageUrl: document["photo_url"],
                                                        fit: BoxFit.cover,
                                                        alignment: Alignment.topLeft,
                                                        placeholder: (context, imageUrl) =>
                                                            CircularProgressIndicator(),
                                                      ),
                                                      Align(
                                                        alignment: Alignment.bottomCenter,
                                                        child: Container(
                                                          width: double.maxFinite,
                                                          height: 26.0,
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: 4.0, horizontal: 16.0),
                                                          color: Color(0x66000000),
                                                          alignment: Alignment.bottomCenter,
                                                          child: Text(
                                                            document['name'],
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                            )
                                        ),
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context){
                                            return BorrowApplicants(requestedItem: document, context: context, currentUser: userCurrent,);
                                          }));
                                        },
                                      );
                                    }).toList()),

                                //second tab

                                GridView.count(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12.0,
                                    mainAxisSpacing: 12.0,
                                    padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 8.0),
                                    shrinkWrap: true,
                                    children: snapshot.data.documents
                                        .where((doc) => doc["request"] == "buy" && userCurrent.uid == doc['userId'])
                                        .map((DocumentSnapshot document) {
                                      return GestureDetector(
                                        child: Material(
                                            color: Colors.white,
                                            shadowColor: Colors.grey,
                                            elevation:14.0,
                                            borderRadius: BorderRadius.circular(24.0),
                                            child: Container(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: <Widget>[
                                                      document["photo_url"] == null || document["photo_url"] == ""
                                                          ? Icon(Icons.broken_image)
                                                          : CachedNetworkImage(
                                                        imageUrl: document["photo_url"],
                                                        fit: BoxFit.cover,
                                                        alignment: Alignment.topLeft,
                                                        placeholder: (context, imageUrl) =>
                                                            CircularProgressIndicator(),
                                                      ),
                                                      Align(
                                                        alignment: Alignment.bottomCenter,
                                                        child: Container(
                                                          width: double.maxFinite,
                                                          height: 26.0,
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: 4.0, horizontal: 16.0),
                                                          color: Color(0x66000000),
                                                          alignment: Alignment.bottomCenter,
                                                          child: Text(
                                                            document['name'],
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                            )
                                        ),
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context){
                                              return SellApplicants(requestedItem: document, context: context, currentUser: userCurrent,);
                                            }));
                                        },
                                      );
                                    }).toList()),

                                //third tab
                                GridView.count(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12.0,
                                    mainAxisSpacing: 12.0,
                                    padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 8.0),
                                    shrinkWrap: true,
                                    children: snapshot.data.documents
                                        .where((doc) => doc["request"] == "getforfree" && userCurrent.uid == doc['userId'])
                                        .map((DocumentSnapshot document) {
                                      return GestureDetector(
                                        child: Material(
                                            color: Colors.white,
                                            shadowColor: Colors.grey,
                                            elevation:14.0,
                                            borderRadius: BorderRadius.circular(24.0),
                                            child: Container(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: <Widget>[
                                                      document["photo_url"] == null || document["photo_url"] == ""
                                                          ? Icon(Icons.broken_image)
                                                          : CachedNetworkImage(
                                                        imageUrl: document["photo_url"],
                                                        fit: BoxFit.cover,
                                                        alignment: Alignment.topLeft,
                                                        placeholder: (context, imageUrl) =>
                                                            CircularProgressIndicator(),
                                                      ),
                                                      Align(
                                                        alignment: Alignment.bottomCenter,
                                                        child: Container(
                                                          width: double.maxFinite,
                                                          height: 26.0,
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: 4.0, horizontal: 16.0),
                                                          color: Color(0x66000000),
                                                          alignment: Alignment.bottomCenter,
                                                          child: Text(
                                                            document['name'],
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                            )
                                        ),
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context){
                                            return GiveawayApplicants(requestedItem: document, context: context, currentUser: userCurrent,);
                                          }));
                                        },
                                      );
                                    }).toList()),

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