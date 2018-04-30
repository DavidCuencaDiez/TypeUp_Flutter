import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:typeup/view/home.dart';
import 'package:typeup/view/search.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => new _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TabController _tabController;
  String _email;
  String _name;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    firebaseAuth.currentUser().then((onValue)=> _email = onValue.email);
  }

@override
  void dispose() {
    _tabController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('TypeUp'),
        backgroundColor: Colors.black,
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text('David Cuenca'),
              accountEmail: new Text(_email),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.white,
                child: new Text('D'),
              ),
            ),
            new ListTile(         
              trailing: new Icon(Icons.add),     
              title: new Text('Add new book'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            new ListTile(
              trailing: new Icon(Icons.exit_to_app),
              title: new Text('Log Out'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: new Material(
        color: Colors.black,
        child: new TabBar(
          controller: _tabController,
          tabs: <Widget>[
            new Tab(
              icon: new Icon(Icons.home),
            ),
            new Tab(
              icon: new Icon(Icons.search),
            ),
            new Tab(
              icon: new Icon(Icons.rss_feed),
            ),
          ],
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new Tab(
            child: new HomePage(),
          ),
          new Tab(
            child: new SearchPage(),
          ),
        ],
      ),
    );
  }
}
