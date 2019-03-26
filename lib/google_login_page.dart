import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikode/Auth/auth.dart';
import 'package:ikode/Auth/auth_bloc.dart';

class LogInPage extends StatefulWidget {

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          renderFirstChild(),
          SizedBox(
            width: double.infinity,
            height: 50.0,
          ),
          renderSecondChild(),
          SizedBox(
            width: double.infinity,
            height: 50.0,
          ),
          renderThirdChild()
        ],
      ),
    );
  }



  Widget renderFirstChild() {
    return Container(
      width: double.infinity,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlutterLogo(),
          Text(
            "Welcome To",
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            "Syde",
            style: TextStyle(
                fontSize: 16.0,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
    );
  }

  Widget renderSecondChild() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Share your expereinces with thousands of developers",
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.grey, width: 2.0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.grey, width: 2.0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.grey, width: 2.0)),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget renderThirdChild() {
    var assetsImage = new AssetImage('assets/google.png');
    var image = new Image(image: assetsImage, width: 32.0, height: 32.0);
    return InkWell(
      onTap: () {
        authBloc.eventSink.add(LogInClick());
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 5.0,
          child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 20.0,
                  ),
                  image,
                  SizedBox(
                    width: 50.0,
                  ),
                  Text(
                    "Sign in with google",
                  )
                ],
              ),
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0))),
        ),
      ),
    );
  }
}
