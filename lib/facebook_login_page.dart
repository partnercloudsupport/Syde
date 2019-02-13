import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:ikode/Auth/auth.dart';

class LogInPage extends StatefulWidget {
  final VoidCallback loginCallBack;
  final BaseAuth baseAuth;

  LogInPage({this.loginCallBack, this.baseAuth});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  FirebaseAuth auth;
  FacebookLogin fbLogIn;
  FirebaseUser user;

  initAuth() {
    auth = widget.baseAuth.getFireBAseAuth();
    fbLogIn = widget.baseAuth.getFaceBookLogin();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAuth();
  }

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

  signIn() async {
    FacebookLoginResult result =
        await widget.baseAuth.initFaceBookLogIn(fbLogIn, ["email"]);
    final AuthCredential authCredential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        widget.baseAuth
            .signInWithCredentials(auth, authCredential)
            .then((user) {
          this.user = user;
          widget.loginCallBack();
        });

        break;
      case FacebookLoginStatus.cancelledByUser:
        print("cancelled by user");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
    }
  }

  Widget renderFirstChild() {
    return Container(
      width: double.infinity,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          FlutterLogo(

          ),
          Text(
            "Welcome To",
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            "ikode",
            style: TextStyle(
                fontSize: 16.0,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(200, 50),
              bottomRight: Radius.elliptical(200, 50))),
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
    var assetsImage = new AssetImage('assets/facebook.png');
    var image = new Image(image: assetsImage, width: 18.0, height: 18.0);
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: GestureDetector(
        onTap: signIn,
        child: Container(
            child: Row(
              children: <Widget>[

              Container(
                width: 50.0,
                height: 50.0,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0),topLeft: Radius.circular(5.0)),
                    color: Colors.indigo[900].withOpacity(0.5),

                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: image,
                ),),
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  "FACEBOOK",
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                )
              ],
            ),
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.circular(5.0))),
      ),
    );
  }
}
