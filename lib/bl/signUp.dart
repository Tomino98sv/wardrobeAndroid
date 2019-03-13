import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/bl/signIn.dart';
import 'package:flutter_app/bl/Pages/auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              onPressed: signUp,
              child: Text("Sign up"),
              textColor: Colors.white,
            ),
            RaisedButton(
              onPressed: () =>authService.signOut(),
              child: Text('Sign out from Google'),
              textColor: Colors.white,
            ),
            RaisedButton(
              onPressed: () => authService.googleSignIn(),
              child: Text('Sign in with Google'),
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  void signUp() async{
    debugPrint("ide to?");
    if(_formKey.currentState.validate()){
      debugPrint("kontrolujem data");

      _formKey.currentState.save();
      debugPrint("ukladam");
      try{
        debugPrint("skusam heslo a mail 1");
        FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        debugPrint("skusam heslo a mail 2");
        user.sendEmailVerification();

        Navigator.of(context).pop();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        debugPrint("posielam do LoginPage");

      }catch(e){
        debugPrint("tu je chybova hlaska");
        print(e.message);
        debugPrint("tu je chybova hlaska");
      }
    }
  }
}
