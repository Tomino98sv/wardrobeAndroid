import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/profilePics.dart';
import 'package:flutter_app/bl/videjko/services/usermanagment.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/ui/themes.dart';

class SettingsPage extends StatefulWidget{
  @override
  _SettingsPageState  createState() {
    return  _SettingsPageState();
  }

}


class _SettingsPageState extends State<SettingsPage>{
  ThemeSwitcher inheritedThemeSwitcher;
  FirebaseUser user;
  bool note = false;
  bool click = false;
  bool mode = false;
  bool themeChosen;
  UserManagement userManagement = new UserManagement();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getActiveTheme();
  }

  @override
  Widget build(BuildContext context) {
   inheritedThemeSwitcher = ThemeSwitcher.of(context);
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
            "Settings",style: TextStyle(color: Colors.white)
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                new Text("Changing color of app",style:Theme.of(context).textTheme.subhead),
                new Switch(
                  value: click ,
                  onChanged: (bool valueOfClick) => changingColor(valueOfClick),
                ),
             ],),
            Row(
              children: <Widget>[
                new Text("Dark mode",style:Theme.of(context).textTheme.subhead),
                new Switch(
                  value: mode,
                  onChanged: (bool valueOfMode) => darkMode(valueOfMode),
                ),
              ],),
             Row(
              children: <Widget>[
                new Text("Turn on the notifications",style:Theme.of(context).textTheme.subhead),
                new Switch(
                    value: note,
                    onChanged: (bool valueOfNote) => setNotifications(valueOfNote),
                ),
              ],
          ),
          ],
        ),
      )
    );

  }

    DemoTheme _buildPinkTheme() {
    return DemoTheme(
        'pink',
        new ThemeData(
            primaryColor: Colors.pink[400],
            scaffoldBackgroundColor: Colors.grey[50],
            accentColor: Colors.pink[400],
            buttonColor: Colors.pink,
            fontFamily: 'Quicksand',
            indicatorColor: Colors.pink[100],
            brightness: Brightness.light,
    ));
  }

  DemoTheme _buildBlueTheme() {
    return DemoTheme(
        'blue',
        new ThemeData(
          primaryColor: Colors.blue[400],
          scaffoldBackgroundColor: Colors.grey[50],
          accentColor: Colors.blueAccent[400],
          buttonColor: Colors.blue,
          toggleableActiveColor: Colors.lightBlue,
          unselectedWidgetColor: Colors.blueAccent,
          fontFamily: 'Quicksand',
          indicatorColor: Colors.blueGrey,
          brightness: Brightness.light,
          textTheme: TextTheme(button: TextStyle(color: Colors.white))
        ));
  }


  DemoTheme _buildDarkMode() {
    return DemoTheme(
        'dark',
        new ThemeData(
            textTheme: TextTheme(subhead: TextStyle(color: Colors.white),),
            primaryColor: Colors.black,
            scaffoldBackgroundColor: Colors.black,
            accentColor: Colors.black45,
            buttonColor: Colors.white12,
            toggleableActiveColor: Colors.black54,
            unselectedWidgetColor: Colors.black45,
            fontFamily: 'Quicksand',
            indicatorColor: Colors.black54,
        ));
  }

  void changingColor(bool valueOfClick){
    setState(() {
      if(valueOfClick){
        inheritedThemeSwitcher.themeBloc.selectedTheme.add(_buildBlueTheme());
        valueOfClick = true;
        click = true;
        userManagement.updateUsingTheme(valueOfClick);

      } else {
        inheritedThemeSwitcher.themeBloc.selectedTheme.add(_buildPinkTheme());
        valueOfClick =false;
        click = false;
        userManagement.updateUsingTheme(valueOfClick);
      }
    });
  }

  void darkMode(bool valueOfMode){
    setState(() {
      if(valueOfMode){
        inheritedThemeSwitcher.themeBloc.selectedTheme.add(_buildDarkMode());
        valueOfMode = true;
        mode = true;
      } else {
       inheritedThemeSwitcher.themeBloc.selectedTheme.add(_buildPinkTheme());
        valueOfMode =false;
        mode = false;
      }
    });
  }

  void setNotifications(bool valueOfNote){
    setState(() {
      if(valueOfNote){
        note = false;
        valueOfNote = false;
      } else {
        note = true;
        valueOfNote = true;
      }
    });
  }

  void getActiveTheme(){
    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        user = fUser;
        Stream<QuerySnapshot> snapshot = Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .snapshots();

        snapshot.listen((QuerySnapshot data){
          themeChosen = data.documents[0]['theme'];
          debugPrint("ThemeChosen: ${themeChosen}");
          changingColor(themeChosen);
        });
      });
    });
  }
}