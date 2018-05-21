import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:typeup/view/home.dart';
import 'package:typeup/data/book_data_provider.dart';
import 'package:typeup/model/book.dart';
import 'package:typeup/view/book_detail.dart';
import 'package:material_search/material_search.dart';
import 'package:typeup/view/profile_detail.dart';
import 'package:typeup/view/related.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  final reference = FirebaseDatabase.instance.reference().child('relateds');

  final googleSignIn = GoogleSignIn();
  final TextEditingController _textController = TextEditingController();
  String _imageUrl;
  String _message;
  String _title;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  TabController _tabController;
  List<Book> _books;
  BookData bookDB = BookData();
  Book _book;
  bool sheetOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController _sheetController;
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

  void _sendMessage({String text, String imageUrl, String title}) {
    reference.push().set({
      'title': title,
      'text': text,
      'imageUrl': imageUrl,
      'senderName': googleSignIn.currentUser.displayName,
      'senderPhotoUrl': googleSignIn.currentUser.photoUrl,
    });
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) user = await googleSignIn.signInSilently();
    if (user == null) {
      user = await googleSignIn.signIn();
    }
    if (await firebaseAuth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
          await googleSignIn.currentUser.authentication;
      await firebaseAuth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
    }
  }

  Future<bool> _handleSubmitted() async {
    _textController.clear();
    await _ensureLoggedIn();
    if (_title == null) {
      _title = '';
    }
    if (_imageUrl != null) {
      if (_message != null && _message.length > 0) {
        _sendMessage(text: _message, imageUrl: _imageUrl, title: _title);
      } else {
        _sendMessage(imageUrl: _imageUrl, title: _title);
      }
      return true;
    } else if (_message != null && _message.length > 0) {
      _sendMessage(text: _message, title: _title);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _neverSatisfied() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Remember'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Write a Story or add image.'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                return true;
              },
            ),
          ],
        );
      },
    );
  }

  _buildStoryWriter() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (val) => _title = val,
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: TextStyle(color: Colors.black, fontSize: 20.0),
              hintText: 'Title...',
            ),
            maxLength: 30,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Story',
              labelStyle: TextStyle(color: Colors.black, fontSize: 30.0),
              hintText: 'Write some Story...',
            ),
            onChanged: (val) => _message = val,
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            maxLength: 400,
          ),
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: _imageUrl ?? '',
          ),
          Row(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: IconButton(
                      icon: Icon(Icons.photo_camera),
                      onPressed: () async {
                        await _ensureLoggedIn();
                        File imageFile = await ImagePicker.pickImage(
                            source: ImageSource.camera);
                        int random = Random().nextInt(100000);
                        StorageReference ref = FirebaseStorage.instance
                            .ref()
                            .child("image_$random.jpg");
                        StorageUploadTask uploadTask = ref.putFile(imageFile);
                        Uri downloadUrl = (await uploadTask.future).downloadUrl;
                        this.setState(() => _imageUrl = downloadUrl.toString());
                      }),
                ),
                Container(
                  child: IconButton(
                      icon: Icon(Icons.photo_album),
                      onPressed: () async {
                        await _ensureLoggedIn();
                        File imageFile = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                        int random = Random().nextInt(100000);
                        StorageReference ref = FirebaseStorage.instance
                            .ref()
                            .child("image_$random.jpg");
                        StorageUploadTask uploadTask = ref.putFile(imageFile);
                        Uri downloadUrl = (await uploadTask.future).downloadUrl;
                        this.setState(() => _imageUrl = downloadUrl.toString());
                      }),
                ),
              ],
            ),
          ])
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllBooks();
    _tabController = TabController(vsync: this, length: 2);
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
      key: _scaffoldKey,
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
              accountName: Text(user != null ? user.displayName : 'Unknow'),
              accountEmail: Text(user != null ? user.email : 'Unknow'),
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
                        child:
                            Image.network(user != null ? user.photoUrl : '')),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(249, 170, 51, 1.0),
        isExtended: true,
        onPressed: () async {
          if (_sheetController == null) {
            setState(() {
              _tabController.index = 1;
            });
            _sheetController = _scaffoldKey.currentState
                .showBottomSheet((builder) => _buildStoryWriter());
            _sheetController.closed.then((onValue) {
              _sheetController = null;
              _imageUrl = null;
              _message = null;
              _title = null;
            });
          } else {
            bool correct = await _handleSubmitted();
            if (correct) {
              _sheetController.close();
              _sheetController = null;
            } else {
              await _neverSatisfied();
            }
          }
        },
        child: Icon(Icons.send),
      ),
      bottomNavigationBar: BottomAppBar(
        hasNotch: true,
        elevation: 5.0,
        child: Material(
          color: Color.fromRGBO(52, 73, 85, 1.0),
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

class BottonSheet extends StatefulWidget {
  @override
  _BottonSheetState createState() => new _BottonSheetState();
}

class _BottonSheetState extends State<BottonSheet> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 400.0,
      decoration: BoxDecoration(color: Colors.greenAccent),
    );
  }
}
