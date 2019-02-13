import 'package:flutter/material.dart';
import 'package:ikode/Auth/auth.dart';
import 'package:ikode/facebook_login_page.dart';
import 'package:ikode/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(new Root());
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  AuthState _authState;
  FirebaseUser user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authState = AuthState.loggedOut;

    FirebaseAuth.instance.currentUser().then((user) {
      if (user == null) {
        print("no user found!");
        loggedOut();
      } else
        this.user = user;
      print(user.displayName);
      loggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_authState == AuthState.loggedIn) {
      return HomePage(
          homeCallBack: loggedOut,user: user,
      );
    } else if (_authState == AuthState.loggedOut) {
      return LogInPage(
        loginCallBack: loggedIn,
        baseAuth: Auth(),
      );
    }
  }

  loggedOut() {
    setState(() {
      _authState = AuthState.loggedOut;
      print("called log out");
    });
  }

  loggedIn() {
    setState(() {
      print("called log in");

      _authState = AuthState.loggedIn;
    });
  }
}

enum AuthState { loggedIn, loggedOut }
