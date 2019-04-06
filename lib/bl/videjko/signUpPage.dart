import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/usermanagment.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _email;
  String _password;
  String _name;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _groupGender;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Sign Up"),
        ),
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Center(
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: 'Username',icon: new Icon(Icons.person, color: Colors.black)),
                validator: (input){
                  if(input.isEmpty){
                    return 'Please type an username';
                  }else if(input.length < 2  && input.length > 10){
                    return 'Username must have at least 2 chars';
                  }
                },
                onSaved: (input) => _name = input,
              ),SizedBox(height: 15.0),
              TextFormField(
                decoration: InputDecoration(hintText: 'Email', icon: new Icon(Icons.email, color: Colors.black)),
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
                decoration: InputDecoration(hintText: 'Password', icon: new Icon(Icons.text_fields, color: Colors.black)),
                validator: (input){
                if(input.length < 6){
                  return 'Your password needs to be at least 6 characters';
                }
              },
                onSaved: (input) => _password = input,
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                      value: 0,
                      activeColor: Colors.blue,
                      groupValue: _groupGender,
                      onChanged: (int gender) => pickGender(gender),
                  ),
                  Text(
                    "Male"
                  ),
                  Radio(
                      value: 1,
                      activeColor: Colors.pink,
                      groupValue: _groupGender,
                      onChanged: (int gender) => pickGender(gender),
                  ),
                  Text(
                    "Female"
                  )
                ],
              ),
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
                        signUpMethod(context) ;
                      },
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
      ),
      )
    );
  }

  void signUpMethod(BuildContext context) {

    if(_formKey.currentState.validate() && _groupGender != null){
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
          .createUserWithEmailAndPassword(email: _email,
          password: _password)
          .then((signedInUser){
        if(_groupGender == 0){
          UserManagement().storeNewUser(signedInUser,context,_name,"https://firebasestorage.googleapis.com/v0/b/wardrobe-26e92.appspot.com/o/woman.jpg?alt=media&token=3f3e2bbb-6f21-4e8e-8d02-79af6b3ea303");
        }
        if(_groupGender == 1){
          UserManagement().storeNewUser(signedInUser,context,_name,"https://firebasestorage.googleapis.com/v0/b/wardrobe-26e92.appspot.com/o/man.jpg?alt=media&token=a3be6224-a659-4551-977f-1511faa3d34e");
        }
      })
          .catchError((e){
        print(e);
        Navigator.of(context, rootNavigator: true).pop('dialog');
        _showSnackBar("Email already used or problem with internet connection");
      });
    }else if(_groupGender == null){
      _showSnackBar("You must pick up your gender");
    }else{
      debugPrint("validation not pass");
      _showSnackBar("Data not passed throught form validation");
    }

  }

  _showSnackBar(String st){
    final snackBar = new SnackBar(
      content: new Text(st),
      duration: new Duration(seconds: 3),
      backgroundColor: Colors.black54,
      action: new SnackBarAction(label: 'OUKEY', onPressed: (){
        print("pressed snackbar");
      }),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
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

  void pickGender(int gender){
    setState(() {
      _groupGender=gender;
      debugPrint("${_groupGender}");
    });
  }
}


