import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/bl/nutused/home.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';
import 'package:flutter_app/bl/mainLoginPage.dart';
import 'package:flutter_app/bl/videjko/hisMain.dart';
import 'package:flutter_app/ui/homePage.dart';

void main(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Dress",
 //       home: HomePage(),
      home: QuickBee(),
        theme: ThemeData(
          primaryColor: Colors.pink[400],
          scaffoldBackgroundColor: Colors.grey[50],
          accentColor: Colors.pink[400],
          buttonColor: Colors.pink,
          fontFamily: 'Quicksand',
          indicatorColor: Colors.blueGrey,
        )
  ),
  );
}
