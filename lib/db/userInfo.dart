import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_app/db/FirestoreManager.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserInfoList extends StatelessWidget{
  DocumentSnapshot userInfo;
  DocumentSnapshot itemInfo;

  UserInfoList({@required this.userInfo, this.itemInfo});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('items').where("userId", isEqualTo: userInfo.data['uid']).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(body: new Text('Loading...'));
          default:
            return Scaffold(
              appBar: AppBar(
                title: Text(userInfo['name']),
              ),
                 body: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
//              Image.network(userInfo['photo'],
//    //                  height: 150,
//    //                  width: 150,
//                    ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text('User Name: '),
                                ),
                                Expanded(
                                  child: Text(userInfo.data['name']),
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text('User email: '),
                                ),
                                Expanded(
                                    child: Text(userInfo.data['email'])
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(itemInfo.data['name']),
                              ],
                            ),
                            RaisedButton(
                              child: Text(
                                 itemInfo.data['borrowedTo'] == ""  || itemInfo.data['borrowedTo'] == null ?
                                  'Choose' : 'Return'),
                              onPressed: () {
                                if (itemInfo.data['borrowedTo'] == ""  || itemInfo.data['borrowedTo'] == null) {
                                  itemInfo.data['borrowedTo'] = userInfo.data['uid'];
                                  itemInfo.data['borrowName'] = userInfo.data['name'];
                                  Firestore.instance.collection('items')
                                      .document(itemInfo.documentID)
                                      .updateData({
                                    "borrowedTo": itemInfo.data['borrowedTo'],
                                    "borrowName": itemInfo.data['borrowName']
                                  });
                                  debugPrint(itemInfo.data['borrowedTo']);
                                  debugPrint(itemInfo.data['borrowName']);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                                else {
                                  Firestore.instance.collection('items')
                                      .document(itemInfo.documentID)
                                      .updateData({
                                    "borrowedTo": "",
                                    "borrowName": ""
                                  });
                                  Navigator.pop(context);
                                }
                              },
                            ),
                            Text('User\'s items: '),
                      Expanded(
                        child: Container(
                          height: 200.0,
                          child: ListView(
                              children:
                                snapshot.data.documents.map((DocumentSnapshot document){
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
                                            ],
                                          ),
                                      );
                                }).toList()
                            ),
                        ),
                      ),
                    ],
                  ),
            );
      }});
  }
}