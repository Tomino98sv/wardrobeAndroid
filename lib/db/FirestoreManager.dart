import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_app/db/getItem.dart';
import 'package:flutter_app/db/model/changeImageItem.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_app/db/userInfo.dart';
import 'package:cached_network_image/cached_network_image.dart';


import 'userInfo.dart';

void main() => runApp(ItemsList());


class ItemsList extends StatefulWidget {

  @override
  _ItemsListState createState() {
    return _ItemsListState();
  }
}

class _ItemsListState extends State<ItemsList> {
  
  
  FirebaseUser userCurrent;
  var userName;

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
        snapshot.listen((QuerySnapshot data){
          userName = data.documents[0]['name'];
        });
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('items').snapshots(),
      //shows items from Firebase
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}', style:Theme.of(context).textTheme.subhead);
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...',style:Theme.of(context).textTheme.subhead);
          default:
            return Scaffold(
              body: new ListView(
                children:
                snapshot.data.documents.map((DocumentSnapshot document) {
                  Item item = Item(
                      name: document['name'],
                      color: document['color'],
                      size: document['size'],
                      length: document['length'],
                      photoUrl: document['photo_url'],
                      id: document.documentID,
                      borrowName: document['borrowName']
                  );
                  if(document['userId']!=userCurrent.uid){
                    return Slidable(
                      delegate: new SlidableDrawerDelegate(),
                      actionExtentRatio: 0.25,
                      child: new ExpansionTile(
                        leading: Container(
                          width: 46.0,
                          height: 46.0,
                          child: item.photoUrl == null || item.photoUrl == ""
                              ? Icon(Icons.broken_image)
                              : ZoomableWidget(
                              minScale: 1.0,
                              maxScale: 2.0,
                              // default factor is 1.0, use 0.0 to disable boundary
                              panLimit: 0.0,
                              bounceBackBoundary: true,
                              child: CachedNetworkImage(
                                imageUrl: item.photoUrl,
                                placeholder: (context, imageUrl) => CircularProgressIndicator(),
                              ),
//                              image: AdvancedNetworkImage(
//                                  item.photoUrl,
//                                  useDiskCache: true,
//                                  timeoutDuration: Duration(seconds: 60),
//                                  cacheRule:
//                                  CacheRule(maxAge: const Duration(days: 7)),
//                                  fallbackAssetImage: 'assets/images/image_error.png',
//                                  retryLimit: 0
//                              ),
//                              placeholder: CircularProgressIndicator(),
//                              duration: Duration(milliseconds: 300),)
                          ),
                        ),
                        title: new Text(item.name, style:Theme.of(context).textTheme.subhead),
//                  subtitle: new Text(document['color']),
                        children: <Widget>[
                          new Text("Name: ${item.name}", style:Theme.of(context).textTheme.subhead),
                          new Text("Color: ${item.color}",  style:Theme.of(context).textTheme.subhead),
                          new Text("Size: ${item.size}",style:Theme.of(context).textTheme.subhead),
                          new Text("Length: ${item.length}",style:Theme.of(context).textTheme.subhead),
                          new Text(document['borrowedTo'] == ""  || document['borrowedTo'] == null ?
                          '' :
                          'Borrowed to : ${item.borrowName}', style:Theme.of(context).textTheme.subhead),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(
                                fit: FlexFit.tight,
                                child: Container(
                                  child: InkWell(
                                    onTap: (){ Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return ShowDetails(item: document, user: userCurrent, userName: userName);
//                            return SecondRoute(item: document); //tu je predchadzajuci kod
                                        }));
                                    debugPrint("idem dalej");},
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        color: Theme.of(context).buttonColor,
                                        borderRadius: new BorderRadius.circular(30.0),
                                      ),
                                      margin: EdgeInsets.all(10.0),
                                      height: 40.0,
                                      alignment: Alignment.center,
                                      child: Text('GET dress',style:Theme.of(context).textTheme.subhead,),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                child: Container(
                                  child: InkWell(
                                    onTap: (){
                                      Firestore.instance.collection('users').where("uid", isEqualTo: document['userId']).snapshots().listen((user){
                                        debugPrint(document['userId']);
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                              return UserInfoList2(userInfo: user.documents?.first);
                                            }));
                                      });// kod s vyberom userov Navigator.push},
                                    },
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        color: Theme.of(context).buttonColor,
                                        borderRadius: new BorderRadius.circular(30.0),
                                      ),
                                      margin: EdgeInsets.all(10.0),
                                      height: 40.0,
                                      alignment: Alignment.center,
                                      child: Text('Owner Details', style:Theme.of(context).textTheme.subhead,),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }else{
                    return Container();
                  }
                }).toList(),
              ),
            );
        }
      },
    );;
  }
  
}

//ked chces vybrat user pre borrow
class UserList extends StatelessWidget {
  DocumentSnapshot item;

  UserList({@required this.item});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...',style:Theme.of(context).textTheme.subhead);
            default:
              return Scaffold(
                  appBar: AppBar(
                  title: Text("Fashionistas", style: TextStyle(color: Colors.white),),
                  ),
                body: new ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: document['photoUrl'],
                      height: 42.0,
                      width: 42.0,
                      placeholder: (context, imageUrl) => CircularProgressIndicator(),
                    ),
                    trailing:
                        Icon(Icons.info_outline,color: Theme.of(context).buttonColor),
                    title: Text(document['name']),
                    onTap: () {
                      //kod ktory urci usra, ktoremu bolo pozicane
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return UserInfoList(userInfo: document, itemInfo: item);
                      }));
                    },
                  );
                }).toList()),
              );
          }
        });
  }
}




class DialogonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height - 60.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

//searching bar
class ItemsListSearch extends SearchDelegate<ItemsList> {
  var items = Firestore.instance.collection('items').snapshots();

  ItemsListSearch(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: items,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text("No  data", style:Theme.of(context).textTheme.subhead),
              );
            }
            final results = snapshot.data.documents
                .where((a) => a['name'].toLowerCase().contains(query));

            return ListView(
              children: results.map(
                (DocumentSnapshot document) {
                },
              ).toList(),
            );
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: items,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("No  data"),
            );
          }
          final results = snapshot.data.documents
              .where((a) => a['name'].startsWith(query))
              .toList();
          //a.documentID.toLowerCase().contains(query));
          return ListView(
            children: results
                .map<ListTile>((a) => ListTile(
                      title: Text(a['name'],
                          style: Theme.of(context).textTheme.subhead.copyWith(
                                fontSize: 16.0,
                                color: Colors.black,
                              )),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ShowDetails(
                            item: a,
                          );
                        }));
                      },
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class Item {
  var name;
  var color;
  var size;
  var length;
  var photoUrl;
  var id;
  var userid;
  var borrowedTo = "";
  var borrowName = "";
  var request = "";
  var description = "";
  

  Item({this.name, this.color, this.size, this.length, this.photoUrl, this.id, this.userid, this.borrowedTo, this.borrowName, this.request, this.description
  });

}
// 5. screen
class UserListHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return Scaffold(
                  body:
                  ListView(
                            children: snapshot.data.documents
                                .map((DocumentSnapshot document) {
                              return Container(
                                height: 80.0,
                                padding:  EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                child: Material(
                                  color: Colors.white,
                                  shadowColor: Colors.grey,
                                  elevation: 14.0,
                                  borderRadius: BorderRadius.circular(14.0),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.only(top: 7.0, left: 12.0, right: 12.0),                                    leading:  ClipOval(
                                      child: CachedNetworkImage(
                                        width: 50.0,
                                        height: 50.0,
                                        fit: BoxFit.cover,
                                        imageUrl: document['photoUrl'],
                                        
                                        placeholder: (context, imageUrl) => CircularProgressIndicator(),
                                      ),
                                    ),
//                              leading: Image.network(
//                                  document['photoUrl'],
//                              height: 42.0,
//                                  width: 42.0,),
                                      trailing: Icon(Icons.info_outline,color: Theme.of(context).buttonColor),
                                    title: Text(document['name'], style: Theme.of(context).textTheme.subhead,),
                                    onTap: () {
                                      //kod ktory urci usra, ktoremu bolo pozicane
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {


                                                //firebaseuser where zo streambuilderu user.uid je userinfo['userid']
                                            return UserInfoList2(userInfo: document);
                                          }));
                                    },
                                  ),
                                ),
                              );
                            }).toList()),
                );
            }
          }),
    );
  }
}

//searching bar
class UserListSearch extends SearchDelegate<UserList> {
  var users = Firestore.instance.collection('users').snapshots();

  UserListSearch(this.users);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: users,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text("No  data", style:Theme.of(context).textTheme.subhead),
              );
            }
            final results = snapshot.data.documents
                .where((a) => a['name'].toUpperCase().contains(query));

            return ListView(
              children: results.map(
                    (DocumentSnapshot document) {}
              ).toList(),
            );
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: users,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("No  data"),
            );
          }
          final results = snapshot.data.documents
              .where((a) => a['name'].startsWith(query))
              .toList();
          //a.documentID.toLowerCase().contains(query));
          return ListView(
            children: results
                .map<ListTile>((a) => ListTile(
              title: Text(a['name'],
                  style: Theme.of(context).textTheme.subhead.copyWith(
                    fontSize: 16.0,
                    color: Colors.black,
                  )),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return UserInfoList2(
                        userInfo: a,
                      );
                    }));
              },
            ))
                .toList(),
          );
        },
      ),
    );
  }
}
