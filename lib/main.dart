import 'package:flutter/material.dart';
import 'package:flutter_app/bl/mainLoginPage.dart';
import 'package:flutter_app/ui/homePage.dart';

void main(){
  runApp(
      MaterialApp(
        title: "Dress",
        home: HomePage(),
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
