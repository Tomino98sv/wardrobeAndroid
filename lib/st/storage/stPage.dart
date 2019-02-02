import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyStoragePage extends StatefulWidget{
  @override
  _MyStoragePageState createState() => new _MyStoragePageState();
}

class _MyStoragePageState extends State<MyStoragePage>{
  File sampleImage;

  //funkcia na pridanie obrazku z galerie
  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(
        source: ImageSource.gallery
    );
    setState(() {
      sampleImage = tempImage;
    });
  }

  //dizajn
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:  new AppBar(
        title: new Text('Your Wardrobe'),
        centerTitle: true,
      ),
      body: new Center(
        child: sampleImage == null ? Text('Select an Image'): enableUpload() ,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: new Icon(Icons.add),
      ),
    );
  }



  Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(sampleImage, height: 300.0, width: 300.0,),
          RaisedButton(
            elevation: 7.0,
            child: Text('Upload'),
            textColor: Colors.white,
            color: Colors.cyan,
            onPressed:() async {
              final StorageReference firebaseStorageRef =
                  FirebaseStorage.instance.ref().child('myimage.jpg');
              final StorageUploadTask task =
                  firebaseStorageRef.putFile(sampleImage);

            },
          )
        ],
      ),
    );
  }
}
