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

  FirebaseUser _user; //current user
  int _currentTabPosition = 0; // tab navigation position
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();// key to reference the scaffold widget
  String _title = "Stories";


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

    // here we render the widget based on the tab position
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
    //this method builds the app bar and renders it to the screen
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


  // renders the bottom tabs to the screen
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

// this class creates a list of items to be displayed on the drawer
// stateless widget is extended to provide another context different from the parent
class DrawerChildren extends StatelessWidget {
  final FirebaseUser _user;

  DrawerChildren(this._user);

  final GoogleSignIn _googleSignIn = GoogleSignIn(); // get instance of google sign in


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

            Navigator.pop(context);
            logUserOut();

          },
          leading: Icon(Icons.exit_to_app),
          title: Text("Log out"),
        ),
      ],
    );
  }

  // log user out completely
  logUserOut() {
    FirebaseAuth.instance.signOut().then((val) {
      _googleSignIn.disconnect();
      _googleSignIn.signOut();
    });
  }
}
