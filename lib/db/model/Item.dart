import 'package:flutter/material.dart';
import 'dart:math';


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
//  static String generateID() {
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

  @override

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Item'),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (String userInput) {
                setState(() {
                  name = userInput;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child:Text(
                "Name: $name",
                style: TextStyle(fontSize: 20.0),
            )),
            TextField(
              onSubmitted: (String userInput) {
                id = userInput;
              },
            ),
            Text(
              "ID: $id",
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

              onChanged: (String newValueSelected){
                //moj kod, co sa ma vykonat, poslat do databazy
                setState(() {
                  this. _currentItemSelected = newValueSelected;
                });
              },



              value: _currentItemSelected,
            ),
            Text(
              "Size: $_currentItemSelected",
              style: TextStyle(fontSize: 20.0),
            )

          ],
        ),
      ),
    );
  }
}


