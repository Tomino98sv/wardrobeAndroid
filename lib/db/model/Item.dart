import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_app/st/storage/stPage.dart';

void main() => runApp(MyNewItem());

//class Item {
//  String id = generateID();
//  String userId;
//  String name;
//  int size;
//  String length;
//  String color;
//
//  Item(this.id, this.userId, this.name, this.size, this.length, this.color);
//
//  public String generateID() {
//    var random = new Random();
//    String newID = random.toString();
//    return newID;
//  }
//
//
//}

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

  var _sizes = ['34', '36', '38', '40', '42', '44'];
  var _currentItemSelected = '34';
  var _length = ['Mini', 'Midi', 'Maxi', 'Oversize'];
  var _currentLengthSelected = 'Midi';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Add New Item'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              MyStoragePage2(),
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
                  //moj kod, co sa ma vykonat, poslat do databazy
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
                  //moj kod, co sa ma vykonat, poslat do databazy
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
                  Firestore.instance.runTransaction((transaction) async {
                    await transaction.set(Firestore.instance.collection("items").document(), {
                      'name': name,
                      'color': color,
                      'size': _currentItemSelected,
                      'length': _currentLengthSelected,
                      'photo_url': "", //tu treba dat _path od mimik
                      'id': "",
                      'userId': ""
                    });
                    debugPrint("poslal");
                  });
                },
              ))
            ],
          ),
        ),
      ),
//      floatingActionButton: new RaisedButton(
//          child: Text('Send'),
//          onPressed: (){
//            Firestore.instance.runTransaction((transaction) async {
//              await transaction.set(Firestore.instance.collection("items").document(), {
//                'name' : name,
//                'color' : color,
//                'size': _currentItemSelected,
//                'length' : _currentLengthSelected,
//                'photo_url' : "", //tu treba dat _path od mimik
//                'id' : "",
//                'userId' : ""
//              });
//            }
//            );
//
//
//          }),
    );
  }
}
