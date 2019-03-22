import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(
        child: Center(child: Text("Notifications not available!")),
      ),

    );

  }
}
