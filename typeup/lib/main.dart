import 'package:flutter/material.dart';
import 'package:typeup/view/home.dart';
import 'package:typeup/view/login.dart';
import 'package:typeup/view/tab_page.dart';
import 'package:typeup/view/profile_detail.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.yellowAccent),
        title: 'Flutter Demo',
        routes: <String, WidgetBuilder>{
          "/LoginPage": (BuildContext context) => LoginPage(),
          "/HomePage": (BuildContext context) => HomePage(),
          "/TapPage": (BuildContext context) => TabPage(),
        },
        home: ProfilePage());
  }
}
