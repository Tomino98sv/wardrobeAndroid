import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/bl/nutused/home.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';
import 'package:flutter_app/bl/mainLoginPage.dart';
import 'package:flutter_app/bl/nutused/hisMain.dart';
import 'package:flutter_app/bl/videjko/signUpPage.dart';
import 'package:flutter_app/ui/homePage.dart';

final ThemeData pinkTheme = new ThemeData(
  primaryColor: Colors.pink[400],
  scaffoldBackgroundColor: Colors.grey[50],
  accentColor: Colors.pink[400],
  buttonColor: Colors.pink,
  fontFamily: 'Quicksand',
  indicatorColor: Colors.blueGrey,
);

final ThemeData darkTheme = new ThemeData(
  primaryColor: Colors.brown[400],
  scaffoldBackgroundColor: Colors.grey[50],
  accentColor: Colors.brown[400],
  buttonColor: Colors.brown,
  fontFamily: 'Quicksand',
  indicatorColor: Colors.blueGrey,
);

void main(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dress",
//        home: HomePage(),
      home: QuickBee(),
      theme: pinkTheme,
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
