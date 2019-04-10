import 'package:flutter/material.dart';
import 'package:ikode/Model/Comment.dart';
import 'package:ikode/Model/Story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pk_skeleton/pk_skeleton.dart';

class NotificationDetailedScreen extends StatefulWidget {
  final Map notification;

  const NotificationDetailedScreen(this.notification);

  @override
  _NotificationDetailedScreenState createState() =>
      _NotificationDetailedScreenState();
}

class _NotificationDetailedScreenState
    extends State<NotificationDetailedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.notification["title"]),
          elevation: 0.0,
          backgroundColor: Colors.blue,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          Text(
            widget.notification["title"],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          Divider(
            height: 1.0,
            color: Colors.grey,
          ),
          Text(widget.notification["body"],
              style:
                  TextStyle(fontSize: 14.0, color: Colors.black, height: 2.0)),
        ],
      ),
    );
  }
}
