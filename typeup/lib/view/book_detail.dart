import 'package:flutter/material.dart';
import 'package:typeup/model/book.dart';
import 'package:typeup/rating_bar.dart';

class BookPage extends StatefulWidget {
  final Book _book;

  BookPage(this._book);

  @override
  _BookPageState createState() => _BookPageState(_book);
}

class _BookPageState extends State<BookPage> {
  final Book _book;
  bool _favorite = false;
  _BookPageState(this._book);

  @override
  Widget build(BuildContext context) {
    //app bar
    final appBar = AppBar(
      elevation: .5,
      title: Text('Book'),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            _addToFavorite();
          },
          tooltip: 'Search',
          icon:
              Icon(_favorite == true ? Icons.bookmark : Icons.bookmark_border),
        )
      ],
    );

    ///detail of book image and it's pages
    final topLeft = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Hero(
            tag: _book.title,
            child: Material(
              elevation: 15.0,
              shadowColor: Colors.grey,
              child: Image.network(
                _book.cover,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        text('300 pages', color: Colors.black, size: 12)
      ],
    );

    ///detail top right
    final topRight = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text(_book.title,
            size: 16,
            color: Colors.black,
            isBold: true,
            padding: EdgeInsets.only(top: 16.0)),
        text(
          'by David Cuenca',
          color: Colors.black,
          size: 12,
          padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0),
        ),
        Row(
          children: <Widget>[
            RatingBar(
              rating: 4.0,
              color: Colors.red,
            )
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 10.0),),
        Row(
          children: <Widget>[
            Chip(label: Text('Comedi'),backgroundColor: Colors.redAccent,),
            Padding(padding: EdgeInsets.only(right: 10.0),),
            Chip(label: Text('Romance'),backgroundColor: Colors.redAccent,),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.0),
        ),        
        Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.blue.shade200,
          elevation: 5.0,
          child: MaterialButton(
            onPressed: () {},
            minWidth: 160.0,
            color: Colors.blueAccent.shade100,
            child: text('Read', color: Colors.black, size: 13),
          ),
        )
      ],
    );

    final topContent = Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(flex: 2, child: topLeft),
          Flexible(flex: 3, child: topRight),
        ],
      ),
    );

    ///scrolling text description
    final bottomContent = Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            'Description',
            style: Theme.of(context).textTheme.title,
            textAlign: TextAlign.left,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          SingleChildScrollView(
            child: Text(
              _book.description,
              style: TextStyle(fontSize: 13.0, height: 1.5),
            ),
          )
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: topContent,
          ),
          Expanded(
            flex: 1,
            child: bottomContent,
          ),
        ],
      ),
    );
  }

  ///create text widget
  text(String data,
          {Color color = Colors.black87,
          num size = 14,
          EdgeInsetsGeometry padding = EdgeInsets.zero,
          bool isBold = false}) =>
      Padding(
        padding: padding,
        child: Text(
          data,
          style: TextStyle(
              color: color,
              fontSize: size.toDouble(),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      );

  void _addToFavorite() {
    this.setState(() => _favorite = !_favorite);
  }
}
