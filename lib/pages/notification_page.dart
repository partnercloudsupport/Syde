import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection("announcement").snapshots(),
            builder: (context, snapshot) {
              print(snapshot.data.documents[0]["title"]);

              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return makeNotificationItem(
                        snapshot.data.documents[index].data);
                  });
            }));
  }

  Widget makeNotificationItem(Map data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            data["title"],
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            data["body"],
            style: TextStyle(fontSize: 14.0),
          )
        ],
      ),
    );
  }
}
