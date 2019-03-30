import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/bl/videjko/services/usermanagment.dart';
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

  }

  Widget getUploadButton() {

  }

}