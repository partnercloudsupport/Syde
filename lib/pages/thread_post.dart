import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThreadPost extends StatefulWidget {
  @override
  _ThreadPostState createState() => _ThreadPostState();
}

class _ThreadPostState extends State<ThreadPost> {
  FirebaseUser _user;

  TextEditingController _textBodyController;
  TextEditingController _textTitleController;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    //init objects
    _textBodyController = TextEditingController();
    _textTitleController = TextEditingController();
    getUser();
  }

  @override
  void dispose() {
    //dispose text controllers
    _textBodyController.dispose();
    _textTitleController.dispose();
    super.dispose();
  }

  void getUser() async {
    //get user
    _user = await FirebaseAuth.instance.currentUser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 3.0,
          title: Text("Create story"),
          backgroundColor: Colors.blue,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (_textBodyController.text.length < 5) {
                    final snackBar = SnackBar(
                      content: Text("Message body too short"),
                      duration: Duration(milliseconds: 500),
                    );

                    _scaffoldKey.currentState.showSnackBar(snackBar);

                    return;

                  }

                  makePost(
                      title: _textTitleController.text,
                      body: _textBodyController.text,
                      images: []);
//
                  Navigator.pop(context);
                })
          ],
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                child: TextField(
                  controller: _textTitleController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      hintText: "title"),
                ),
              ),
            ),

            Positioned(
                child: Padding(
              padding: const EdgeInsets.only(
                  top: 60.0, bottom: 50.0, left: 16.0, right: 16.0),
              child: ListView(
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  TextField(
                    controller: _textBodyController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration.collapsed(
                        hintText: "share your experience"),
                  ),
                ],
              ),
            )),
//            ),

            Positioned(
                left: 0.0, right: 0.0, bottom: 0.0, child: _buildTextComposer())
          ],
        ));
  }

  void makePost({String body, String title, List images}) {
    images = ["image001", "image002"];
    Firestore.instance.collection("all_post").add({
      "post_id": "not available",
      "time_stamp": DateTime.now().millisecondsSinceEpoch.toString(),
      "user": {
        "user_id": _user.uid,
        "user_name": _user.displayName,
        "user_photo": _user.photoUrl,
      },
      "post_title": title,
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

  Widget _buildTextComposer() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey))),
//            color: Colors.grey,
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Add to story",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
//                      flex: 1,
                ),
                IconButton(
                    icon: Icon(
                      Icons.photo,
                      color: Colors.grey,
                    ),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    ),
                    onPressed: () {}),
              ],
            ),
          ),
        )
      ],
    );
  }
}
