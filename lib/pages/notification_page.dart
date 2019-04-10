import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.blue,
          title: Text("Notofication"),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: FutureBuilder( //future builder is used to retrieve data from backend
            future:
            Firestore.instance.collection("announcement").orderBy(
                "index", descending: true).getDocuments(),
            builder: (context, snapshot) {
              //display a circle progress bar while connection state is waiting
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                );
              }

              //in a case of no data, display a text showing "not available"
              if (snapshot.data == null) {
                return Center(child: Text("Not Available"),);
              }

              //display a list of items when other conditions stated above are not met
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return makeNotificationItem(
                        snapshot.data.documents[index].data);
                  });
            }));
  }

  //make widget for each notification item
  Widget makeNotificationItem(Map data) {
    return InkWell(
      onTap: () {

      },
      child: Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    data["title"],
                    style: TextStyle(fontSize: 14.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600),
                  ),
                ),

                Text(
                  data["date"],
                  style: TextStyle(fontSize: 10.0,),
                ),
              ],
            ),

            Text(
              data["body"].toString().trim(),
              maxLines: 2,
              style: TextStyle(fontSize: 14.0),
            )
          ],
        ),
      ),
    );
  }
}
