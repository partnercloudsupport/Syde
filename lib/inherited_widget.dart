import 'package:ikode/Auth/auth_bloc.dart';
import 'package:flutter/material.dart';

class MyInheritedWidget extends InheritedWidget {

  final AuthBloc bloc;
  MyInheritedWidget({this.bloc,Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static AuthBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(MyInheritedWidget)
            as MyInheritedWidget)
        .bloc;
  }
}
