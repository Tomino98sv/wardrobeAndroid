import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/db/FirestoreManager.dart';
import 'package:image_picker/image_picker.dart';

class changeImageItem extends StatefulWidget{
  DocumentSnapshot item;

  changeImageItem ({@required this.item});

  @override
  _changeImageItemState createState() => new _changeImageItemState(item: item);

}

class _changeImageItemState extends State<changeImageItem>{

  DocumentSnapshot item;
 // Firestore.instance.collecton('/items').document(item.documentID)
  File itemImage;
//  Item itemURL = item['photo_url'];

  _changeImageItemState({@required this.item}) {
       docImage = item['photo_url'];
  }

  String docImage = '';

  //vytvorenie image
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      itemImage = tempImage;
      print("vybralo obrazok");
    });
  }


//  @override
//  Widget build(BuildContext context) {
//    return Column(
//        mainAxisSize: MainAxisSize.max,
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          new Center(
//            child: docImage != null ? uploadSecondImage(): Container(),
//          ),
//          new Row(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Container(
//                child: RaisedButton(
//                    onPressed: getImage,
//                    child: Text('Change image',style: TextStyle(color: Colors.white),),
//                ),
//                  padding: EdgeInsets.all(15.0)
//              ),
//            ],
//          )
//        ]
//    );
//  }

  uploadSecondImage() async {
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
    StorageUploadTask task = firebaseStorageRef.putFile(itemImage);
    task.events.listen((event){
      if(event.type == StorageTaskEventType.failure){
        print("DO riti nieco sa posralo");
        Navigator.of(context, rootNavigator: true).pop('dialog');
//        _showSnackBar("Kamarade ziadna nova profilovka nebude");
      }
    });

    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL().then((value){
      userManagement.updateSecondImage(value.toString()).then((val){

        Navigator.of(context, rootNavigator: true).pop('dialog');
//      _showSnackBar("Profile picture successfully changed");
        Navigator.pop(context);
      });
    });
  }
}