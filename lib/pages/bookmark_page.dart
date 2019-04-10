import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikode/Model/Story.dart';
import 'package:ikode/pages/detailed_page.dart';
import 'package:intl/intl.dart';
import 'package:pk_skeleton/pk_skeleton.dart';

class SavedStoryScreen extends StatefulWidget {

  final String uid;

  SavedStoryScreen(this.uid);

  @override
  _SavedStoryScreenState createState() => _SavedStoryScreenState();
}

class _SavedStoryScreenState extends State<SavedStoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blue,
        title: Text("Saved stories"),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,

            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: getId(),
    );
  }

  Widget makeNotificationItem(List<DocumentSnapshot> documents) {
    return
      // return each item at current position

      ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            print(documents[index]["story_id"]);

            return FutureBuilder(

                future: Firestore.instance.collection("all_post").document(
                    documents[index]["story_id"]).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                      color: Colors.white,
                    );

                  DateTime date = DateTime.fromMillisecondsSinceEpoch(
                      int.parse(snapshot.data["time_stamp"]));
                  var format = DateFormat("yMMMMd");
                  var dateString = format.format(date);

                  print(snapshot.data.data);

                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 15.0,
                                    backgroundImage: NetworkImage(
                                      snapshot
                                          .data["user"]
                                      ["user_photo"] +
                                          "?height=500",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                    child: Container(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Text(
                                            snapshot
                                                .data["user"]
                                            ["user_name"],
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0),
                                          ),
                                          Text(
                                            dateString,
                                            style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              InkWell(
                                onTap: () {
                                  //

                                   Story storyDetails =
                                   Story.fromMap(
                                       snapshot.data.data);
                                   Navigator.push(context,
                                       MaterialPageRoute(
                                           builder: (BuildContext context) {
                                             return DetailedScreen(
                                               story: storyDetails,
                                             );
                                           }));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    snapshot.data["post_body"],
//                                  textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'Rubik',
                                        fontSize: 14.0,
                                        fontStyle: FontStyle.normal
//                                  fontWeight: FontWeight.bold
                                    ),
                                    maxLines: 5,
//                                  softWrap: true,
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.chat_bubble_outline,
                                      color: Colors.grey,
                                      size: 18.0),
                                  Text(
                                    snapshot.data == null
                                        ? "0"
                                        : snapshot
                                        .data.data["comment_count"]
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10.0),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Divider(
                                height: 1.0,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        )),
                  );
                });
          });
  }


//        );


  Widget getId() {
    return FutureBuilder(
        future: Firestore.instance
            .collection("saved_story")
            .document(widget.uid)
            .collection("bookmark")
            .orderBy("time_stamp", descending: true)
            .getDocuments(),
        builder: (context, snapShot) {
          print("future builder");

          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black)),
            );
          }
          QuerySnapshot shot = snapShot.data;

          if (snapShot.hasData) {
            if ((shot.documents.length) < 1) {
              return Center(child: Text("No Story found"));
            }


              print(shot.documents[0]["story_id"]);
              return makeNotificationItem(shot.documents);
            } else {
              return Center(child: Text("No Story found"),);
            }
          }

    );
  }


}