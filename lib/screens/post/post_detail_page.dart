import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_achieve_app/screens/post/post.dart';
import 'package:share_achieve_app/screens/post/post_detail_page_model.dart';

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
  final Post postContent;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PostDetailModel>(
      create: (_) => PostDetailModel(postContent: postContent),
      child: Scaffold(
        appBar: AppBar(
          title: Text(imageTitle),
          actions: [
            Consumer<PostDetailModel>(builder: (context, model, child) {
              return IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () {
                  model.deletePost();
                  Navigator.of(context).pop();
                },
              );
            }),
          ],
        ),
        body: Consumer<PostDetailModel>(
          builder: (context, model, child) {
            return Padding(
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
            );
          },
        ),
      ),
    );
  }
}
