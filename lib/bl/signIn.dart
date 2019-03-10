import 'dart:async';
import 'auth.dart';


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/bl/Pages/Home.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {





  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (input){
                  if(input.isEmpty){
                    return 'Please type an email';
                  }
                },
                onSaved: (input) => _email = input,
                decoration: InputDecoration(
                  labelText: 'Email'
                ),
              ),
              TextFormField(
                validator: (input){
                  if(input.length < 6){
                    return 'Your password needs to be at least 6 characters';
                  }
                },
                onSaved: (input) => _password = input,
                decoration: InputDecoration(
                    labelText: 'Password'
                ),
                obscureText: true,
              ),
              RaisedButton(
                onPressed: signIn,
                child: Text('Sign in'),
                textColor: Colors.white,
              )
            ],
          ),
      ),
    );
  }

  void signIn() async{
    debugPrint("ide to?");
    if(_formKey.currentState.validate()){
      debugPrint("kontrolujem data");
      _formKey.currentState.save();
      debugPrint("ukladam");
      try{
        debugPrint("skusam heslo a mail 1");
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        debugPrint("skusam heslo a mail 2");
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(user: user)));
        debugPrint("posielam do Home");
      }catch(e){
        debugPrint("tu je chybova hlaska");
        print(e.message);
        debugPrint("tu je chybova hlaska");
      }
    }
  }
}
//
//class UserProfile extends StatefulWidget{
//  @override
//  UserProfileState createState() => UserProfileState();
//}

//class UserProfileState extends State<UserProfile> {
//  Map<String, dynamic> _profile;
//  bool _loading = false;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    authService.profile
//        .listen((state) => setState(() => _profile = state));
//    authService.loading
//        .listen((state) => setState(() => _loading = state));
//  }
//
//  @override
//  Widget build(BuildContext context){
//    return Column(children: <Widget>[
//      Container(
//          padding: EdgeInsets.all(20),
//          child: Text(_profile.toString())
//      ),
//      Text(_loading.toString())
//    ],);
//
//  }
//}
