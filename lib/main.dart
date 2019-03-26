import 'package:flutter/material.dart';
import 'package:ikode/Auth/auth.dart';
import 'package:ikode/google_login_page.dart';
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
  void initState() {
    // TODO: implement initState

//    Firestore.instance.settings(timestampsInSnapshotsEnabled: true,persistenceEnabled: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StreamBuilder<FirebaseUser> builder = new StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, asyncSnapshot) {
          print("shot =  ${asyncSnapshot.data}");
          print("data = ${asyncSnapshot.hasData}");
          print("error = ${asyncSnapshot.hasError}");
          if (asyncSnapshot.data == null) {
            return LogInPage();

          }

          return HomePage(
            user: asyncSnapshot.data,
          );
        }

//          print("shot =  ${asyncSnapshot.data}");
//          print("data = ${asyncSnapshot.hasData}");
//          print("error = ${asyncSnapshot.hasError}");
//          if (asyncSnapshot.hasError) {
//            return  Text("Error!");
//
//          }else {
//
//
//        }

        );

    return MaterialApp(
        title: "Syde", debugShowCheckedModeBanner: false, home: builder);
  }
}

class WaitingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            "Syde",
            style: TextStyle(color: Colors.blue, fontSize: 29.0),
          ),
        ),
      ),
    );
  }
}
