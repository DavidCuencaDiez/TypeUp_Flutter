import 'package:flutter/material.dart';
import '../data/book_data_provider.dart';
import '../model/Book.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Book> _books;
  BookData bookDB = new BookData();
  List<Book> _booksFilter = new List<Book>();

  getAllBooks() {
    bookDB.getAllBooks().then((bo) {
      this.setState(() {
        _books = bo;
        filterBooks('le');
      });
    });    
  }

  filterBooks(String text) {
    this.setState(() {
      _booksFilter = _books.where((bo) {
        bo.title.toLowerCase().contains(text.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView.builder(
        itemCount: _booksFilter.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: new Text(_booksFilter[index].title),
          );
        },
      ),
    );
  }
}
