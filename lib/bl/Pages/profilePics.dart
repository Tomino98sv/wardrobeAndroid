import 'dart:io';
import 'dart:math';

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

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = tempImage;
    });
  }

  uploadImage() async {
    var randomno = Random(25);
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(
        'profilepics/${randomno.nextInt(5000).toString()}.jpg');
    StorageUploadTask task = firebaseStorageRef.putFile(newProfilePic);
    task.events.listen((event){
      if(event.type == StorageTaskEventType.failure){
        print("DO riti nieco sa posralo");
      }
    });

    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL().then((value){
      userManagement.updateProfilePic(value.toString()).then((val){
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
      body: newProfilePic == null ? getChooseButton() : getUploadButton(),
    );
  }

  Widget getChooseButton() {
    return new Container(
      height: 30.0,
      width: 120.0,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        shadowColor: Colors.orange,
        color: Colors.red,
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
        shadowColor: Colors.orange,
        color: Colors.red,
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

}