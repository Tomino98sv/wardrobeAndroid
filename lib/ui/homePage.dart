import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';
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
    MyNewItem(),
    ItemsList(),
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
      appBar: AppBar(
        title: Text('Wardrobe'),
        actions: <Widget>[_page!=2? Container() :
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(
                context: context,
                delegate: ItemsListSearch(Firestore.instance.collection('items').snapshots()),
              );
            },
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
            icon: new Icon(Icons.person, color: Colors.brown[800]),
            title: new Text('Me'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail, color: Colors.brown[800]),
            title: new Text('Share'),
          ),
          BottomNavigationBarItem(
              icon: new Icon(Icons.ac_unit, color: Colors.brown[800]),
              title: new Text('Public')
          )
        ],
        currentIndex: _page,
        onTap: onPageChanged,
      ),
    );
  }
}
