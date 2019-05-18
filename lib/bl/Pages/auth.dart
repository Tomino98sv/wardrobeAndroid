import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user; //firebase user
  //Observe for detecting and being notified when an object is mutated.
  //<Map> unordered collection of key-value pair Map<Key Value>
  //Map<String, String> fruits = Map();
  //fruits["apple"] = "red";
  //fruits["banana"] = "yellow";

  Observable<Map<String, dynamic>> profile; //custom user data in Firestore
  PublishSubject loading = PublishSubject();

  AuthService() {
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u){
      if( u != null) {
        return _db.collection('users').document(u.uid).snapshots().map((snap) => snap.data);

      } else {
        return Observable.just({ });
      }
    });
  }

  Future <FirebaseUser> googleSignIn() async {
    signOut();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    storeNewUser(currentUser);
    return currentUser;
  }
//  Future<FirebaseUser> googleSignIn() async {
//    loading.add(true);
//    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//    FirebaseUser user = await _auth.signInWithGoogle(
//        accessToken: googleAuth.accessToken,
//        idToken: googleAuth.idToken
//    );
//
//    updateUserData(user);
//    print("signed in " + user.displayName);
//
//    loading.add(false);
//    return user;
//  }


  void signOut() {
    _auth?.signOut();
    _googleSignIn?.signOut();
  }

  void storeNewUser(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
  //merge true cize ak uz existuje taky dokument v firestore tak nevytvori novy rovnaky
    return ref.setData({
        'email': user.email,
        'name':user.displayName,
        'uid': user.uid,
        'photoUrl': user.photoUrl,
        'theme':false,
    }, merge: true);
  }


}

final AuthService authService = AuthService();



