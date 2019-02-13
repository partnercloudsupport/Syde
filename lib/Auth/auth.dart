import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:async';

abstract class BaseAuth {
  FirebaseAuth getFireBAseAuth();

  FacebookLogin getFaceBookLogin();

  Future<FacebookLoginResult> initFaceBookLogIn(
      FacebookLogin fbLogIn, List<String> permission);

  Future<void> logUserOut(FirebaseAuth mAuth);

  Future<FirebaseUser> signInWithCredentials(
      FirebaseAuth mAuth, AuthCredential credential);
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
  FacebookLogin getFaceBookLogin() {
    // TODO: implement getFaceBookLogin
    return FacebookLogin();
  }

  @override
  Future<FacebookLoginResult> initFaceBookLogIn(
      FacebookLogin fbLogIn, List<String> permission) async {
    // TODO: implement initFaceBookLogIn
    var result = await fbLogIn.logInWithReadPermissions(permission);
    return result;
  }

  @override
  Future<FirebaseUser> signInWithCredentials(
      FirebaseAuth mAuth, AuthCredential credential) async {
    // TODO: implement signInWithCredentials
    var user = await mAuth.signInWithCredential(credential);
    return user;
  }
}
