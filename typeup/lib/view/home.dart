import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/book_data_provider.dart';
import '../model/Book.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> _books;
  BookData bookDB = new BookData();

  getAllBooks() {
    bookDB.getAllBooks().then((bo) {
      this.setState(() {
        _books = bo;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllBooks();
  }
@override

  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    createTile(Book book) => new Hero(
          tag: book.title,
          child: new Material(
            elevation: 15.0,
            shadowColor: Colors.yellow.shade900,
            child: new InkWell(
              child: new Image.network(
                book.cover,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );

    return new Scaffold(
      body: _books == null
          ? new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new Padding(
                    padding: new EdgeInsets.only(top: 10.0),
                  ),
                  new Text('Loading')
                ],
              ),
            )
          : new CustomScrollView(
              primary: false,
              slivers: <Widget>[
                new SliverPadding(
                  padding: new EdgeInsets.all(16.0),
                  sliver: new SliverGrid.count(
                    childAspectRatio: 2 / 3,
                    crossAxisCount: 3,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    children: _books.map((book) => createTile(book)).toList(),
                  ),
                )
              ],
            ),
    );
  }
}