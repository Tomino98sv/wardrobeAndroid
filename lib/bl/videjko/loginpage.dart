import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';
import 'package:flutter_app/bl/mainLoginPage.dart';
import 'package:flutter_app/ui/homePage.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Login"),
        ),
        key: _scaffoldKey,
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Email',
                      icon: new Icon(Icons.email, color: Colors.black)),
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please type an email';
                    } else if (validateEmail(input)) {
                      return 'Mail must be in mail format (%@%.%)';
                    }
                  },
                  onSaved: (input) => _email = input,
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Password',
                      icon: new Icon(Icons.text_fields, color: Colors.black)),
                  validator: (input) {
                    if (input.length < 6) {
                      return 'Your password needs to be at least 6 characters';
                    }
                  },
                  onSaved: (input) => _password = input,
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
                        onTap: () {
                          signInMethod(context);
                        },
                        child: Container(
                          width: 100.0,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Log In',
                            style: TextStyle(color: Colors.white),
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
                        onTap: () {
                          Navigator.of(context).pushNamed('/signup');
                        },
                        child: Container(
                          width: 100.0,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Sign up',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void signInMethod(BuildContext context) async {
    if (_formKey.currentState.validate()) {

        _formKey.currentState.save();
        showDialog(context: context, barrierDismissible: false,builder: (BuildContext context) {
          return Center(
            child: Container(
              width: 48.0,
              height: 48.0,
              child: CircularProgressIndicator(backgroundColor: Colors.pink,),
            ),
          );
        });
        FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password)
            .then((FirebaseUser user) {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                      (Route<dynamic> route) => false);
        }).catchError((e) {
          print(
              "NO LOGGING validation was passed but not loggin to firebaseAuth");
          print(e);
          Navigator.of(context, rootNavigator: true).pop('dialog');
          _showSnackBar("Non existing mail or wrong password");
        });

    } else {
      debugPrint("validation of sign in to firebaseAuth not pass");
      _showSnackBar("Data not passed throught form validation");
    }
  }

  _showSnackBar(String str) {
    final snackBar = new SnackBar(
      content: new Text(str),
      duration: new Duration(seconds: 3),
      backgroundColor: Colors.black54,
      action: new SnackBarAction(
          label: 'OUKEY',
          onPressed: () {
            print("pressed snackbar");
          }),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  bool validateEmail(String value) {
    Pattern pattern = r'^[a-zA-Z0-9\.\-\_]+\@[a-zA-Z0-9]+\.[a-zA-Z0-9]{2,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }

}
