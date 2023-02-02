import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:share_achieve_app/screens/Home/home_content.dart';

class HomeModel extends ChangeNotifier {
  // ListView.builderで使うためのBookのList booksを用意しておく。
  List<HomeContent> homeContentList = [];

  Future<void> fetchHomeContent() async {
    // Firestoreからコレクション'books'(QuerySnapshot)を取得してdocsに代入。
    final docs = await FirebaseFirestore.instance
        .collectionGroup('data')
        .orderBy('date', descending: true)
        .get();

    // getter docs: docs(List<QueryDocumentSnapshot<T>>型)のドキュメント全てをリストにして取り出す。
    // map(): Listの各要素をBookに変換
    // toList(): Map()から返ってきたIterable→Listに変換する。
    final homeContent = docs.docs.map((doc) => HomeContent(doc)).toList();
    homeContentList = homeContent;
    notifyListeners();
  }

  Future<void> deletePost(String postId) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
  }
}
