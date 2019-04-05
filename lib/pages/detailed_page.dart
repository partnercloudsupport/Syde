import 'package:flutter/material.dart';
import 'package:ikode/Model/Comment.dart';
import 'package:ikode/Model/Story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pk_skeleton/pk_skeleton.dart';

class DetailedScreen extends StatefulWidget {
  final Story story;

  const DetailedScreen({this.story});

  @override
  _DetailedScreenState createState() => _DetailedScreenState();
}

class _DetailedScreenState extends State<DetailedScreen> {
  String textBody =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Tellus elementum sagittis vitae et leo. Purus semper eget duis at tellus at urna condimentum mattis. Sed enim ut sem viverra aliquet eget. Ac turpis egestas sed tempus urna et pharetra pharetra. Non tellus orci ac auctor augue mauris augue. Volutpat odio facilisis mauris sit amet massa vitae. Aenean vel elit scelerisque mauris. Rutrum tellus pellentesque eu tincidunt tortor. Id volutpat lacus laoreet non curabitur gravida arcu ac tortor. Etiam non quam lacus suspendisse faucibus interdum. Fusce id velit ut tortor pretium viverra suspendisse potenti. Sed viverra ipsum nunc aliquet bibendum enim facilisis gravida. Laoreet sit amet cursus sit amet dictum. Aliquet nibh praesent tristique magna. Consequat ac felis donec et odio pellentesque diam volutpat commodo. Lacinia quis vel eros donec ac odio. Nulla malesuada pellentesque elit eget gravida cum sociis natoque penatibus. Lectus proin nibh nisl condimentum id. Habitant morbi tristique senectus et netus et. Eros in cursus turpis massa. Aliquet enim tortor at auctor urna nunc id cursus. Lectus arcu bibendum at varius vel pharetra vel turpis. Tellus integer feugiat scelerisque varius morbi enim nunc. Eget sit amet tellus cras adipiscing enim eu. Risus sed vulputate odio ut enim blandit. Viverra justo nec ultrices dui sapien eget mi proin. Natoque penatibus et magnis dis parturient montes. Aliquet lectus proin nibh nisl condimentum. Massa placerat duis ultricies lacus sed turpis tincidunt. Viverra nam libero justo laoreet sit. Iaculis eu non diam phasellus vestibulum lorem sed risus ultricies. Integer eget aliquet nibh praesent tristique. Ultricies leo integer malesuada nunc vel.";

  CollectionReference _commentRef;
  TextEditingController _controller = TextEditingController();
  FirebaseUser _user;


  @override
  void initState() {
    _commentRef = Firestore.instance
        .collection("comments")
        .document(widget.story.storyId)
        .collection("story_comments");

    getUser();
    super.initState();
  }

  getUser() async{

    _user = await FirebaseAuth.instance.currentUser();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blue,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(child: _buildBody()),
          Positioned(
              bottom: 0.0, right: 0.0, left: 0.0, child: _buildTextComposer()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
            child: Text(
              "My Journey as a Flutter Developer with DevC Uyo",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left:8.0,right: 8.0,bottom: 4.0,top: 8.0),
            child: Divider(height: 1.0,color: Colors.black,),
          ),
          Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0,right: 16.0),
              child: Row(
//
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                          widget.story.user["user_photo"] + "?height=500"),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),

//
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.story.user["user_name"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12.0),
                          ),
                          Text(
                            "Mobile Engineer",
                            style:
                                TextStyle(fontSize: 10.0, color: Colors.grey),
                          ),
                        ])
                  ])),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.story.storyBody,
                style:
                    TextStyle(fontSize: 14.0, color: Colors.grey, height: 2.0)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0,right: 16.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: _commentRef.orderBy("time_stamp", descending: true).snapshots(),
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){

                if(snapshot.connectionState == ConnectionState.waiting)
//                  return PKCardListSkeleton(
//                    isCircularImage: true,
//                    isBottomLinesActive: true,
//                    length: 10,
//                  );

                  return Center(
                  child: Container(
                    width: 50.0,
                    height: 50.0,


                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),


                  ),
                );

                if(snapshot.data == null){
                  print("snapshot is null");
                  return Container(

                    child: Center(child: Text("No comments yet!")),
                  );

                }

                if(snapshot.data.documents.length <1){

                  return Container(
                    child: Center(child: Text("No comments yet!")),
                  );
                }

                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                      return _buildCommentItem(snapshot,index);
                    });



              },

            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextField(
                      controller: _controller,
                      maxLines: 1,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.send,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                      onSubmitted: (text) {},
                      decoration: InputDecoration.collapsed(
                          hintText: "Write a comment"),
                    ),
                  ),
//                      flex: 1,
                ),
                FlatButton(
                    onPressed: () {

                      print(_controller.text.length);
                      if(_controller.text.trim().length<1)return;


                      Map<String, dynamic> data = Comment(
                              commentBody: _controller.value.text,
                              commentId: "na",
                              userId: _user.uid,
                              timeStamp: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString())
                          .toMap();

                      _controller.clear();
                      _commentRef.add(data).then((docRef) {


                        _commentRef
                            .document(docRef.documentID)
                            .updateData({"comment_id": docRef.documentID});

                        incrementComment(widget.story.storyId);



                      });
                    },
                    child: Icon(Icons.send,color: Colors.blue,))
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCommentItem(AsyncSnapshot<QuerySnapshot> snapshot, int index) {

    Comment comment = Comment.fromMap(snapshot.data.documents[index].data);

    return StreamBuilder(
      stream: Firestore.instance.collection("users").document(comment.userId).snapshots(),
        builder: (context,userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting)
            return Container(
              child: Center(child: PKCardSkeleton(
                isCircularImage: true,
                isBottomLinesActive: true,
              ),),);

          print("shot ${userSnapshot.data["name"]}");

          if (userSnapshot.data == null) return Container(color: Colors.white,);
          else  return makeItem(comment, userSnapshot);

        });
  }
    Widget makeItem(Comment comment, AsyncSnapshot userSnapshot){
      DateTime date =  DateTime.fromMillisecondsSinceEpoch(int.parse(comment.timeStamp));
      var format =  DateFormat("yMMMMd");
      var dateString = format.format(date);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
//      mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 20.0,
            backgroundImage:
            NetworkImage(userSnapshot.data["photoUrl"] + "?height=500"),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top:10.0,left: 10.0),
              child: Column(
                children: <Widget>[
//                SizedBox(height: 40.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        userSnapshot.data["name"],
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w500),
                      ),
                      Text(dateString                          ,
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                              fontSize: 12.0))
                    ],
                  ),
                  SizedBox(height:10.0),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(

                      comment.commentBody,
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 12.0)),
                  ),


                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  incrementComment(String docRef) async {
    //use transaction on the fire store instance to prevent race condition
    Firestore.instance.runTransaction((transaction) async {
      //get a document snapshot at the current position
      DocumentSnapshot snapshot =
      await transaction.get(Firestore.instance.collection("all_post").document(docRef));

      //increment comment count for the story
      await transaction.update(snapshot.reference,
          {"comment_count": snapshot.data["comment_count"] + 1});

    });
  }
}
