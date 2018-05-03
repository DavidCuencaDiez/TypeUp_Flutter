import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/authentification.dart';
import '../services/validations.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserData user = UserData();
  UserAuth userAuth = UserAuth();
  bool autovalidate = false;
  Validations validations = Validations();
  bool _obscureText = true;

  onPressed(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  void _handleSubmitted() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      userAuth.verifyUser(user).then((onValue) {
        if (onValue == "Login Successfull")
          Navigator.pushReplacementNamed(context, "/TapPage");
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
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: screenSize.height,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('assets/login-screen-background.png'),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 200.0),
                    ),
                    TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail_outline),
                          hintText: 'Enter Email',
                        ),
                        validator: (email) => validations.validateEmail(email),
                        onSaved: (String email) {
                          user.email = email;
                        }),
                    TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.grey,
                          hintText: 'Enter password',
                          prefixIcon: Icon(Icons.lock_open),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        validator: (pass) => validations.validatePassword(pass),
                        obscureText: _obscureText,
                        onSaved: (String password) {
                          user.password = password;
                        }),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                    ),
                    RaisedButton(
                      color: Colors.black,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Roboto'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      onPressed: _handleSubmitted,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Roboto'),
                          ),
                          onPressed: () => onPressed("/LoginPage"),
                        ),
                        FlatButton(
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Roboto'),
                          ),
                          onPressed: () => onPressed("/LoginPage"),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    Text('OR'),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    RaisedButton(
                      elevation: 2.0,
                      color: Colors.white,
                      onPressed: () {},
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
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    RaisedButton(
                      elevation: 2.0,
                      color: Colors.white,
                      onPressed: () {},
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/flogo.png',
                            width: 18.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 18.0, left: 6.0),
                          ),
                          Text(
                            'SIGN IN WITH FACEBOOK',
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
        ),
      ),
    );
  }
}
