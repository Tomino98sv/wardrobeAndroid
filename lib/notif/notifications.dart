import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPage createState() => _NotificationsPage();

}

class _NotificationsPage extends State<NotificationsPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("notifikacie", style: Theme.of(context).textTheme.subhead,)
        ],
      ),
    );
  }

}