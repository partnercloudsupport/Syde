import 'dart:async';
import 'package:ikode/Auth/auth.dart';

class AuthBloc {
  final BaseAuth baseAuth;
  StreamController<ClickEvents> _controller = StreamController<ClickEvents>();

  AuthBloc(this.baseAuth) {
    _inputStream().listen((event) {
      if (event is ClickEvents) {
        baseAuth.signInWithCredentials(baseAuth.getFireBAseAuth());
      }
    });
  }

  Stream<ClickEvents> _inputStream() {
    return _controller.stream;
  }

  Sink<ClickEvents> get eventSink => _controller.sink;

  void dispose() {
    _controller.close();
  }
}

abstract class ClickEvents {}

class LogInClick extends ClickEvents {}

final authBloc = AuthBloc(Auth());
