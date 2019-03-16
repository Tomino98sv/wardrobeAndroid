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



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Container(
        padding: EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: 'Email'),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),SizedBox(height: 15.0),
            TextField(
              decoration: InputDecoration(hintText: 'Password'),
              onChanged: (value){
                setState(() {
                  _password = value;
                });
              },
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Material(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(30.0),
                  child: InkWell(
                    splashColor: Colors.pink[400],
                    onTap:  () {FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                        email: _email, password: _password)
                        .then((FirebaseUser user){
                      Navigator.of(context).pushReplacementNamed('/homepage');
                    })
                        .catchError((e){
                      print("NO LOGGING");
                      print(e);
                    });},
                    child: Container(
                      width: 100.0,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Login',style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Text('Don\'t have an account?'),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Material(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(30.0),
                    child: InkWell(
                    splashColor: Colors.pink[400],
                      onTap:  () {Navigator.of(context).pushNamed('/signup');},
                        child: Container(
                          width: 100.0,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Sign up',style: TextStyle(color: Colors.white),
                          ),
                        ),
                    ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

