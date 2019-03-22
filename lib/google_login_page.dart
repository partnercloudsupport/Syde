import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogInPage extends StatefulWidget {
//  final VoidCallback loginCallBack;
//  final BaseAuth baseAuth;

  const LogInPage();

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  FirebaseUser user;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          renderFirstChild(),
          SizedBox(
            width: double.infinity,
            height: 50.0,
          ),
          renderSecondChild(),
          SizedBox(
            width: double.infinity,
            height: 50.0,
          ),
          renderThirdChild()
        ],
      ),
    );
  }


  //authenticate with google
  void _authenticateWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
//    final FirebaseUser user =
    await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      storeUser(user);
      print("user = ${user.displayName}");

    });


    // do something with signed-in user
  }


  //store user to firestore is not available
  void storeUser(FirebaseUser user) async {
    if (user != null) {
      // Check is already sign up
      final QuerySnapshot result =
      await Firestore.instance.collection('users').where(
          'id', isEqualTo: user.uid).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;

      print("Size ${documents.length}");
      documents.forEach((val){

        print("Data = ${val.data}");

      });
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance.collection('users').document(user.uid).setData(
            {
              'name': user.displayName,
              'photoUrl': user.photoUrl,
              'id': user.uid
            });
      }
    }
  }



    Widget renderFirstChild() {
      return Container(
        width: double.infinity,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlutterLogo(),
            Text(
              "Welcome To",
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              "Syde",
              style: TextStyle(
                  fontSize: 16.0,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),

        decoration: BoxDecoration(
            color: Colors.grey[200],


        ),
      );
    }

    Widget renderSecondChild() {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Join Thousands of developers on a daily code challenge",
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.grey, width: 2.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.grey, width: 2.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.grey, width: 2.0)),
                ),
              )
            ],
          ),
        ],
      );
    }

    Widget renderThirdChild() {
      var assetsImage = new AssetImage('assets/google.png');
      var image = new Image(image: assetsImage, width: 32.0, height: 32.0);
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: GestureDetector(
          onTap: () {
            print("sign in ");
            _authenticateWithGoogle();
          },
            child: Material(
              elevation: 5.0,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 20.0,),image,SizedBox(width: 50.0,),Text("Sign in with google",)
                  ],
                ),
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0))),
            ),
        ),
      );
    }
  }

