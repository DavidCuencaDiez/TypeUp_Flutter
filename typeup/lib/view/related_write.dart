import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

class RelatedWritePage extends StatefulWidget {
  @override
  _RelatedWritePageState createState() => _RelatedWritePageState();
}

class _RelatedWritePageState extends State<RelatedWritePage> {
  final reference = FirebaseDatabase.instance.reference().child('relateds');
  final auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final googleSignIn = GoogleSignIn();
  final TextEditingController _textController = TextEditingController();
  String _imageUrl;
  String _message;
  String _title;
  void _sendMessage({String text, String imageUrl, String title}) {
    reference.push().set({
      'title': title,
      'text': text,
      'imageUrl': imageUrl,
      'senderName': googleSignIn.currentUser.displayName,
      'senderPhotoUrl': googleSignIn.currentUser.photoUrl,
    });
    //analytics.logEvent(name: 'send_message');
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) user = await googleSignIn.signInSilently();
    if (user == null) {
      user = await googleSignIn.signIn();
    }
    if (await auth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
          await googleSignIn.currentUser.authentication;
      await auth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
    }
  }

  Future<Null> _handleSubmitted() async {
    _textController.clear();
    await _ensureLoggedIn();
    if (_title == null) {
      _title = '';
    }
    if (_imageUrl != null) {
      if (_message != null && _message.length > 0) {
        _sendMessage(text: _message, imageUrl: _imageUrl, title: _title);
        Navigator.of(context).pop(context);
      } else {
        _sendMessage(imageUrl: _imageUrl, title: _title);
        Navigator.of(context).pop(context);
      }
    } else if (_message != null && _message.length > 0) {
      _sendMessage(text: _message, title: _title);
      Navigator.of(context).pop(context);
    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Write a Story or add image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        heroTag: 'SendRelate',
        onPressed: () {
          _handleSubmitted();
        },
        child: Icon(Icons.send),
      ),
      appBar: AppBar(
        title: Text('Story'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (val) => _title = val,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                hintText: 'Title...',
              ),
              maxLength: 30,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Story',
                labelStyle: TextStyle(color: Colors.black, fontSize: 30.0),
                hintText: 'Write some Story...',
              ),
              onChanged: (val) => _message = val,
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              maxLength: 400,
            ),
            FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: _imageUrl ?? '',
            ),
            Row(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: IconButton(
                        icon: Icon(Icons.photo_camera),
                        onPressed: () async {
                          await _ensureLoggedIn();
                          File imageFile = await ImagePicker.pickImage(
                              source: ImageSource.camera);
                          int random = Random().nextInt(100000);
                          StorageReference ref = FirebaseStorage.instance
                              .ref()
                              .child("image_$random.jpg");
                          StorageUploadTask uploadTask = ref.putFile(imageFile);
                          Uri downloadUrl =
                              (await uploadTask.future).downloadUrl;
                          this.setState(
                              () => _imageUrl = downloadUrl.toString());
                        }),
                  ),
                  Container(
                    child: IconButton(
                        icon: Icon(Icons.photo_album),
                        onPressed: () async {
                          await _ensureLoggedIn();
                          File imageFile = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          int random = Random().nextInt(100000);
                          StorageReference ref = FirebaseStorage.instance
                              .ref()
                              .child("image_$random.jpg");
                          StorageUploadTask uploadTask = ref.putFile(imageFile);
                          Uri downloadUrl =
                              (await uploadTask.future).downloadUrl;
                          this.setState(
                              () => _imageUrl = downloadUrl.toString());
                        }),
                  ),
                ],
              ),
            ])
          ],
        ),
      ),
    );
  }
}
