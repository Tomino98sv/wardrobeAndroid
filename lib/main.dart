import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/Home.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';
import 'package:flutter_app/bl/mainLoginPage.dart';
import 'package:flutter_app/bl/videjko/hisMain.dart';
import 'package:flutter_app/bl/videjko/homepage.dart';
import 'package:flutter_app/ui/homePage.dart';

void main(){
  runApp(
      MaterialApp(
        title: "Dress",
        home: QuickBee(),
        theme: ThemeData(
          primaryColor: Colors.grey[50],
//          scaffoldBackgroundColor: Colors.pinkAccent[30],
          buttonColor: Colors.brown[300],
          fontFamily: 'Quicksand',
          indicatorColor: Colors.blueGrey,
        )
  ),
  );
}
