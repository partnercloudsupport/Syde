import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:ikode/Auth/auth.dart';

class AuthBloc {
  final BaseAuth baseAuth;
  FirebaseAuth auth;
  FacebookLogin fbLogIn;
  FirebaseUser user;

  StreamController<ClickEvents> _controller = StreamController<ClickEvents>();
  StreamController<bool> _controllerAuth = StreamController<bool>.broadcast();

  AuthBloc(this.baseAuth) {
    _inputStream().listen(processEvent);
    authStream.listen((val) {
      print("stream is $val");

      if (val == false) {
        baseAuth.logUserOut(FirebaseAuth.instance);
      }
    });
    initAuth();
  }

  Stream<ClickEvents> _inputStream() {
    return _controller.stream;
  }

  Stream<bool> get authStream {
    return _controllerAuth.stream;
  }

  Sink<ClickEvents> get eventSink => _controller.sink;

  Sink<bool> get authSink => _controllerAuth.sink;

  void dispose() {
    _controller.close();
    _controllerAuth.close();
  }

  void processEvent(ClickEvents event) {
    if (event is InitialClick) {
      print("Initial Click");
      signIn();
    } else
      print("already clicked");
  }

  initAuth() {
    auth = baseAuth.getFireBAseAuth();
    fbLogIn = baseAuth.getFaceBookLogin();

    auth.currentUser().then((user) {
      if (user == null) {
        print("no user found!");
        authBloc.authSink.add(false);
      } else {
        this.user = user;
        print(user.displayName);
        authBloc.authSink.add(true);
      }
    });
  }

  signIn() async {
    FacebookLoginResult result =
        await baseAuth.initFaceBookLogIn(fbLogIn, ["email"]);
    final AuthCredential authCredential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
//        print("fb log in");
        baseAuth.signInWithCredentials(auth, authCredential).then((user) {
//          print("inside");
          this.user = user;

          print("user ${this.user.displayName}");

          authBloc.authSink.add(true);
//          widget.loginCallBack();
        });

        break;
      case FacebookLoginStatus.cancelledByUser:
        print("cancelled by user");
        authBloc.authSink.add(false);
        break;
      case FacebookLoginStatus.error:
        print("error");
        authBloc.authSink.add(false);
        break;
    }
  }
}

abstract class ClickEvents {}

class InitialClick extends ClickEvents {}

class AlreadyClicked extends ClickEvents {}

final authBloc = AuthBloc(Auth());

//signIn() async {
//  FacebookLoginResult result =
//  await widget.baseAuth.initFaceBookLogIn(fbLogIn, ["email"]);
//  final AuthCredential authCredential = FacebookAuthProvider.getCredential(
//      accessToken: result.accessToken.token);
//  switch (result.status) {
//    case FacebookLoginStatus.loggedIn:
////        print("fb log in");
//      widget.baseAuth.signInWithCredentials(auth, authCredential).then((user) {
////          print("inside");
//        this.user = user;
//
//        print("user ${this.user.displayName}");
//
//        authBloc.authSink.add(true);
////          widget.loginCallBack();
//      });
//
//      break;
//    case FacebookLoginStatus.cancelledByUser:
//      print("cancelled by user");
//      authBloc.authSink.add(false);
//      break;
//    case FacebookLoginStatus.error:
//      print("error");
//      authBloc.authSink.add(false);
//      break;
//  }
//}
