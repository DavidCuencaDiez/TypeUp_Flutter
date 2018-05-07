import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserData {
  String email;
  String password;

  UserData({this.email, this.password});
}

class UserAuth {
  String statusMsg = "Account Created Successfully";
  //To create new User
  Future<String> createUser(UserData userData) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.createUserWithEmailAndPassword(
        email: userData.email, password: userData.password);
    return statusMsg;
  }

  //To verify new User
  Future<String> verifyUser(UserData userData) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signInWithEmailAndPassword(
        email: userData.email, password: userData.password);
    return "Login Successfull";
  }

  Future<FirebaseUser> googleSignIn() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    GoogleSignIn gsi = new GoogleSignIn();
    GoogleSignInAccount googleSignInAccount = await gsi.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    FirebaseUser firebaseUser = await firebaseAuth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    return firebaseUser;
  }


}
