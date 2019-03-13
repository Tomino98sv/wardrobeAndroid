import 'package:flutter/material.dart';
import 'package:flutter_app/ui/homePage.dart';

import 'homepage.dart';
import 'loginpage.dart';
import 'signUpPage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: LoginPage(),
      routes: <String,WidgetBuilder>{
        '/landingpage' : (BuildContext context)=> new MyApp(),
        '/signup' : (BuildContext context)=> new SignupPage(),
        '/homepage':(BuildContext context) => new HomePage(),
    },
    );
  }

}