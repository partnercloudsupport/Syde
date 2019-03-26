import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  FirebaseAuth getFireBAseAuth();

  GoogleSignIn getGoogleLogin();

  Future<FacebookLoginResult> initFaceBookLogIn(
      FacebookLogin fbLogIn, List<String> permission);

  Future<GoogleSignInAuthentication> getGoogleSignInAuth();

  AuthCredential getAuthCredential(GoogleSignInAuthentication auth);

  Future<void> logUserOut(FirebaseAuth mAuth);

  Future<void> storeUser(FirebaseUser user);

  Future<FirebaseUser> signInWithCredentials(FirebaseAuth mAuth);
}

class Auth implements BaseAuth {
  @override
  FirebaseAuth getFireBAseAuth() {
    // TODO: implement getFireBAseAuth
    var instance = FirebaseAuth.instance;
    return instance;
  }

  @override
  Future<void> logUserOut(FirebaseAuth auth) {
    // TODO: implement logUserOut
    var out = auth.signOut();
    return out;
  }

  @override
  Future<FacebookLoginResult> initFaceBookLogIn(
      FacebookLogin fbLogIn, List<String> permission) async {
    // TODO: implement initFaceBookLogIn
    var result = await fbLogIn.logInWithReadPermissions(permission);
    return result;
  }

  @override
  Future<FirebaseUser> signInWithCredentials(FirebaseAuth mAuth) async {
    GoogleSignInAuthentication authentication = await getGoogleSignInAuth();
    AuthCredential credential = getAuthCredential(authentication);
    var user = await mAuth.signInWithCredential(credential);

    storeUser(user);

    return user;
  }

  @override
  GoogleSignIn getGoogleLogin() {
    return GoogleSignIn();
  }

  @override
  Future<GoogleSignInAuthentication> getGoogleSignInAuth() async {
    final GoogleSignInAccount googleUser = await getGoogleLogin().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    return googleAuth;
  }

  @override
  AuthCredential getAuthCredential(GoogleSignInAuthentication googleAuth) {
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    return credential;
  }

  @override
  Future<void> storeUser(FirebaseUser user) async {
    if (user != null) {
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;

      print("Size ${documents.length}");
      documents.forEach((val) {
        print("Data = ${val.data}");
      });
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance.collection('users').document(user.uid).setData({
          'name': user.displayName,
          'photoUrl': user.photoUrl,
          'id': user.uid,
          'created': DateTime.now().millisecondsSinceEpoch.toString()
        });
      }


    }
  }
}
