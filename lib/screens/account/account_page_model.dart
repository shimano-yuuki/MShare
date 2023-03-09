import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'account.dart';
import 'user.dart';

class AccountModel extends ChangeNotifier {
  // ユーザー情報
  AccountModel(this.uid);
  final String uid;
  // ListView.builderで使うためのBookのList booksを用意しておく。
  List<Account> accountContentList = [];
  User? user;

  Future<void> fetchAccountContent() async {
    // Firestoreからコレクション'books'(QuerySnapshot)を取得してdocsに代入。
    final docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('posts')
        .orderBy('date', descending: true)
        .get();

    // getter docs: docs(List<QueryDocumentSnapshot<T>>型)のドキュメント全てをリストにして取り出す。
    // map(): Listの各要素をBookに変換
    // toList(): Map()から返ってきたIterable→Listに変換する。
    final accountContent = docs.docs.map((doc) => Account(doc)).toList();
    accountContentList = accountContent;
    notifyListeners();
  }

  Future fetchUser() async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final user = User(doc);
    this.user = user;
    notifyListeners();
  }
}
