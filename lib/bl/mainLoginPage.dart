import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/auth.dart';
import 'package:flutter_app/bl/nutused/signIn.dart';
import 'package:flutter_app/bl/videjko/hisMain.dart';


class QuickBee extends StatefulWidget {
  @override
  _QuickBeeState createState() => _QuickBeeState();
}

class _QuickBeeState extends State<QuickBee> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Stack(
              children: <Widget>[
                new Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(50.0),
                      color: Color(0xFFFC6A7F)
                  ),
                  child: new Icon(Icons.local_offer,color: Colors.white,),
                )
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 80.0),
                    child: new Text("Wardrobe",style: new TextStyle(fontSize: 30.0),
                    )
                )
              ],
            ),
            new Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:20.0,right: 20.0,top: 10.0),
                    child: new Container(
                      padding: const EdgeInsets.only(left:20.0,right: 20.0,top: 10.0),
                      child:MaterialButton(
//                          onPressed: () => Navigator.of(context).pushReplacementNamed('/signup'),
                        onPressed: navigationToSignInMail,
                        child: SizedBox.expand(
//                            width: double.infinity,
                          child: new Text(
                            "Sign in With Email",
                            style: new TextStyle(fontSize: 22.0,color: Colors.white),
                          ),
//                            textColor: Colors.white,
                        ),
                      ),
                      height: 60.0,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(color: Color(0xff00cc99),borderRadius: new BorderRadius.circular(18.0)),
                    ),
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:10.0,right: 5.0,top: 10.0),
                    child: new Container(
                      padding: const EdgeInsets.only(left:5.0,top:16.0,right:5.0,bottom:12.0),
                      height: 60.0,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(color: Color(0xFF4364A1),borderRadius: new BorderRadius.circular(15.0)),
                      child: MaterialButton(
                        onPressed: print,
                        child: SizedBox.expand(
//                            width: double.infinity,
                          child: new Text(
                            "FaceBook",
                            style: new TextStyle(fontSize: 20.0,color: Colors.white),
                          ),
//                            textColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:5.0,right: 10.0,top: 10.0),
                    child: new Container(
                      padding: const EdgeInsets.only(left:5.0,top:12.0,right:5.0,bottom:12.0),
                      height: 60.0,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(color: Color(0xFFDF5138),borderRadius: new BorderRadius.circular(15.0)),
                      child: MaterialButton(
                        onPressed: () => authService.googleSignIn(),
                        child: SizedBox.expand(
//                            width: double.infinity,
                          child: new Text(
                            "Google",
                            style: new TextStyle(fontSize: 25.0,color: Colors.white),
                          ),
//                            textColor: Colors.white,
                        ),
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


  void print(){
    debugPrint("hii world");
  }

  void navigationToSignInMail(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(),fullscreenDialog: true));
    debugPrint("ide to?");

  }


}
