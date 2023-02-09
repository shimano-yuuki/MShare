import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_achieve_app/screens/post/post_content.dart';

final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

class PostDetail extends StatelessWidget {
  const PostDetail({
    super.key,
    required this.imageUrl,
    required this.imageTitle,
    required this.imageExplanation,
    required this.postContent,
  });

  final String imageUrl;
  final String imageTitle;
  final String imageExplanation;
  final PostContent postContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imageTitle),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              deletePost();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  imageTitle,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Image.network(
                      imageUrl,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20, left: 6),
                    child: Text(
                      imageExplanation,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future deletePost() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('posts')
        .doc(postContent.id)
        .delete();
  }
}
