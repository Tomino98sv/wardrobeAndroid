import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/auth.dart';
import 'package:flutter_app/bl/nutused/signIn.dart';
import 'package:flutter_app/bl/nutused/hisMain.dart';
import 'package:flutter_app/bl/videjko/loginpage.dart';
import 'package:flutter_app/ui/homePage.dart';
import 'package:flutter_app/ui/themes.dart';
import 'package:google_sign_in/google_sign_in.dart';

class QuickBee extends StatefulWidget {

  @override
  _QuickBeeState createState() => _QuickBeeState();
}

class _QuickBeeState extends State<QuickBee> {

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((fuser){
        if (fuser.email != null && fuser.uid != null) {
          debugPrint("already sign in");
          debugPrint(fuser.email);
          debugPrint(fuser.uid);
          Navigator.pushReplacement(context,  MaterialPageRoute(builder: (BuildContext context) => new HomePage()));

        } else {
          debugPrint("continue to login");
        }
    }).catchError((e) {
    });
  }




  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/blackDresses.png")),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 80.0),
                    child: new Text("Wardrobe",
                      style: new TextStyle(
                        fontSize: 50.0,
                        color: Colors.white,
                        fontFamily: 'Alyfe_Demo',
                      ),
                      textAlign: TextAlign.center,
                    )
                )
              ],
            ),
            new Row(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(left:1.0,right: 1.0,top: 2.0,bottom: 2.0),
                  margin: EdgeInsets.only(bottom: 16.0,top: 130.0, left: 15.0, right: 38.0),
                  child:MaterialButton(
//                          onPressed: () => Navigator.of(context).pushReplacementNamed('/signup'),
                    onPressed: navigationToSignInMail,
                    child: new Text(
                      "Continue with email",
                      style: new TextStyle(fontSize: 15.0,color: Colors.white),
                        textAlign: TextAlign.center
                    ),
                  ),
                  height: 55,
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                      color: Colors.white12,
                      borderRadius: new BorderRadius.circular(30.0),
                    border: Border.all(color: Colors.white)
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.only(left:1.0,right: 1.0,top: 2.0,bottom: 2.0),
                  margin: EdgeInsets.only(bottom: 16.0,top: 130.0, left: 5.0, right: 5.0),
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                      color: Colors.white12,
                      borderRadius: new BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.white)
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      await authService.googleSignIn();
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context)=>HomePage()));
                    },
                    child: Row(
                      children: <Widget>[
                        new Text(
                          "Continue with  ",

                          style: new TextStyle(fontSize: 15.0,color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Image.asset("assets/images/google.png",
                          width: 20.0, height: 20.0,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
//            new Row(
//              children: <Widget>[
//                new Container(
//                  margin: EdgeInsets.only(bottom: 16.0,top: 10.0, left: 75.0, right: 5.0),
//                  padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 2.0,bottom: 2.0),
//                  alignment: Alignment.center,
//                  decoration: new BoxDecoration(
//                      color: Colors.white12,
//                      borderRadius: new BorderRadius.circular(30.0),
//                      border: Border.all(color: Colors.white)
//                  ),
//                  child: MaterialButton(
//                    onPressed: () async {
//                      await authService.googleSignIn();
//                      Navigator.pushReplacement(context, MaterialPageRoute(
//                          builder: (context)=>HomePage()));
//                    },
//                    child: Row(
//                      children: <Widget>[
//                        new Text(
//                          " Continue      with  ",
//
//                          style: new TextStyle(fontSize: 20.0,color: Colors.white),
//                            textAlign: TextAlign.center,
//                        ),
//                        Image.asset("assets/images/google.png",
//                          width: 24.0, height: 24.0,),
//                      ],
//                    ),
//                  ),
//                ),
//              ],
//            )
          ],
        ),
      ),
    );
  }


  void print() {
    debugPrint("nic sa nedeje");
  }

  void navigationToSignInMail() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => LoginPage()));
    debugPrint("ide to?");
  }

}
