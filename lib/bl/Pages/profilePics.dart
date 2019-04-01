import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/videjko/services/usermanagment.dart';
import 'package:flutter_app/ui/homePage.dart';
import 'package:image_picker/image_picker.dart';

class SelectProfilePicPage extends StatefulWidget {
  @override
  _SelectProfilePicPageState createState() => _SelectProfilePicPageState();

}

class _SelectProfilePicPageState extends State<SelectProfilePicPage> {

  File newProfilePic;
  UserManagement userManagement = new UserManagement();
//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = tempImage;
    });
  }

  uploadImage() async {

    showDialog(context: context, barrierDismissible: false,builder: (BuildContext context) {
      return Center(
        child: Container(
          width: 48.0,
          height: 48.0,
          child: CircularProgressIndicator(backgroundColor: Colors.pink,),
        ),
      );
    });
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(
        '${user.email}/${user.email}_profilePicture.jpg');
    StorageUploadTask task = firebaseStorageRef.putFile(newProfilePic);
    task.events.listen((event){
      if(event.type == StorageTaskEventType.failure){
        print("DO riti nieco sa posralo");
        Navigator.of(context, rootNavigator: true).pop('dialog');
//        _showSnackBar("Kamarade ziadna nova profilovka nebude");
      }
    });

    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL().then((value){
      userManagement.updateProfilePic(value.toString()).then((val){

        Navigator.of(context, rootNavigator: true).pop('dialog');
//      _showSnackBar("Profile picture successfully changed");
        Navigator.pop(context);
      });
    });



  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("Profile Picture"),
      ),
//      key: _scaffoldKey,
      body: newProfilePic == null ? getChooseButton() : getUploadButton(),
    );
  }

  Widget getChooseButton() {
    return new Container(
      height: 30.0,
      width: 120.0,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        shadowColor: Colors.pinkAccent,
        color: Colors.pink,
        elevation: 7.0,
        child: FlatButton(
          onPressed: getImage,
          child: Center(
            child: Text(
                "getImage",
                style: new TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w400
                )
            ),
          ),
        ),
      ),
    );
  }

  Widget getUploadButton() {
    return new Container(
      height: 30.0,
      width: 120.0,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        shadowColor: Colors.pinkAccent,
        color: Colors.pink,
        elevation: 7.0,
        child: FlatButton(
          onPressed: uploadImage,
          child: Center(
            child: Text(
                "UploadImg",
                style: new TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w400
                )
            ),
          ),
        ),
      ),
    );
  }


//  _showSnackBar(String str) {
//    final snackBar = new SnackBar(
//      content: new Text(str),
//      duration: new Duration(seconds: 3),
//      backgroundColor: Colors.black54,
//      action: new SnackBarAction(
//          label: 'OUKEY',
//          onPressed: () {
//            print("pressed snackbar");
//          }),
//    );
//    _scaffoldKey.currentState.showSnackBar(snackBar);
//
//  }

}