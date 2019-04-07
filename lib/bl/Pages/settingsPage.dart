import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/profilePics.dart';
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
  bool note = false;
  bool click = false;

  @override
  Widget build(BuildContext context) {
   inheritedThemeSwitcher = ThemeSwitcher.of(context);
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
            "Settings"
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                new Text("Changing color of app"),
                new Switch(
                  value: click ,
                  onChanged: (bool valueOfClick) => changingColor(valueOfClick),
                ),
             ],),
             Row(
              children: <Widget>[
                new Text("Turn on the notifications"),
                new Switch(
                    value: note,
                    onChanged: (bool valueOfNote) => setNotifications(valueOfNote),
                ),
              ],
          ),
            Container(
              height: 30.0,
              width: 150.0,
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.pinkAccent,
                color: Colors.pink,
                elevation: 7.0,
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectProfilePicPage()));
                  },
                  child: Center(
                    child: Text(
                        "ChangeProfilePics",
                        style: new TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400
                        )
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );

  }

    DemoTheme _buildPinkTheme() {
    return DemoTheme(
        'light',
        new ThemeData(
        primaryColor: Colors.pink[400],
        scaffoldBackgroundColor: Colors.grey[50],
        accentColor: Colors.pink[400],
        buttonColor: Colors.pink,
        fontFamily: 'Quicksand',
        indicatorColor: Colors.blueGrey,
    ));
  }

  DemoTheme _buildBlueTheme() {
    return DemoTheme(
        'dark',
        new ThemeData(
          primaryColor: Colors.blue[400],
          scaffoldBackgroundColor: Colors.grey[50],
          accentColor: Colors.blueAccent[400],
          buttonColor: Colors.blue,
          toggleableActiveColor: Colors.lightBlue,
          unselectedWidgetColor: Colors.blueAccent,
//          splashColor: Colors.lightBlue,
          fontFamily: 'Quicksand',
          indicatorColor: Colors.blueGrey,
        ));
  }

  void changingColor(bool valueOfClick){
    setState(() {
      if(valueOfClick){
        inheritedThemeSwitcher.themeBloc.selectedTheme.add(_buildBlueTheme());
        valueOfClick = true;
        click = true;
      } else {
        inheritedThemeSwitcher.themeBloc.selectedTheme.add(_buildPinkTheme());
        valueOfClick =false;
        click = false;
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
}