import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Book.dart';

class BookData {
  Future<List<Book>> getAllBooks() async {
    final response = await http.get(Uri.encodeFull(
        'http://typeupapi.eu-west-3.elasticbeanstalk.com/api/Books'));
    List<dynamic> responseJson = json.decode(response.body);
    List<Book> books = new List<Book>();
    for (var book in responseJson) {
      Book bo = await parseNetworkBook(book);
      books.add(bo);
    }
    return books;
  }

  parseNetworkBook(jsonBook) async {
    String description = "No description";
    if (jsonBook.containsKey("Description")) {
      description = jsonBook["Description"];
    }
    return new Book(
        title: jsonBook["Title"],
        id: jsonBook["ID"],
        description: description,
        cover: jsonBook["Cover"]);
  }
}
