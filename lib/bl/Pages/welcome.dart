import 'package:flutter/material.dart';
import 'package:flutter_app/bl/signIn.dart';
import 'package:flutter_app/bl/signUp.dart';
import 'package:flutter_app/bl/auth.dart';


class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget> [
          RaisedButton(
            onPressed: navigationToSignIn,
            child: Text("Sign in"),

          ),
          RaisedButton(
            onPressed: navigationToSignUp,
            child: Text("Sign up"),
          )
        ],
      );
  }

  void navigationToSignIn(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),fullscreenDialog: true));
    debugPrint("ide to?");

  }

  void navigationToSignUp(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(),fullscreenDialog: true));
    debugPrint("ide to?");

  }
}
