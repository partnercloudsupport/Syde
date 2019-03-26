import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailedScreen extends StatefulWidget {
  @override
  _DetailedScreenState createState() => _DetailedScreenState();

  DetailedScreen({this.user});

  final FirebaseUser user;
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
        body: Column(
          children: <Widget>[
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
//
//

                  SliverList(
                      delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 8.0, right: 16.0),
                      child: Text(
                        "My Journey as a Flutter Developer with DevC Uyo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 16.0, bottom: 18.0),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 20.0,
                            backgroundImage: NetworkImage(
                                widget.user.photoUrl + "?height=500"),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.user.displayName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                              Text(
                                "new user",
                                style: TextStyle(
                                    fontSize: 10.0, color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(textBody,
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey, height: 2.0)),
                    ),

//                    Expanded(
//                      child: ListView.builder(
//                          itemCount: 10,
//                          itemBuilder: (context, pos) {
//                        return Text("Comment $pos");
//                      }),
//                    )

//              Container(color: Colors.red, height: 150.0),
//                    TextField(
//                      maxLines: null,
//                      keyboardType: TextInputType.multiline,
//                      decoration: InputDecoration(
//                          focusedBorder: UnderlineInputBorder(
//                              borderSide: BorderSide(color: Colors.grey)),
//                          hintText: "share your experience"),
//                    )
                  ])),
                  SliverGrid(

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 4.0,
                        crossAxisCount: 3,
                      crossAxisSpacing: 10.0


                    ),
//                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//                      maxCrossAxisExtent: 200.0,
//                      mainAxisSpacing: 10.0,
//                      crossAxisSpacing: 10.0,
//                      childAspectRatio: 4.0,
//                    ),
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


//                  SliverList(
//
//                      delegate: SliverChildBuilderDelegate((context,pos){
//
////                        return ListView.builder(
////                  itemCount: 10,i
////                  itemBuilder: (context,index){
//                return Text("Comment $pos");
//
////              });
//
//                  })),
//
//                  SliverFixedExtentList(
//                    itemExtent: 50.0,
//                    delegate: SliverChildBuilderDelegate(
//
//                      (BuildContext context, int index) {
//                        return Container(
//                          alignment: Alignment.center,
//                          color: Colors.lightBlue[100 * (index % 9)],
//                          child: Text('list item $index'),
//                        );
//                      },
//                    ),
//                  ),

//                  SliverToBoxAdapter(
//                    child: Container(
//                      height: 100.0,
//                      child: ListView.builder(
//                        scrollDirection: Axis.vertical,
//                        itemCount: 10,
//                        itemBuilder: (context, index) {
//                          return Container(
//                            width: 100.0,
//                            child: Card(
//                                child: Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Image(
//                                image: AssetImage("assets/google.png"),
//                                width: 70,
//                                height: 50,
//                              ),
//                            )),
//                          );
//                        },
//                      ),
//                    ),
//                  )
                ],
              ),
            ),

//            Expanded(
//              child: ListView(
//                children: <Widget>[
//
//
////              ListView.builder(
////                  itemCount: 10,
////                  itemBuilder: (context,index){
////                return Text("Comment $index");
////
////              })
//                ],
//              ),
//            ),

            Container(
                color: Colors.white,
                height: 50.0,
                alignment: Alignment.bottomCenter,
//              decoration: BoxDecoration(color: Theme.of(context).cardColor), //new

                child: _buildTextComposer()),
//
          ],
        )

//      Container(
//        child: Stack(
//          children: <Widget>[
//
//
//            Container(
//              child: ListView(
//                children: <Widget>[
//
//
//                  Padding(
//                    padding: const EdgeInsets.only(left: 16.0,top: 8.0,right: 16.0),
//                    child: Text("My Journey as a Flutter Developer with DevC Uyo",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),),
//                  ),
//
//                  Padding(
//                    padding: const EdgeInsets.only(left: 16.0,top: 16.0,bottom: 18.0),
//                    child: Row(
//
//                      children: <Widget>[
//                        CircleAvatar(
//                          radius: 20.0,
//                          backgroundImage:
//                          NetworkImage(widget.user.photoUrl + "?height=500"),
//                        ) ,
//                        SizedBox(width: 10.0,),
//
//
//                        Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Text(widget.user.displayName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0),),
//                            Text("new user",style: TextStyle(fontSize: 10.0,color: Colors.grey),),
//
//
//                          ],
//
//                        )
//
//
//                      ],
//
//                    ),
//                  ),
//
//                  Padding(
//                    padding: const EdgeInsets.all(16.0),
//                    child: Text(textBody,style: TextStyle(fontSize: 14.0, color: Colors.grey,height: 2.0)),
//                  ),
//
////              ListView.builder(
////                  itemCount: 10,
////                  itemBuilder: (context,index){
////                return Text("Comment $index");
////
////              })
//
//                ],
//
//              ),
//            ),
//
//               Container(
//color: Colors.white,
//                height: 50.0,
//                alignment: Alignment.bottomCenter,
////              decoration: BoxDecoration(color: Theme.of(context).cardColor), //new
//
//                  child: _buildTextComposer()
//
//              ),
//
//
//
//          ],
//        ),
//      ),
        );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      //new
      data: new IconThemeData(color: Colors.grey), //new
      child: new Container(
        //modified
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                onSubmitted: (text) {},
                decoration: InputDecoration.collapsed(hintText: "comment"),
              ),
            ),
            Icon(Icons.comment),
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: Transform.rotate(
                angle: -10,
                child: IconButton(
                  onPressed: () {},
                  icon: new Icon(Icons.reply),
                ),
              ),
            )
          ],
        ),
      ), //new
    );
  }
}
