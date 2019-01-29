import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
    Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Flutter login',
      theme: new ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: new LoginPage()
        //tu treba kopac

    );
  }
  //a tu tiez
}