import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'userInfo.dart';

void main() => runApp(ItemsList());

//scrolling list of items
class ItemsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                return Slidable(
                  delegate: new SlidableDrawerDelegate(),
                  actionExtentRatio: 0.25,
                  child: new ExpansionTile(
                    leading: Container(
                      width: 46.0,
                      height: 46.0,
                      child: item.photoUrl == null || item.photoUrl == ""
                          ? Icon(Icons.accessibility)
                          : TransitionToImage(
                          image: AdvancedNetworkImage(
                            item.photoUrl,
                            useDiskCache: true,
                            cacheRule:
                            CacheRule(maxAge: const Duration(days: 7)),
                            fallbackAssetImage: 'assets/images/error_image.png',
                            retryLimit: 0
                          ),
                          placeholder: CircularProgressIndicator(),
                          duration: Duration(milliseconds: 300),),
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
                                      return EditItem(item: document);
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
                                      child: Text('Edit',style: TextStyle(color: Colors.white),),
                                    ),
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                            child: InkWell(
                              onTap: (){ if (document['borrowedTo'] == ""  || document['borrowedTo'] == null) {
                                 Navigator.push(context,
                                 MaterialPageRoute(builder: (context) {return UserList(item: document);
                                }));
                                          }
                                        else {
                                          Firestore.instance.collection('users').where("uid", isEqualTo: document['borrowedTo']).snapshots().listen((user){
                                            Navigator.push(context,
                                             MaterialPageRoute(builder: (context) {
                                                return UserInfoList(userInfo: user.documents?.first, itemInfo: document);
                                              }));
                                           });

                                         }
                                         // kod s vyberom userov Navigator.push},
                              },
                              child: Container(
                                decoration: new BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                margin: EdgeInsets.all(10.0),
                                height: 40.0,
                                alignment: Alignment.center,
                                child: Text(document['borrowedTo'] == ""  || document['borrowedTo'] == null
                                    ? 'Borrow to...'
                                    : 'Return dress', style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  secondaryActions: <Widget>[
                    new IconSlideAction(
                      icon: Icons.transfer_within_a_station,
                      caption: 'Delete',
                      color: Colors.red,
                      onTap: () {
                        debugPrint('klikol som');
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Item'),
                              content: Text(
                                  'Are you sure you want to delete this item?'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    Firestore.instance
                                        .collection('items')
                                        .document(item.id)
                                        .delete();
//                                    StorageReference obr = FirebaseStorage.instance.getReferenceFromUrl(item.photoUrl);
//                                    obr.delete();
                                    deleteFireBaseStorageItem(item.photoUrl);
                                    Navigator.pop(context);
                                    debugPrint("vymazanee");
                                  },
                                ),
                                FlatButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              }).toList(),
            );
        }
      },
    );
  }

  void deleteFireBaseStorageItem(String fileUrl) {
    String filePath = fileUrl.replaceAll(
        new RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/wardrobe-2324a.appspot.com/o/'),
        '');
    filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
    StorageReference storageReferance = FirebaseStorage.instance.ref();
    storageReferance
        .child(filePath)
        .delete()
        .then((_) => print('Successfully deleted $filePath storage item'));
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

class ShowDetails extends StatefulWidget {
  DocumentSnapshot item;

  ShowDetails({@required this.item});

  _ShowDetails createState() => new _ShowDetails(item: item);
}

//show details about item with option to edit
class _ShowDetails extends State<ShowDetails> {
  DocumentSnapshot item;

  _ShowDetails({@required this.item});

  @override
  void initState() {
    super.initState();
    debugPrint("XXX ini starte");
    Firestore.instance
        .collection('items')
        .document(item.documentID)
        .get()
        .then((onValue) {
      setState(() {
        debugPrint("XXX firestore");
        item = onValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("XXX build");
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('items')
            .document(item.documentID)
            .get()
            .asStream(),
        //shows items from Firebase
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Scaffold(body: new Text('Loading...'));
            default:
              return new Scaffold(
                appBar: new AppBar(
                  title: new Text(snapshot.data['name']),
                ),
                body: SingleChildScrollView(
                  child: new Container(
                    padding: new EdgeInsets.all(100.0),
                    child: new Center(
                      child: new Column(
                        children: <Widget>[
//                new Flexible(
//                  child: new ZoomableImage(
                          Image.network(snapshot.data['photo_url'],
                              height: 120, width: 120
//                    ,)
                              ),
                          Row(
                            children: <Widget>[
                              Expanded(child: Icon(Icons.account_circle)),
                              Expanded(
                                child: Text(snapshot.data['name']),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Icon(Icons.color_lens),
                              ),
                              Expanded(
                                child: Text(snapshot.data['color']),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Icon(Icons.aspect_ratio),
                              ),
                              Expanded(
                                child: Text(snapshot.data['size']),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Icon(Icons.content_cut),
                              ),
                              Expanded(
                                child: Text(snapshot.data['length']),
                              )
                            ],
                          ),
                          Container(
                            child: InkWell(
                              onTap: (){ Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return EditItem(
                                      item: snapshot.data,
                                    );
                                  }));},
                              child: Container(
                                decoration: new BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('Edit',style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
          }
        });
  }
}

//editing item screen
class EditItem extends StatefulWidget {
  DocumentSnapshot item;

  EditItem({@required this.item});

  _State createState() => new _State(item: item);
}

class _State extends State<EditItem> {
  DocumentSnapshot item;

  _State({@required this.item});

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
                new TextField(
                  decoration: new InputDecoration(
                      labelText: item['name'],
                      icon: new Icon(Icons.account_circle,
                          color: Colors.brown[800])),
                  onChanged: _onChangedName,
                ),
                new TextField(
                  decoration: new InputDecoration(
                      labelText: item['color'],
                      icon:
                          new Icon(Icons.color_lens, color: Colors.brown[800])),
                  onChanged: _onChangedColor,
                ),
                new TextField(
                  decoration: new InputDecoration(
                      labelText: item['size'],
                      icon: new Icon(Icons.aspect_ratio,
                          color: Colors.brown[800])),
                  onChanged: _onChangedSize,
                ),
                new TextField(
                  decoration: new InputDecoration(
                      labelText: item['length'],
                      icon: new Icon(Icons.content_cut,
                          color: Colors.brown[800])),
                  onChanged: _onChangedLength,
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

  Item({this.name, this.color, this.size, this.length, this.photoUrl, this.id, this.userid, this.borrowedTo, this.borrowName});

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
