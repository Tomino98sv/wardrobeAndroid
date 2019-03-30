import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget{
  @override
  _SettingsPageState  createState() {
    return  _SettingsPageState();
  }

}

class _SettingsPageState extends State<SettingsPage>{

  bool click = false;
  bool note = false;

  @override
  Widget build(BuildContext context) {
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
                    value: click,
                    onChanged: (bool valueOfClick) => changingColor(valueOfClick),
                ),
              ],
            ),
             Row(
              children: <Widget>[
                new Text("Turn on the notifications"),
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

  void changingColor(bool valueOfClick){
    setState(() {
      if(valueOfClick){
        click = false;
        valueOfClick = false;
      } else {
        click = true;
        valueOfClick = true;
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