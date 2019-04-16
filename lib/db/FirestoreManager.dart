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
                  title: Text("Fashonistats"),
                  ),
                body: new ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                  return ListTile(
                    trailing: Icon(Icons.send,color: Theme.of(context).buttonColor),
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
    if (item['request'] == 'borrow')
      docFunction = '';
    else if (item['request'] == 'buy')
      docFunction = "sell";
    else
      docFunction = item['request'];
    if (item['price']!=null)
      docPrice = item['price'];
 //   docImage = item['photo_url'];
  }

  String docName = '';
  String docColor = '';
  String docSize = '';
  String docLength = '';
  String docFunction = '';
  String docPrice = '';


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

  void _onChangedFunction(String value) {
    setState(() {
      if (value == '-not selected-')
        docFunction = "";
      else
        docFunction = '$value';
    });
  }

  void _onChangedPrice(String value) {
    setState(() {
      docPrice = '$value';
    });
  }


//
//  void _onSubmit(String value) {
//    setState(() => docName = 'Submit: $value');
//  }

  var _sizes = ['34', '36', '38', '40', '42', '44', '46', '48'];
  var _currentItemSelected = '38';
  var _length = ['Mini', 'Midi', 'Maxi', 'Oversize'];
  var _currentLengthSelected = 'Midi';
  var _functions = ['-not selected-', 'giveaway', 'sell'];
  var _currentFunctionSelected = '-not selected-';





  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Edit Item',style:Theme.of(context).textTheme.subhead),
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
                      child: CachedNetworkImage(
                        imageUrl: item['photo_url'],
                        placeholder: (context, imageUrl) => CircularProgressIndicator(),
                      ),
//                      child: TransitionToImage(
//                        image: AdvancedNetworkImage(
//                          item['photo_url'],
//                          useDiskCache: true,
//                          cacheRule: CacheRule(maxAge: const Duration(days: 7)),
//                        ),
//                        placeholder: CircularProgressIndicator(),
//                        duration: Duration(milliseconds: 300),
//                      )),
                ),),
                changeImageItem(item: item),
                new TextField(
                    style:Theme.of(context).textTheme.subhead,
                  decoration: new InputDecoration(
                      labelText: item['name'],
                      icon: new Icon(Icons.account_circle,
                          color: Theme.of(context).buttonColor)),
                  onChanged: _onChangedName,
                ),
                new TextField(
                    style:Theme.of(context).textTheme.subhead,
                  decoration: new InputDecoration(
                      labelText: item['color'],
                      icon:
                          new Icon(Icons.color_lens, color: Theme.of(context).buttonColor)),
                  onChanged: _onChangedColor,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Icon(Icons.aspect_ratio,
                    color: Theme.of(context).buttonColor),
                    ),
                    Expanded(
                      child: Text(
                        'Size:',style:Theme.of(context).textTheme.subhead
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
                          color: Theme.of(context).buttonColor),
                    ),
                    Expanded(
                      child: Text(
                          'Length:', style:Theme.of(context).textTheme.subhead
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Icon(Icons.business_center,
                          color: Theme.of(context).buttonColor),
                    ),
                    Expanded(
                      child: Text(
                          'Sell/Giveaway:', style:Theme.of(context).textTheme.subhead
                      ),
                    ),
                    Expanded(
                      child: DropdownButton(
                          items: _functions.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (String newValueSelected) {
                            setState(() {
                              this._currentFunctionSelected = newValueSelected;
                              if (newValueSelected == '-not selected-')
                                docFunction = "";
                              else
                                docFunction = newValueSelected;
                            });
                            _onChangedFunction(docFunction);
                          },
                          value: _currentFunctionSelected == item['request'].toString()
                              ? item['request'].toString()
                              : docFunction == ""
                              ? '-not selected-' : docFunction
//                        value: item['length'].toString(),
//                      value: _currentLengthSelected,
                      ),
                    ),
                  ],
                ),
                  Container(
//                    child: (item['request'] == 'sell' || docFunction == 'sell')
                    child: (docFunction == 'sell')
                    ? Row(
                      children: <Widget>[
                        Expanded(
                          child: Icon(Icons.monetization_on, color: Theme.of(context).buttonColor),
                        ),
                        Expanded(
                          child: Text('Set price:',style:Theme.of(context).textTheme.subhead),
                        ),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            style:Theme.of(context).textTheme.subhead,
                            decoration: new InputDecoration(
                                labelText: item['price'],),
                            onChanged: _onChangedPrice,
                              ),
                        )
                      ],
                    ) : Container(),
                  ),
                  Container(
                    child: InkWell(
                      onTap:() {
                        if (docName != '') {
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
//                        if (docFunction !=''){

//                        if(docFunction == 'sell' && item['request'].toString() == 'buy'){
                        if(docFunction == 'sell'){
                          debugPrint('teraz je tototoo');
                          var count = 0;
                          Firestore.instance.collection('requestBuy')
                              .where('respondent', isEqualTo: item['userId']).where('itemID', isEqualTo: item.documentID).getDocuments().then((foundDoc){
                            for (DocumentSnapshot ds in foundDoc.documents){
                              if (ds['respondent'] == item['userId']){
                                count++;
                              }
                            }

                            if (count!=0){
                              Firestore.instance
                                  .collection('items')
                                  .document(item.documentID)
                                  .updateData({"request": 'buy'});
                              debugPrint("zmenul som funkciu/request");
                            }
                          });

                        } else if (item['request'].toString() != 'borrow' || docFunction!=''){
                          Firestore.instance
                              .collection('items')
                              .document(item.documentID)
                              .updateData({"request": docFunction});
                          debugPrint("zmenul som funkciu/request");
                        }
                        if (docPrice != '') {
                          Firestore.instance
                              .collection('items')
                              .document(item.documentID)
                              .updateData({"price": docPrice});
                          debugPrint("zmenil som cenu");
                        }
                        if (docFunction != 'sell'){
                          Firestore.instance
                              .collection('items')
                              .document(item.documentID)
                              .updateData({'price' : FieldValue.delete()});
                        }
                        Navigator.pop(context);},
                      child: Container(
                          decoration: new BoxDecoration(
                           color: Theme.of(context).buttonColor,
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Send',style:Theme.of(context).textTheme.subhead,),
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
  

  Item({this.name, this.color, this.size, this.length, this.photoUrl, this.id, this.userid, this.borrowedTo, this.borrowName, this.request});

}

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
                  body: new ListView(
                            children: snapshot.data.documents
                                .map((DocumentSnapshot document) {
                              return ListTile(
                                leading:  CachedNetworkImage(
                                  imageUrl: document['photoUrl'],
                                  height: 42.0,
                                  width: 42.0,
                                  placeholder: (context, imageUrl) => CircularProgressIndicator(),
                                ),
//                              leading: Image.network(
//                                  document['photoUrl'],
//                              height: 42.0,
//                                  width: 42.0,),
                                trailing: Icon(Icons.send, color: Theme.of(context).buttonColor,),
                                title: Text(document['name'], style: Theme.of(context).textTheme.subhead,),
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
