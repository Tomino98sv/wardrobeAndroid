import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';
import 'package:flutter_app/st/storage/mainSt.dart';
import 'package:flutter_app/db/FirestoreManager.dart';
import 'package:flutter_app/db/model/Item.dart';


//zatial na testovanie

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: "Firebase Demo na login",
      theme: new ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: new WelcomePage(),
    );
  }
}







//tu je vas dole

//void main() {
//  runApp( MaterialApp(
//    title: "Dress",
//    home: Scaffold(
////      body: getListView(),
////      body: DatabaseList(),
////    body: MyAppSt(),
////    body: ItemsList(),
//
////    body: MyNewItem(),
//     floatingActionButton: new FloatingActionButton(
//          child: Icon(Icons.add),
//          onPressed: (){
//
//
//
//      }),
//    )
//  ));
//
//}
