import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/auth.dart';
import 'package:flutter_app/bl/nutused/signIn.dart';
import 'package:flutter_app/bl/videjko/hisMain.dart';
import 'package:flutter_app/ui/homePage.dart';


class QuickBee extends StatefulWidget {
  @override
  _QuickBeeState createState() => _QuickBeeState();
}

class _QuickBeeState extends State<QuickBee> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var ctx = context;

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
                        fontFamily: 'Alyfe_Demo', //neberie
                      ),
                      textAlign: TextAlign.center,
                    )
                )
              ],
            ),
            new Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 5.0, top: 40.0, bottom: 20.0),
                    child: new Container(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 1.0),
                      child: MaterialButton(
//                          onPressed: () => Navigator.of(context).pushReplacementNamed('/signup'),
                        onPressed: navigationToSignInMail,
                        child: SizedBox.expand(
//                            width: double.infinity,
                          child: new Text(
                              "Continue with email",
                              style: new TextStyle(
                                  fontSize: 22.0, color: Colors.white),
                              textAlign: TextAlign.center
                          ),
//                            textColor: Colors.white,
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
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 5.0, top: 10.0),
                    child: new Container(
                      padding: const EdgeInsets.only(
                          left: 5.0, top: 12.0, right: 5.0, bottom: 12.0),
                      height: 60.0,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                          color: Colors.white12,
                          borderRadius: new BorderRadius.circular(30.0),
                          border: Border.all(color: Colors.white)
                      ),
                      child: MaterialButton(
                        onPressed: print,
                        child: SizedBox.expand(
//                            width: double.infinity,
                          child: new Text(
                              "Continue with",
                              style: new TextStyle(
                                  fontSize: 15.0, color: Colors.white),
                              textAlign: TextAlign.center
                          ),
//                            textColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 10.0, top: 10.0),
                    child: new Container(
                      padding: const EdgeInsets.only(
                          left: 5.0, top: 12.0, right: 5.0, bottom: 12.0),
                      height: 60.0,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                          color: Colors.white12,
                          borderRadius: new BorderRadius.circular(30.0),
                          border: Border.all(color: Colors.white)
                      ),
                      child: MaterialButton(
                        onPressed: () async {
                          await authService.googleSignIn();
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) =>
                              new HomePage())
                          );
                        },
                        child: SizedBox.expand(
//                            width: double.infinity,
                          child: new Text(
                            "Continue with ",
                            style: new TextStyle(
                                fontSize: 15.0, color: Colors.white),
                            textAlign: TextAlign.center,
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


  void print() {
    debugPrint("hii world");
  }

  void navigationToSignInMail() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => MyApp(), fullscreenDialog: true));
    debugPrint("ide to?");
  }

}