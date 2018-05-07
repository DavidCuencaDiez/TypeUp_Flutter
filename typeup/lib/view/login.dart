import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  onPressed(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  void _loginGoogle() async {
    await _ensureLoggedIn()
        .then(
            (googleUser){Navigator.pushReplacementNamed(context, "/TapPage");} )
        .catchError((error) => showInSnackBar(error.message));
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignIn googleSignIn = new GoogleSignIn();
    GoogleSignInAccount user = googleSignIn.currentUser;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if (user == null) user = await googleSignIn.signInSilently();
    if (user == null) {
      user = await googleSignIn.signIn();
    }
    if (await firebaseAuth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
          await googleSignIn.currentUser.authentication;
      await firebaseAuth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellowAccent.shade200,
      body: Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  elevation: 12.0,
                  child: FlutterLogo(
                    style: FlutterLogoStyle.horizontal,
                    size: 320.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                RaisedButton(
                  elevation: 12.0,
                  color: Colors.white,
                  onPressed : () {
                    _loginGoogle();
                  },
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/g-logo.png',
                        width: 18.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 18.0, left: 6.0),
                      ),
                      Text(
                        'SIGN IN WITH GOOGLE',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 54.0),
                            fontFamily: 'Roboto',
                            fontSize: 14.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 6.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
