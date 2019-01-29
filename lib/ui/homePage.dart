import 'package:flutter/material.dart';
import 'package:flutter_app/bl/mainLogin.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Flutter App'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('Me'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail),
            title: new Text('Share'),
          ),
          BottomNavigationBarItem(
              icon: new Icon(Icons.ac_unit),
              title: new Text('sracka')
          )
        ],
      ),
    );
  }
}
