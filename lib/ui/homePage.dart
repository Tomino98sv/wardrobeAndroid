import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';
import 'package:flutter_app/bl/mainLoginPage.dart';
import 'package:flutter_app/db/model/Item.dart';
import 'package:flutter_app/db/FirestoreManager.dart';


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
    UserListHome(),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Wardrobe'),
        actions: <Widget>[
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
          _page!=0? Container() :
          PopupMenuButton<String>(
            onSelected: choiceAction,
            offset: Offset(0, 100),
            itemBuilder: (BuildContext context){
              return Constants.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            }
          ),
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
              icon: new Icon(Icons.account_circle, color: Colors.grey[900]),
              title: new Text('Users')
          )
        ],
        currentIndex: _page,
        onTap: onPageChanged,
      ),
    );
  }

  void choiceAction(String choice){
    if(choice == Constants.Settings){
      print("Settings  .. treba dorobit");
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
}
