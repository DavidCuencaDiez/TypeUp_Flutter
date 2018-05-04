import 'package:flutter/material.dart';
import 'package:typeup/model/book.dart';
import 'package:typeup/model/profile.dart';
import 'package:typeup/view/book_detail.dart';
import 'package:typeup/view/home.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    booksCollection() => {};
    final Size screenSize = MediaQuery.of(context).size;
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
                    color: Colors.yellowAccent,
                  ),
                  child: Column(
                    children: <Widget>[
                      Material(
                        color: Colors.transparent,
                        type: MaterialType.circle,
                        elevation: 12.0,
                        child: Container(
                          height: 100.0,
                          child: Image.network(
                              'https://i.ytimg.com/vi/w5zJpVR8TMk/maxresdefault.jpg'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 14.0),
                      ),
                      Text('David Cuenca',
                          style: Theme.of(context).textTheme.caption),
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
                height: 300.0,
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
                            'Relats',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    body: TabBarView(
                      children: [
                        HomePage(),
                        Icon(Icons.directions_transit),
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
