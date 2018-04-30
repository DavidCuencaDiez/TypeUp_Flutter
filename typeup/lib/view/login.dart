import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/authentification.dart';
import '../services/validations.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserData user = new UserData();
  UserAuth userAuth = new UserAuth();
  bool autovalidate = false;
  Validations validations = new Validations();
  bool _obscureText = true;

  onPressed(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      userAuth.verifyUser(user).then((onValue) {
        if (onValue == "Login Successfull")
          Navigator.pushReplacementNamed(context, "/HomePage");
        else
          showInSnackBar(onValue);
      }).catchError((PlatformException onError) {
        showInSnackBar(onError.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      resizeToAvoidBottomPadding: true,
      key: _scaffoldKey,
      body: new SingleChildScrollView(
        child: new Container(
          height: screenSize.height,
          padding: new EdgeInsets.all(16.0),
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image:
                    new ExactAssetImage('assets/login-screen-background.png'),
                fit: BoxFit.cover),
          ),
          child: new SingleChildScrollView(
            child: new Center(
              child: new Form(
                key: formKey,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.only(top: 200.0),
                    ),
                    new TextFormField(
                        decoration: new InputDecoration(
                          prefixIcon: new Icon(Icons.mail_outline),
                          hintText: 'Enter Email',
                        ),
                        validator: (email) => validations.validateEmail(email),
                        onSaved: (String email) {
                          user.email = email;
                        }),
                    new TextFormField(
                        decoration: new InputDecoration(
                          fillColor: Colors.grey,
                          hintText: 'Enter password',
                          prefixIcon: new Icon(Icons.lock_open),
                          suffixIcon: new GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: new Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        validator: (pass) => validations.validatePassword(pass),
                        obscureText: _obscureText,
                        onSaved: (String password) {
                          user.password = password;
                        }),
                    new Padding(
                      padding: new EdgeInsets.only(top: 30.0),
                    ),
                    new RaisedButton(
                      color: Colors.black,
                      child: new Container(
                        height: 50.0,
                        child: new Center(
                          child: new Text(
                            "Login",
                            style: new TextStyle(
                                color: Colors.white, fontFamily: 'Roboto'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      onPressed: _handleSubmitted,
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new FlatButton(
                          child: new Text(
                            "Create Account",
                            style: new TextStyle(
                                color: Colors.black, fontFamily: 'Roboto'),
                          ),
                          onPressed: () => onPressed("/LoginPage"),
                        ),
                        new FlatButton(
                          child: new Text(
                            "Forgot password?",
                            style: new TextStyle(
                                color: Colors.black, fontFamily: 'Roboto'),
                          ),
                          onPressed: () => onPressed("/LoginPage"),
                        ),
                      ],
                    ),
                    new Padding(
                      padding: new EdgeInsets.all(10.0),
                    ),
                    new Text('OR'),
                    new Padding(
                      padding: new EdgeInsets.all(10.0),
                    ),
                    new RaisedButton(
                      elevation: 2.0,
                      color: Colors.white,
                      onPressed: () {},
                      child: new Row(
                        children: <Widget>[
                          new Image.asset(
                            'assets/g-logo.png',
                            width: 18.0,
                          ),
                          new Padding(
                            padding:
                                new EdgeInsets.only(right: 18.0, left: 6.0),
                          ),
                          new Text(
                            'SIGN IN WITH GOOGLE',
                            style: new TextStyle(
                                color: new Color.fromRGBO(0, 0, 0, 54.0),
                                fontFamily: 'Roboto',
                                fontSize: 14.0),
                          ),
                          new Padding(
                            padding: new EdgeInsets.only(right: 6.0),
                          ),
                        ],
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 10.0),
                    ),
                    new RaisedButton(
                      elevation: 2.0,
                      color: Colors.white,
                      onPressed: () {},
                      child: new Row(
                        children: <Widget>[
                          new Image.asset(
                            'assets/flogo.png',
                            width: 18.0,
                          ),
                          new Padding(
                            padding:
                                new EdgeInsets.only(right: 18.0, left: 6.0),
                          ),
                          new Text(
                            'SIGN IN WITH FACEBOOK',
                            style: new TextStyle(
                                color: new Color.fromRGBO(0, 0, 0, 54.0),
                                fontFamily: 'Roboto',
                                fontSize: 14.0),
                          ),
                          new Padding(
                            padding: new EdgeInsets.only(right: 6.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
