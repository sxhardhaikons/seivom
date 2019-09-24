import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActorsDetails extends StatelessWidget {
  String imageUrl;

  ActorsDetails(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: FadeInImage(
            image: NetworkImage(imageUrl),
            placeholder:
                AssetImage("lib/assets/images/offline_placeholder.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
