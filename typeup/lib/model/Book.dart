import 'package:meta/meta.dart';

class Book {

  String title, description, cover;
  int id;
  Book({
    @required this.title,
    @required this.id,
    @required this.description,
    @required this.cover,
  });
}
