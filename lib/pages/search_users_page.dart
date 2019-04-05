
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

        leading: Icon(Icons.arrow_back,color: Colors.white,),
        title: Text("New Messages",style: TextStyle(color: Colors.white),),
      ),

      body: StreamBuilder(
          stream: Firestore.instance.collection("users").snapshots(),
          builder: (context,snapshot){

            print(snapshot.data["name"]);
            if(snapshot.connectionState == ConnectionState.waiting) return PKCardListSkeleton(
                    isCircularImage: true,
                    isBottomLinesActive: true,
                    length: 10,
                  );



            return ListView.builder(itemBuilder: (context,index){

              return Text("Hey $index");
            });
      }),

    );
  }
}
