import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:ikode/Auth/auth.dart';
import 'package:ikode/BottomTabPages/page_chatroom.dart';

class HomePage extends StatefulWidget {
  final VoidCallback homeCallBack;
  final FirebaseUser user;

  HomePage({this.homeCallBack, this.user});

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
        drawer: Drawer(child: ListView(children: renderDrawerChildren())),
        appBar: renderAppBar(),
        body: renderBody(),
        bottomNavigationBar: renderBottomNavBar());
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      _user = widget.user;

      print(_user.displayName);
    });
  }

  Widget renderBody() {
    if (_currentTabPosition == 0) {
      return Center(
        child: Text("Posts will be displayed here..."),
      );
    } else if (_currentTabPosition == 1) {
      return ChatRoom(_user);
    } else if (_currentTabPosition == 2) {
      return Center(
        child: Text("DM goes here.."),
      );
    }
  }

  AppBar renderAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.grey),
      actions: <Widget>[
        Icon(Icons.notifications_none),
        SizedBox(
          width: 8.0,
        ),
      ],
      textTheme:
          TextTheme(title: TextStyle(color: Colors.black, fontSize: 18.0)),
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 1.0,
          shape: CircleBorder(),
          color: Colors.transparent,
          child: CircleAvatar(
            backgroundImage:_user==null?Icon(Icons.account_circle): NetworkImage(_user.photoUrl + "?height=500"),
            child: InkWell(
              onTap: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
          ),
        ),
      ),
      title: Text(_title),
    );
  }

  BottomNavigationBar renderBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentTabPosition,
      onTap: (pos) {
        switch (pos) {
          case 0:
            _title = "Home";
            break;
          case 1:
            _title = "Chatroom";
            break;
          case 2:
            _title = "Messages";
            break;
        }
        _currentTabPosition = pos;
        setState(() {});
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline), title: Text("Chatroom")),
        BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline), title: Text("Messages")),
      ],
    );
  }

  List<Widget> renderDrawerChildren() {
    return <Widget>[
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
          Auth().logUserOut(FirebaseAuth.instance).then((val) {
            print("out now!");
            widget.homeCallBack();
          });
        },
        leading: Icon(Icons.exit_to_app),
        title: Text("Log out"),
      ),
    ];
  }
}
