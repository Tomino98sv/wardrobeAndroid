import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/st/storage/stPage.dart';

void main() => runApp(MyNewItem());

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
  FirebaseUser userLend;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    initUser();
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
    setState(() {
      _imgUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[
              MyStoragePage2(function: _setImgUrl),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: new InputDecoration(
                          labelText: 'Name',
                          icon: new Icon(Icons.account_circle,
                              color: Colors.brown[800])),
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
                      decoration: new InputDecoration(
                          labelText: 'Color',
                          icon: new Icon(Icons.color_lens,
                              color: Colors.brown[800])),
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
                    child: Icon(Icons.aspect_ratio, color: Colors.brown[800]),
                  ),
                  Expanded(
                    child: Text('Size'),
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
                    child: Icon(Icons.content_cut, color: Colors.brown[800]),
                  ),
                  Expanded(
                    child: Text('Length'),
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
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(30.0),
                      child: InkWell(
                          splashColor: Colors.pink[400],
                          onTap: () {
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
                                      'userId': user.uid
                                    });
                              });
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
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Send',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
