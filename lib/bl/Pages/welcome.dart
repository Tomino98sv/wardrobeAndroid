import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/mainLoginPage.dart';
import 'package:flutter_app/bl/videjko/loginpage.dart';
import 'package:google_sign_in/google_sign_in.dart';


class WelcomePage extends StatefulWidget {

  @override
  _WelcomePageState createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> {

  FirebaseUser user2;
  GoogleSignInAccount googleUser;


  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        user2 = fUser;
      });
    });
  }

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
                     Navigator.push(context, new MaterialPageRoute(
                         builder: (context) =>
                         new QuickBee())
                     );
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
                 user2 == null ? "" : 'Email: ${user2.email}',
                   style: new TextStyle(fontSize: 15.0,color: Colors.orange)
               ),
               new Text(
                 user2 == null ? "" : 'UID: ${user2.uid}',
                   style: new TextStyle(fontSize: 15.0,color: Colors.orange)
               ),
               new Text(
                   user2 == null ? "" : 'Name: ${user2.displayName}',
                   style: new TextStyle(fontSize: 15.0,color: Colors.orange)
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
