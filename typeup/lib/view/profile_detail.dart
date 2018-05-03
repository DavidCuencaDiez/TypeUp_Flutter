import 'package:flutter/material.dart';
import 'package:typeup/model/profile.dart';

class ProfilePage extends StatefulWidget {
  final int id;

  const ProfilePage({Key key, this.id}) : super(key: key);
  @override
  _ProfilePageState createState() => new _ProfilePageState(id);
}

class _ProfilePageState extends State<ProfilePage> {
  final int id;
  Profile _info;

  _ProfilePageState(this.id);


  @override
    void initState() {
      // TODO: implement initState
      super.initState();

    }
  @override
  Widget build(BuildContext context) {
    return new Container(
    );
  }
}