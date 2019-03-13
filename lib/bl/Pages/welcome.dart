import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/nutused/signIn.dart';
import 'package:flutter_app/bl/nutused/signUp.dart';
import 'package:flutter_app/bl/Pages/auth.dart';
import 'package:flutter_app/bl/videjko/loginpage.dart';



class WelcomePage extends StatefulWidget {

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
//  var login = new LoginPage();
////  var login = new _LoginPageState();
//  FirebaseUser user;
//  @override
//  void initState() {
//    super.initState();
//    user =login;
//  }

  @override
  Widget build(BuildContext context) {
   return SingleChildScrollView(

     child: Column(
       children: <Widget>[
         Container(
           alignment: Alignment.topRight,
           child: new OutlineButton(
                 borderSide: BorderSide(
                     color: Colors.red,style: BorderStyle.solid,width: 3.0),
                 child: Text('Logout'),
                 onPressed: () {
                   FirebaseAuth
                       .instance.signOut().then((value){
                     Navigator.of(context).pushReplacementNamed('/MainBee');
                   }).catchError((e){
                     print(e);
                   });
                 },
               ),
         ),
         Container(
           alignment: Alignment.center,
           child: new Column(
             mainAxisAlignment: MainAxisAlignment.start,
             children: <Widget>[
               new Text(
                   ' EMAIIIILL',
                   style: new TextStyle(fontSize: 25.0,color: Colors.orange)
               ),
               new Text(
                 'USEEEER',
                   style: new TextStyle(fontSize: 25.0,color: Colors.orange)
               ),

             ],
           ),
         )
       ],
     )

   );
  }
}

//      child: new Center(
//       child: Container(
//         padding: EdgeInsets.all(32.0),
//         child: Column(
//           children: <Widget>[
//             Center(
//               child: Container(
//                 child: new Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     new Text('You are now logged in'),
//                     SizedBox(
//                       height: 15.0,
//                     ),
//                     new OutlineButton(
//                       borderSide: BorderSide(
//                           color: Colors.red,style: BorderStyle.solid,width: 3.0),
//                       child: Text('Logout'),
//                       onPressed: () {
//                         FirebaseAuth
//                             .instance.signOut().then((value){
//                           Navigator.of(context).pushReplacementNamed('/MainBee');
//                         }).catchError((e){
//                           print(e);
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
