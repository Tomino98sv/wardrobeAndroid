import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/settingsPage.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';
import 'package:flutter_app/bl/mainLoginPage.dart';
import 'package:flutter_app/db/model/Item.dart';
import 'package:flutter_app/db/FirestoreManager.dart';
import 'package:flutter_app/deals/dealsHome.dart';
import 'package:flutter_app/notif/notifications.dart';
import 'package:flutter_app/ui/themes.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState()  => _HomeState();
}
//preklikavanie v navigation bar
class _HomeState extends State<HomePage> {
  int _page = 0;


  final _options =[
    WelcomePage(),
//    MyStoragePage2(),
    ItemsList(),
    NotificationsPage(),
    DealsPage(),
    UserListHome()
//    MyNewItem(),  pre Kluad na floating buttonn
//    Text('Index 2: Public'),

  ];

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: (){
          debugPrint("TUUUUUUUUUUUUUUU WILLPOPSCOPE");

//          Navigator.of(context).pushAndRemoveUntil(
//                                      MaterialPageRoute(
//                                          builder: (context) => HomePage()),
//                                      (Route<dynamic> route) => false);
              confirm(context, "Escape from app", "Are you want to logout and get out of here?");
        },
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Wardrobe'),
        actions: <Widget>[
          _page!=4? Container() :
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(
                context: context,
                delegate: UserListSearch(Firestore.instance.collection('users').snapshots()),
              );
            },
          ),
          _page!=1? Container() :
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(
                context: context,
                delegate: ItemsListSearch(Firestore.instance.collection('items').snapshots()),
              );
            },
          ),
//          _page!=0? Container() :
//          PopupMenuButton<String>(
//            onSelected: choiceAction,
//            offset: Offset(0, 100),
//            itemBuilder: (BuildContext context){
//              return Constants.choices.map((String choice){
//                return PopupMenuItem<String>(
//                  value: choice,
//                  child: Text(choice, style: TextStyle(color: Colors.black),),
//                );
//              }).toList();
//            }
//          ),
        ],
      ),
      body: Container(
        child: _options.elementAt(_page),
        //sirka, vyska, child do childu podmienku - uz netreba pravdepodobne
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: new Icon(Icons.face, color: Colors.grey[900]),
            title: new Text('Me'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.style, color: Colors.grey[900]),
            title: new Text('Dresses'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.notifications, color: Colors.grey[900]),
            title: new Text('Alerts'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.shopping_cart, color: Colors.grey[900]),
            title: new Text('Deals'),
          ),
          BottomNavigationBarItem(
              icon: new Icon(Icons.account_circle, color: Colors.grey[900]),
              title: new Text('Users')
          )
        ],
        currentIndex: _page,
        onTap: onPageChanged,
        ),
        ),
    );
  }

  void choiceAction(String choice){
    GoogleSignIn _googleSignIn;
    _googleSignIn?.signOut();
    if(choice == Constants.Settings){
      Navigator.of(context).push( MaterialPageRoute(
          builder: (context)=>SettingsPage()));
    }else if (choice == Constants.LogOut){
      FirebaseAuth.instance.signOut().then((value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => QuickBee()),
                (Route<dynamic> route) => false);
      }).catchError((e) {
        print(e);
      });
    }
  }

  confirm(BuildContext context, String title, String description){
    debugPrint("TUUUUUUUUUUUUUUU ALERTDIALOG");

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(description)
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: signOut,
                child: Text("LogOut"),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Stay on app"),
              )
            ],
          );
        }
    );
  }

  signOut(){
    debugPrint("TUUUUUUUUUUUUUUU SIGN OUT");
    GoogleSignIn _googleSignIn;
    _googleSignIn?.signOut();
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context, rootNavigator: true).pop('dialog');

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => QuickBee()),
              (Route<dynamic> route) => false);
    }).catchError((e) {
      print(e);
    });

  }
}
