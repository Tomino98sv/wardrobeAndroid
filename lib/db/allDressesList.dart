import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/filter.dart';
import 'package:flutter_app/db/FirestoreManager.dart';
import 'package:flutter_app/db/getItem.dart';
import 'package:flutter_app/db/userInfo.dart';

class AllDressesList extends StatefulWidget {
  String filterValue;

  AllDressesList({Key key, @required this.filterValue}) : super(key: key);

  @override
  DressesListState createState() {
    return DressesListState(filterValue: filterValue);
  }
}

class DressesListState extends State<AllDressesList>
    with TickerProviderStateMixin {
  FirebaseUser userCurrent;
  var userName;

  bool showFilters = false;
  String filterValue;

  DressesListState({@required this.filterValue});

//  get filterValue => filterValue;

  var docSize = "";

  void onChangeSize(String value) {
    setState(() => docSize = '$value');
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        userCurrent = fUser;
        Stream<QuerySnapshot> snapshot = Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: userCurrent.uid)
            .snapshots();
        snapshot.listen((QuerySnapshot data) {
          userName = data.documents[0]['name'];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          createFilter(),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('items').snapshots(),
            //shows items from Firebase
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}',
                    style: Theme.of(context).textTheme.subhead);
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...',
                      style: Theme.of(context).textTheme.subhead);
                default:
                  return  Expanded(
                    child: Stack(
                      children: <Widget> [
                        GridView.count(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8.0),
                          crossAxisCount: 3,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          shrinkWrap: true, //must be here!!!!
                          children: snapshot.data.documents
                              .where((doc) => doc["userId"] != userCurrent.uid)
                              .map((DocumentSnapshot document) {
                            Item item = Item(
                              name: document['name'],
                              color: document['color'],
                              size: document['size'],
                              length: document['length'],
                              photoUrl: document['photo_url'],
                              id: document.documentID,
                              borrowName: document['borrowName'],
                              description: document['description'],
                            );
                            debugPrint("Filter value je $filterValue");
//                      if (docSize != ""){
                          if (filterValue == null || item.size == filterValue || item.color == filterValue || item.length == filterValue){
                            return GestureDetector(
                              child: Material(
                                color: Colors.white,
                                shadowColor: Colors.grey,
                                elevation: 14.0,
                                borderRadius: BorderRadius.circular(24.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      item.photoUrl == null ||
                                              item.photoUrl == ""
                                          ? Icon(Icons.broken_image)
                                          : CachedNetworkImage(
                                              imageUrl: item.photoUrl,
                                              fit: BoxFit.cover,
                                              alignment: Alignment.topLeft,
                                              placeholder: (context,
                                                      imageUrl) =>
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    child: CupertinoAlertDialog(
                                      title: Text(item.name,style: TextStyle(fontFamily: 'Pacifico')),
                                      content: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          CachedNetworkImage(
                                            imageUrl: item.photoUrl,
                                            placeholder: (context, imageUrl) =>
                                                CircularProgressIndicator(),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(child: Text(item.description,
                                                  style: TextStyle(fontFamily: 'Pacifico'),
                                                  textAlign: TextAlign.center),),
                                            ],
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return ShowDetails(
                                                      item: document,
                                                      user: userCurrent,
                                                      userName: userName);
                                                }));
                                              },
                                              child: Text("Get"),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                Firestore.instance
                                                    .collection('users')
                                                    .where("uid",
                                                        isEqualTo:
                                                            document['userId'])
                                                    .snapshots()
                                                    .listen((user) {
                                                  debugPrint(
                                                      document['userId']);
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return UserInfoList2(
                                                        userInfo: user
                                                            .documents?.first);
                                                  }));
                                                });
                                              },
                                              child: Text("Seller"),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel"),
                                            )
                                          ],
                                        )
                                      ],
                                    ));
                              },
                            );
                            }
                          else
                            return Container();
                          }).toList(),
                        ),
                      ]
                    ),
                  );
              }
            },
          )
        ],
      ),
    );
  }

  void setFilterValue(String value) {
    setState(() {
      filterValue = value;
    });
  }

  Widget createFilter() {
    if (showFilters)
      return FilterChipDisplay(function: setFilterValue);
    else
      return Container();
  }
}

