import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pk_skeleton/pk_skeleton.dart';

class SearchUsers extends StatefulWidget {
  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        title: Text(
          "New Messages",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return PKCardListSkeleton(
                isCircularImage: true,
                isBottomLinesActive: true,
                length: 10,
              );

            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.documentChanges.length,
                  itemBuilder: (context, index) {
//                    return Text("Hey ${snapshot.data.documents[index]["name"]}");

                    return ListTile(
                      onTap: () {},
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            snapshot.data.documents[index]["photoUrl"] +
                                "?height=500"),
                      ),
                      title: Text("${snapshot.data.documents[index]["name"]}"),
                      subtitle:
                          Text("${snapshot.data.documents[index]["email"]}"),
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

  Widget makeUserItem() {}
}
