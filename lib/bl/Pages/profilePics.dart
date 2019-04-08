import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  FirebaseUser user;
  String profileUrlImg="";
  String emailUser="";
  String nameUser="";
  File newProfilePic;
  String _nameNew="";
  UserManagement userManagement = new UserManagement();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        user = fUser;
        Stream<QuerySnapshot> snapshot = Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .snapshots();

        snapshot.listen((QuerySnapshot data){
          profileUrlImg = data.documents[0]['photoUrl'];
          emailUser = data.documents[0]['email'];
          nameUser = data.documents[0]['name'];
        });
      });
    });
  }

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500
    );
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
          child: CircularProgressIndicator(backgroundColor: Theme.of(context).accentColor,),
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
        key: _scaffoldKey,
        body: getChooseButton(),
    );
  }

  Widget getChooseButton() {
    return ListView(
      children: <Widget>[
        Column(
            children: <Widget>[
              Container(
                height: 40.0,
                width: 150.0,
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: Colors.pinkAccent,
                  color: Colors.pink,
                  elevation: 7.0,
                  child: FlatButton(
                    onPressed: getImage,
                    child: Center(
                      child: Text(
                          "Change Image",
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400
                          )
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                    color: Colors.pink,
                    image: DecorationImage(
                        image: newProfilePic==null?NetworkImage(profileUrlImg):FileImage(newProfilePic),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 7.0, color: Colors.black)
                    ]
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "${nameUser}",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 5.0),
              Form(
               key: _formKey,
               child: TextFormField(
                 onSaved: (input) => _nameNew = input,
                 decoration: new InputDecoration(
                   labelText: "Enter Name",
                   fillColor: Colors.white,
                   border: new OutlineInputBorder(
                     borderRadius: new BorderRadius.circular(25.0),
                     borderSide: new BorderSide(
                     ),
                   ),
                 ),
                 keyboardType: TextInputType.emailAddress,
                 style: new TextStyle(
                   fontFamily: "Poppins",
                 ),
               ),
              )
            ]
        ),
        SizedBox(height: 30.0),
        Container(
          height: 40.0,
          width: 150.0,
          child: Material(
            borderRadius: BorderRadius.circular(20.0),
            shadowColor: Colors.pinkAccent,
            color: Colors.pink,
            elevation: 7.0,
            child: FlatButton(
              onPressed: appleChanges,
              child: Center(
                child: Text(
                    "Apply changes",
                    style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400
                    )
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future appleChanges() async {
    _formKey.currentState.save();
    if(_nameNew!= ""){
      if(_nameNew.length<2 || _nameNew.length>10){
        _showSnackBar2("Name must be at least 2 chars");
      }else{
        userManagement.updateProfileName(_nameNew);
        _showSnackBar("Name changed");
        if(newProfilePic != null){
          uploadImage();
          _showSnackBar("Picture changed");
        }else{
          _showSnackBar("Picture not changed");
        }
      }
    }else{
      if(newProfilePic != null){
        uploadImage();
        _showSnackBar("Only Picture changed");
      }else{
        _showSnackBar("Nothing changed");
      }
    }

  }

  _showSnackBar(String str) {
    final snackBar = new SnackBar(
      content: new Text(str),
      duration: new Duration(seconds: 3),
      backgroundColor: Colors.black54,
      action: new SnackBarAction(
          label: 'Get Out',
          onPressed: () {
            Navigator.pop(context);
          },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);

  }

  _showSnackBar2(String str) {
    final snackBar = new SnackBar(
      content: new Text(str),
      duration: new Duration(seconds: 3),
      backgroundColor: Colors.black54,
      action: new SnackBarAction(
          label: 'Notice',
          onPressed: () {
      }),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);

  }

}