import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ikode/Bloc/home_page_bloc.dart';
import 'package:ikode/BottomTabPages/page_chatroom.dart';
import 'package:ikode/BottomTabPages/page_messages.dart';
import 'package:ikode/BottomTabPages/page_stories.dart';
import 'package:ikode/pages/notification_page.dart';
import 'package:ikode/pages/thread_post.dart';
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
        body: StreamBuilder(
            initialData: 0,
            stream: homePageBloc.stream,
            builder: (context,snapshot){
              print(snapshot.data);

              return renderBody(snapshot.data);

        }),
        bottomNavigationBar: StreamBuilder(
          initialData: 0,
            stream: homePageBloc.stream,
            builder: (context,snapshot){

              _currentTabPosition = snapshot.data;
          return renderBottomNavBar(snapshot.data);
        })

    );
  }


  @override
  void initState() {
    super.initState();
    getUser();
  }


  @override
  void dispose(){
    homePageBloc.dispose();
    super.dispose();
  }

  getUser() {
    _user = widget.user;
  }

  Widget renderBody(int pos) {

    // here we render the widget based on the tab position
    if (pos == 0) {
      return ThreadPage(
        user: _user,
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
            child: Icon(Icons.add_circle_outline,color: Colors.blue,),
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
            child: Icon(Icons.notifications_none,color:Colors.blue),
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
      title: Text(_title,style: TextStyle(fontWeight: FontWeight.bold),),
    );
  }


  // renders the bottom tabs to the screen
  BottomNavigationBar renderBottomNavBar(int pos) {

    return BottomNavigationBar(
      currentIndex: pos,
      onTap: (pos) {

        //if tab position is same, break out of the function
        if(_currentTabPosition == pos)return;

        if(pos==1)
          //open chat room route
          Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return ChatRoom(_user);
            }));
        else homePageBloc.tabPosition.add(pos); // add value to sink

      },

      //item list for bottom navigattion
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.blur_on), title: Text("Stories")),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline), title: Text("Chatroom")),
        BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline), title: Text("Messages")),
      ],
    );
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
