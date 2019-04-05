import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ikode/home_page.dart';
import 'package:ikode/login_page.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}



class _RootState extends State<Root> {



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        print(snapshot.connectionState);
        print(snapshot.data);
        print(snapshot.hasData);


        if (snapshot.hasData) {

          Navigator.push(
              context, MaterialPageRoute(builder: (BuildContext context) {
            return HomePage(
              user: snapshot.data,
            );
          }));

          } else {

          Navigator.push(
              context, MaterialPageRoute(builder: (BuildContext context) {
            return LogInPage();
          }));

//            return LogInPage();
        }

//        return Container(
//
//          child: Text("Root"),
//
//        );
      },
    );
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
