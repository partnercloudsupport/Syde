import 'package:flutter/material.dart';
import 'package:ikode/pages/detailed_page.dart';
import 'package:ikode/pages/thread_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThreadPage extends StatefulWidget {
  @override
  _ThreadPageState createState() => _ThreadPageState();

  const ThreadPage({Key key, this.user}) : super(key: key);
  final FirebaseUser user;
}

class _ThreadPageState extends State<ThreadPage> {
  bool isLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('all_post')
            .orderBy("time_stamp", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> document) {
          if (document.hasError)
            return Center(child: Text('Error: ${document.error}'));
          switch (document.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));
            default:
              return ListView.builder(
                itemCount: document.data.documents.length,
                itemBuilder: (context, index) {
//                  print(document.data.documents[index].data["user"]["user_photo"] + "?height=500");
                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 15.0,
                                backgroundImage: NetworkImage(
                                  document.data.documents[index].data["user"]
                                          ["user_photo"] +
                                      "?height=500",
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    document.data.documents[index].data["user"]
                                        ["user_name"],
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0),
                                  ),
                                  Text(
                                    new DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(
                                                document.data.documents[index]
                                                    ["time_stamp"]))
                                        .toLocal()
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 10.0, color: Colors.black54),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          InkWell(
                            onTap: () {
                              //
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return DetailedScreen(
                                  user: widget.user,
                                );
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                document.data.documents[index]["post_body"],
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
                              InkWell(
                                  onTap: () {
                                    Firestore.instance
                                        .collection("all_post")
                                        .document(document.data.documents[index]
                                            ["post_id"])
                                        .collection("likes")
                                        .document(widget.user.uid)
                                        .get()
                                        .then((dataSnapShot) {
                                      var s = dataSnapShot.data ?? ["like"];
//
                                      if (s is Map) {
                                        print("data is a map $s");
                                        if (s["like"] == true) {
                                          unLikePost(index, document);
                                        } else {
                                          likePost(index, document);
                                        }
                                      } else {
                                        likePost(index, document);
                                        print("data is a not map $s");
                                      }
//                                      print("valUE = ${dataSnapShot.data["like"]}");

//                                      if(s["like"] == null){
//                                        likePost(index, document);
//                                        return;
//                                      }
//
//
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Row(
                                      children: <Widget>[
                                        StreamBuilder(
                                            stream: Firestore.instance
                                                .collection("all_post")
                                                .document(document
                                                        .data.documents[index]
                                                    ["post_id"])
                                                .collection("likes")
                                                .document(widget.user.uid)
                                                .snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot snapshot) {
                                              if (!snapshot.hasData) {
                                                return Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.grey,
                                                  size: 18.0,
                                                );
                                              }

                                              DocumentSnapshot s =
                                                  snapshot.data ?? ["like"];
//
                                              print("val = ${s.data}");

                                              if (s.data == null) {
                                                return Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.grey,
                                                  size: 18.0,
                                                );
                                              }

//
                                              if (snapshot.data["like"] ==
                                                  true) {
                                                return Icon(
                                                  Icons.favorite,
                                                  color: Colors.blue,
                                                  size: 18.0,
                                                );
                                              } else
                                                return Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.grey,
                                                  size: 18.0,
                                                );

//                                              print(
//                                                  "like STREAM = ${snapshot.data["like"]}");
//                                              return Text("hello");
                                            }),
                                        Text(
                                          "${document.data.documents[index]["like_count"]}",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 10.0),
                                        ),
                                      ],
                                    ),
                                  )),
                              InkWell(
                                  onTap: () {
                                    print("tapped!");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.chat_bubble_outline,
                                            color: Colors.grey, size: 18.0),
                                        Text(
                                          "10k",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10.0),
                                        ),
                                      ],
                                    ),
                                  )),
//                              InkWell(
//                                  onTap: () {
//                                    print("tapped!");
//                                  },
//                                  child: Padding(
//                                    padding: const EdgeInsets.only(right: 20.0),
//                                    child: Row(
//                                      children: <Widget>[
//                                        Icon(Icons.favorite_border,
//                                            color: Colors.grey, size: 18.0),
//                                        Text(
//                                          "50k",
//                                          style: TextStyle(
//                                              color: Colors.grey,
//                                              fontSize: 10.0),
//                                        )
//                                      ],
//                                    ),
//                                  )),
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
                },
//                reverse: false,
//                children:
//                    snapshot.data.documents.map((DocumentSnapshot document) {
//
//                }).toList(),
              );
          }
        },
      ),

//        floatingActionButton: fab()
    );
  }

  likePost(int index, AsyncSnapshot<QuerySnapshot> document) async {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot =
          await transaction.get(document.data.documents[index].reference);

      await transaction.set(
          snapshot.reference.collection("likes").document(widget.user.uid),
          {"like": true});

      await transaction.update(snapshot.reference,
          {"like_count": document.data.documents[index]["like_count"] + 1});
    });
  }

  unLikePost(int index, AsyncSnapshot<QuerySnapshot> document) async {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot =
          await transaction.get(document.data.documents[index].reference);

      if (document.data.documents[index]["like_count"] > 0) {
        await transaction.set(
            snapshot.reference.collection("likes").document(widget.user.uid),
            {"like": false});

        await transaction.update(snapshot.reference,
            {"like_count": document.data.documents[index]["like_count"] - 1});
      }
    });
  }
}

class Fab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "home",
      onPressed: () {
        print("post here");
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ThreadPost();
        }));
      },
      child: Icon(Icons.add_box),
    );
  }
}
