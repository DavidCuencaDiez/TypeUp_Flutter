import 'package:meta/meta.dart';

class Profile{
  String id;
  String name;
  String lastName;
  String profileImage;
  String description;
    Profile({
    @required this.name,
    @required this.id,
    @required this.lastName,
    @required this.profileImage,
    @required this.description
  });
}