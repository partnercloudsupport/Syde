import 'package:flutter/material.dart';
import 'package:ikode/Auth/auth_bloc.dart';
import 'package:ikode/syde_color.dart';

class LogInPage extends StatefulWidget {


  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  AssetImage _image;
  @override
  void initState() {


//    precacheImage( AssetImage('assets/photo.png'), context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {

      print(constraints.maxHeight);
      return Stack(

        children: <Widget>[

          Container(
            decoration: BoxDecoration(
              image: DecorationImage(

                image:
                AssetImage('assets/photo.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),

//        FadeInImage(placeholder:  AssetImage('assets/photo.png'), image:  AssetImage('assets/photo.png')),


          Positioned(
            left: 10.0,
            right: 10.0,
            top: constraints.maxHeight-398,
            child: Column(
              children: <Widget>[
                Text(
                  "Welcome to SYDE",
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                      fontSize: 30.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                ),
                Text(

                  "Share your stories with thousands of developers",
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                      fontSize: 15.0),textAlign: TextAlign.center,
                ),
                Text(

                  "Connect with thousands of developers",
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                      fontSize: 15.0),textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          Positioned(
            left: 40.0,
            right: 40.0,
            top: constraints.maxHeight-228,
            child: Container(
              height: 50.0,
              width: double.infinity,
              child: Center(
                child: Text(
                  "Sign in with",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                      width: 3.0,
                      color: Color(getColorHexFromStr("90CAF9")))),
            ),
          ),


          Positioned(
              left: 40.0,
              right: 40.0,
              top: constraints.maxHeight-154,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap:(){
                    authBloc.eventSink.add(FaceBookSignIn());

                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(2.0),
                          color: Colors.blue,
                          child: Image(image:AssetImage("assets/facebook.png"),width: 24.0,height: 24.0,)),
                      SizedBox(width: 10.0,),
                      Text("Facebook",style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              )
              ,
              Text("or",style: TextStyle(color: Colors.white),),

              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (){
                    print("Hello");
                  authBloc.eventSink.add(GoogleSignIn());
                  },
                  child: Row(
                    children: <Widget>[
                      Image(image: AssetImage("assets/google.png"), width: 24.0, height: 24.0),
                      SizedBox(width: 10.0,),

                      Text("Google",style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              )








            ],
          ))
        ],
      );
    }));
  }

}
