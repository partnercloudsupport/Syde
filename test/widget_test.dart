// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikode/Auth/auth.dart';
import 'package:ikode/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ikode/main.dart';

void main() {
  
  testWidgets("login widget test", (WidgetTester tester)async{

    await tester.pumpWidget(LogInPage());


    await tester.tap(find.byType(InkWell));
    
    expect(Auth().signInWithCredentials(Auth().getFireBAseAuth()), FirebaseUser);


  });
}
