import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Home  extends StatefulWidget {
  const Home({
    Key key,
    @required this.user
  }) : super(key: key);
  final FirebaseUser user;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  @override
  Widget build(BuildContext context) {
    debugPrint("ide to?");
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Home User: ${widget.user.email}"),
      ),
    );
  }
}