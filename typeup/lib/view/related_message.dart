import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';

@override
class RelatedMessage extends StatelessWidget {
  RelatedMessage({this.snapshot, this.animation});
  final DataSnapshot snapshot;
  final Animation animation;

  Widget _drawContent() {
    if (snapshot.value['imageUrl'] != null) {
      if (snapshot.value['text'] != null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              placeholder: new CircularProgressIndicator(),
              imageUrl: snapshot.value['imageUrl'],
            ),
            Text(snapshot.value['text'])
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              placeholder: new CircularProgressIndicator(),
              imageUrl: snapshot.value['imageUrl'],
            ),
          ],
        );
      }
    } else {
      return Text(snapshot.value['text']);
    }
  }

  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[200])),
                ),
                margin: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.value['senderPhotoUrl']),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                    ),
                    Column(
                      children: <Widget>[
                        Text(snapshot.value['senderName'],
                            style: Theme.of(context).textTheme.subhead),
                        Text(snapshot.value['title'] ?? '',
                            style: Theme.of(context).textTheme.subhead),
                      ],
                    )
                  ],
                ),
                padding: EdgeInsets.only(bottom: 5.0),
              ),
              Container(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  margin: const EdgeInsets.only(top: 5.0),
                  child: _drawContent()),
            ],
          ),
        ),
      ),
    );
  }
}
