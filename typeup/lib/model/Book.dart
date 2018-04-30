import 'package:meta/meta.dart';

class Book {
  static final db_id = "ID";
  static final db_title = "Title";
  static final db_description = "Description";
  static final db_cover = "Cover";

  String title, description, cover;
  int id;
  Book({
    @required this.title,
    @required this.id,
    @required this.description,
    @required this.cover,
  });

  Book.fromMap(Map<String, dynamic> map)
      : this(
          title: map[db_title],
          id: map[db_id],
          description: map[db_description],
          cover: map[db_cover],
        );
  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      db_title: title,
      db_id: id,
      db_description: description,
      db_cover: cover
    };
  }
}
