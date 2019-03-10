import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_app/st/storage/stPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  FirebaseUser user;


  @override
  void initState() {
    super.initState();
    initUser();
  }

  void initUser() async{
    user = await FirebaseAuth.instance.currentUser();
  }

  var _sizes = ['34', '36', '38', '40', '42', '44'];
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
          margin: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              MyStoragePage2(function: _setImgUrl),
              TextField(
                onChanged: (String userInput) {
                  setState(() {
                    name = userInput;
                  });
                },
              ),
              Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text(
                    "Name: $name",
                    style: TextStyle(fontSize: 20.0),
                  )),
              TextField(
                onChanged: (String userInput) {
                  setState(() {
                    color = userInput;
                  });
                },
              ),
              Text(
                "Color: $color",
                style: TextStyle(fontSize: 20.0),
              ),
              TextField(
                onChanged: (String userIn) {
                  size = userIn;
                },
              ),
              DropdownButton<String>(
                items: _sizes.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                onChanged: (String newValueSelected) {
                  setState(() {
                    this._currentItemSelected = newValueSelected;
                  });
                },
                value: _currentItemSelected,
              ),
              Text(
                "Size: $_currentItemSelected",
                style: TextStyle(fontSize: 20.0),
              ),
              TextField(
                onChanged: (String userIn) {
                  length = userIn;
                },
              ),
              DropdownButton<String>(
                items: _length.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                onChanged: (String newValueSelected) {
                  setState(() {
                    this._currentLengthSelected = newValueSelected;
                  });
                },
                value: _currentLengthSelected,
              ),
              Text(
                "Length: $_currentLengthSelected",
                style: TextStyle(fontSize: 20.0),
              ),
              ListTile(
                  title: new RaisedButton(
                child: Text('Send'),
                onPressed: () {
                  if(user != null) {
                    Firestore.instance.runTransaction((transaction) async {
                        await transaction.set(
                            Firestore.instance.collection("items").document(), {
                                'name': name,
                                'color': color,
                                'size': _currentItemSelected,
                                'length': _currentLengthSelected,
                                'photo_url': _imgUrl,
                                'id': "",
                                'userId': user.uid
                              }
                        );
                    });
                  }else {
                    Firestore.instance.runTransaction((transaction) async {
                      await transaction.set(
                          Firestore.instance.collection("items").document(), {
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
              ))
            ],
          ),
        ),
      );
  }
}
