import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ikode/Model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';

//
//class DirectMessaging extends StatelessWidget {
//  final User user;
//
//  DirectMessaging(this.user);
//
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      debugShowCheckedModeBanner: false,
//      home: new ChatScreen(user),
//    );
//  }
//}

class DirectMessaging extends StatefulWidget {
  final User peerUser;

  DirectMessaging(this.peerUser);

  @override
  _DirectMessagingState createState() => _DirectMessagingState();
}

class _DirectMessagingState extends State<DirectMessaging> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  Firestore firestore = Firestore.instance;

  FirebaseUser currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> initDM() async {
    currentUser = await FirebaseAuth.instance.currentUser();

    //add to connections

    await Firestore.instance
        .collection("users")
        .document(currentUser.uid)
        .collection("collections")
        .add({"id": widget.peerUser.id});



  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
            centerTitle: true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.peerUser.name,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0),
                ),
                Text(widget.peerUser.emial,
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 12.0))
              ],
            )),
        body: new Column(
          //modified
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            //new

            Flexible(
              //new

              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('chatroom')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('Loading...');
                    default:
                      return ListView(
                        reverse: true,
                        controller: _scrollController,
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return ChatMessage(
                            text: document['message'],
                            sender: document['sender'],
                            photoUrl: document['photoUrl'],
                          );
//                          new ListTile(
//                          title: new Text(document['message']),
//                          subtitle: new Text(document['sender']),
//                        );
                        }).toList(),
                      );
                  }
                },
              ),
//            child: StreamBuilder(
//              stream: Firestore.instance.collection("chatroom").snapshots(),
//              builder: (BuildContext context,
//                  AsyncSnapshot<QuerySnapshot> snapshot) {
//                snapshot.data.documents.map((e){
//
//                  print(e["message"]);
//                });
//
//                return ListView.builder(
//                  //new
//                  padding: new EdgeInsets.all(8.0), //new
//                  reverse: false, //new
//                  itemBuilder: (_, int index) {
//                    print(snapshot.data.documents[index].data);
////                    return _messages[index];
//                  }, //new
//                  itemCount: _messages.length, //new
//                );
//              },
//            ), //new
            ), //new
            Divider(height: 1.0), //new
            Container(
              //new
              decoration:
                  BoxDecoration(color: Theme.of(context).cardColor), //new
              child: _buildTextComposer(), //modified
            ), //new
          ], //new
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      //new
      data: new IconThemeData(color: Theme.of(context).accentColor), //new
      child: new Container(
        //modified
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            Container(
              child: new IconButton(
                  icon: new Icon(
                    Icons.photo,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    //handle photo
                  }),
            ),
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: (text) {
                  _handleSubmitted(text, 0);
                },
                decoration:
                    new InputDecoration.collapsed(hintText: "type here..."),
              ),
            ),
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () {
                    //send
                  }),
            ),
          ],
        ),
      ), //new
    );
  }

  void _handleSubmitted(String text, int type) async {
    _textController.clear();

    var map = {
      "photoUrl": widget.peerUser.photo,
      "message": text,
      "sender": widget.peerUser.name,
      "idFrom": currentUser.uid,
      "idTo": widget.peerUser.id,
      "type": type,
      "timestamp": DateTime.now().millisecondsSinceEpoch.toString()
    };

    DocumentReference documentReference = Firestore.instance
        .collection("chatroom")
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(documentReference, map);
    });

//    await Firestore.instance
//        .collection("chatroom")
//        .add(map);

    _scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);

//    ChatMessage message = new ChatMessage(
//      widget.user,
//      //new
//      text: text, //new
//    ); //new
//    setState(() {
//      //new
//      _messages.insert(0, message); //new
//    });
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.sender, this.text, this.photoUrl});

  final String text, sender, photoUrl;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 1.0,
                shape: CircleBorder(),
                color: Colors.transparent,
                child: CircleAvatar(
                  backgroundImage: NetworkImage("$photoUrl?height=500"),
                  child: InkWell(
                    onTap: () {
                      //goto user profile
                    },
                  ),
                ),
              ),
            ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(sender, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
