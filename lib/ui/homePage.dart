import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';
import 'package:flutter_app/st/storage/stPage.dart';
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
      ),
      body: Container(
        child: _options.elementAt(_page),
        //sirka, vyska, child do childu podmienku - uz netreba pravdepodobne
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: new Icon(Icons.person, color: Colors.orange[900]),
            title: new Text('Me'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail, color: Colors.orange[900]),
            title: new Text('Share'),
          ),
          BottomNavigationBarItem(
              icon: new Icon(Icons.ac_unit, color: Colors.orange[900]),
              title: new Text('Public')
          )
        ],
        currentIndex: _page,
        onTap: onPageChanged,
      ),
    );
  }
}
