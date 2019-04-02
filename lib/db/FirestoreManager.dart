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
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('items').snapshots(),
      //shows items from Firebase
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
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
                            child: TransitionToImage(
                              image: AdvancedNetworkImage(
                                  item.photoUrl,
                                  useDiskCache: true,
                                  timeoutDuration: Duration(seconds: 60),
                                  cacheRule:
                                  CacheRule(maxAge: const Duration(days: 7)),
                                  fallbackAssetImage: 'assets/images/image_error.png',
                                  retryLimit: 0
                              ),
                              placeholder: CircularProgressIndicator(),
                              duration: Duration(milliseconds: 300),)
                        ),
                      ),
                      title: new Text(item.name),
//                  subtitle: new Text(document['color']),
                      children: <Widget>[
                        new Text("Name: ${item.name}"),
                        new Text("Color: ${item.color}"),
                        new Text("Size: ${item.size}"),
                        new Text("Length: ${item.length}"),
                        new Text(document['borrowedTo'] == ""  || document['borrowedTo'] == null ?
                        '' :
                        'Borrowed to : ${item.borrowName}'),
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
                                        return ShowDetails(item: document, user: userCurrent,);
//                            return SecondRoute(item: document); //tu je predchadzajuci kod
                                      }));
                                  debugPrint("idem dalej");},
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.pink,
                                      borderRadius: new BorderRadius.circular(30.0),
                                    ),
                                    margin: EdgeInsets.all(10.0),
                                    height: 40.0,
                                    alignment: Alignment.center,
                                    child: Text('GET dress',style: TextStyle(color: Colors.white),),
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
                                      color: Colors.pink,
                                      borderRadius: new BorderRadius.circular(30.0),
                                    ),
                                    margin: EdgeInsets.all(10.0),
                                    height: 40.0,
                                    alignment: Alignment.center,
                                    child: Text('Owner Details', style: TextStyle(color: Colors.white),),
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
            );
        }
      },
    );;
  }
  
}


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
              return new Text('Loading...');
            default:
              return Scaffold(
                  appBar: AppBar(
                  title: Text("Fashonistats"),),
                body: new ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                  return ListTile(
                    trailing: Icon(Icons.send, color: Colors.pink,),
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

//editing item screen
class EditItem extends StatefulWidget {
  DocumentSnapshot item;

  EditItem({@required this.item});

  _State createState() => new _State(item: item);
}

class _State extends State<EditItem> {
  DocumentSnapshot item;

  _State({@required this.item}) {
    docName = item['name'];
    docColor = item['color'];
    docSize = item['size'];
    docLength = item['length'];
 //   docImage = item['photo_url'];
  }

  String docName = '';
  String docColor = '';
  String docSize = '';
  String docLength = '';


  void _onChangedName(String value) {
    setState(() => docName = '$value');
  }

  void _onChangedColor(String value) {
    setState(() => docColor = '$value');
  }

  void _onChangedSize(String value) {
    setState(() => docSize = '$value');
  }

  void _onChangedLength(String value) {
    setState(() => docLength = '$value');
  }


//
//  void _onSubmit(String value) {
//    setState(() => docName = 'Submit: $value');
//  }

  var _sizes = ['34', '36', '38', '40', '42', '44', '46', '48'];
  var _currentItemSelected = '38';
  var _length = ['Mini', 'Midi', 'Maxi', 'Oversize'];
  var _currentLengthSelected = 'Midi';





  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Edit Item'),
      ),
      body: SingleChildScrollView(
        child: new Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
                Container(
                  width: 200.0,
                  height: 200.0,
                  child: new ZoomableWidget(
                      minScale: 1.0,
                      maxScale: 2.0,
                      // default factor is 1.0, use 0.0 to disable boundary
                      panLimit: 0.0,
                      bounceBackBoundary: true,
                      child: TransitionToImage(
                        image: AdvancedNetworkImage(
                          item['photo_url'],
                          useDiskCache: true,
                          cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                        ),
                        placeholder: CircularProgressIndicator(),
                        duration: Duration(milliseconds: 300),
                      )),
                ),
                changeImageItem(item: item),
                new TextField(
                  decoration: new InputDecoration(
                      labelText: item['name'],
                      icon: new Icon(Icons.account_circle,
                          color: Colors.black)),
                  onChanged: _onChangedName,
                ),
                new TextField(
                  decoration: new InputDecoration(
                      labelText: item['color'],
                      icon:
                          new Icon(Icons.color_lens, color: Colors.black)),
                  onChanged: _onChangedColor,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Icon(Icons.aspect_ratio,
                    color: Colors.black),
                    ),
                    Expanded(
                      child: Text(
                        'Size:'
                      ),
                    ),
                    Expanded(
                      child: DropdownButton(
                          items: _sizes.map((String dropDownStringItem){
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (String newValueSelected) {
                            setState(() {
                              this._currentItemSelected = newValueSelected;
                              docSize = newValueSelected;
                            });
                            _onChangedSize(docSize);
                          },
                        //value: _currentItemSelected,
                       value: _currentItemSelected == item['size'].toString() ? item['size'].toString() : docSize
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Icon(Icons.content_cut,
                          color: Colors.black),
                    ),
                    Expanded(
                      child: Text(
                          'Length:'
                      ),
                    ),
                    Expanded(
                      child: DropdownButton(
                        items: _length.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          setState(() {
                            this._currentLengthSelected = newValueSelected;
                            docLength = newValueSelected;
                          });
                          _onChangedLength(docLength);
                        },
                        value: _currentLengthSelected == item['length'].toString() ? item['length'].toString() : docLength
//                        value: item['length'].toString(),
//                      value: _currentLengthSelected,
                      ),
                    ),
                  ],
                ),
                  Container(
                    child: InkWell(
                      onTap:() {  if (docName != '') {
                  Firestore.instance
                      .collection('items')
                      .document(item.documentID)
                      .updateData({"name": docName});
                  debugPrint("zmenil som meno");
                  }
                      if (docColor != '') {
          Firestore.instance
              .collection('items')
              .document(item.documentID)
              .updateData({"color": docColor});
          debugPrint("zmenil som farbu");
          }
              if (docSize != '') {
        Firestore.instance
            .collection('items')
            .document(item.documentID)
            .updateData({"size": docSize});
        debugPrint("zmenil som velkost");
        }
            if (docLength != '') {
      Firestore.instance
          .collection('items')
          .document(item.documentID)
          .updateData({"length": docLength});
      debugPrint("zmenil som dlzku");

      }
          Navigator.pop(context);},
                      child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.pink,
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Send',style: TextStyle(color: Colors.white),),
                ),),),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
    return StreamBuilder<QuerySnapshot>(
        stream: items,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("No  data"),
            );
          }
          final results = snapshot.data.documents
              .where((a) => a['name'].toLowerCase().contains(query));

          return ListView(
            children: results.map(
              (DocumentSnapshot document) {
                Item item = Item(
                    name: document['name'],
                    color: document['color'],
                    size: document['size'],
                    length: document['length'],
                    photoUrl: document['photo_url'],
                    id: document.documentID);
              },
            ).toList(),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
//                 close(context, a);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
//                 return ShowDetails(item: Item(name: a['name'],
//                   color: a['color'],
//                   size: a['size'],
//                   length: a['length'],
//                   photoUrl: a['photo_url'],
//                   id: a.documentID
//                 ));
                        return ShowDetails(
                          item: a,
                        );
                      }));
                    },
                  ))
              .toList(),
        );
      },
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
  

  Item({this.name, this.color, this.size, this.length, this.photoUrl, this.id, this.userid, this.borrowedTo, this.borrowName, this.request});

}

class UserListHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return Scaffold(
                body: new ListView(
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                            return ListTile(
                              leading: Image.network(
                                  document['photoUrl'],
                              height: 42.0,
                                  width: 42.0,),
                              trailing: Icon(Icons.send, color: Colors.pink,),
                              title: Text(document['name']),
                              onTap: () {
                                //kod ktory urci usra, ktoremu bolo pozicane
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return UserInfoList2(userInfo: document);
                                    }));
                              },
                            );
                          }).toList()),
              );
          }
        });
  }

}
