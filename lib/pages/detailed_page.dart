import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ikode/Model/Story.dart';

class DetailedScreen extends StatefulWidget {
  final Story story;

  const DetailedScreen({this.story});

  @override
  _DetailedScreenState createState() => _DetailedScreenState();
}

class _DetailedScreenState extends State<DetailedScreen> {
  String textBody =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Tellus elementum sagittis vitae et leo. Purus semper eget duis at tellus at urna condimentum mattis. Sed enim ut sem viverra aliquet eget. Ac turpis egestas sed tempus urna et pharetra pharetra. Non tellus orci ac auctor augue mauris augue. Volutpat odio facilisis mauris sit amet massa vitae. Aenean vel elit scelerisque mauris. Rutrum tellus pellentesque eu tincidunt tortor. Id volutpat lacus laoreet non curabitur gravida arcu ac tortor. Etiam non quam lacus suspendisse faucibus interdum. Fusce id velit ut tortor pretium viverra suspendisse potenti. Sed viverra ipsum nunc aliquet bibendum enim facilisis gravida. Laoreet sit amet cursus sit amet dictum. Aliquet nibh praesent tristique magna. Consequat ac felis donec et odio pellentesque diam volutpat commodo. Lacinia quis vel eros donec ac odio. Nulla malesuada pellentesque elit eget gravida cum sociis natoque penatibus. Lectus proin nibh nisl condimentum id. Habitant morbi tristique senectus et netus et. Eros in cursus turpis massa. Aliquet enim tortor at auctor urna nunc id cursus. Lectus arcu bibendum at varius vel pharetra vel turpis. Tellus integer feugiat scelerisque varius morbi enim nunc. Eget sit amet tellus cras adipiscing enim eu. Risus sed vulputate odio ut enim blandit. Viverra justo nec ultrices dui sapien eget mi proin. Natoque penatibus et magnis dis parturient montes. Aliquet lectus proin nibh nisl condimentum. Massa placerat duis ultricies lacus sed turpis tincidunt. Viverra nam libero justo laoreet sit. Iaculis eu non diam phasellus vestibulum lorem sed risus ultricies. Integer eget aliquet nibh praesent tristique. Ultricies leo integer malesuada nunc vel.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(45),
        leading: IconButton(
            icon: Icon(
              Icons.navigate_before,
              color: Colors.grey,
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
              padding:
                  const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 18.0),
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
            child: Text(textBody,
                style:
                    TextStyle(fontSize: 14.0, color: Colors.grey, height: 2.0)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
                itemCount: 5,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _buildCommentItem();
                }),
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
                    padding: const EdgeInsets.only(left:8.0,right: 8.0),
                    child: TextField(
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.send,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      onSubmitted: (text) {},
                      decoration: InputDecoration.collapsed(hintText: "Write a comment"),
                    ),
                  ),
//                      flex: 1,
                ),

           FlatButton(onPressed: (){}, child: Text("Send"))
              ],
            ),
          ),
        )
      ],
    );
  }


  Widget _buildCommentItem(){

    return Padding(
      padding: const EdgeInsets.only(left:8.0,right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(
                widget.story.user["user_photo"] + "?height=500"),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right: 8.0,bottom: 8.0),
                      child: Text("James Esther",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text("March 30,2019",style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300,fontSize: 12.0))
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: Text("Yea! me too! I love layering my codebase with MVP design pattern",
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal,fontSize: 12.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                  child: Divider(
                    height: 2.0,color: Colors.grey,
                  ),
                )

              ],
            ),

          )

        ],
      ),
    );
  }
}
