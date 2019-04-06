import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/profilePics.dart';
import 'package:flutter_app/ui/themes.dart';

class SettingsPage extends StatefulWidget{
  final ThemeBloc themeBloc;

  SettingsPage({Key key, this.themeBloc}) : super(key: key);

  @override
  _SettingsPageState  createState() {
    return  _SettingsPageState();
  }

}

class _SettingsPageState extends State<SettingsPage>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Theme Selector',
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () =>
                    widget.themeBloc.selectedTheme.add(_buildLightTheme()),
                child: Text(
                  'Light theme',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: RaisedButton(
                  onPressed: () =>
                      widget.themeBloc.selectedTheme.add(_buildDarkTheme()),
                  child: Text(
                    'Dark theme',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  DemoTheme _buildLightTheme() {
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

  DemoTheme _buildDarkTheme() {
    return DemoTheme(
        'dark',
        new ThemeData(
          primaryColor: Colors.brown[400],
          scaffoldBackgroundColor: Colors.grey[50],
          accentColor: Colors.brown[400],
          buttonColor: Colors.brown,
          fontFamily: 'Quicksand',
          indicatorColor: Colors.blueGrey,
        ));
  }

}

//class _SettingsPageState extends State<SettingsPage>{
//
//  bool click = false;
//  bool note = false;
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: Text(
//            "Settings"
//        ),
//      ),
//      body: Container(
//        child: Column(
//          children: <Widget>[
//            Row(
//              children: <Widget>[
//                new Text("Changing color of app"),
//                new Switch(
//                    value: click,
//                    onChanged: (bool valueOfClick) => changingColor(valueOfClick),
//                ),
//              ],
//            ),
//             Row(
//              children: <Widget>[
//                new Text("Turn on the notifications"),
//                new Switch(
//                    value: note,
//                    onChanged: (bool valueOfNote) => setNotifications(valueOfNote),
//                ),
//              ],
//          ),
//            Container(
//              height: 30.0,
//              width: 150.0,
//              child: Material(
//                borderRadius: BorderRadius.circular(20.0),
//                shadowColor: Colors.pinkAccent,
//                color: Colors.pink,
//                elevation: 7.0,
//                child: FlatButton(
//                  onPressed: () {
//                    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectProfilePicPage()));
//                  },
//                  child: Center(
//                    child: Text(
//                        "ChangeProfilePics",
//                        style: new TextStyle(
//                            fontSize: 12.0,
//                            color: Colors.white,
//                            fontWeight: FontWeight.w400
//                        )
//                    ),
//                  ),
//                ),
//              ),
//            ),
//          ],
//        ),
//      )
//    );
//  }
//
//  void changingColor(bool valueOfClick){
//    setState(() {
//      if(valueOfClick){
//        click = false;
//        valueOfClick = false;
//      } else {
//        click = true;
//        valueOfClick = true;
//      }
//    });
//  }
//
//  void setNotifications(bool valueOfNote){
//    setState(() {
//      if(valueOfNote){
//        note = false;
//        valueOfNote = false;
//      } else {
//        note = true;
//        valueOfNote = true;
//      }
//    });
//  }
//}