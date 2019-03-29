import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/auth.dart';
import 'package:flutter_app/bl/nutused/signIn.dart';
import 'package:flutter_app/bl/videjko/hisMain.dart';
import 'package:flutter_app/ui/homePage.dart';
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
          Navigator.push(context,  MaterialPageRoute(builder: (BuildContext context) => new HomePage()));

        } else {
          debugPrint("continue to login");
        }
    }).catchError((e) {
    });
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build

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
                Expanded(
                  child: new Container(
                    padding: const EdgeInsets.only(left:20.0,right: 20.0,top: 8.0,bottom: 8.0),
                    margin: EdgeInsets.only(bottom: 16.0,top: 80.0, left: 10.0, right: 10.0),
                    child:MaterialButton(
//                          onPressed: () => Navigator.of(context).pushReplacementNamed('/signup'),
                      onPressed: navigationToSignInMail,
                      child: new Text(
                        " Continue     with email",
                        style: new TextStyle(fontSize: 22.0,color: Colors.white),
                          textAlign: TextAlign.center
                      ),
                    ),
                    height: 60.0,
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                        color: Colors.white12,
                        borderRadius: new BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.white)
                    ),
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                Expanded(
                  child: new Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    height: 40.0,
                    decoration: new BoxDecoration(
                        color: Colors.white12,
                        borderRadius: new BorderRadius.circular(30.0),
                        border: Border.all(color: Colors.white)
                    ),
                    child: MaterialButton(
                      onPressed: print,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              "Continue with ",
                              style: new TextStyle(fontSize: 15.0,color: Colors.white),
                                textAlign: TextAlign.center
                            ),
                          Image.asset("assets/images/fb2.png",
                          width: 24.0, height: 24.0,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: new Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    height: 40.0,
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
                            width: 24.0, height: 24.0,),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
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
        builder: (context) => MyApp(), fullscreenDialog: true));
    debugPrint("ide to?");
  }

}
