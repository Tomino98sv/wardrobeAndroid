import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/profilePics.dart';
import 'package:flutter_app/bl/Pages/settingsPage.dart';
import 'dart:math' as math;

import 'package:flutter_app/bl/mainLoginPage.dart';

class AnimatedFab extends StatefulWidget {
  final VoidCallback onClick;

  const AnimatedFab({Key key, this.onClick}) : super(key: key);

  @override
  _AnimatedFabState createState() => new _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorAnimation;
  FirebaseUser user2;
  String profileUrlImg="";
  final double expandedSize = 120.0;
  final double hiddenSize = 14.0;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        user2 = fUser;
        Stream<QuerySnapshot> snapshot = Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: user2.uid)
            .snapshots();

        snapshot.listen((QuerySnapshot data){
          profileUrlImg = data.documents[0]['photoUrl'];
        });
      });
    });
    _animationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _colorAnimation = new ColorTween(begin: Colors.pink, end: Colors.pink[800])
        .animate(_animationController);
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expandedSize,
      height: expandedSize,
      child: new AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          return Stack(
            alignment: Alignment.centerRight,
              children: <Widget>[
                _buildExpandedBackground(),
                _buildOption(Icons.perm_identity, 0.0,profile ),
                _buildOption(Icons.notifications, -math.pi / 3,notifications),
                _buildOption(Icons.settings, -2 * math.pi / 3, settings),
                _buildOption(Icons.power_settings_new, math.pi, logOut),
                _menuImage(),
              ],
          );
        },
      ),
    );
  }


  Widget _menuImage(){
    return Padding(
      padding: EdgeInsets.only(left: 80.0,top: 5.0),
      child: new InkWell(
        child: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              image: DecorationImage(
                  image: NetworkImage(profileUrlImg),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.all(Radius.circular(75.0)),
              boxShadow: [
                BoxShadow(blurRadius: 7.0, color: Colors.black)
              ]
          ),
        ),
        onTap: _onFabTap,
      ),
    );
  }

  Widget _buildExpandedBackground() {
    debugPrint(_animationController.value.toString());
    double size = expandedSize * _animationController.value;
    return new Container(
      height: size,
      width: size,
      decoration: new BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor));
  }

  open() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    }
  }

  close() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    }
  }

  _onFabTap() {
    if (_animationController.isDismissed) {
      open();
    } else {
      close();
    }
  }

  Widget _buildOption(IconData icon, double angle, Function func) {
    double iconSize = 0.0;
    if (_animationController.value > 0.8) {
      iconSize = 26.0 * (_animationController.value - 0.8) * 5;
    }
    return new Transform.rotate(
      angle: angle,
      child: new Align(
        alignment: Alignment.topCenter,
        child: new Padding(
          padding: new EdgeInsets.only(top: 5.0,right: 3.0),
          child: new IconButton(
            onPressed: (){func();},
            icon: new Transform.rotate(
              angle: -angle,
              child: new Icon(
                icon,
                color: Colors.white,
              ),
            ),
            iconSize: iconSize,
            alignment: Alignment.center,
            padding: new EdgeInsets.all(2.0),
          ),
        ),
      ),
    );
  }

  logOut(){
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => QuickBee()),
              (Route<dynamic> route) => false);
    }).catchError((e) {
      print(e);
    });
  }

  settings(){
    Navigator.of(context).push( MaterialPageRoute(
        builder: (context)=>SettingsPage()));
  }

  notifications(){}

  profile(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectProfilePicPage()));
  }


}