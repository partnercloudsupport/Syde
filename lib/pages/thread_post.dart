import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThreadPost extends StatefulWidget {
  @override
  _ThreadPostState createState() => _ThreadPostState();
}

class _ThreadPostState extends State<ThreadPost> {
  FirebaseUser _user;

  TextEditingController textBodyController;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textBodyController = TextEditingController();
    getUser();
//    initFireStore();
  }

  @override
  void dispose() {
    textBodyController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void getUser() async {
    _user = await FirebaseAuth.instance.currentUser();
  }

  initFireStore() {
    Firestore.instance
        .settings(timestampsInSnapshotsEnabled: true, persistenceEnabled: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 3.0,
          title: Text("App Bar"),
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.blue,
                ),
                onPressed: () {
                  if (textBodyController.text.length < 5) {
                    final snackbar = SnackBar(
                      content: Text("Message body too short"),
                      duration: Duration(milliseconds: 500),
                    );

                    _scaffoldKey.currentState.showSnackBar(snackbar);

                    return;
//                Fluttertoast.showToast(
//                    msg: "Message body too short",
//                    toastLength: Toast.LENGTH_SHORT,
//                    gravity: ToastGravity.BOTTOM,
//                    timeInSecForIos: 1,
//                    backgroundColor: Colors.grey,
//                    textColor: Colors.white,
//                  fontSize: 12.0
//                );

                  }

                  makePost(body: textBodyController.text, images: []);
//
                  Navigator.pop(context);
                })
//            InkWell(
//              onTap: () {
//
//                makePost(body: textBodyController.text,images: []);
//
////                Navigator.pop(context);
//              },
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Container(
//                  width: 60.0,
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(10.0),
//                    color: Colors.blue,
//                  ),
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Center(child: Text("Post")),
//                  ),
//                ),
//              ),
//            )
          ],
        ),
        body: CustomScrollView(
          slivers: <Widget>[
//

            SliverList(
                delegate: SliverChildListDelegate([
//              Container(color: Colors.red, height: 150.0),
              TextField(
                controller: textBodyController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    hintText: "share your experience"),
              )
            ])),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 4.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.teal[100 * (index % 9)],
                    child: Text('grid item $index'),
                  );
                },
                childCount: 20,
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 50.0,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.lightBlue[100 * (index % 9)],
                    child: Text('list item $index'),
                  );
                },
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 100.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 100.0,
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                          image: AssetImage("assets/google.png"),
                          width: 70,
                          height: 50,
                        ),
                      )),
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }

  void makePost({String body, List images}) {
    images = ["image001", "image002"];
    Firestore.instance.collection("all_post").add({
      "post_id": "not available",
      "time_stamp": DateTime.now().millisecondsSinceEpoch.toString(),
      "user":{

        "user_id": _user.uid,
        "user_name": _user.displayName,
        "user_photo": _user.photoUrl,
      },
      "post_body": body,
      "like_count": 0,
      "comment_count": 0,
      "image_url": images
    }).then((docRef) {
      docRef.updateData({"post_id": docRef.documentID});

      Navigator.pop(context);
      print(docRef.documentID);
    });
  }
}
