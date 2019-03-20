import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';
import 'package:flutter_app/bl/mainLoginPage.dart';
import 'package:flutter_app/ui/homePage.dart';

import 'loginpage.dart';
import 'signUpPage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink[400],
          scaffoldBackgroundColor: Colors.grey[50],
          accentColor: Colors.pink[400],
          buttonColor: Colors.pink,
          fontFamily: 'Quicksand',
          indicatorColor: Colors.blueGrey,
        ),
      home: LoginPage(),
      routes: <String,WidgetBuilder>{
        '/landingpage' : (BuildContext context)=> new MyApp(),
        '/signup' : (BuildContext context)=> new SignupPage(),
        '/homepage':(BuildContext context) => new HomePage(),
        '/MainBee':(BuildContext context) => new QuickBee(),
        '/welcome':(BuildContext context) => new WelcomePage(),
    },
    );
  }

}