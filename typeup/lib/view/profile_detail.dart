import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:typeup/model/book.dart';
import 'package:typeup/model/profile.dart';
import 'package:typeup/view/home.dart';
import 'package:typeup/view/related.dart';

class ProfilePage extends StatefulWidget {
  final String id;

  const ProfilePage({this.id});
  @override
  _ProfilePageState createState() => _ProfilePageState(id);
}

class _ProfilePageState extends State<ProfilePage> {
  final String id;
  Profile _info;
  List<Book> _books = List<Book>();
  _ProfilePageState(this.id);
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseAuth.currentUser().then((fireUser) => this.setState(() {
          user = fireUser;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  height: 250.0,
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent.shade400,
                  ),
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: 'User',
                        child: Material(
                          color: Colors.transparent,
                          type: MaterialType.circle,
                          elevation: 12.0,
                          child: Container(
                            height: 100.0,
                            child: Image.network(
                              user != null ? user.photoUrl : '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 14.0),
                      ),
                      Text(user != null ? user.displayName : '',
                          style: Theme.of(context).textTheme.title),
                      Padding(
                        padding: EdgeInsets.only(top: 14.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Material(
                            color: Colors.blueAccent,
                            child: Container(
                              height: 50.0,
                              child: RaisedButton(
                                child: Icon(Icons.people),
                                onPressed: () {},
                              ),
                            ),
                            type: MaterialType.circle,
                          ),
                          Material(
                            color: Colors.blueAccent,
                            child: Container(
                              height: 50.0,
                              child: RaisedButton(
                                child: Icon(Icons.message),
                                onPressed: () {},
                              ),
                            ),
                            type: MaterialType.circle,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 310.0,
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: TabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            'Books',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Stories',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    body: TabBarView(
                      children: [
                        HomePage(),
                        RelatedPage(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
