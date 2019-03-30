import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(user,context,String name){
    Firestore.instance.collection('/users').add({
      'email':user.email,
      'uid':user.uid,
      'name':name,
      'photoUrl': "https://firebasestorage.googleapis.com/v0/b/wardrobe-26e92.appspot.com/o/55b9552d-78b1-421f-b11a-3e89bfbd7b5e.jpg?alt=media&token=b61fd432-4049-47fd-ba97-44d90c37b9d7",
    }).then((value){
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed('/homepage');
    })
        .catchError((e){
      print(e);
    });
  }

 Future updateProfilePic(picUrl) async{
    var userInfo = new UserUpdateInfo();
    userInfo.photoUrl = picUrl;

    await FirebaseAuth.instance.currentUser().then((user){
        Firestore.instance
            .collection('/users')
            .where('uid',isEqualTo: user.uid)
            .getDocuments()
            .then((docs){
              Firestore.instance
                  .document('/users/${docs.documents[0].documentID}')
                  .updateData({'photoUrl': picUrl}).then((val){
                 print("Updated");
              }).catchError((e){
                print(e);
              });
        }).catchError((e){
          print(e);
        });
      }).catchError((e){
        print(e);
      });
  }

}