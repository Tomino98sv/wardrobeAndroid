import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/videjko/loginpage.dart';
import 'package:google_sign_in/google_sign_in.dart';


class WelcomePage extends StatefulWidget {

  FirebaseUser user;
  GoogleSignInAccount googleUser;

  WelcomePage({@required this.user});
  WelcomePage.google({@required this.googleUser});


  @override
  _WelcomePageState createState() {
    print("DOLE SU DATA KTORE SA POSIELAJU DO WELCOMEPAGESTATE");
    try{
      print(user.uid);
      print(user.email);
    }catch(e){
      print(user.uid);
      print(user.email);
      print("FAULT WITH EMAIL OR UID");
      print(e);
    }
    return _WelcomePageState(user2: user);
  }

//  @override
//  _WelcomePageState createState() {
//    print("DOLE SU DATA KTORE SA POSIELAJU DO WELCOMEPAGESTATE");
//    try{
//      print("USER MAIL IS: "+user.email);
//      print("USER Name IS: "+user.displayName);
//    }catch(e){
//      print("FAULT WITH EMAIL OR UID");
//      print("USER MAIL IS: "+user.email);
//      print("USER Name IS: "+user.displayName);
//      print(e);
//    }
//    return _WelcomePageState(googleUser: googleUser);
//  }


}

class _WelcomePageState extends State<WelcomePage> {

  FirebaseUser user2;
  final GoogleSignInAccount googleUser;

  _WelcomePageState({@required this.user2,this.googleUser});


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
                    "Email",
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
