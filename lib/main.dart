import 'package:flutter/material.dart';
import 'package:flutter_app/ui/homePage.dart';
import 'package:flutter_app/bl/mainLogin.dart';
import 'package:flutter_app/st/storage/mainSt.dart';
import 'package:flutter_app/db/FirestoreManager.dart';
import 'package:flutter_app/db/model/Item.dart';



void main() {
  runApp( MaterialApp(
    title: "Dress",
    home: Scaffold(
//      body: getListView(),
//      body: DatabaseList(),
//    body: MyAppSt(),
    body: ItemsList(),
//    body: HomePage(),
//    body: MyNewItem(),
    )
  ));

}
