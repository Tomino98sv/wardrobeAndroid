import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/st/storage/stPage.dart';

//void main() => runApp(MyNewItem());

class MyNewItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyNewItem();
  }
}

class _MyNewItem extends State<MyNewItem> {
  String name = "";
  String id = "";
  String userId = "";
  String size = "34";
  String length = "";
  String color = "";
  String borrowedTo = "";
  String borrowName = "";
  FirebaseUser userLend;
  FirebaseUser user;

  var stPage;

  @override
  void initState() {
    super.initState();
    initUser();
    stPage = MyStoragePage2(function: _setImgUrl);
  }

  void initUser() async {
    user = await FirebaseAuth.instance.currentUser();
  }

  var _sizes = ['34', '36', '38', '40', '42', '44', '46', '48'];
  var _currentItemSelected = '38';
  var _length = ['Mini', 'Midi', 'Maxi', 'Oversize'];
  var _currentLengthSelected = 'Midi';
  String _imgUrl = "";

  void _setImgUrl(String url) {
    if (url.isEmpty) {
      _showSnackBar("Upload failed");
    } else
      setState(() {
        _imgUrl = url;
      });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Create New Item",style:Theme.of(context).textTheme.subhead),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              children: <Widget>[
                stPage,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        style:Theme.of(context).textTheme.subhead,
                        decoration: new InputDecoration(
                            labelText: 'Name',
                            icon: new Icon(Icons.account_circle,
                                color: Colors.black)),
                        onChanged: (String userInput) {
                          setState(() {
                            name = userInput;
                          });
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        style:Theme.of(context).textTheme.subhead,
                        decoration: new InputDecoration(
                            labelText: 'Color',
                            icon: new Icon(Icons.color_lens,
                                color: Colors.black)),
                        onChanged: (String userInput) {
                          setState(() {
                            color = userInput;
                          });
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Icon(Icons.aspect_ratio, color: Colors.black),
                    ),
                    Expanded(
                      child: Text('Size',style:Theme.of(context).textTheme.subhead),
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        items: _sizes.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          setState(() {
                            this._currentItemSelected = newValueSelected;
                            size = newValueSelected;
                          });
                        },
                        value: _currentItemSelected,
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Icon(Icons.content_cut, color: Colors.black),
                    ),
                    Expanded(
                      child: Text('Length',style:Theme.of(context).textTheme.subhead),
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        items: _length.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          setState(() {
                            this._currentLengthSelected = newValueSelected;
                            length = newValueSelected;
                          });
                        },
                        value: _currentLengthSelected,
                      ),
                    )
                  ],
                ),
                ListTile(
                    title: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Material(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(30.0),
                    child: InkWell(
                      splashColor:Theme.of(context).accentColor,
                      onTap: () {
                        if (_imgUrl != "" && stPage.uploadLoad) {
                          print("tapped");
                          if (user != null) {
                            Firestore.instance
                                .runTransaction((transaction) async {
                              await transaction.set(
                                  Firestore.instance
                                      .collection("items")
                                      .document(),
                                  {
                                    'name': name,
                                    'color': color,
                                    'size': _currentItemSelected,
                                    'length': _currentLengthSelected,
                                    'photo_url': _imgUrl,
                                    'id': "",
                                    'userId': user.uid,
                                    'borrowedTo': borrowedTo,
                                    'borrowName': borrowName
                                  });
                            });
                            Navigator.pop(context);
                            // tu bude navigatior pop!
                          } else {
                            Firestore.instance
                                .runTransaction((transaction) async {
                              await transaction.set(
                                  Firestore.instance
                                      .collection("items")
                                      .document(),
                                  {
                                    'name': name,
                                    'color': color,
                                    'size': _currentItemSelected,
                                    'length': _currentLengthSelected,
                                    'photo_url': _imgUrl,
                                    'id': "",
                                    'userId': ""
                                  });

                              debugPrint("poslal");
                            });
                          }
                        }
                        if (_imgUrl == "" && stPage.uploadLoad) {
                          _showSnackBar("First confirme picture");
                        }
                        if (stPage.uploadLoad == false) {
                          _showSnackBar(
                              "Choose picture source between camera and galery");
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Send',
                          style:Theme.of(context).textTheme.subhead,
                        ),
                      ),
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showSnackBar(String str) {
    final snackBar = new SnackBar(
      content: new Text(str, style:Theme.of(context).textTheme.subhead),
      duration: new Duration(seconds: 3),
      backgroundColor: Colors.pinkAccent,
      action: new SnackBarAction(
          label: 'OUKEY',
          onPressed: () {
            print("pressed snackbar");
          }),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
