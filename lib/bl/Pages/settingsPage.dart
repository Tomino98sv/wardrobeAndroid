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
  bool darkThemeChosen;
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
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
            "Settings",style: TextStyle(color: Colors.white, fontFamily: 'Pacifico')
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text("Changing color of app",style:Theme.of(context).textTheme.subhead,),
                new Switch(
                  value: click ,
                  onChanged: (bool valueOfClick) => changingColor(valueOfClick),
                ),
             ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text("Dark mode",style:Theme.of(context).textTheme.subhead),
                new Switch(
                  value: mode,
                  onChanged: (bool valueOfMode) => darkMode(valueOfMode),
                ),
              ],),
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
          primaryIconTheme: IconThemeData(color: Colors.pink[500]),
          fontFamily: 'Pacifico',
          indicatorColor: Colors.pink[100],
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
              subhead: TextStyle(color: Colors.black,),
              subtitle: TextStyle(color: Colors.white)),
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
            primaryIconTheme: IconThemeData(color: Colors.blue),
            fontFamily: 'Pacifico',
            indicatorColor: Colors.blue[200],
            brightness: Brightness.light,
            textTheme: TextTheme(
                subhead: TextStyle(color: Colors.black,),
                subtitle: TextStyle(color: Colors.white)),
            iconTheme: IconThemeData(color: Colors.black)
        ));
  }


  DemoTheme _buildDarkMode() {
    return DemoTheme(
        'dark',
        new ThemeData(
          textTheme: TextTheme(
              subhead: TextStyle(color: Colors.white),
              subtitle: TextStyle(color: Colors.black)
          ),
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.grey[900],
          accentColor: Colors.black45,
          buttonColor: Colors.white12,
          primaryIconTheme: IconThemeData(color: Colors.white),
          toggleableActiveColor: Colors.black54,
          unselectedWidgetColor: Colors.black45,
          fontFamily: 'Pacifico',
          canvasColor: Colors.black54,
          indicatorColor: Colors.black54,
          dialogBackgroundColor: Colors.black54,
          iconTheme: IconThemeData(color: Colors.white),
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
        userManagement.updateUsingThemeDark(valueOfMode);
      } else {
        valueOfMode =false;
        mode = false;
        userManagement.updateUsingThemeDark(valueOfMode);
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
          darkThemeChosen = data.documents[0]['darkTheme'];
          debugPrint("ThemeChosen: ${themeChosen}");
          changingColor(themeChosen);
          darkMode(darkThemeChosen);
        });
      });
    });
  }
}