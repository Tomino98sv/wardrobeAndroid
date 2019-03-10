import 'package:flutter/material.dart';
import 'package:flutter_app/ui/homePage.dart';

void main(){
  runApp( MaterialApp(
      title: "Dress",
      home: HomePage(),
      theme: ThemeData(
        primaryColor: Colors.pink,
      )
  )
  );
}
