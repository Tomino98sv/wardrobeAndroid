import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginPage extends StatefulWidget {

//  Function _function;

//  LoginPage({@required Function function}){
//    _function = function;
//  }

  @override
  _LoginPageState createState() => _LoginPageState();
  }

  class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  FirebaseUser user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Form(
        key: _formKey,
      child: Container(
        padding: EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(hintText: 'Email'),
              validator: (input){
                if(input.isEmpty){
                  return 'Please type an email';
                }else if(validateEmail(input)){
                  return 'Mail must be in mail format (%@%.%)';
                }
              },
              onSaved: (input) => _email = input,
            ),SizedBox(height: 15.0),
            TextFormField(
              decoration: InputDecoration(hintText: 'Password'),
              validator: (input){
                if(input.length < 6){
                  return 'Your password needs to be at least 6 characters';
                }
              },
              onSaved: (input) => _password = input,
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              child: Text('Login'),
              color: Colors.blue,
              textColor: Colors.white,
              elevation: 7.0,
              onPressed: signInMethod,
            ),
            SizedBox(height: 15.0),
            Text('Don\'t have an account?'),
            SizedBox(height: 10.0),
            RaisedButton(
              child: Text('Sign up'),
              color: Colors.blue,
              textColor: Colors.white,
              elevation: 7.0,
              onPressed: (){
                Navigator.of(context).pushNamed('/signup');
              },
            )
          ],
        ),
      ),
    )
    );
  }


  void signInMethod() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _email, password: _password)
          .then((FirebaseUser user){
        Navigator.of(context).pushReplacementNamed('/homepage');
      })
          .catchError((e){
        print("NO LOGGING validation was passed but not loggin to firebaseAuth");
        print(e);
      });
    }else{
      debugPrint("validation of sign in to firebaseAuth not pass");
    }
  }


  bool validateEmail(String value) {
    Pattern pattern =r'^[a-zA-Z0-9\.\-\_]+\@[a-zA-Z0-9]+\.[a-zA-Z0-9]{2,}$';
    RegExp regex = new RegExp(pattern);
    if(!regex.hasMatch(value)){
      return true;
    }else{
      return false;
    }

  }

}

