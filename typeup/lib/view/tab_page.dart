import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:typeup/model/profile.dart';
import 'package:typeup/view/home.dart';
import 'package:typeup/data/book_data_provider.dart';
import 'package:typeup/model/book.dart';
import 'package:typeup/view/book_detail.dart';
import 'package:material_search/material_search.dart';
import 'package:typeup/view/profile_detail.dart';
import 'package:typeup/view/related.dart';
import 'package:typeup/data/profile_data_provider.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  TabController _tabController;
  String _email;
  String _name;
  List<Book> _books;
  BookData bookDB = BookData();
  List<Book> _booksFilter = List<Book>();
  Book _book = null;

  getAllBooks() {
    bookDB.getAllBooks().then((bo) {
      this.setState(() {
        _books = bo;
      });
    });
  }

  _buildMaterialSearchPage(BuildContext context) {
    return MaterialPageRoute<Book>(
        settings: RouteSettings(
          name: 'material_search',
          isInitialRoute: false,
        ),
        builder: (BuildContext context) {
          return Material(
            child: MaterialSearch<Book>(
              placeholder: 'Search',
              results: _books
                  .map(
                    (Book v) => MaterialSearchResult<Book>(
                          icon: Icons.library_books,
                          value: v,
                          text: v.title,
                        ),
                  )
                  .toList(),
              filter: (dynamic value, String criteria) {
                return value.title
                    .toLowerCase()
                    .trim()
                    .contains(RegExp(r'' + criteria.toLowerCase().trim() + ''));
              },
              onSelect: (dynamic value) {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookPage(value)));
              },
            ),
          );
        });
  }

  _showMaterialSearch(BuildContext context) {
    Navigator
        .of(context)
        .push(_buildMaterialSearchPage(context))
        .then((dynamic value) {
      setState(() => _book = value as Book);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllBooks();
    _tabController = TabController(vsync: this, length: 3);
    firebaseAuth.currentUser().then((fireUser) => this.setState(() {
          user = fireUser;
        }));
  }

  @override
  void dispose() {
    _tabController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TypeUp'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _showMaterialSearch(context);
            },
            tooltip: 'Search',
            icon: Icon(Icons.search),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(user != null ?user.displayName :'Unknow'),
              accountEmail: Text(user != null ?user.email :'Unknow'),
              currentAccountPicture: Hero(
                child: Material(
                  elevation: 12.0,
                  type: MaterialType.circle,
                  color: Colors.black,
                  child: Container(
                    child: InkWell(
                        onTap: () {
                          Navigator
                              .push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new ProfilePage(),
                                  ))
                              .then((value) =>
                                  Navigator.of(context).pop(context));
                        },
                        child: Image.network(user != null ?user.photoUrl :'')),
                  ),
                ),
                tag: 'User',
              ),
            ),
            ListTile(
              trailing: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pushReplacementNamed(context, '/LoginPage');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: Colors.yellowAccent.shade400,
        child: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home),
            ),
            Tab(
              icon: Icon(Icons.rss_feed),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Tab(
            child: HomePage(),
          ),
          Tab(
            child: RelatedPage(),
          ),
        ],
      ),
    );
  }
}
