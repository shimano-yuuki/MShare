import 'package:flutter/material.dart';

class PostDetail extends StatelessWidget {
  const PostDetail(
      {super.key, required this.imageUrl, required this.imageTitle});
  final String imageUrl;
  final String imageTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imageTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Expanded(
            child: Container(
              color: Colors.blue,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
