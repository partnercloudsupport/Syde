import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:ikode/syde_color.dart';
import 'package:ikode/Bloc/chat_room_page_bloc.dart';
import 'package:toast/toast.dart';

class ChatRoom extends StatefulWidget {
  final FirebaseUser user;

  ChatRoom(this.user);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text("Syde Chat"),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        //modified
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          //

          Flexible(
            //

            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('chatroom')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading...');
                  default:
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        reverse: true,
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          //display view for current user
                          if (widget.user.uid == document['sender_id']) {
                            return ChatMessageUser(document['message']);
                          } else {
                            //display view for other users
                            return ChatMessage(
                              text: document['message'],
                              sender: document['sender'],
                              photoUrl: document['photoUrl'],
                              id: document['sender_id'],
                            );
                          }
                        }).toList(),
                      ),
                    );
                }
              },
            ),

          ), //
          Divider(height: 1.0), //
          Container(
            //
            decoration: BoxDecoration(color: Theme
                .of(context)
                .cardColor), //
            child: _buildTextComposer(), //modified
          ), //
        ], //
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      //
      data: IconThemeData(color: Theme
          .of(context)
          .accentColor), //
      child: Container(
        child: Row(
          children: <Widget>[

            Container(
              child: IconButton(
                  icon: Icon(
                    Icons.photo,
                    color: Colors.grey,
                  ),
                  onPressed: () {}),
            ),
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: (text) {
                  _handleSubmitted(text, 0);
                },
                decoration:
                InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(
                    Icons.send,
                  ),
                  onPressed: () => _handleSubmitted(_textController.text, 0)),
            ),
          ],
        ),
      ), //
    );
  }

  void _handleSubmitted(String text, int type) async {
    if (text
        .trim()
        .length < 1) return;

    _textController.clear();

    var map = {
      "photoUrl": widget.user.photoUrl,
      "message": text,
      "sender": widget.user.displayName,
      "type": type,
      "sender_id": widget.user.uid,
      "timestamp": DateTime
          .now()
          .millisecondsSinceEpoch
          .toString()
    };

    DocumentReference documentReference = Firestore.instance
        .collection("chatroom")
        .document(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(documentReference, map);
    });
  }
}

class ChatMessage extends StatefulWidget {
  ChatMessage({this.sender, this.text, this.photoUrl, this.id});

  final String text, sender, photoUrl, id;

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  Color col = Color(getColorHexFromStr("F1EEEE"));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          col = Colors.grey;
        });

        _showBottomSheet(context, widget.text);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
//      margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage("${widget.photoUrl}?height=500"),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.sender,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold)),
                      Container(
                        margin: EdgeInsets.only(right: 80.0),
                        padding: const EdgeInsets.all(5.0),
                        child: Text(widget.text),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: col

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showBottomSheet(context, text) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: _requestPop,
            child: Wrap(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    //close bottom sheet
                    Navigator.pop(context);

                    //copy text to clipboard
                    Clipboard.setData(ClipboardData(text: text))
                        .whenComplete(() {
                      //when complete,display a toast
                      Toast.show(
                        "Copied", context, backgroundColor: Colors.grey,
                        duration: 1,);
                    }
                    );

                    //revert container to default color and rebuild the widget
                    setState(() {
                      col = col = Color(getColorHexFromStr("F1EEEE"));
                    });
                  },
                  title: Icon(Icons.content_copy),
                  subtitle: Center(child: Text("Copy")),
                ),

              ],
            ),
          );
        }

    );
  }

  Future<bool> _requestPop() {
    //revert container to default color and rebuild the widget
    setState(() {
      col = col = Color(getColorHexFromStr("F1EEEE"));
    });
    return new Future.value(true);
  }


}

class ChatMessageUser extends StatefulWidget {
  final String body;

  const ChatMessageUser(this.body);

  @override
  _ChatMessageUserState createState() => _ChatMessageUserState();
}

class _ChatMessageUserState extends State<ChatMessageUser> {


  Color col = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(left: 80.0, bottom: 10.0),
        child: GestureDetector(
            onLongPress: () {
              setState(() {
                col = Colors.blue[700];
              });
              _showBottomSheet(context, widget.body);
            },

            onTap: () => roomBloc.containerColor.add(Colors.grey),

            child: Container(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                widget.body,
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), color: col),
            )
        ),
      ),
    );
  }

  void _showBottomSheet(context, text) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: _requestPop,
            child: Wrap(
              children: <Widget>[
                ListTile(
                  onTap: () {
//
                    //close bottom sheet
                    Navigator.pop(context);

                    //Copy text to clipboard
                    Clipboard.setData(ClipboardData(text: text))
                        .whenComplete(() {
                      //when complete,display a toast
                      Toast.show(
                        "Copied", context, backgroundColor: Colors.grey,
                        duration: 1,);
                    });

                    //revert container to default color and rebuild the widget
                    setState(() {
                      col = Colors.blue;
                    });
//
                  },
                  title: Icon(Icons.content_copy),
                  subtitle: Center(child: Text("Copy")),
                ),

              ],
            ),
          );
        }

    );
  }

  Future<bool> _requestPop() {
    //revert container to default color and rebuild the widget
    setState(() {
      col = Colors.blue;
    });
    return new Future.value(true);
  }
}


