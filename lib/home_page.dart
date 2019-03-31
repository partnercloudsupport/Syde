import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ikode/BottomTabPages/page_chatroom.dart';
import 'package:ikode/BottomTabPages/page_stories.dart';
import 'package:ikode/BottomTabPages/page_messages.dart';
import 'package:ikode/pages/notification_page.dart';
import 'package:ikode/pages/thread_post.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:progress_dialog/progress_dialog.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;

  const HomePage({this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser _user;
  int _currentTabPosition = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _title = "Home";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: DrawerChildren(_user),
        ),
        appBar: renderAppBar(),
        body: renderBody(),
        bottomNavigationBar: renderBottomNavBar());
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() {
    _user = widget.user;
  }

  Widget renderBody() {
    if (_currentTabPosition == 0) {
      return ThreadPage(
        user: _user,
      );
    } else if (_currentTabPosition == 1) {
      return Container(
        child: Text("Messages"),
      );
    } else {
      return DirectMessaging();
    }
  }

  AppBar renderAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.grey),
      actions: <Widget>[
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (_currentTabPosition == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return ThreadPost();
              }));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return DirectMessaging();
              }));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(Icons.add),
          ),
        ),

        InkWell(
          borderRadius: BorderRadius.circular(20),
          radius: 5,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return NotificationScreen();
            }));
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(Icons.notifications_none),
          ),
        )

//        IconButton(padding: EdgeInsets.all(0.0),icon: Icon(Icons.notifications_none), onPressed: (){
//
//
//        })
      ],
      textTheme:
          TextTheme(title: TextStyle(color: Colors.black, fontSize: 18.0)),
      backgroundColor: Colors.white,
      leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
              child: _user == null
                  ? Icon(Icons.account_circle)
                  : CircleAvatar(
                      backgroundImage:
                          NetworkImage(_user.photoUrl + "?height=500"),
                    ),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              })),
      title: Text(_title),
    );
  }

//  Material(
//  elevation: 1.0,
//  shape: CircleBorder(),
//  color: Colors.transparent,
//  child: CircleAvatar(
//  backgroundImage: NetworkImage(_user.photoUrl + "?height=500"),
//  child: InkWell(
//  onTap: () {
//  },
//  ),
//  ),
//  ),

  BottomNavigationBar renderBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentTabPosition,
      onTap: (pos) {
        switch (pos) {
          case 0:
            _title = "Stories";
            break;
          case 1:
            _title = "Chatroom";
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return ChatRoom(_user);
            }));
            break;
          case 2:
            _title = "Messages";
            break;
        }
        setState(() {
          _currentTabPosition = pos;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.blur_on), title: Text("Stories")),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline), title: Text("Chatroom")),
        BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline), title: Text("Messages")),
      ],
    );
  }

  List<Widget> renderDrawerChildren() {
    return <Widget>[];
  }
}

ProgressDialog pr;

class DrawerChildren extends StatelessWidget {
  final FirebaseUser _user;

  DrawerChildren(this._user);

  final GoogleSignIn _googleSignIn = GoogleSignIn();


  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.setMessage('logging out...');

    return ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Colors.grey[500]),
          accountEmail: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[Text("25 Posts")],
            ),
          ),
          accountName: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(_user == null ? "Guest" : _user.displayName),
                Text(
                  _user == null ? "" : _user.email,
                ),
              ],
            ),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(
                _user == null ? "avatar" : _user.photoUrl + "?height=500"),
          ),
        ),
        ListTile(
          leading: Icon(Icons.person_outline),
          title: Text("Profile"),
        ),
        ListTile(
          leading: Icon(Icons.playlist_play),
          title: Text("TDL"),
        ),
        ListTile(
          leading: Icon(Icons.bookmark_border),
          title: Text("Bookmarks"),
        ),
        ListTile(
          leading: Icon(Icons.chat_bubble_outline),
          title: Text("General"),
        ),
        ListTile(
          onTap: () {
            print("auth log out ");


            Navigator.pop(context);

//            if(!pr.isShowing())
//              pr.show();
//            Future.delayed(Duration(seconds: 3)).whenComplete((){
//              if(pr.isShowing())
//                pr.hide();
//            });
            logUserOut();

//            Auth().logUserOut(FirebaseAuth.instance).then((val) {
//              authBloc.authSink.add(false);
//            });
          },
          leading: Icon(Icons.exit_to_app),
          title: Text("Log out"),
        ),
      ],
    );
  }

  logUserOut() {
//    await _googleSignIn.disconnect();
//    await _googleSignIn.signOut();
    FirebaseAuth.instance.signOut().then((val) {
      _googleSignIn.disconnect();
      _googleSignIn.signOut();
    });
  }
}
