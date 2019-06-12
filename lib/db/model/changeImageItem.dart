import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/db/FirestoreManager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class changeImageItem extends StatefulWidget{
  DocumentSnapshot item;

  changeImageItem ({@required this.item});

  @override
  _changeImageItemState createState() => new _changeImageItemState(item: item);

}

class _changeImageItemState extends State<changeImageItem>{

  DocumentSnapshot item;
  File itemImage;
  String docImage = "";
  String _path;
  String filePath;

  _changeImageItemState({@required this.item}) {
       docImage = item['photo_url'];
       debugPrint(docImage);
  }



  //vytvorenie image
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      itemImage = tempImage;
      debugPrint(itemImage.path);
      filePath = itemImage.path;
    });
    uploadSecondImage(filePath, context);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Center(
      //      child: docImage != null ? uploadImage(): Container(),
          ),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 8.0),
                child: InkWell(
                  splashColor: Theme.of(context).accentColor,
                  onTap:  getImage,
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Theme.of(context).buttonColor,
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    width: 150.0,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Change image',style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
            ],
          )
        ]
    );
  }

  uploadSecondImage(String filePath, BuildContext context) async {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              width: 48.0,
              height: 48.0,
              child: CircularProgressIndicator(backgroundColor: Theme.of(context).accentColor,),
            ),
          );
        });

    print('funckia uploadFile $filePath');
    final ByteData bytes = await rootBundle.load(filePath);
    final Directory tempFile = Directory.systemTemp; // filePath dame do docasneho pricinku
    String extension = filePath.substring(filePath.length - 3); //vybratie poslednych 3 pismenok - urcenie pripony
    final String fileName = "${Uuid().v4()}.$extension"; // vytvorenie mena obrazka .. uuid radom cisla,pismenka
    final File imageFile = File('${tempFile.path}/$fileName'); //vytvorenie objektu-obrazka
    imageFile.writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write); //ci dobry access

    //pridanie obrazka
    new Image(image: new CachedNetworkImageProvider(filePath));
    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask task = ref.putFile(imageFile);
    task.events.listen((event){
      if(event.type == StorageTaskEventType.failure) {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        //widget._function("");
      }
    });
    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    _path = downloadUrl.toString();
    //widget._function(_path);
    
    print(_path); // url cesta pre Klaud
    Navigator.of(context, rootNavigator: true).pop('dialog');


    //zmazanie starej url
    deleteFireBaseStorageItem(docImage);
    debugPrint("vymazanee");

    //namiesto starej url sa ma dat nova
    Firestore.instance.collection('items').document(item.documentID).updateData({"photo_url": _path});
    debugPrint("zmenil sa obrazok");

  }


  void deleteFireBaseStorageItem(String fileUrl) {
    String filePath = fileUrl.replaceAll(
        new RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/wardrobe-26e92.appspot.com/o/'),
        '');
    filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
    StorageReference storageReferance = FirebaseStorage.instance.ref();
    storageReferance
        .child(filePath)
        .delete()
        .then((_) => print('Successfully deleted $filePath storage item'));
  }
}

