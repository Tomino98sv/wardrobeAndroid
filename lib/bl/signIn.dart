import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/bl/Pages/Home.dart';

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
