import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(user, context, String name, String url) {
    Firestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid,
      'name': name,
      'photoUrl': url,
      'theme':false,
      'darkTheme':false
    }).then((value) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/homepage');
    })
        .catchError((e) {
      print(e);
    });
  }

  Future updateProfilePic(picUrl) async {
//    var userInfo = new UserUpdateInfo();
//    userInfo.photoUrl = picUrl;

    await FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('/users')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        Firestore.instance
            .document('/users/${docs.documents[0].documentID}')
            .updateData({'photoUrl': picUrl}).then((val) {
          print("Updated");
        }).catchError((e) {
          print(e);
        });
      }).catchError((e) {
        print(e);
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future updateProfileName(newName) async {
//    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('/users')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        Firestore.instance
            .document('/users/${docs.documents[0].documentID}')
            .updateData({'name': newName}).then((val) {
          print("Updated");
        }).catchError((e) {
          print(e);
        });
      }).catchError((e) {
        print(e);
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future updateUsingTheme(valueOfClick) async {
//    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('/users')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        Firestore.instance
            .document('/users/${docs.documents[0].documentID}')
            .updateData({'theme': valueOfClick}).then((val) {
          print("Updated common theme");
        }).catchError((e) {
          print(e);
        });
      }).catchError((e) {
        print(e);
      });
    }).catchError((e) {
      print(e);
    });
  }


  Future updateUsingThemeDark(valueOfDarkClick) async {
//    var userInfo = new UserUpdateInfo();

    await FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('/users')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        Firestore.instance
            .document('/users/${docs.documents[0].documentID}')
            .updateData({'darkTheme': valueOfDarkClick}).then((val) {
          print("Updated dark theme");
        }).catchError((e) {
          print(e);
        });
      }).catchError((e) {
        print(e);
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future sendRating(value) async {

    await FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('/users')
          .where('uid', isEqualTo: user.uid)
          .getDocuments()
          .then((docs) {
        Firestore.instance
            .document('/users/${docs.documents[0].documentID}')
            .updateData({'rating': value}).then((val) {
          print("Rating of user: ${docs.documents[0].data['name']} was added");
        }).catchError((e) {
          print(e);
        });
      }).catchError((e) {
        print(e);
      });
    }).catchError((e) {
      print(e);
    });
  }

}
