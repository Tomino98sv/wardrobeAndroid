import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class MyStoragePage2 extends StatefulWidget{

  Function _function;

  MyStoragePage2({@required Function function}) {
    _function = function;
  }

  @override
  _MyStoragePageState2 createState() => new _MyStoragePageState2();
}

class _MyStoragePageState2 extends State<MyStoragePage2>{
  String _path;

  //upload funkcia
  uploadFile(String filePath) async {
    print('funckia uploadFile $filePath');
    final ByteData bytes = await rootBundle.load(filePath);
    final Directory tempFile = Directory.systemTemp; // filePath dame do docasneho pricinku
    String extension = filePath.substring(filePath.length - 3); //vybratie poslednych 3 pismenok - urcenie pripony
    final String fileName = "${Uuid().v4()}.$extension"; // vytvorenie mena obrazka .. uuid radom cisla,pismenka
    final File imageFile = File('${tempFile.path}/$fileName'); //vytvorenie objektu-obrazka
    imageFile.writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write); //ci dobry access

    //pridanie obrazka
    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask task = ref.putFile(imageFile);
    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    _path = downloadUrl.toString();
    widget._function(_path);
    print(_path); // url cesta pre Klaud
  }



  //funkcia na pridanie obrazku z galerie
  File sampleImage;
  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(
        source: ImageSource.gallery
    );
    setState(() {
      sampleImage = tempImage;
    });
  }




  //funkcia na pridanie obrazku z camery
  File sampleImage2;
  Future getImage2() async{
    var tempImage2 = await ImagePicker.pickImage(
        source: ImageSource.camera
    );
    setState(() {
      sampleImage2 = tempImage2;
    });
  }



  //dizajn
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
         new Center(
            child: sampleImage == null && sampleImage2 == null
                ? Text('Select an Image')
                : sampleImage != null ? enableUpload() : enableUpload2(),
         ),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: new FloatingActionButton(
                  onPressed: getImage,
                  tooltip: 'Add Image',
                  child: new Icon(Icons.add_photo_alternate),
                  backgroundColor: Colors.pink,
                  mini: true,
                ),padding: EdgeInsets.all(15.0),
              ),
              Container(
                child: new FloatingActionButton(
                  onPressed: getImage2,
                  tooltip: 'Add Image',
                  child: new Icon(Icons.add_a_photo),
                  backgroundColor: Colors.pink,
                  mini: true,
                ),padding: EdgeInsets.all(15.0)
              ),
            ],
          )
        ]
    );
  }



  Widget enableUpload() {
    print('upload image from gallery');
    String filePath = sampleImage.path;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.file(sampleImage, height: 300.0, width: 300.0,),
          Container(
            margin: EdgeInsets.only(top: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Material(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(30.0),
                child: InkWell(
                  splashColor: Colors.pink[400],
                  onTap:  () {uploadFile(filePath);},
                  child: Container(
                    width: 100.0,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Confirm',style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget enableUpload2() {
    print('upload image from camera');
    String filePath = sampleImage2.path;
    return Container(
      child: InkWell(
        onTap:  uploadFile(filePath),
        child: Column(
          children: <Widget>[
            Image.file(sampleImage2, height: 300.0, width: 300.0,),
            Container(
              decoration: new BoxDecoration(
                color: Colors.pink,
                borderRadius: new BorderRadius.circular(30.0),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Confirm',style: TextStyle(color: Colors.white),),
            ),
          ],
      ),
      ),
    );
  }
}
