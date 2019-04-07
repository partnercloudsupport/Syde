import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ikode/Model/User.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:firebase_auth/firebase_auth.dart';
class DirectMessaging extends StatefulWidget {

  final FirebaseUser currentUser;
  DirectMessaging(this.currentUser);

  @override
  _DirectMessagingState createState() => _DirectMessagingState();
}

class _DirectMessagingState extends State<DirectMessaging> {
  
  FirebaseUser currentUser;
  
  @override initState(){
    super.initState();

    currentUser = widget.currentUser;
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("users").document(currentUser.uid).collection("connections").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Container(color: Colors.white,);

            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.documentChanges.length,
                  itemBuilder: (context, index) {
//                    return Text("Hey ${snapshot.data.documents[index]["name"]}");

                    return StreamBuilder(
                      stream: Firestore.instance.collection("users").document(snapshot.data.documents[index]["id"]).snapshots(),
                      builder: (context, snapshot) {

                        if (snapshot.connectionState == ConnectionState.waiting)
                          return PKCardSkeleton(
                            isCircularImage: true,
                            isBottomLinesActive: true,
                          );

                        return ListTile(
                          onTap: () {
//                        User user = User(
//                            id: snapshot.data.documents[index]["id"],
//                            emial: snapshot.data.documents[index]["email"],
//                            photo: snapshot.data.documents[index]["photoUrl"],
//                            name: snapshot.data.documents[index]["name"]);
//                        Navigator.push(context,
//                            MaterialPageRoute(builder: (BuildContext context) {
//                              return DirectMessaging();
//                            }));
                          },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            snapshot.data["photoUrl"] +
                                "?height=500"),
                      ),
                          title: Text("${snapshot.data["name"]}"),
                      subtitle:
                      Text("${snapshot.data["email"]}"),
                        );
                      }
                    );
                  });
            } else {
              return Center(
                child: Text("No user found!"),
              );
            }
          }),

    );
  }
}
