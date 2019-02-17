import 'package:flutter/material.dart';
import 'package:flutter_app/st/storage/stPage.dart';


void main() => runApp( new MyAppSt());

class MyAppSt extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return  new MaterialApp(
      title: "Firebase Storage",
      theme: new ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: new MyStoragePage2(),
    );
  }
}

