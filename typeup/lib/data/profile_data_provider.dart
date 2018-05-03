import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:typeup/model/profile.dart';

class ProfileData {
  Future<Profile> getProfile(String id) async {
    final response = await http.get(Uri.encodeFull(
        'http://typeupapi.eu-west-3.elasticbeanstalk.com/api/Profiles/$id'));
    var responseJson = json.decode(response.body);
    Profile profile = await parseNetworkProfile(responseJson);
    return profile;
  }

  parseNetworkProfile(jsonBook) async {
    String description = "No description";
    if (jsonBook.containsKey("Description")) {
      description = jsonBook["Description"];
    }
    String profileImage = "http://icons.iconarchive.com/icons/paomedia/small-n-flat/256/profile-icon.png";
    if (jsonBook.containsKey("ProfileImage")) {
      profileImage = jsonBook["ProfileImage"];
    }
    return new Profile(
        name: jsonBook["Name"],
        id: jsonBook["ID"],
        description: description,
        profileImage: profileImage,
        lastName: jsonBook["LastName"]);
  }
}
