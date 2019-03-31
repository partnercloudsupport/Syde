import 'dart:async';
import 'package:ikode/Auth/auth.dart';

class AuthBloc {
  final BaseAuth baseAuth;
  StreamController<LogInEvents> _controller = StreamController<LogInEvents>();

  AuthBloc(this.baseAuth) {
    _inputStream().listen((event) {
      if (event is GoogleSignIn) {
        baseAuth.signInWithCredentials(baseAuth.getFireBAseAuth());
      }else{
        print("facebook log in");
      }
    });
  }

  Stream<LogInEvents> _inputStream() {
    return _controller.stream;
  }

  Sink<LogInEvents> get eventSink => _controller.sink;

  void dispose() {
    _controller.close();
  }
}

abstract class LogInEvents {}

class GoogleSignIn extends LogInEvents {}
class FaceBookSignIn extends LogInEvents{}

final authBloc = AuthBloc(Auth());
