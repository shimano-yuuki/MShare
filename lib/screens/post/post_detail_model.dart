import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:share_achieve_app/screens/post/post_content.dart';

import '../account/account_detail.dart';

class PostDetailModel extends ChangeNotifier {
  PostDetailModel({
    required this.postContent,
  });

  final PostContent postContent;

  Future<void> deletePost() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('posts')
        .doc(postContent.id)
        .delete();
  }
}
