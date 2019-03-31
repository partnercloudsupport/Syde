import 'package:flutter/material.dart';
import 'package:ikode/Auth/auth.dart';
import 'package:ikode/login_page.dart';
import 'package:ikode/home_page.dart';
import 'package:ikode/root.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //create a stream build to listen to the auth changes
    StreamBuilder<FirebaseUser> builder = new StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, asyncSnapshot) {
          debugCheckHasMediaQuery(context);

          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
            );
          }

          //render login page if user is null
          if (asyncSnapshot.data == null) {
            return LogInPage();
          }

          //render home page if user is null
          return HomePage(
            user: asyncSnapshot.data,
          );
        });

    return MaterialApp(
        title: "Syde", debugShowCheckedModeBanner: false, home: builder);
  }
}
